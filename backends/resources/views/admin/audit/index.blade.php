@extends('layouts.admin')
@section('title','Audit Log')
@section('content')
<div class="page-header">
  <div>
    <div class="page-title">Audit Log</div>
    <div class="page-subtitle">Every action across the mobile app and admin panel — full accountability</div>
  </div>
  <div style="font-size:12px;color:var(--c-fg2)">
    <span class="badge badge-blue">📱 App</span> &nbsp;
    <span class="badge badge-purple">🖥 Admin</span>
  </div>
</div>

{{-- Filters --}}
<div class="search-form">
  <form method="GET" style="display:flex;gap:8px;flex-wrap:wrap">
    <select class="select" name="source" onchange="this.form.submit()">
      <option value="">All sources</option>
      <option value="app"   {{ request('source')==='app'   ?'selected':'' }}>📱 Mobile app</option>
      <option value="admin" {{ request('source')==='admin' ?'selected':'' }}>🖥 Admin panel</option>
    </select>
    <select class="select" name="user_id" onchange="this.form.submit()">
      <option value="">All users</option>
      @foreach($allUsers as $u)
        <option value="{{ $u->id }}" {{ request('user_id')==$u->id?'selected':'' }}>
          {{ $u->name }}{{ $u->is_admin ? ' (admin)' : '' }}
        </option>
      @endforeach
    </select>
    <select class="select" name="type" onchange="this.form.submit()">
      <option value="">All types</option>
      @foreach($allTypes as $t)
        <option value="{{ $t }}" {{ request('type')===$t?'selected':'' }}>
          {{ str_replace('_',' ',ucwords($t)) }}
        </option>
      @endforeach
    </select>
    @if(request()->hasAny(['source','user_id','type']))
      <a href="{{ route('admin.audit.index') }}" class="btn btn-default">Clear</a>
    @endif
  </form>
</div>

<div class="card">
  <table>
    <thead>
      <tr>
        <th>Source</th>
        <th>Type</th>
        <th>Description</th>
        <th>User</th>
        <th>Context</th>
        <th>When</th>
      </tr>
    </thead>
    <tbody>
      @forelse($unified as $log)
      <tr>
        {{-- Source badge --}}
        <td>
          @if($log->source === 'admin')
            <span class="badge badge-purple" title="Admin panel action">🖥 Admin</span>
          @else
            <span class="badge badge-blue" title="Mobile app event">📱 App</span>
          @endif
        </td>

        {{-- Type badge --}}
        <td>
          @php
            $type = $log->type;
            $badgeClass = match(true) {
              str_contains($type,'login')    => 'badge-green',
              str_contains($type,'logout')   => 'badge-gray',
              str_contains($type,'delete')   => 'badge-red',
              str_contains($type,'suspend')  => 'badge-red',
              str_contains($type,'done')     => 'badge-green',
              str_contains($type,'grant')    => 'badge-purple',
              str_contains($type,'create')   => 'badge-blue',
              str_contains($type,'join')     => 'badge-blue',
              str_contains($type,'assign')   => 'badge-yellow',
              str_contains($type,'update')   => 'badge-gray',
              default                        => 'badge-gray',
            };
          @endphp
          <span class="badge {{ $badgeClass }}" style="white-space:nowrap">
            {{ str_replace('_', ' ', $type) }}
          </span>
        </td>

        {{-- Description --}}
        <td style="max-width:300px;font-size:13px">{{ $log->description }}</td>

        {{-- User --}}
        <td>
          <div style="display:flex;align-items:center;gap:6px">
            <div class="av" style="font-size:10px;background:{{ $log->is_admin ? 'rgba(163,113,247,.2)' : 'rgba(47,129,247,.15)' }};color:{{ $log->is_admin ? 'var(--c-purple)' : 'var(--c-blue)' }}">
              {{ strtoupper(substr($log->user_name,0,1)) }}
            </div>
            <div>
              <div style="font-size:12px;font-weight:500">{{ $log->user_name }}</div>
              @if($log->is_admin)
                <div style="font-size:10px;color:var(--c-purple)">Admin</div>
              @else
                <div style="font-size:10px;color:var(--c-fg2)">Student</div>
              @endif
            </div>
          </div>
        </td>

        {{-- Context --}}
        <td style="color:var(--c-fg2);font-size:12px">{{ $log->context }}</td>

        {{-- When --}}
        <td style="color:var(--c-fg2);font-size:12px;white-space:nowrap">
          {{ $log->created_at->format('M d, Y') }}<br>
          <span style="color:var(--c-fg2);font-size:11px">{{ $log->created_at->format('H:i:s') }}</span>
        </td>
      </tr>
      @empty
      <tr><td colspan="6" style="text-align:center;color:var(--c-fg2);padding:32px">No audit events yet.</td></tr>
      @endforelse
    </tbody>
  </table>

  {{-- Pagination --}}
  @if($paginator->hasPages())
  <div class="pagination" style="margin-top:14px">
    @if(!$paginator->onFirstPage())
      <a class="page-btn" href="{{ $paginator->previousPageUrl() }}">← Prev</a>
    @else
      <span class="page-btn" style="opacity:.4">← Prev</span>
    @endif

    <span style="font-size:12px;color:var(--c-fg2);padding:0 8px">
      Page {{ $paginator->currentPage() }} of {{ $paginator->lastPage() }}
    </span>

    @if($paginator->hasMorePages())
      <a class="page-btn" href="{{ $paginator->nextPageUrl() }}">Next →</a>
    @else
      <span class="page-btn" style="opacity:.4">Next →</span>
    @endif
  </div>
  @endif
</div>
@endsection
