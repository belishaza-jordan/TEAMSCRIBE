@extends('layouts.admin')
@section('title', $role === 'admin' ? 'Add Admin' : 'Add Student')

@section('content')
<div class="page-header">
  <div style="display:flex;align-items:center;gap:12px">
    <a href="{{ route('admin.users.index', $role === 'admin' ? ['role'=>'admin'] : []) }}"
       class="btn btn-default btn-sm">← Back</a>
    <div>
      <div class="page-title">{{ $role === 'admin' ? 'Add new admin' : 'Add new student' }}</div>
      <div class="page-subtitle">
        @if($role === 'admin')
          A welcome email with a password-setup link will be sent to their Gmail.
        @else
          A welcome email will be sent with instructions to activate their account in the TeamScribe app.
        @endif
      </div>
    </div>
  </div>
</div>

<div style="max-width:520px">
  <div class="card">

    {{-- Role indicator --}}
    <div style="display:flex;align-items:center;gap:10px;padding:12px 14px;margin-bottom:20px;background:var(--c-canvas);border:1px solid var(--c-border);border-radius:8px">
      @if($role === 'admin')
        <div style="width:36px;height:36px;border-radius:8px;background:rgba(47,129,247,.12);display:flex;align-items:center;justify-content:center">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-blue)"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm4.879-2.773 4.264 2.559a.25.25 0 0 1 0 .428l-4.264 2.559A.25.25 0 0 1 6 10.559V5.442a.25.25 0 0 1 .379-.215Z"/></svg>
        </div>
        <div>
          <div style="font-weight:600;font-size:13px;color:var(--c-fg)">Admin account</div>
          <div style="font-size:11px;color:var(--c-fg2)">Will receive a Gmail with a link to set their password on the web panel</div>
        </div>
      @else
        <div style="width:36px;height:36px;border-radius:8px;background:rgba(63,185,80,.12);display:flex;align-items:center;justify-content:center">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-green)"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
        </div>
        <div>
          <div style="font-weight:600;font-size:13px;color:var(--c-fg)">Student account</div>
          <div style="font-size:11px;color:var(--c-fg2)">Will receive a Gmail with instructions to set up their account in the mobile app</div>
        </div>
      @endif
    </div>

    <form method="POST" action="{{ route('admin.users.store') }}">
      @csrf
      <input type="hidden" name="role" value="{{ $role }}" />

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">
          Full name <span style="color:var(--c-red)">*</span>
        </label>
        <input class="input" name="name" type="text" value="{{ old('name') }}"
          required autofocus placeholder="e.g. Berry Jordan" style="width:100%" />
        @error('name')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">
          Email address <span style="color:var(--c-red)">*</span>
        </label>
        <input class="input" name="email" type="email" value="{{ old('email') }}"
          required placeholder="their@gmail.com" style="width:100%" />
        <div style="font-size:11px;color:var(--c-fg2);margin-top:4px">
          The welcome email will be sent here.
        </div>
        @error('email')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      @if($role === 'student')
      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">
          University
        </label>
        <input class="input" name="university" type="text" value="{{ old('university') }}"
          placeholder="e.g. MIT, Stanford, UCT" style="width:100%" />
        @error('university')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>
      @endif

      {{-- Email preview note --}}
      <div style="background:var(--c-canvas);border:1px solid var(--c-border);border-radius:8px;padding:12px 14px;margin-bottom:20px">
        <div style="font-size:11px;font-weight:600;color:var(--c-fg2);text-transform:uppercase;letter-spacing:.6px;margin-bottom:8px">What they'll receive</div>
        @if($role === 'admin')
          <div style="font-size:13px;color:var(--c-fg);line-height:1.6">
            📧 <strong>Subject:</strong> You've been invited to TeamScribe Admin<br/>
            🔗 A <strong>Set my password</strong> button linking to the web reset-password page<br/>
            ⏱ The link expires in <strong>60 minutes</strong>
          </div>
        @else
          <div style="font-size:13px;color:var(--c-fg);line-height:1.6">
            📧 <strong>Subject:</strong> Welcome to TeamScribe — set up your account<br/>
            📱 Step-by-step instructions to:<br/>
            &nbsp;&nbsp;1. Download the TeamScribe app<br/>
            &nbsp;&nbsp;2. Use <strong>Forgot Password</strong> with their email<br/>
            &nbsp;&nbsp;3. Enter the OTP and set a new password
          </div>
        @endif
      </div>

      <div style="display:flex;gap:8px">
        <button type="submit" class="btn btn-primary">
          Create & send email
        </button>
        <a href="{{ route('admin.users.index', $role === 'admin' ? ['role'=>'admin'] : []) }}"
           class="btn btn-default">Cancel</a>
      </div>
    </form>
  </div>
</div>
@endsection
