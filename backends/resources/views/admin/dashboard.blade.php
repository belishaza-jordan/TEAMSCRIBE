@extends('layouts.admin')
@section('title', 'Dashboard')

@section('content')

<div class="page-header">
  <div>
    <div class="page-title">Dashboard</div>
    <div class="page-subtitle">TeamScribe platform overview — updated in real time</div>
  </div>
  <a href="{{ route('admin.users.index') }}" class="btn btn-primary">
    <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
    Manage users
  </a>
</div>

{{-- Stats cards --}}
<div class="stats-grid">
  <div class="stat-card">
    <div class="stat-icon" style="background:rgba(47,129,247,.12)">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-blue)"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
    </div>
    <div class="stat-label">Total Users</div>
    <div class="stat-value">{{ number_format($stats['users']) }}</div>
  </div>
  <div class="stat-card">
    <div class="stat-icon" style="background:rgba(63,185,80,.12)">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-green)"><path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.549-.514 3.507 3.507 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 5.5.75.75 0 0 1 11 4Zm-5.5-.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"/></svg>
    </div>
    <div class="stat-label">Total Groups</div>
    <div class="stat-value">{{ number_format($stats['groups']) }}</div>
  </div>
  <div class="stat-card">
    <div class="stat-icon" style="background:rgba(163,113,247,.12)">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-purple)"><path d="M2.678 11.894a1 1 0 0 1 .287.801 11.81 11.81 0 0 1-.398 2.014 11.815 11.815 0 0 0 2.666-1.42 1 1 0 0 1 .592-.168c.139.012.277.023.418.03C10.612 13.384 15 9.907 15 5.5S10.612-.016 6 .156C1.388-.016 0 3.584 0 5.5c0 2.393 1.407 4.483 3.678 5.894Z"/></svg>
    </div>
    <div class="stat-label">Messages Sent</div>
    <div class="stat-value">{{ number_format($stats['messages']) }}</div>
  </div>
  <div class="stat-card">
    <div class="stat-icon" style="background:rgba(210,153,34,.12)">
      <svg width="16" height="16" viewBox="0 0 16 16" fill="var(--c-yellow)"><path d="M1.75 1h8.5c.966 0 1.75.784 1.75 1.75v5.5A1.75 1.75 0 0 1 10.25 10H7.061l-2.574 2.573A1.458 1.458 0 0 1 2 11.543V10h-.25A1.75 1.75 0 0 1 0 8.25v-5.5C0 1.784.784 1 1.75 1ZM1.5 2.75v5.5c0 .138.112.25.25.25h1a.75.75 0 0 1 .75.75v2.19l2.72-2.72a.749.749 0 0 1 .53-.22h3.5a.25.25 0 0 0 .25-.25v-5.5a.25.25 0 0 0-.25-.25h-8.5a.25.25 0 0 0-.25.25Z"/></svg>
    </div>
    <div class="stat-label">Sections Created</div>
    <div class="stat-value">{{ number_format($stats['sections']) }}</div>
  </div>
</div>

{{-- Charts row --}}
<div class="charts-row">
  {{-- Line chart: registrations --}}
  <div class="card">
    <div class="card-title">
      <svg width="14" height="14" viewBox="0 0 16 16" fill="var(--c-blue)"><path d="M0 0h1.5v15H0Zm14.5 3h-13v1.5h13Zm0 4h-13v1.5h13Zm0 4h-13v1.5h13Z"/></svg>
      User Registrations — last 30 days
    </div>
    <div class="chart-wrap"><canvas id="regChart"></canvas></div>
  </div>

  {{-- Donut: section status --}}
  <div class="card">
    <div class="card-title">
      <svg width="14" height="14" viewBox="0 0 16 16" fill="var(--c-green)"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5Z"/></svg>
      Section Status
    </div>
    <div class="chart-wrap" style="height:200px"><canvas id="statusChart"></canvas></div>
    <div style="display:flex;gap:12px;justify-content:center;margin-top:10px;font-size:12px;">
      <span style="color:var(--c-blue)">● Done</span>
      <span style="color:var(--c-yellow)">● In Progress</span>
      <span style="color:var(--c-fg2)">● Not Started</span>
    </div>
  </div>
</div>

{{-- Groups bar chart --}}
<div class="card" style="margin-bottom:20px">
  <div class="card-title">
    <svg width="14" height="14" viewBox="0 0 16 16" fill="var(--c-purple)"><path d="M3 4.75A2.75 2.75 0 0 1 5.75 2h4.5A2.75 2.75 0 0 1 13 4.75v6.5A2.75 2.75 0 0 1 10.25 14h-4.5A2.75 2.75 0 0 1 3 11.25ZM5.75 3.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h4.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25Z"/></svg>
    Groups Created — last 14 days
  </div>
  <div class="chart-wrap" style="height:160px"><canvas id="groupChart"></canvas></div>
</div>

{{-- Recent tables --}}
<div class="table-grid">
  {{-- Recent users --}}
  <div class="card">
    <div class="card-title">Recent Users</div>
    <table>
      <thead><tr><th>User</th><th>University</th><th>Joined</th></tr></thead>
      <tbody>
        @foreach($recentUsers as $u)
        <tr>
          <td>
            <div style="display:flex;align-items:center;gap:8px">
              <div class="avatar">{{ strtoupper(substr($u->name,0,1)) }}</div>
              <div>
                <div style="font-weight:500">{{ $u->name }}</div>
                <div style="color:var(--c-fg2);font-size:11px">{{ $u->email }}</div>
              </div>
            </div>
          </td>
          <td style="color:var(--c-fg2)">{{ $u->university ?: '—' }}</td>
          <td style="color:var(--c-fg2)">{{ $u->created_at->diffForHumans() }}</td>
        </tr>
        @endforeach
      </tbody>
    </table>
    <div style="margin-top:10px"><a href="{{ route('admin.users.index') }}" class="btn btn-default btn-sm">View all users →</a></div>
  </div>

  {{-- Recent groups --}}
  <div class="card">
    <div class="card-title">Recent Groups</div>
    <table>
      <thead><tr><th>Group</th><th>Creator</th><th>Created</th></tr></thead>
      <tbody>
        @foreach($recentGroups as $g)
        <tr>
          <td>
            <div style="font-weight:500">{{ $g->name }}</div>
            @if($g->course)<div style="color:var(--c-fg2);font-size:11px">{{ $g->course }}</div>@endif
          </td>
          <td style="color:var(--c-fg2)">{{ $g->creator?->name ?? '—' }}</td>
          <td style="color:var(--c-fg2)">{{ $g->created_at->diffForHumans() }}</td>
        </tr>
        @endforeach
      </tbody>
    </table>
    <div style="margin-top:10px"><a href="{{ route('admin.groups.index') }}" class="btn btn-default btn-sm">View all groups →</a></div>
  </div>
</div>

{{-- Recent activity --}}
<div class="card">
  <div class="card-title">Recent Activity</div>
  <table>
    <thead><tr><th>Event</th><th>User</th><th>Group</th><th>When</th></tr></thead>
    <tbody>
      @foreach($recentActivities as $a)
      <tr>
        <td>
          @php
            $badge = match($a->type) {
              'section_done'     => ['badge-green',  'Done'],
              'member_joined'    => ['badge-blue',   'Joined'],
              'section_assigned' => ['badge-yellow', 'Assigned'],
              default            => ['badge-gray',   'Updated'],
            };
          @endphp
          <span class="badge {{ $badge[0] }}">{{ $badge[1] }}</span>
          <span style="margin-left:8px;color:var(--c-fg2);font-size:12px">{{ Str::limit($a->description, 50) }}</span>
        </td>
        <td style="color:var(--c-fg2)">{{ $a->user?->name ?? '—' }}</td>
        <td style="color:var(--c-fg2)">{{ $a->group?->name ?? '—' }}</td>
        <td style="color:var(--c-fg2)">{{ $a->created_at->diffForHumans() }}</td>
      </tr>
      @endforeach
    </tbody>
  </table>
</div>

@endsection

@push('scripts')
<script>
const isDark = () => document.documentElement.getAttribute('data-theme') === 'dark';
const gridColor = () => isDark() ? 'rgba(255,255,255,.06)' : 'rgba(0,0,0,.06)';
const tickColor = () => isDark() ? '#8b949e' : '#636e7b';

// ── Registrations line chart ──────────────────────────────────────────────
const regCtx = document.getElementById('regChart').getContext('2d');
const regData = @json($regData);
const regLabels = @json($regLabels);

const grad = regCtx.createLinearGradient(0,0,0,220);
grad.addColorStop(0, 'rgba(47,129,247,.25)');
grad.addColorStop(1, 'rgba(47,129,247,0)');

new Chart(regCtx, {
  type: 'line',
  data: {
    labels: regLabels,
    datasets: [{
      label: 'Registrations',
      data: regData,
      borderColor: '#2f81f7',
      backgroundColor: grad,
      borderWidth: 2,
      pointRadius: 3,
      pointBackgroundColor: '#2f81f7',
      fill: true,
      tension: .4,
    }]
  },
  options: {
    responsive: true, maintainAspectRatio: false,
    plugins: { legend: { display: false } },
    scales: {
      x: { grid: { color: gridColor() }, ticks: { color: tickColor(), maxTicksLimit: 8, font: { size: 11 } } },
      y: { grid: { color: gridColor() }, ticks: { color: tickColor(), font: { size: 11 }, precision: 0 }, beginAtZero: true }
    }
  }
});

// ── Section status donut ──────────────────────────────────────────────────
const statusCtx = document.getElementById('statusChart').getContext('2d');
const statusData = @json($sectionStatus);
new Chart(statusCtx, {
  type: 'doughnut',
  data: {
    labels: ['Done', 'In Progress', 'Not Started'],
    datasets: [{
      data: [statusData.done ?? 0, statusData.in_progress ?? 0, statusData.not_started ?? 0],
      backgroundColor: ['#2f81f7', '#d29922', '#30363d'],
      borderWidth: 0,
      hoverOffset: 6,
    }]
  },
  options: {
    responsive: true, maintainAspectRatio: false,
    cutout: '68%',
    plugins: {
      legend: { display: false },
      tooltip: { callbacks: { label: ctx => ` ${ctx.label}: ${ctx.raw}` } }
    }
  }
});

// ── Groups bar chart ──────────────────────────────────────────────────────
const groupCtx = document.getElementById('groupChart').getContext('2d');
new Chart(groupCtx, {
  type: 'bar',
  data: {
    labels: @json($groupLabels),
    datasets: [{
      label: 'Groups',
      data: @json($groupData),
      backgroundColor: 'rgba(163,113,247,.7)',
      borderRadius: 4,
      borderSkipped: false,
    }]
  },
  options: {
    responsive: true, maintainAspectRatio: false,
    plugins: { legend: { display: false } },
    scales: {
      x: { grid: { display: false }, ticks: { color: tickColor(), font: { size: 11 } } },
      y: { grid: { color: gridColor() }, ticks: { color: tickColor(), precision: 0 }, beginAtZero: true }
    }
  }
});
</script>
@endpush
