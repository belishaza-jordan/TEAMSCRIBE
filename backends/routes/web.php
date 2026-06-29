<?php

use App\Http\Controllers\Admin\ActivityController;
use App\Http\Controllers\Admin\AnnouncementController;
use App\Http\Controllers\Admin\AuditController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\GroupController as AdminGroupController;
use App\Http\Controllers\Admin\InvitationController as AdminInvitationController;
use App\Http\Controllers\Admin\NotificationController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\SettingsController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

// ── Public landing page ───────────────────────────────────────────────────────
Route::get('/', fn () => view('landing'))->name('landing');

// ── Block register — admin-only system, no self-registration ─────────────────
Route::get('register', fn () => abort(404))->middleware('guest');
Route::post('register', fn () => abort(404))->middleware('guest');

// ── Admin entry point — redirects to dashboard (auth middleware handles login) ─
Route::get('/go-admin', fn () => redirect()->route('admin.dashboard'))->name('go-admin');

// ── Invitation accept/reject — public web links sent via email ────────────────
Route::get('invitations/{token}/accept', [AdminInvitationController::class, 'accept'])->name('invitations.accept');
Route::get('invitations/{token}/reject', [AdminInvitationController::class, 'reject'])->name('invitations.reject');

Route::prefix('admin')->name('admin.')->middleware(['auth', 'admin'])->group(function () {

    Route::get('dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // Users (students + admins)
    Route::get('users', [UserController::class, 'index'])->name('users.index');
    Route::get('users/create', [UserController::class, 'create'])->name('users.create'); // before {user}
    Route::post('users', [UserController::class, 'store'])->name('users.store');
    Route::get('users/{user}', [UserController::class, 'show'])->name('users.show');
    Route::get('users/{user}/edit', [UserController::class, 'edit'])->name('users.edit');
    Route::patch('users/{user}', [UserController::class, 'update'])->name('users.update');
    Route::patch('users/{user}/toggle-admin', [UserController::class, 'toggleAdmin'])->name('users.toggle-admin');
    Route::patch('users/{user}/suspend', [UserController::class, 'suspend'])->name('users.suspend');
    Route::delete('users/{user}', [UserController::class, 'destroy'])->name('users.destroy');

    // Groups
    Route::get('groups', [AdminGroupController::class, 'index'])->name('groups.index');
    Route::get('groups/{group}', [AdminGroupController::class, 'show'])->name('groups.show');
    Route::delete('groups/{group}', [AdminGroupController::class, 'destroy'])->name('groups.destroy');

    // Activity feed
    Route::get('activities', [ActivityController::class, 'index'])->name('activities.index');

    // Audit log
    Route::get('audit', [AuditController::class, 'index'])->name('audit.index');

    // Reports / moderation
    Route::get('reports', [ReportController::class, 'index'])->name('reports.index');
    Route::post('reports/{report}/resolve', [ReportController::class, 'resolve'])->name('reports.resolve');

    // Announcements
    Route::get('announcements', [AnnouncementController::class, 'index'])->name('announcements.index');
    Route::post('announcements', [AnnouncementController::class, 'store'])->name('announcements.store');
    Route::delete('announcements/{announcement}', [AnnouncementController::class, 'destroy'])->name('announcements.destroy');

    // Settings + domains
    Route::get('settings', [SettingsController::class, 'index'])->name('settings.index');
    Route::post('settings', [SettingsController::class, 'update'])->name('settings.update');
    Route::post('settings/domains', [SettingsController::class, 'addDomain'])->name('settings.domains.add');
    Route::patch('settings/domains/{domain}/toggle', [SettingsController::class, 'toggleDomain'])->name('settings.domains.toggle');
    Route::delete('settings/domains/{domain}', [SettingsController::class, 'deleteDomain'])->name('settings.domains.delete');

    // Notification feed (JSON for panel)
    Route::get('notifications/feed', [NotificationController::class, 'feed'])->name('notifications.feed');
});

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
