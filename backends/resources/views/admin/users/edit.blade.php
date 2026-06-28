@extends('layouts.admin')
@section('title', 'Edit ' . $user->name)

@section('content')
<div class="page-header">
  <div style="display:flex;align-items:center;gap:12px">
    <a href="{{ route('admin.users.show', $user) }}" class="btn btn-default btn-sm">← Back</a>
    <div>
      <div class="page-title">Edit student</div>
      <div class="page-subtitle">{{ $user->email }}</div>
    </div>
  </div>
</div>

<div style="max-width:560px">
  <div class="card">
    {{-- Avatar row --}}
    <div style="display:flex;align-items:center;gap:14px;padding-bottom:16px;border-bottom:1px solid var(--c-border);margin-bottom:20px">
      <div style="width:52px;height:52px;border-radius:50%;background:var(--c-blue-dim);display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700;color:var(--c-blue);overflow:hidden">
        @if($user->avatar_path)
          <img src="{{ Storage::url($user->avatar_path) }}" style="width:100%;height:100%;object-fit:cover" />
        @else
          {{ strtoupper(substr($user->name, 0, 1)) }}
        @endif
      </div>
      <div>
        <div style="font-weight:700;font-size:16px">{{ $user->name }}</div>
        <div style="font-size:12px;color:var(--c-fg2);margin-top:2px">
          Student · Joined {{ $user->created_at->format('M d, Y') }}
        </div>
      </div>
    </div>

    <form method="POST" action="{{ route('admin.users.update', $user) }}">
      @csrf
      @method('PATCH')

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Full name</label>
        <input class="input" name="name" value="{{ old('name', $user->name) }}" required style="width:100%" />
        @error('name')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Email address</label>
        <input class="input" name="email" type="email" value="{{ old('email', $user->email) }}" required style="width:100%" />
        @error('email')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="margin-bottom:14px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">University</label>
        <input class="input" name="university" value="{{ old('university', $user->university) }}" placeholder="e.g. MIT, Stanford" style="width:100%" />
        @error('university')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="margin-bottom:20px">
        <label style="display:block;font-size:12px;font-weight:600;margin-bottom:5px;color:var(--c-fg2)">Account status</label>
        <select class="select" name="status" style="width:100%">
          <option value="active"    {{ old('status', $user->status) === 'active'    ? 'selected' : '' }}>Active</option>
          <option value="suspended" {{ old('status', $user->status) === 'suspended' ? 'selected' : '' }}>Suspended</option>
          <option value="pending"   {{ old('status', $user->status) === 'pending'   ? 'selected' : '' }}>Pending</option>
        </select>
        <div style="font-size:11px;color:var(--c-fg2);margin-top:4px">Suspended accounts cannot log in to the mobile app.</div>
        @error('status')<div style="color:var(--c-red);font-size:11px;margin-top:4px">{{ $message }}</div>@enderror
      </div>

      <div style="display:flex;gap:8px">
        <button type="submit" class="btn btn-primary">Save changes</button>
        <a href="{{ route('admin.users.show', $user) }}" class="btn btn-default">Cancel</a>
      </div>
    </form>
  </div>
</div>
@endsection
