<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Mail\AdminWelcomeMail;
use App\Mail\StudentWelcomeMail;
use App\Models\AdminAction;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;

class UserController extends Controller
{
    /** Authenticated admin id — cast to int to satisfy Psalm (auth()->id() can be null). */
    private function adminId(): int
    {
        return (int) auth()->id();
    }

    public function index(Request $request)
    {
        $isAdminView = $request->role === 'admin';

        // Mark this section as "seen" so sidebar badge resets
        $sessionKey = $isAdminView ? 'admin_viewed_admins_at' : 'admin_viewed_students_at';
        session([$sessionKey => now()->toDateTimeString()]);

        $users = User::query()
            // Role scope: admins page shows only admins (excluding self), students page shows only students
            ->when($isAdminView,
                fn ($q) => $q->where('is_admin', true)->where('id', '!=', $this->adminId()),
                fn ($q) => $q->where('is_admin', false)
            )
            ->when($request->search, fn ($q, $s) => $q->where('name', 'like', "%$s%")->orWhere('email', 'like', "%$s%"))
            ->when($request->university, fn ($q, $u) => $q->where('university', $u))
            ->when($request->status, fn ($q, $s) => $q->where('status', $s))
            ->withCount('groups')
            ->latest()->paginate(20)->withQueryString();

        $universities = User::whereNotNull('university')->distinct()->pluck('university');

        return view('admin.users.index', compact('users', 'universities'));
    }

    public function show(User $user)
    {
        $user->load(['groups.sections']);

        return view('admin.users.show', compact('user'));
    }

    public function edit(User $user)
    {
        return view('admin.users.edit', compact('user'));
    }

    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users,email,'.$user->id],
            'university' => ['nullable', 'string', 'max:255'],
            'status' => ['required', 'in:active,suspended,pending'],
        ]);

        $user->update($validated);

        AdminAction::create([
            'admin_id' => $this->adminId(),
            'action' => 'edit_user',
            'target_type' => 'user',
            'target_id' => $user->id,
            'description' => "Updated profile for {$user->name}",
        ]);

        return redirect()->route('admin.users.show', $user)
            ->with('success', "{$user->name} updated successfully.");
    }

    public function toggleAdmin(User $user)
    {
        $user->update(['is_admin' => ! $user->is_admin]);
        AdminAction::create([
            'admin_id' => $this->adminId(),
            'action' => $user->is_admin ? 'grant_admin' : 'revoke_admin',
            'target_type' => 'user', 'target_id' => $user->id,
            'description' => ($user->is_admin ? 'Granted' : 'Revoked')." admin for {$user->name}",
        ]);

        return back()->with('success', $user->is_admin ? "{$user->name} is now an admin." : "{$user->name} admin access removed.");
    }

    public function suspend(User $user)
    {
        $user->update(['status' => $user->status === 'suspended' ? 'active' : 'suspended']);
        AdminAction::create([
            'admin_id' => $this->adminId(),
            'action' => $user->status === 'suspended' ? 'suspend_user' : 'reactivate_user',
            'target_type' => 'user', 'target_id' => $user->id,
            'description' => "{$user->status} {$user->name}",
        ]);

        return back()->with('success', "User {$user->status}.");
    }

    /** Show the create-user form. Role comes from query string: ?role=admin|student */
    public function create(Request $request)
    {
        $role = $request->get('role', 'student');

        return view('admin.users.create', compact('role'));
    }

    /** Create the user, send the appropriate welcome email, log the action. */
    public function store(Request $request)
    {
        $isAdmin = $request->input('role') === 'admin';

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users,email'],
            'university' => ['nullable', 'string', 'max:255'],
            'role' => ['required', 'in:admin,student'],
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'university' => $validated['university'] ?? null,
            'password' => bcrypt(Str::random(24)), // temporary — reset via email
            'is_admin' => $isAdmin,
            'status' => 'active',
        ]);

        $invitedBy = auth()->user()->name ?? 'TeamScribe Admin';

        if ($isAdmin) {
            // Generate a web password-reset link so the new admin can set their password
            $token = Password::broker()->createToken($user);
            $resetUrl = route('password.reset', ['token' => $token, 'email' => $user->email]);

            Mail::to($user->email)->send(new AdminWelcomeMail($user, $resetUrl, $invitedBy));
        } else {
            // Student — tell them to use the mobile app's Forgot Password flow
            Mail::to($user->email)->send(new StudentWelcomeMail($user, $invitedBy));
        }

        AdminAction::create([
            'admin_id' => $this->adminId(),
            'action' => $isAdmin ? 'create_admin' : 'create_student',
            'target_type' => 'user',
            'target_id' => $user->id,
            'description' => "Created {$user->name} ({$user->email}) as ".($isAdmin ? 'admin' : 'student').'. Welcome email sent.',
        ]);

        $back = $isAdmin
            ? route('admin.users.index', ['role' => 'admin'])
            : route('admin.users.index');

        return redirect($back)
            ->with('success', "{$user->name} created successfully. A welcome email has been sent to {$user->email}.");
    }

    public function destroy(User $user)
    {
        AdminAction::create([
            'admin_id' => $this->adminId(),
            'action' => 'delete_user',
            'target_type' => 'user', 'target_id' => $user->id,
            'description' => "Deleted user {$user->name} ({$user->email})",
        ]);
        $user->delete();

        return redirect()->route('admin.users.index')->with('success', 'User deleted.');
    }
}
