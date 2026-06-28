<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use Illuminate\Http\Request;

class ActivityController extends Controller
{
    public function index(Request $request)
    {
        $activities = Activity::with(['user', 'group'])
            ->when($request->type, fn ($q, $t) => $q->where('type', $t))
            ->latest()
            ->paginate(25)
            ->withQueryString();

        $types = Activity::distinct()->pluck('type');

        return view('admin.activities.index', compact('activities', 'types'));
    }
}
