<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use App\Models\User;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function index()
    {
        $announcements = Announcement::with('admin')->latest()->paginate(15);
        $universities = User::whereNotNull('university')->distinct()->pluck('university');

        return view('admin.announcements.index', compact('announcements', 'universities'));
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'message' => ['required', 'string'],
            'target' => ['required', 'in:all,university'],
            'target_university' => ['nullable', 'string', 'max:255'],
        ]);
        Announcement::create([...$data, 'admin_id' => auth()->id(), 'is_sent' => true, 'sent_at' => now()]);

        return back()->with('success', 'Announcement sent!');
    }

    public function destroy(Announcement $announcement)
    {
        $announcement->delete();

        return back()->with('success', 'Announcement deleted.');
    }
}
