@extends('layouts.admin')
@section('title', $group->name)

@section('content')
<div class="page-header">
  <div style="display:flex;align-items:center;gap:12px">
    <a href="{{ route('admin.groups.index') }}" class="btn btn-default btn-sm">← Back</a>
    <div>
      <div class="page-title">{{ $group->name }}</div>
      <div class="page-subtitle">{{ $group->course ? $group->course . ' · ' : '' }}Created by {{ $group->creator?->name }}</div>
    </div>
  </div>
  <form method="POST" action="{{ route('admin.groups.destroy', $group) }}"
    onsubmit="return confirm('Delete this group and all its data?')">
    @csrf @method('DELETE')
    <button type="submit" class="btn btn-danger">Delete Group</button>
  </form>
</div>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px">
  {{-- Members --}}
  <div class="card">
    <div class="card-title">Members ({{ $group->members->count() }})</div>
    <table>
      <thead><tr><th>Member</th><th>Role</th></tr></thead>
      <tbody>
        @foreach($group->members as $m)
        <tr>
          <td>
            <div style="display:flex;align-items:center;gap:8px">
              <div class="avatar">{{ strtoupper(substr($m->name,0,1)) }}</div>
              <div>
                <a href="{{ route('admin.users.show', $m) }}">{{ $m->name }}</a>
                <div style="color:var(--c-fg2);font-size:11px">{{ $m->email }}</div>
              </div>
            </div>
          </td>
          <td>
            <span class="badge {{ $m->pivot->role === 'admin' ? 'badge-green' : 'badge-gray' }}">
              {{ ucfirst($m->pivot->role) }}
            </span>
          </td>
        </tr>
        @endforeach
      </tbody>
    </table>
  </div>

  {{-- Sections --}}
  <div class="card">
    <div class="card-title">Sections ({{ $group->sections->count() }})</div>
    <table>
      <thead><tr><th>Title</th><th>Assigned</th><th>Status</th><th>Progress</th></tr></thead>
      <tbody>
        @foreach($group->sections as $s)
        <tr>
          <td style="font-weight:500">{{ $s->title }}</td>
          <td style="color:var(--c-fg2)">{{ $s->assignee?->name ?? '—' }}</td>
          <td>
            <span class="badge {{ match($s->status) { 'done' => 'badge-green', 'in_progress' => 'badge-yellow', default => 'badge-gray' } }}">
              {{ str_replace('_', ' ', ucfirst($s->status)) }}
            </span>
          </td>
          <td>
            <div style="display:flex;align-items:center;gap:6px">
              <div style="width:60px;height:5px;background:var(--c-border);border-radius:3px;overflow:hidden">
                <div style="width:{{ $s->progress }}%;height:100%;background:var(--c-blue)"></div>
              </div>
              <span style="color:var(--c-fg2);font-size:11px">{{ $s->progress }}%</span>
            </div>
          </td>
        </tr>
        @endforeach
      </tbody>
    </table>
  </div>
</div>

{{-- Recent messages --}}
<div class="card">
  <div class="card-title">Recent Messages ({{ $group->messages->count() }})</div>
  @if($group->messages->isEmpty())
    <p style="color:var(--c-fg2);text-align:center;padding:24px 0">No messages yet.</p>
  @else
    <div style="max-height:300px;overflow-y:auto">
      @foreach($group->messages->take(20) as $msg)
      <div style="display:flex;gap:10px;padding:8px 0;border-bottom:1px solid var(--c-border2)">
        <div class="avatar" style="width:28px;height:28px;font-size:10px;flex-shrink:0">
          {{ strtoupper(substr($msg->sender?->name ?? '?', 0, 1)) }}
        </div>
        <div>
          <span style="font-weight:500;font-size:12px">{{ $msg->sender?->name ?? 'Unknown' }}</span>
          <span style="color:var(--c-fg2);font-size:11px;margin-left:6px">{{ $msg->created_at->diffForHumans() }}</span>
          <div style="color:var(--c-fg);font-size:13px;margin-top:2px">{{ $msg->content }}</div>
        </div>
      </div>
      @endforeach
    </div>
  @endif
</div>
@endsection
