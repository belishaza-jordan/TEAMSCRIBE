@extends('layouts.admin')
@section('title', 'Groups')

@section('content')
<div class="page-header">
  <div>
    <div class="page-title">Groups</div>
    <div class="page-subtitle">{{ $groups->total() }} total groups created</div>
  </div>
</div>

<div class="search-form">
  <form method="GET" style="display:flex;gap:8px">
    <input class="input" name="search" value="{{ request('search') }}" placeholder="Search by group name…" style="width:280px" />
    <button type="submit" class="btn btn-default">Search</button>
    @if(request('search'))
      <a href="{{ route('admin.groups.index') }}" class="btn btn-default">Clear</a>
    @endif
  </form>
</div>

<div class="card">
  <table>
    <thead>
      <tr>
        <th>Group</th>
        <th>Creator</th>
        <th>Members</th>
        <th>Sections</th>
        <th>Messages</th>
        <th>Created</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      @forelse($groups as $group)
      <tr>
        <td>
          <a href="{{ route('admin.groups.show', $group) }}" style="font-weight:500">{{ $group->name }}</a>
          @if($group->course)
            <div style="color:var(--c-fg2);font-size:11px">{{ $group->course }}</div>
          @endif
        </td>
        <td style="color:var(--c-fg2)">{{ $group->creator?->name ?? '—' }}</td>
        <td><span class="badge badge-blue">{{ $group->members_count }}</span></td>
        <td><span class="badge badge-yellow">{{ $group->sections_count }}</span></td>
        <td><span class="badge badge-gray">{{ $group->messages_count }}</span></td>
        <td style="color:var(--c-fg2)">{{ $group->created_at->format('M d, Y') }}</td>
        <td>
          <div style="display:flex;gap:6px">
            <a href="{{ route('admin.groups.show', $group) }}" class="btn btn-default btn-sm">View</a>
            <form method="POST" action="{{ route('admin.groups.destroy', $group) }}"
              onsubmit="return confirm('Delete group {{ $group->name }}? All messages and sections will be lost.')">
              @csrf @method('DELETE')
              <button type="submit" class="btn btn-danger btn-sm">Delete</button>
            </form>
          </div>
        </td>
      </tr>
      @empty
      <tr><td colspan="7" style="text-align:center;color:var(--c-fg2);padding:32px">No groups found.</td></tr>
      @endforelse
    </tbody>
  </table>

  @if($groups->hasPages())
  <div class="pagination" style="margin-top:16px">
    @if($groups->onFirstPage())
      <span class="page-btn" style="opacity:.4">← Prev</span>
    @else
      <a class="page-btn" href="{{ $groups->previousPageUrl() }}">← Prev</a>
    @endif
    @foreach($groups->getUrlRange(max(1,$groups->currentPage()-2), min($groups->lastPage(),$groups->currentPage()+2)) as $page => $url)
      <a class="page-btn {{ $page === $groups->currentPage() ? 'active' : '' }}" href="{{ $url }}">{{ $page }}</a>
    @endforeach
    @if($groups->hasMorePages())
      <a class="page-btn" href="{{ $groups->nextPageUrl() }}">Next →</a>
    @else
      <span class="page-btn" style="opacity:.4">Next →</span>
    @endif
  </div>
  @endif
</div>
@endsection
