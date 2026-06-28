<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminAction;
use App\Models\Report;
use App\Models\User;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $reports = Report::with('reporter', 'resolver')
            ->when($request->status, fn ($q, $s) => $q->where('status', $s))
            ->latest()->paginate(20)->withQueryString();

        return view('admin.reports.index', compact('reports'));
    }

    public function resolve(Request $request, Report $report)
    {
        $action = $request->input('action', 'resolved');
        $report->update([
            'status' => $action === 'dismiss' ? 'dismissed' : 'resolved',
            'resolved_by' => auth()->id(),
            'admin_note' => $request->input('note'),
        ]);
        if ($action === 'suspend') {
            User::find($report->reported_id)?->update(['status' => 'suspended']);
        }
        AdminAction::create([
            'admin_id' => auth()->id(),
            'action' => "report_{$action}",
            'target_type' => 'report',
            'target_id' => $report->id,
            'description' => "Report #{$report->id} {$action}ed",
        ]);

        return back()->with('success', 'Report handled.');
    }
}
