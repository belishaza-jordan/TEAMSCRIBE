<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\AdminAction;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class AuditController extends Controller
{
    public function index(Request $request)
    {
        $perPage = 40;
        $page = max(1, (int) $request->get('page', 1));
        $source = $request->get('source');   // 'app' | 'admin' | ''
        $userId = $request->get('user_id');
        $type = $request->get('type');

        // ── App activities (mobile + web logins/logouts) ───────────────
        $appQuery = Activity::with(['user', 'group'])
            ->when($userId, fn ($q) => $q->where('user_id', $userId))
            ->when($type, fn ($q) => $q->where('type', $type));

        // ── Admin panel actions ────────────────────────────────────────
        $adminQuery = AdminAction::with('admin')
            ->when($userId, fn ($q) => $q->where('admin_id', $userId))
            ->when($type, fn ($q) => $q->where('action', $type));

        if ($source === 'app') {
            $rows = $appQuery->latest()->paginate($perPage)->withQueryString();
            $unified = collect($this->normaliseApp($rows->getCollection()));
            $paginator = $rows;
        } elseif ($source === 'admin') {
            $rows = $adminQuery->latest()->paginate($perPage)->withQueryString();
            $unified = collect($this->normaliseAdmin($rows->getCollection()));
            $paginator = $rows;
        } else {
            // Merge both: fetch top N from each, merge-sort, then manual paginate
            $appRows = $appQuery->latest()->limit(500)->get();
            $adminRows = $adminQuery->latest()->limit(500)->get();

            // Use collect() to convert to a plain Support\Collection before
            // merging — Eloquent\Collection::merge() expects Eloquent models.
            $merged = collect($this->normaliseApp($appRows))
                ->merge(collect($this->normaliseAdmin($adminRows)))
                ->sortByDesc('created_at')
                ->values();

            $total = $merged->count();
            $offset = ($page - 1) * $perPage;
            $items = $merged->slice($offset, $perPage)->values();

            $paginator = new LengthAwarePaginator(
                $items, $total, $perPage, $page,
                ['path' => $request->url(), 'query' => $request->query()]
            );
            $unified = $items;
        }

        // Filter options
        $allUsers = User::orderBy('name')->get();
        $appTypes = Activity::distinct()->pluck('type');
        $adminTypes = AdminAction::distinct()->pluck('action');
        $allTypes = $appTypes->merge($adminTypes)->unique()->sort()->values();

        return view('admin.audit.index', compact(
            'unified', 'paginator', 'allUsers', 'allTypes'
        ));
    }

    /** Normalise Activity rows into a common shape. */
    private function normaliseApp(Collection $rows): Collection
    {
        return $rows->map(fn ($a) => (object) [
            'source' => 'app',
            'type' => $a->type,
            'description' => $a->description,
            'user_name' => $a->user?->name ?? 'Unknown',
            'user_id' => $a->user_id,
            'is_admin' => $a->user?->is_admin ?? false,
            'context' => $a->group?->name ? "Group: {$a->group->name}" : 'Platform',
            'created_at' => $a->created_at,
        ]);
    }

    /** Normalise AdminAction rows into a common shape. */
    private function normaliseAdmin(Collection $rows): Collection
    {
        return $rows->map(fn ($a) => (object) [
            'source' => 'admin',
            'type' => $a->action,
            'description' => $a->description,
            'user_name' => $a->admin?->name ?? 'Unknown',
            'user_id' => $a->admin_id,
            'is_admin' => true,
            'context' => $a->target_type
                ? ucfirst($a->target_type)." #{$a->target_id}"
                : 'Admin panel',
            'created_at' => $a->created_at,
        ]);
    }
}
