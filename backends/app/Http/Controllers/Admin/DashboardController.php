<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Activity;
use App\Models\Group;
use App\Models\Message;
use App\Models\Section;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = [
            'users' => User::count(),
            'groups' => Group::count(),
            'messages' => Message::count(),
            'sections' => Section::count(),
        ];

        // User registrations last 30 days
        $registrations = User::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('COUNT(*) as count')
        )
            ->where('created_at', '>=', now()->subDays(29))
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('count', 'date');

        $days = collect(range(29, 0))->map(fn ($i) => now()->subDays($i)->toDateString());
        $regLabels = $days->values();
        $regData = $days->map(fn ($d) => $registrations[$d] ?? 0)->values();

        // Section status breakdown
        $sectionStatus = Section::select('status', DB::raw('COUNT(*) as count'))
            ->groupBy('status')
            ->pluck('count', 'status');

        // Groups per day (last 14 days)
        $groupsPerDay = Group::select(
            DB::raw('DATE(created_at) as date'),
            DB::raw('COUNT(*) as count')
        )
            ->where('created_at', '>=', now()->subDays(13))
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('count', 'date');

        $days14 = collect(range(13, 0))->map(fn ($i) => now()->subDays($i)->toDateString());
        $groupLabels = $days14->values();
        $groupData = $days14->map(fn ($d) => $groupsPerDay[$d] ?? 0)->values();

        $recentUsers = User::latest()->limit(5)->get();
        $recentGroups = Group::with('creator')->latest()->limit(5)->get();
        $recentActivities = Activity::with(['user', 'group'])->latest()->limit(10)->get();

        return view('admin.dashboard', compact(
            'stats',
            'regLabels', 'regData',
            'sectionStatus',
            'groupLabels', 'groupData',
            'recentUsers', 'recentGroups', 'recentActivities'
        ));
    }
}
