@extends('layouts.admin')
@section('title','Users')
@section('content')
<div class="page-header">
  <div>
    <div class="page-title">
      {{ request('role') === 'admin' ? 'Admins' : 'Students' }}
      <span style="font-size:14px;font-weight:400;color:var(--c-fg2);margin-left:6px">{{ $users->total() }} total</span>
    </div>
  </div>
  <a href="{{ route('admin.users.create', ['role' => request('role', 'student')]) }}"
     class="btn btn-primary">
    <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M7.75 2a.75.75 0 0 1 .75.75V7h4.25a.75.75 0 0 1 0 1.5H8.5v4.25a.75.75 0 0 1-1.5 0V8.5H2.75a.75.75 0 0 1 0-1.5H7V2.75A.75.75 0 0 1 7.75 2Z"/></svg>
    Add {{ request('role') === 'admin' ? 'admin' : 'student' }}
  </a>
</div>

<div class="search-form">
  <form method="GET" style="display:flex;gap:8px;flex-wrap:wrap">
    <input class="input" name="search" value="{{ request('search') }}" placeholder="Name or email…" style="width:220px" />
    <select class="select" name="university" onchange="this.form.submit()">
      <option value="">All universities</option>
      @foreach($universities as $u)<option value="{{ $u }}" {{ request('university')===$u?'selected':'' }}>{{ $u }}</option>@endforeach
    </select>
    <select class="select" name="status" onchange="this.form.submit()">
      <option value="">All status</option>
      <option value="active" {{ request('status')==='active'?'selected':'' }}>Active</option>
      <option value="suspended" {{ request('status')==='suspended'?'selected':'' }}>Suspended</option>
    </select>
    @if(request('role'))<input type="hidden" name="role" value="{{ request('role') }}" />@endif
    <button type="submit" class="btn btn-default">Filter</button>
    @if(request()->hasAny(['search','university','status']))<a href="{{ route('admin.users.index') }}?role={{ request('role') }}" class="btn btn-default">Clear</a>@endif
  </form>
</div>

<div class="card">
  <table>
    <thead><tr><th>User</th><th>University</th><th>Groups</th><th>Email</th><th>Status</th><th>Role</th><th>Joined</th><th>Actions</th></tr></thead>
    <tbody>
      @forelse($users as $u)
      <tr>
        <td>
          <div style="display:flex;align-items:center;gap:10px">
            <div class="av" style="width:32px;height:32px;font-size:12px">
              @if($u->avatar_path)<img src="{{ Storage::url($u->avatar_path) }}" />@else{{ strtoupper(substr($u->name,0,1)) }}@endif
            </div>
            <div>
              <a href="{{ route('admin.users.show',$u) }}" style="font-weight:500">{{ $u->name }}</a>
              <div style="color:var(--c-fg2);font-size:11px">{{ $u->email }}</div>
            </div>
          </div>
        </td>
        <td style="color:var(--c-fg2);font-size:12px">{{ $u->university ?: '—' }}</td>
        <td><span class="badge badge-blue">{{ $u->groups_count }}</span></td>
        <td>
          @if($u->email_verified_at)
            <span class="badge badge-green" title="Verified {{ $u->email_verified_at->format('M d, Y') }}">✓ Verified</span>
          @else
            <span class="badge badge-yellow">Unverified</span>
          @endif
        </td>
        <td>
          <span class="badge {{ match($u->status){'active'=>'badge-green','suspended'=>'badge-red',default=>'badge-yellow'} }}">
            {{ ucfirst($u->status) }}
          </span>
        </td>
        <td><span class="badge {{ $u->is_admin ? 'badge-purple' : 'badge-gray' }}">{{ $u->is_admin ? 'Admin' : 'Student' }}</span></td>
        <td style="color:var(--c-fg2);font-size:12px">{{ $u->created_at->format('M d, Y') }}</td>
        <td>
          <div style="display:flex;gap:4px;flex-wrap:wrap">
            <a href="{{ route('admin.users.show',$u) }}" class="btn btn-default btn-sm">View</a>

            {{-- Edit only for students --}}
            @if(!$u->is_admin)
              <a href="{{ route('admin.users.edit',$u) }}" class="btn btn-default btn-sm">Edit</a>
            @endif

            <form method="POST" action="{{ route('admin.users.suspend',$u) }}">
              @csrf @method('PATCH')
              <button class="btn btn-sm {{ $u->status==='suspended' ? 'btn-primary' : 'btn-warning' }}">
                {{ $u->status==='suspended' ? 'Reactivate' : 'Suspend' }}
              </button>
            </form>

            {{-- Promote/demote admin --}}
            <form method="POST" action="{{ route('admin.users.toggle-admin',$u) }}">
              @csrf @method('PATCH')
              <button class="btn btn-sm btn-default" title="{{ $u->is_admin ? 'Remove admin access' : 'Grant admin access' }}">
                {{ $u->is_admin ? '−Admin' : '+Admin' }}
              </button>
            </form>

            {{-- Delete: never self, never the seeded super-admin --}}
            @if(auth()->id() !== $u->id)
              <form method="POST" action="{{ route('admin.users.destroy',$u) }}"
                onsubmit="return confirm('Permanently delete {{ $u->name }}?')">
                @csrf @method('DELETE')
                <button class="btn btn-danger btn-sm">Delete</button>
              </form>
            @endif
          </div>
        </td>
      </tr>
      @empty
      <tr><td colspan="8" style="text-align:center;color:var(--c-fg2);padding:32px">No users found.</td></tr>
      @endforelse
    </tbody>
  </table>
  @if($users->hasPages())
  <div class="pagination" style="margin-top:12px">
    @if(!$users->onFirstPage())<a class="page-btn" href="{{ $users->previousPageUrl() }}">← Prev</a>@else<span class="page-btn" style="opacity:.4">← Prev</span>@endif
    @foreach($users->getUrlRange(max(1,$users->currentPage()-2),min($users->lastPage(),$users->currentPage()+2)) as $page => $url)
      <a class="page-btn {{ $page===$users->currentPage()?'active':'' }}" href="{{ $url }}">{{ $page }}</a>
    @endforeach
    @if($users->hasMorePages())<a class="page-btn" href="{{ $users->nextPageUrl() }}">Next →</a>@else<span class="page-btn" style="opacity:.4">Next →</span>@endif
  </div>
  @endif
</div>
@endsection
