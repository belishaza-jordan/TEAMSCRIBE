@extends('layouts.admin')
@section('title','Announcements')
@section('content')
<div class="page-header">
  <div><div class="page-title">Announcements</div><div class="page-subtitle">Broadcast messages to all students or a specific university</div></div>
</div>
<div style="display:grid;grid-template-columns:380px 1fr;gap:16px">
{{-- COMPOSE --}}
<div class="card" style="height:fit-content">
  <div class="card-title">New Announcement</div>
  <form method="POST" action="{{ route('admin.announcements.store') }}">
    @csrf
    <div style="margin-bottom:12px">
      <label style="font-size:12px;color:var(--c-fg2);display:block;margin-bottom:5px">Title</label>
      <input class="input" name="title" placeholder="Announcement title" required style="width:100%" />
    </div>
    <div style="margin-bottom:12px">
      <label style="font-size:12px;color:var(--c-fg2);display:block;margin-bottom:5px">Message</label>
      <textarea class="input" name="message" rows="4" placeholder="Write your message…" required style="width:100%"></textarea>
    </div>
    <div style="margin-bottom:12px">
      <label style="font-size:12px;color:var(--c-fg2);display:block;margin-bottom:5px">Target</label>
      <select class="select" name="target" id="target-sel" onchange="toggleUni()" style="width:100%">
        <option value="all">All users</option>
        <option value="university">Specific university</option>
      </select>
    </div>
    <div id="uni-field" style="margin-bottom:12px;display:none">
      <label style="font-size:12px;color:var(--c-fg2);display:block;margin-bottom:5px">University name</label>
      <select class="select" name="target_university" style="width:100%">
        <option value="">— Select —</option>
        @foreach($universities as $u)<option>{{ $u }}</option>@endforeach
      </select>
    </div>
    <button type="submit" class="btn btn-primary" style="width:100%">📣 Send Announcement</button>
  </form>
</div>

{{-- HISTORY --}}
<div>
  <div class="card">
    <div class="card-title">Sent Announcements</div>
    @if($announcements->isEmpty())
      <div style="text-align:center;color:var(--c-fg2);padding:32px">No announcements yet.</div>
    @else
    <table>
      <thead><tr><th>Title</th><th>Target</th><th>By</th><th>Sent</th><th></th></tr></thead>
      <tbody>
        @foreach($announcements as $a)
        <tr>
          <td>
            <div style="font-weight:500">{{ $a->title }}</div>
            <div style="color:var(--c-fg2);font-size:12px;margin-top:2px">{{ Str::limit($a->message,60) }}</div>
          </td>
          <td>
            @if($a->target === 'all')
              <span class="badge badge-blue">All users</span>
            @else
              <span class="badge badge-purple">{{ $a->target_university }}</span>
            @endif
          </td>
          <td style="color:var(--c-fg2)">{{ $a->admin?->name ?? '—' }}</td>
          <td style="color:var(--c-fg2);font-size:12px">{{ $a->created_at->format('M d, Y H:i') }}</td>
          <td>
            <form method="POST" action="{{ route('admin.announcements.destroy',$a) }}"
              onsubmit="return confirm('Delete this announcement?')">
              @csrf @method('DELETE')
              <button class="btn btn-danger btn-sm">Delete</button>
            </form>
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
@push('scripts')
<script>function toggleUni(){document.getElementById('uni-field').style.display=document.getElementById('target-sel').value==='university'?'block':'none'}</script>
@endpush
