@extends('layouts.admin')
@section('title', 'Profile Settings')

@section('content')
<div class="page-header">
  <div>
    <div class="page-title">Profile Settings</div>
    <div class="page-subtitle">Manage your admin account name, email and password</div>
  </div>
  <a href="{{ route('admin.dashboard') }}" class="btn btn-default">← Dashboard</a>
</div>

<div style="max-width:560px;display:flex;flex-direction:column;gap:16px">

  {{-- ── Profile Information ──────────────────────────────────────────── --}}
  <div class="card">
    <div class="card-title">
      <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
      Profile Information
    </div>

    @if(session('status') === 'profile-updated')
      <div class="flash flash-success" style="margin-bottom:14px">✓ Profile updated.</div>
    @endif

    <form method="POST" action="{{ route('profile.update') }}">
      @csrf
      @method('patch')

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Full name</label>
        <input class="input" name="name" type="text"
          value="{{ old('name', $user->name) }}"
          required autofocus autocomplete="name" style="width:100%" />
        @error('name')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="margin-bottom:20px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Email address</label>
        <input class="input" name="email" type="email"
          value="{{ old('email', $user->email) }}"
          required autocomplete="username" style="width:100%" />
        @error('email')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <button type="submit" class="btn btn-primary">Save profile</button>
    </form>
  </div>

  {{-- ── Change Password ──────────────────────────────────────────────── --}}
  <div class="card">
    <div class="card-title">
      <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M4 8a4 4 0 0 1 7.938-.5h1.43a.75.75 0 0 1 0 1.5H12A4 4 0 0 1 4 8Zm4-2.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5Z"/></svg>
      Change Password
    </div>

    @if(session('status') === 'password-updated')
      <div class="flash flash-success" style="margin-bottom:14px">✓ Password updated.</div>
    @endif

    <form method="POST" action="{{ route('password.update') }}">
      @csrf
      @method('put')

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Current password</label>
        <input class="input" name="current_password" type="password"
          autocomplete="current-password" style="width:100%" placeholder="••••••••" />
        @error('current_password', 'updatePassword')
          <div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>
        @enderror
      </div>

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">New password</label>
        <input class="input" name="password" type="password"
          autocomplete="new-password" style="width:100%" placeholder="Minimum 8 characters" />
        @error('password', 'updatePassword')
          <div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>
        @enderror
      </div>

      <div style="margin-bottom:20px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Confirm new password</label>
        <input class="input" name="password_confirmation" type="password"
          autocomplete="new-password" style="width:100%" placeholder="Re-enter new password" />
        @error('password_confirmation', 'updatePassword')
          <div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>
        @enderror
      </div>

      <button type="submit" class="btn btn-primary">Update password</button>
    </form>
  </div>

  {{-- ── Danger Zone ──────────────────────────────────────────────────── --}}
  <div class="card" style="border-color:rgba(248,81,73,.3)">
    <div class="card-title" style="color:var(--c-red)">
      <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z"/></svg>
      Danger Zone
    </div>

    <p style="font-size:13px;color:var(--c-fg2);margin-bottom:16px">
      Once you delete your account all data will be permanently removed. This action cannot be undone.
    </p>

    <button type="button" class="btn btn-danger"
      onclick="document.getElementById('delete-modal').style.display='flex'">
      Delete my account
    </button>
  </div>

</div>

{{-- Delete confirmation modal --}}
<div id="delete-modal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:500;align-items:center;justify-content:center">
  <div style="background:var(--c-surface);border:1px solid var(--c-border);border-radius:14px;padding:24px;width:360px;max-width:90vw">
    <h3 style="font-size:16px;font-weight:700;margin-bottom:8px;color:var(--c-fg)">Delete account?</h3>
    <p style="font-size:13px;color:var(--c-fg2);margin-bottom:20px;line-height:1.5">
      Please enter your password to confirm. This permanently deletes your account.
    </p>
    <form method="POST" action="{{ route('profile.destroy') }}">
      @csrf
      @method('delete')
      <input class="input" name="password" type="password"
        placeholder="Enter your password" required style="width:100%;margin-bottom:14px" />
      @error('password', 'userDeletion')
        <div style="color:var(--c-red);font-size:11px;margin-bottom:10px">{{ $message }}</div>
      @enderror
      <div style="display:flex;gap:8px">
        <button type="submit" class="btn btn-danger">Yes, delete my account</button>
        <button type="button" class="btn btn-default"
          onclick="document.getElementById('delete-modal').style.display='none'">Cancel</button>
      </div>
    </form>
  </div>
</div>

@endsection
