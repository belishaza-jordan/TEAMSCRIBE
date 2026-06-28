@extends('layouts.admin')
@section('title','Settings')
@section('content')
<div class="page-header">
  <div><div class="page-title">System Settings</div><div class="page-subtitle">Configure platform behaviour, limits and university domains</div></div>
</div>

<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
{{-- FEATURE & SYSTEM SETTINGS --}}
<div>
  <form method="POST" action="{{ route('admin.settings.update') }}">
    @csrf
    @foreach($settings->sortKeys() as $group => $items)
    <div class="card" style="margin-bottom:14px">
      <div class="card-title">{{ ucfirst($group) }}</div>
      @foreach($items as $s)
      <div style="display:flex;align-items:flex-start;justify-content:space-between;padding:10px 0;border-bottom:1px solid var(--c-border2)">
        <div style="flex:1;padding-right:16px">
          <div style="font-weight:500;font-size:13px">{{ $s->label }}</div>
          @if($s->description)<div style="font-size:12px;color:var(--c-fg2);margin-top:2px">{{ $s->description }}</div>@endif
        </div>
        <div style="flex-shrink:0">
          @if($s->type === 'boolean')
            <label class="toggle">
              <input type="checkbox" name="settings[{{ $s->key }}]" value="true" {{ $s->value === 'true' ? 'checked' : '' }} />
              <span class="toggle-slider"></span>
            </label>
            <input type="hidden" name="settings[{{ $s->key }}]" value="{{ $s->value }}" class="bool-hidden-{{ $s->key }}" />
          @elseif($s->type === 'integer')
            <input class="input" type="number" name="settings[{{ $s->key }}]" value="{{ $s->value }}" style="width:90px" />
          @else
            <input class="input" type="text" name="settings[{{ $s->key }}]" value="{{ $s->value }}" style="width:200px" />
          @endif
        </div>
      </div>
      @endforeach
    </div>
    @endforeach
    <button type="submit" class="btn btn-primary">Save settings</button>
  </form>
</div>

{{-- UNIVERSITY DOMAINS --}}
<div>
  <div class="card">
    <div class="card-title">University Domains
      <span style="font-size:11px;color:var(--c-fg2);font-weight:400;margin-left:auto">{{ $domains->count() }} configured</span>
    </div>
    <form method="POST" action="{{ route('admin.settings.domains.add') }}" style="display:flex;gap:8px;margin-bottom:14px">
      @csrf
      <input class="input" name="domain" placeholder="university.edu" required style="flex:1" />
      <input class="input" name="university_name" placeholder="University name" style="flex:1" />
      <button type="submit" class="btn btn-primary btn-sm">+ Add</button>
    </form>

    @if($domains->isEmpty())
      <div style="text-align:center;color:var(--c-fg2);padding:20px 0;font-size:13px">No domains configured. Add one above.</div>
    @else
      <table>
        <thead><tr><th>Domain</th><th>University</th><th>Status</th><th></th></tr></thead>
        <tbody>
          @foreach($domains as $d)
          <tr>
            <td style="font-family:monospace;font-size:12px">{{ $d->domain }}</td>
            <td style="color:var(--c-fg2)">{{ $d->university_name ?: '—' }}</td>
            <td>
              <span class="badge {{ $d->is_allowed ? 'badge-green' : 'badge-red' }}">
                {{ $d->is_allowed ? 'Allowed' : 'Blocked' }}
              </span>
            </td>
            <td>
              <div style="display:flex;gap:4px">
                <form method="POST" action="{{ route('admin.settings.domains.toggle', $d) }}">
                  @csrf @method('PATCH')
                  <button class="btn btn-sm btn-default" type="submit">{{ $d->is_allowed ? 'Block' : 'Allow' }}</button>
                </form>
                <form method="POST" action="{{ route('admin.settings.domains.delete', $d) }}"
                  onsubmit="return confirm('Remove domain?')">
                  @csrf @method('DELETE')
                  <button class="btn btn-sm btn-danger" type="submit">✕</button>
                </form>
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
@push('scripts')
<script>
// Sync boolean toggle to hidden field
document.querySelectorAll('.toggle input[type=checkbox]').forEach(cb=>{
  const key=cb.name.match(/\[(.+)\]/)?.[1];
  const hid=document.querySelector('.bool-hidden-'+key);
  cb.addEventListener('change',()=>{ if(hid) hid.value=cb.checked?'true':'false'; });
});
</script>
@endpush
