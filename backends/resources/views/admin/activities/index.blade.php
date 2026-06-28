@extends('layouts.admin')
@section('title', 'Activity Feed')

@section('content')
<div class="page-header">
  <div>
    <div class="page-title">Activity Feed</div>
    <div class="page-subtitle">All platform events in real-time order</div>
  </div>
</div>

{{-- Filter --}}
<div class="search-form">
  <form method="GET" style="display:flex;gap:8px">
    <select class="input" name="type" onchange="this.form.submit()" style="padding-right:24px">
      <option value="">All types</option>
      @foreach($types as $type)
        <option value="{{ $type }}" {{ request('type') === $type ? 'selected' : '' }}>
          {{ str_replace('_', ' ', ucwords($type)) }}
        </option>
      @endforeach
    </select>
    @if(request('type'))
      <a href="{{ route('admin.activities.index') }}" class="btn btn-default">Clear</a>
    @endif
  </form>
</div>

<div class="card">
  <table>
    <thead>
      <tr>
        <th>Type</th>
        <th>Description</th>
        <th>User</th>
        <th>Group</th>
        <th>When</th>
      </tr>
    </thead>
    <tbody>
      @forelse($activities as $a)
      <tr>
        <td>
          @php
            $badge = match($a->type) {
              'section_done'     => ['badge-green',  'Done'],
              'member_joined'    => ['badge-blue',   'Joined'],
              'section_assigned' => ['badge-yellow', 'Assigned'],
              'section_updated'  => ['badge-gray',   'Updated'],
              default            => ['badge-gray',   str_replace('_',' ',ucwords($a->type))],
            };
          @endphp
          <span class="badge {{ $badge[0] }}">{{ $badge[1] }}</span>
        </td>
        <td style="max-width:320px">{{ $a->description }}</td>
        <td>
          @if($a->user)
            <a href="{{ route('admin.users.show', $a->user) }}">{{ $a->user->name }}</a>
          @else
            <span style="color:var(--c-fg2)">—</span>
          @endif
        </td>
        <td>
          @if($a->group)
            <a href="{{ route('admin.groups.show', $a->group) }}">{{ $a->group->name }}</a>
          @else
            <span style="color:var(--c-fg2)">—</span>
          @endif
        </td>
        <td style="color:var(--c-fg2);white-space:nowrap">{{ $a->created_at->diffForHumans() }}</td>
      </tr>
      @empty
      <tr><td colspan="5" style="text-align:center;color:var(--c-fg2);padding:32px">No activities yet.</td></tr>
      @endforelse
    </tbody>
  </table>

  @if($activities->hasPages())
  <div class="pagination" style="margin-top:16px">
    @if($activities->onFirstPage())
      <span class="page-btn" style="opacity:.4">← Prev</span>
    @else
      <a class="page-btn" href="{{ $activities->previousPageUrl() }}">← Prev</a>
    @endif
    @foreach($activities->getUrlRange(max(1,$activities->currentPage()-2),min($activities->lastPage(),$activities->currentPage()+2)) as $page => $url)
      <a class="page-btn {{ $page === $activities->currentPage() ? 'active' : '' }}" href="{{ $url }}">{{ $page }}</a>
    @endforeach
    @if($activities->hasMorePages())
      <a class="page-btn" href="{{ $activities->nextPageUrl() }}">Next →</a>
    @else
      <span class="page-btn" style="opacity:.4">Next →</span>
    @endif
  </div>
  @endif
</div>
@endsection
