@extends('layouts.admin')
@section('title', $user->name)

@section('content')
<div class="page-header">
  <div style="display:flex;align-items:center;gap:12px">
    <a href="{{ route('admin.users.index') }}" class="btn btn-default btn-sm">← Back</a>
    <div>
      <div class="page-title">{{ $user->name }}</div>
      <div class="page-subtitle">{{ $user->email }}</div>
    </div>
  </div>
  <div style="display:flex;gap:8px">
    {{-- Edit profile — students only --}}
    @if(!$user->is_admin)
      <a href="{{ route('admin.users.edit', $user) }}" class="btn btn-default">
        <svg width="13" height="13" viewBox="0 0 16 16" fill="currentColor"><path d="M11.013 1.427a1.75 1.75 0 0 1 2.474 0l1.086 1.086a1.75 1.75 0 0 1 0 2.474l-8.61 8.61c-.21.21-.47.364-.756.445l-3.251.93a.75.75 0 0 1-.927-.928l.929-3.25c.081-.286.235-.547.445-.758l8.61-8.61Zm.176 4.823L9.75 4.81l-6.286 6.287a.253.253 0 0 0-.064.108l-.558 1.953 1.953-.558a.253.253 0 0 0 .108-.064Zm1.238-3.763a.25.25 0 0 0-.354 0L10.811 3.75l1.439 1.44 1.263-1.263a.25.25 0 0 0 0-.354Z"/></svg>
        Edit student
      </a>
    @endif

    <form method="POST" action="{{ route('admin.users.toggle-admin', $user) }}">
      @csrf @method('PATCH')
      <button type="submit" class="btn {{ $user->is_admin ? 'btn-danger' : 'btn-default' }}">
        {{ $user->is_admin ? '−Remove admin' : '+Make admin' }}
      </button>
    </form>
  </div>
</div>

<div style="display:grid;grid-template-columns:300px 1fr;gap:16px">
  {{-- Profile card --}}
  <div>
    <div class="card" style="text-align:center;padding:24px">
      <div style="width:64px;height:64px;border-radius:50%;background:var(--c-blue-dim);display:flex;align-items:center;justify-content:center;font-size:24px;font-weight:700;color:var(--c-blue);margin:0 auto 12px;overflow:hidden">
        @if($user->avatar_path)
          <img src="{{ Storage::url($user->avatar_path) }}" alt="avatar" style="width:100%;height:100%;object-fit:cover" />
        @else
          {{ strtoupper(substr($user->name,0,1)) }}
        @endif
      </div>
      <div style="font-size:16px;font-weight:700">{{ $user->name }}</div>
      <div style="color:var(--c-fg2);font-size:13px;margin:2px 0 12px">{{ $user->email }}</div>
      @if($user->is_admin)
        <span class="badge badge-green" style="font-size:12px">Admin</span>
      @endif
    </div>

    <div class="card" style="margin-top:12px">
      <div class="card-title">Details</div>
      <div style="font-size:13px">
        <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--c-border2)">
          <span style="color:var(--c-fg2)">University</span>
          <span>{{ $user->university ?: '—' }}</span>
        </div>
        <div style="display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--c-border2)">
          <span style="color:var(--c-fg2)">Groups</span>
          <span class="badge badge-blue">{{ $user->groups->count() }}</span>
        </div>
        <div style="display:flex;justify-content:space-between;padding:6px 0">
          <span style="color:var(--c-fg2)">Joined</span>
          <span>{{ $user->created_at->format('M d, Y') }}</span>
        </div>
      </div>
    </div>
  </div>

  {{-- Groups --}}
  <div>
    <div class="card">
      <div class="card-title">Groups ({{ $user->groups->count() }})</div>
      @if($user->groups->isEmpty())
        <p style="color:var(--c-fg2);text-align:center;padding:24px 0">No groups yet.</p>
      @else
        <table>
          <thead><tr><th>Group</th><th>Course</th><th>Sections</th><th>Progress</th></tr></thead>
          <tbody>
            @foreach($user->groups as $g)
            <tr>
              <td><a href="{{ route('admin.groups.show', $g) }}">{{ $g->name }}</a></td>
              <td style="color:var(--c-fg2)">{{ $g->course ?: '—' }}</td>
              <td><span class="badge badge-blue">{{ $g->sections->count() }}</span></td>
              <td>
                @php $done = $g->sections->where('status','done')->count(); $total = $g->sections->count(); $pct = $total ? round($done/$total*100) : 0; @endphp
                <div style="display:flex;align-items:center;gap:8px">
                  <div style="flex:1;height:6px;background:var(--c-border);border-radius:3px;overflow:hidden">
                    <div style="width:{{ $pct }}%;height:100%;background:var(--c-blue);border-radius:3px"></div>
                  </div>
                  <span style="color:var(--c-fg2);font-size:11px">{{ $pct }}%</span>
                </div>
              </td>
            </tr>
            @endforeach
          </tbody>
        </table>
      @endif
    </div>
  </div>
</div>
@endsection
