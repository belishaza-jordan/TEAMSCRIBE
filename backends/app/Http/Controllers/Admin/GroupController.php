<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Group;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    public function index(Request $request)
    {
        // Mark groups section as "seen"
        session(['admin_viewed_groups_at' => now()->toDateTimeString()]);

        $groups = Group::with('creator')
            ->when($request->search, fn ($q, $s) => $q->where('name', 'like', "%$s%"))
            ->withCount(['members', 'messages', 'sections'])
            ->latest()
            ->paginate(15)
            ->withQueryString();

        return view('admin.groups.index', compact('groups'));
    }

    public function show(Group $group)
    {
        $group->load(['creator', 'members', 'sections.assignee', 'messages.sender']);

        return view('admin.groups.show', compact('group'));
    }

    public function destroy(Group $group)
    {
        $group->delete();

        return redirect()->route('admin.groups.index')->with('success', 'Group deleted.');
    }
}
