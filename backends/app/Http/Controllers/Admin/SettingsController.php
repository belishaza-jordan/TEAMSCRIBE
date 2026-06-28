<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdminAction;
use App\Models\SystemSetting;
use App\Models\UniversityDomain;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        $settings = SystemSetting::all()->groupBy('group');
        $domains = UniversityDomain::latest()->get();

        return view('admin.settings.index', compact('settings', 'domains'));
    }

    public function update(Request $request)
    {
        $data = $request->input('settings', []);
        foreach ($data as $key => $value) {
            $setting = SystemSetting::find($key);
            if ($setting) {
                $setting->update(['value' => $value]);
            }
        }
        AdminAction::create([
            'admin_id' => auth()->id(),
            'action' => 'update_settings',
            'description' => 'Updated system settings',
            'metadata' => $data,
        ]);

        return back()->with('success', 'Settings saved successfully.');
    }

    public function addDomain(Request $request)
    {
        $request->validate([
            'domain' => ['required', 'string', 'max:255'],
            'university_name' => ['nullable', 'string', 'max:255'],
        ]);
        UniversityDomain::updateOrCreate(
            ['domain' => strtolower($request->domain)],
            ['university_name' => $request->university_name, 'is_allowed' => true, 'approved_by' => auth()->id()]
        );

        return back()->with('success', "Domain {$request->domain} added.");
    }

    public function toggleDomain(UniversityDomain $domain)
    {
        $domain->update(['is_allowed' => ! $domain->is_allowed]);

        return back()->with('success', "Domain {$domain->domain} ".($domain->is_allowed ? 'allowed' : 'blocked').'.');
    }

    public function deleteDomain(UniversityDomain $domain)
    {
        $domain->delete();

        return back()->with('success', 'Domain removed.');
    }
}
