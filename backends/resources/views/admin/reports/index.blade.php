@extends('layouts.admin')
@section('title','Reports')
@section('content')
<div class="page-header">
  <div><div class="page-title">Reports & Moderation</div><div class="page-subtitle">Review reported content and take action</div></div>
</div>
<div class="search-form">
  <form method="GET" style="display:flex;gap:8px">
    <select class="select" name="status" onchange="this.form.submit()">
      <option value="">All status</option>
      <option value="pending" {{ request('status')==='pending'?'selected':'' }}>Pending</option>
      <option value="resolved" {{ request('status')==='resolved'?'selected':'' }}>Resolved</option>
      <option value="dismissed" {{ request('status')==='dismissed'?'selected':'' }}>Dismissed</option>
    </select>
    @if(request('status'))<a href="{{ route('admin.reports.index') }}" class="btn btn-default">Clear</a>@endif
  </form>
</div>
<div class="card">
  <table>
    <thead><tr><th>Reporter</th><th>Type</th><th>Reason</th><th>Status</th><th>When</th><th>Actions</th></tr></thead>
    <tbody>
      @forelse($reports as $r)
      <tr>
        <td>
          <div style="display:flex;align-items:center;gap:8px">
            <div class="av">{{ strtoupper(substr($r->reporter?->name??'?',0,1)) }}</div>
            <span>{{ $r->reporter?->name ?? '—' }}</span>
          </div>
        </td>
        <td><span class="badge badge-gray">{{ ucfirst($r->reported_type) }} #{{ $r->reported_id }}</span></td>
        <td>{{ Str::limit($r->reason,40) }}</td>
        <td>
          <span class="badge {{ match($r->status){'pending'=>'badge-yellow','resolved'=>'badge-green',default=>'badge-gray'} }}">
            {{ ucfirst($r->status) }}
          </span>
        </td>
        <td style="color:var(--c-fg2)">{{ $r->created_at->diffForHumans() }}</td>
        <td>
          @if($r->status==='pending')
          <div style="display:flex;gap:4px;flex-wrap:wrap">
            <form method="POST" action="{{ route('admin.reports.resolve',$r) }}">
              @csrf
              <input type="hidden" name="action" value="resolved" />
              <button class="btn btn-primary btn-sm">Resolve</button>
            </form>
            <form method="POST" action="{{ route('admin.reports.resolve',$r) }}">
              @csrf
              <input type="hidden" name="action" value="dismiss" />
              <button class="btn btn-default btn-sm">Dismiss</button>
            </form>
            <form method="POST" action="{{ route('admin.reports.resolve',$r) }}">
              @csrf
              <input type="hidden" name="action" value="suspend" />
              <button class="btn btn-danger btn-sm">Suspend user</button>
            </form>
          </div>
          @else
            <span style="color:var(--c-fg2);font-size:12px">Handled by {{ $r->resolver?->name ?? '—' }}</span>
          @endif
        </td>
      </tr>
      @empty
      <tr><td colspan="6" style="text-align:center;color:var(--c-fg2);padding:32px">No reports found.</td></tr>
      @endforelse
    </tbody>
  </table>
  @if($reports->hasPages())
  <div class="pagination" style="margin-top:12px">
    @if(!$reports->onFirstPage())<a class="page-btn" href="{{ $reports->previousPageUrl() }}">← Prev</a>@else<span class="page-btn" style="opacity:.4">← Prev</span>@endif
    @if($reports->hasMorePages())<a class="page-btn" href="{{ $reports->nextPageUrl() }}">Next →</a>@else<span class="page-btn" style="opacity:.4">Next →</span>@endif
  </div>
  @endif
</div>
@endsection
