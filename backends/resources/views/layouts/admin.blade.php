<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>@yield('title', 'Admin') — TeamScribe</title>
  <meta name="csrf-token" content="{{ csrf_token() }}" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    :root{--c-canvas:#0d1117;--c-surface:#161b22;--c-overlay:#1c2128;--c-border:#30363d;--c-border2:#21262d;--c-fg:#e6edf3;--c-fg2:#8b949e;--c-blue:#2f81f7;--c-blue-dim:#1f3a6e;--c-green:#3fb950;--c-red:#f85149;--c-yellow:#d29922;--c-purple:#a371f7;--c-orange:#f0883e;--sw:240px}
    [data-theme="light"]{--c-canvas:#ffffff;--c-surface:#f6f8fa;--c-overlay:#eaeef2;--c-border:#d0d7de;--c-border2:#c8d1da;--c-fg:#1f2328;--c-fg2:#636e7b;--c-blue:#0969da;--c-blue-dim:#ddf4ff;--c-green:#1a7f37;--c-red:#d1242f;--c-yellow:#9a6700;--c-purple:#8250df;--c-orange:#bc4c00}
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;background:var(--c-canvas);color:var(--c-fg);min-height:100vh;display:flex;flex-direction:column;font-size:14px;line-height:1.5}
    a{color:var(--c-blue);text-decoration:none}a:hover{text-decoration:underline}

    /* TOP NAV */
    .top-nav{position:fixed;top:0;left:0;right:0;height:48px;background:var(--c-surface);border-bottom:1px solid var(--c-border);display:flex;align-items:center;padding:0 16px;z-index:200;gap:12px}
    .brand{display:flex;align-items:center;gap:8px;font-weight:600;font-size:14px;color:var(--c-fg);text-decoration:none;white-space:nowrap}
    .brand:hover{text-decoration:none}
    .spacer{flex:1}
    .top-search{background:var(--c-canvas);border:1px solid var(--c-border);border-radius:6px;padding:4px 12px;color:var(--c-fg2);font-size:12px;width:220px;outline:none;height:28px}
    .top-search:focus{border-color:var(--c-blue);color:var(--c-fg)}
    .top-search::placeholder{color:var(--c-fg2)}
    .nav-btn{background:none;border:none;cursor:pointer;color:var(--c-fg2);padding:5px;border-radius:6px;display:flex;align-items:center;transition:color .12s,background .12s;position:relative}
    .nav-btn:hover{color:var(--c-fg);background:var(--c-overlay)}

    /* NOTIFICATION BADGE */
    .notif-badge{position:absolute;top:1px;right:1px;width:8px;height:8px;background:var(--c-red);border-radius:50%;border:2px solid var(--c-surface);display:none}
    .notif-badge.has-notif{display:block}

    /* NOTIFICATION PANEL */
    .notif-panel{position:fixed;top:48px;right:0;width:380px;height:calc(100vh - 48px);background:var(--c-surface);border-left:1px solid var(--c-border);z-index:300;transform:translateX(100%);transition:transform .25s cubic-bezier(.4,0,.2,1);overflow-y:auto;display:flex;flex-direction:column}
    .notif-panel.open{transform:translateX(0)}
    .notif-panel-header{padding:16px;border-bottom:1px solid var(--c-border);display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;background:var(--c-surface);z-index:1}
    .notif-panel-title{font-weight:700;font-size:15px}
    .notif-close{background:none;border:none;cursor:pointer;color:var(--c-fg2);font-size:18px;line-height:1;padding:4px}
    .notif-close:hover{color:var(--c-fg)}
    .notif-item{display:flex;gap:10px;padding:12px 16px;border-bottom:1px solid var(--c-border2);transition:background .1s}
    .notif-item:hover{background:var(--c-overlay)}
    .notif-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:14px}
    .notif-body .notif-desc{font-size:13px;color:var(--c-fg);line-height:1.4}
    .notif-body .notif-meta{font-size:11px;color:var(--c-fg2);margin-top:3px}
    .notif-empty{padding:40px 16px;text-align:center;color:var(--c-fg2);font-size:13px}
    .notif-overlay{position:fixed;inset:0;z-index:299;display:none}
    .notif-overlay.open{display:block}

    /* PROFILE DROPDOWN */
    .profile-menu{position:relative}
    .avatar-btn{width:32px;height:32px;border-radius:50%;background:var(--c-blue-dim);border:2px solid var(--c-border);cursor:pointer;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;color:var(--c-blue);overflow:hidden;transition:border-color .12s}
    .avatar-btn:hover{border-color:var(--c-blue)}
    .avatar-btn img{width:100%;height:100%;object-fit:cover}
    .dropdown{position:absolute;right:0;top:40px;width:240px;background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;box-shadow:0 8px 24px rgba(0,0,0,.5);padding:8px 0;z-index:400;display:none}
    .dropdown.open{display:block}
    .dropdown-hdr{padding:8px 16px 10px}
    .dropdown-hdr .dn{font-weight:700;font-size:13px;color:var(--c-fg)}
    .dropdown-hdr .de{font-size:11px;color:var(--c-fg2);margin-top:1px}
    .dropdown-hdr .role{display:inline-block;margin-top:5px;font-size:10px;font-weight:600;padding:1px 7px;border-radius:20px;background:rgba(47,129,247,.15);color:var(--c-blue)}
    .dd-sep{border:none;border-top:1px solid var(--c-border);margin:5px 0}
    .dd-item{display:flex;align-items:center;gap:8px;padding:7px 16px;color:var(--c-fg);font-size:13px;cursor:pointer;background:none;border:none;width:100%;text-align:left;transition:background .1s;text-decoration:none}
    .dd-item:hover{background:var(--c-overlay);text-decoration:none}
    .dd-item.danger{color:var(--c-red)}
    .dd-label{font-size:10px;font-weight:600;color:var(--c-fg2);padding:6px 16px 2px;letter-spacing:.6px;text-transform:uppercase}

    /* LAYOUT */
    .layout{display:flex;margin-top:48px;min-height:calc(100vh - 48px)}

    /* SIDEBAR */
    .sidebar{width:var(--sw);background:var(--c-surface);border-right:1px solid var(--c-border);padding:12px 8px;position:fixed;top:48px;bottom:0;overflow-y:auto;flex-shrink:0;z-index:100}
    .sl{font-size:11px;font-weight:600;color:var(--c-fg2);text-transform:uppercase;letter-spacing:.7px;padding:10px 10px 4px}
    .sl:first-child{padding-top:4px}
    .slink{display:flex;align-items:center;gap:8px;padding:6px 10px;border-radius:6px;color:var(--c-fg);font-size:13px;text-decoration:none;transition:background .1s;margin-bottom:1px;white-space:nowrap}
    .slink:hover{background:var(--c-overlay);text-decoration:none}
    .slink.active{background:rgba(47,129,247,.15);color:var(--c-blue);font-weight:600}
    .slink svg{flex-shrink:0;opacity:.8}
    .slink.active svg{opacity:1}
    .sbadge{margin-left:auto;background:var(--c-blue);color:#fff;font-size:10px;font-weight:700;padding:1px 6px;border-radius:20px;min-width:18px;text-align:center}
    .sbadge.red{background:var(--c-red)}

    /* MAIN */
    .main{margin-left:var(--sw);flex:1;padding:24px;min-width:0}

    /* CARDS */
    .card{background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;padding:16px}
    .card+.card{margin-top:12px}
    .card-title{font-size:13px;font-weight:600;color:var(--c-fg);margin-bottom:12px;display:flex;align-items:center;gap:6px}

    /* STATS */
    .stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:20px}
    .stat-card{background:var(--c-surface);border:1px solid var(--c-border);border-radius:10px;padding:16px}
    .stat-icon{width:30px;height:30px;border-radius:7px;display:flex;align-items:center;justify-content:center;margin-bottom:10px}
    .stat-label{font-size:12px;color:var(--c-fg2)}
    .stat-value{font-size:26px;font-weight:700;line-height:1.1;margin:3px 0}
    .stat-sub{font-size:11px;color:var(--c-fg2)}

    /* CHARTS */
    .charts-row{display:grid;grid-template-columns:2fr 1fr;gap:12px;margin-bottom:20px}
    .chart-wrap{position:relative;height:220px}
    .table-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px}

    /* TABLES */
    table{width:100%;border-collapse:collapse;font-size:13px}
    th{padding:8px 12px;text-align:left;font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;color:var(--c-fg2);border-bottom:1px solid var(--c-border)}
    td{padding:8px 12px;border-bottom:1px solid var(--c-border2);color:var(--c-fg);vertical-align:middle}
    tr:last-child td{border-bottom:none}
    tr:hover td{background:var(--c-overlay)}

    /* BADGES */
    .badge{display:inline-flex;align-items:center;gap:4px;padding:2px 8px;border-radius:20px;font-size:11px;font-weight:600}
    .badge-green{background:rgba(63,185,80,.15);color:var(--c-green)}
    .badge-blue{background:rgba(47,129,247,.15);color:var(--c-blue)}
    .badge-red{background:rgba(248,81,73,.15);color:var(--c-red)}
    .badge-yellow{background:rgba(210,153,34,.15);color:var(--c-yellow)}
    .badge-purple{background:rgba(163,113,247,.15);color:var(--c-purple)}
    .badge-gray{background:var(--c-overlay);color:var(--c-fg2)}
    .badge-orange{background:rgba(240,136,62,.15);color:var(--c-orange)}

    /* BUTTONS */
    .btn{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:6px;font-size:13px;font-weight:500;cursor:pointer;border:1px solid;text-decoration:none;transition:background .12s}
    .btn:hover{text-decoration:none}
    .btn-primary{background:var(--c-green);border-color:rgba(0,0,0,.2);color:#fff}
    .btn-primary:hover{background:#2ea043}
    .btn-default{background:var(--c-overlay);border-color:var(--c-border);color:var(--c-fg)}
    .btn-default:hover{background:var(--c-border2)}
    .btn-danger{background:var(--c-red);border-color:rgba(0,0,0,.2);color:#fff}
    .btn-danger:hover{background:#da3633}
    .btn-warning{background:var(--c-yellow);border-color:rgba(0,0,0,.2);color:#fff}
    .btn-sm{padding:3px 8px;font-size:12px}

    /* PAGE HEADER */
    .page-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:20px;gap:12px}
    .page-title{font-size:20px;font-weight:700;color:var(--c-fg)}
    .page-subtitle{font-size:13px;color:var(--c-fg2);margin-top:2px}

    /* FLASH */
    .flash{padding:10px 14px;border-radius:8px;margin-bottom:14px;font-size:13px;display:flex;align-items:center;gap:8px}
    .flash-success{background:rgba(63,185,80,.1);border:1px solid rgba(63,185,80,.3);color:var(--c-green)}
    .flash-error{background:rgba(248,81,73,.1);border:1px solid rgba(248,81,73,.3);color:var(--c-red)}

    /* INPUTS */
    .input,.select{background:var(--c-canvas);border:1px solid var(--c-border);border-radius:6px;padding:5px 10px;color:var(--c-fg);font-size:13px;outline:none}
    .input:focus,.select:focus{border-color:var(--c-blue);box-shadow:0 0 0 3px rgba(47,129,247,.1)}
    .input::placeholder{color:var(--c-fg2)}
    textarea.input{resize:vertical;padding:8px 10px}
    .search-form{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}

    /* AVATAR */
    .av{width:28px;height:28px;border-radius:50%;background:var(--c-blue-dim);display:inline-flex;align-items:center;justify-content:center;font-size:10px;font-weight:700;color:var(--c-blue);flex-shrink:0;overflow:hidden}
    .av img{width:100%;height:100%;object-fit:cover}

    /* PAGINATION */
    .pagination{display:flex;gap:4px;align-items:center;margin-top:14px;flex-wrap:wrap}
    .page-btn{padding:4px 10px;border-radius:6px;border:1px solid var(--c-border);background:var(--c-surface);color:var(--c-fg);font-size:12px;cursor:pointer;text-decoration:none}
    .page-btn.active{background:var(--c-blue);border-color:var(--c-blue);color:#fff}
    .page-btn:hover:not(.active){background:var(--c-overlay)}

    /* PROGRESS */
    .prog-bar{height:5px;background:var(--c-border);border-radius:3px;overflow:hidden}
    .prog-fill{height:100%;background:var(--c-blue);border-radius:3px}

    /* TOGGLE SWITCH */
    .toggle{position:relative;display:inline-block;width:36px;height:20px}
    .toggle input{opacity:0;width:0;height:0}
    .toggle-slider{position:absolute;cursor:pointer;inset:0;background:var(--c-border);border-radius:20px;transition:.2s}
    .toggle-slider::before{content:'';position:absolute;width:14px;height:14px;left:3px;top:3px;background:#fff;border-radius:50%;transition:.2s}
    .toggle input:checked + .toggle-slider{background:var(--c-blue)}
    .toggle input:checked + .toggle-slider::before{transform:translateX(16px)}

    @media(max-width:1024px){.stats-grid{grid-template-columns:repeat(2,1fr)}.charts-row,.table-grid{grid-template-columns:1fr}}
    @media(max-width:768px){:root{--sw:0px}.sidebar{transform:translateX(-100%);transition:transform .2s;width:240px;z-index:150}.sidebar.open{transform:translateX(0)}.main{margin-left:0}}
  </style>
</head>
<body>

{{-- TOP NAV --}}
<nav class="top-nav">
  <button class="nav-btn" id="menu-btn" onclick="document.querySelector('.sidebar').classList.toggle('open')" style="display:none">
    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M1 2.75A.75.75 0 0 1 1.75 2h12.5a.75.75 0 0 1 0 1.5H1.75A.75.75 0 0 1 1 2.75Zm0 5A.75.75 0 0 1 1.75 7h12.5a.75.75 0 0 1 0 1.5H1.75A.75.75 0 0 1 1 7.75ZM1.75 12a.75.75 0 0 0 0 1.5h12.5a.75.75 0 0 0 0-1.5H1.75Z"/></svg>
  </button>

  <a href="{{ route('admin.dashboard') }}" class="brand">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22"><path d="M 19 3 C 17.346 3 16 4.346 16 6 C 16 6.4617584 16.113553 6.8939944 16.300781 7.2851562 L 12.585938 11 L 7.8164062 11 C 7.4021391 9.8387486 6.3016094 9 5 9 C 3.346 9 2 10.346 2 12 C 2 13.654 3.346 15 5 15 C 6.3016094 15 7.4021391 14.161251 7.8164062 13 L 12.585938 13 L 16.300781 16.714844 C 16.113553 17.106006 16 17.538242 16 18 C 16 19.654 17.346 21 19 21 C 20.654 21 22 19.654 22 18 C 22 16.346 20.654 15 19 15 C 18.538242 15 18.106006 15.113553 17.714844 15.300781 L 14.414062 12 L 17.714844 8.6992188 C 18.106006 8.8864466 18.538242 9 19 9 C 20.654 9 22 7.654 22 6 C 22 4.346 20.654 3 19 3 z"/></svg>
    TeamScribe <span style="color:var(--c-fg2);font-weight:400;font-size:13px;margin-left:2px">/ admin</span>
  </a>

  <input class="top-search" type="text" placeholder="Search users, groups…" id="global-search" />

  <div class="spacer"></div>

  {{-- Theme toggle --}}
  <button class="nav-btn" id="theme-toggle" title="Toggle theme">
    <svg id="i-moon" width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M9.598 1.591a.75.75 0 0 1 .785-.175 7 7 0 1 1-8.967 8.967.75.75 0 0 1 .961-.96 5.5 5.5 0 0 0 7.046-7.046.75.75 0 0 1 .175-.786Zm1.616 1.945a7 7 0 0 1-7.678 7.678 5.499 5.499 0 1 0 7.678-7.678Z"/></svg>
    <svg id="i-sun" width="15" height="15" viewBox="0 0 16 16" fill="currentColor" style="display:none"><path d="M8 12a4 4 0 1 1 0-8 4 4 0 0 1 0 8Zm0-1.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Zm5.657-8.457a.75.75 0 0 1 0 1.06l-.97.97a.75.75 0 0 1-1.06-1.06l.97-.97a.75.75 0 0 1 1.06 0ZM7.25 1.75a.75.75 0 0 1 1.5 0v1.5a.75.75 0 0 1-1.5 0v-1.5zm-4.47 2.04a.75.75 0 0 1 1.06 0l.97.97a.75.75 0 0 1-1.06 1.06l-.97-.97a.75.75 0 0 1 0-1.06ZM1.75 8.75a.75.75 0 0 1 0-1.5h1.5a.75.75 0 0 1 0 1.5h-1.5Zm2.04 4.47a.75.75 0 0 1 0-1.06l.97-.97a.75.75 0 1 1 1.06 1.06l-.97.97a.75.75 0 0 1-1.06 0ZM8.75 14.25a.75.75 0 0 1-1.5 0v-1.5a.75.75 0 0 1 1.5 0v1.5Zm4.47-2.04a.75.75 0 0 1-1.06 0l-.97-.97a.75.75 0 1 1 1.06-1.06l.97.97a.75.75 0 0 1 0 1.06Zm1.03-4.71a.75.75 0 0 1 0 1.5h-1.5a.75.75 0 0 1 0-1.5h1.5Z"/></svg>
  </button>

  {{-- Notifications bell --}}
  <button class="nav-btn" id="notif-btn" title="Notifications" onclick="toggleNotifPanel()">
    <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M8 16a2 2 0 0 0 1.985-1.75c.017-.137-.097-.25-.235-.25h-3.5c-.138 0-.252.113-.235.25A2 2 0 0 0 8 16ZM3 5a5 5 0 0 1 10 0v2.947c0 .05.015.098.042.139l1.703 2.555A1.519 1.519 0 0 1 13.482 13H2.518a1.516 1.516 0 0 1-1.263-2.36l1.703-2.554A.255.255 0 0 0 3 7.947V5Z"/></svg>
    <span class="notif-badge" id="notif-badge"></span>
  </button>

  {{-- Profile avatar --}}
  @auth
  <div class="profile-menu">
    <div class="avatar-btn" id="avatar-btn" onclick="toggleDropdown()">
      @if(auth()->user()->avatar_path)
        <img src="{{ Storage::url(auth()->user()->avatar_path) }}" />
      @else
        {{ strtoupper(substr(auth()->user()->name,0,1)) }}
      @endif
    </div>
    <div class="dropdown" id="profile-dropdown">
      <div class="dropdown-hdr">
        <div class="dn">{{ auth()->user()->name }}</div>
        <div class="de">{{ auth()->user()->email }}</div>
        <span class="role">{{ auth()->user()->is_admin ? 'Admin' : 'Student' }}</span>
      </div>
      <hr class="dd-sep" />
      <div class="dd-label">Account</div>
      <a class="dd-item" href="{{ route('profile.edit') }}">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
        Profile settings
      </a>
      <hr class="dd-sep" />
      <div class="dd-label">System</div>
      <a class="dd-item" href="{{ route('admin.settings.index') }}">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M8 0a8.2 8.2 0 0 1 .701.031C9.444.095 9.99.645 10.16 1.29l.288 1.107c.018.066.079.158.212.224.231.114.454.243.668.386.123.082.233.09.299.071l1.103-.303c.644-.176 1.392.021 1.82.63.27.385.506.792.704 1.218.315.675.111 1.422-.364 1.891l-.814.806c-.049.048-.098.147-.088.294.016.257.016.515 0 .772-.01.147.038.246.088.294l.814.806c.475.469.679 1.216.364 1.891a7.977 7.977 0 0 1-.704 1.217c-.428.61-1.176.807-1.82.63l-1.103-.303c-.066-.019-.176-.011-.299.071a5.909 5.909 0 0 1-.668.386c-.133.066-.194.158-.211.224l-.29 1.106c-.168.646-.715 1.196-1.458 1.26a8.006 8.006 0 0 1-1.402 0c-.743-.064-1.289-.614-1.458-1.26l-.289-1.106c-.018-.066-.079-.158-.212-.224a5.738 5.738 0 0 1-.668-.386c-.123-.082-.233-.09-.299-.071l-1.103.303c-.644.176-1.392-.021-1.82-.63a8.12 8.12 0 0 1-.704-1.218c-.315-.675-.111-1.422.363-1.891l.815-.806c.05-.048.098-.147.088-.294a6.214 6.214 0 0 1 0-.772c.01-.147-.038-.246-.088-.294l-.815-.806C.635 6.045.431 5.298.746 4.623a7.92 7.92 0 0 1 .704-1.217c.428-.61 1.176-.807 1.82-.63l1.103.303c.066.019.176.011.299-.071.214-.143.437-.272.668-.386.133-.066.194-.158.211-.224l.29-1.106C6.009.645 6.556.095 7.299.03 7.53.01 7.764 0 8 0Zm-.571 1.525c-.036.003-.108.036-.137.146l-.289 1.105c-.147.561-.549.967-.998 1.189-.173.086-.34.183-.5.29-.417.278-.97.423-1.529.27l-1.103-.303c-.109-.03-.175.016-.195.045-.22.312-.412.644-.573.99-.014.031-.021.11.059.19l.815.806c.411.406.562.957.53 1.456a4.709 4.709 0 0 0 0 .582c.032.499-.119 1.05-.53 1.456l-.815.806c-.081.08-.073.159-.059.19.162.346.353.677.573.989.02.03.085.076.195.046l1.102-.303c.56-.153 1.113-.008 1.53.27.161.107.328.204.501.29.447.222.85.629.997 1.189l.289 1.105c.029.109.101.143.137.146a6.6 6.6 0 0 0 1.142 0c.036-.003.108-.036.137-.146l.289-1.105c.147-.561.549-.967.998-1.189.173-.086.34-.183.5-.29.417-.278.97-.423 1.529-.27l1.103.303c.109.029.175-.016.195-.045.22-.313.411-.644.573-.99.014-.031.021-.11-.059-.19l-.815-.806c-.411-.406-.562-.957-.53-1.456a4.709 4.709 0 0 0 0-.582c-.032-.499.119-1.05.53-1.456l.815-.806c.081-.08.073-.159.059-.19a6.464 6.464 0 0 0-.573-.989c-.02-.03-.085-.076-.195-.046l-1.102.303c-.56.153-1.113.008-1.53-.27a4.44 4.44 0 0 0-.501-.29c-.447-.222-.85-.629-.997-1.189l-.289-1.105c-.029-.11-.101-.143-.137-.146a6.6 6.6 0 0 0-1.142 0ZM11 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM9.5 8a1.5 1.5 0 1 0-3.001.001A1.5 1.5 0 0 0 9.5 8Z"/></svg>
        System settings
      </a>
      <hr class="dd-sep" />
      <form method="POST" action="{{ route('logout') }}">
        @csrf
        <button type="submit" class="dd-item danger">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor"><path d="M2 2.75C2 1.784 2.784 1 3.75 1h2.5a.75.75 0 0 1 0 1.5h-2.5a.25.25 0 0 0-.25.25v10.5c0 .138.112.25.25.25h2.5a.75.75 0 0 1 0 1.5h-2.5A1.75 1.75 0 0 1 2 13.25Zm10.44 4.5-1.97-1.97a.749.749 0 0 1 .326-1.275.749.749 0 0 1 .734.215l3.25 3.25a.75.75 0 0 1 0 1.06l-3.25 3.25a.749.749 0 0 1-1.275-.326.749.749 0 0 1 .215-.734l1.97-1.97H6.75a.75.75 0 0 1 0-1.5Z"/></svg>
          Sign out
        </button>
      </form>
    </div>
  </div>
  @endauth
</nav>

{{-- NOTIFICATION PANEL --}}
<div class="notif-overlay" id="notif-overlay" onclick="closeNotifPanel()"></div>
<div class="notif-panel" id="notif-panel">
  <div class="notif-panel-header">
    <span class="notif-panel-title">Notifications</span>
    <div style="display:flex;gap:8px;align-items:center">
      <button onclick="loadNotifications()" style="background:none;border:none;cursor:pointer;color:var(--c-fg2);font-size:12px" title="Refresh">↻</button>
      <button class="notif-close" onclick="closeNotifPanel()">✕</button>
    </div>
  </div>
  <div id="notif-list">
    <div class="notif-empty">Loading…</div>
  </div>
</div>

{{-- LAYOUT --}}
<div class="layout">
  {{-- SIDEBAR --}}
  <aside class="sidebar">
    <div class="sl">Main</div>
    <a class="slink {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}" href="{{ route('admin.dashboard') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M6.906.664a1.749 1.749 0 0 1 2.187 0l5.25 4.2c.415.332.657.835.657 1.367v7.019A1.75 1.75 0 0 1 13.25 15h-3.5a.75.75 0 0 1-.75-.75V9H7v5.25a.75.75 0 0 1-.75.75h-3.5A1.75 1.75 0 0 1 1 13.25V6.23c0-.531.242-1.034.657-1.366l5.25-4.2h-.001Z"/></svg>
      Overview
    </a>

    @php
      // New since last viewed — badges disappear after visiting the section
      $studentsViewedAt = session('admin_viewed_students_at');
      $adminsViewedAt   = session('admin_viewed_admins_at');
      $groupsViewedAt   = session('admin_viewed_groups_at');

      $newStudents = \App\Models\User::where('is_admin', false)
          ->when($studentsViewedAt, fn($q) => $q->where('created_at', '>', $studentsViewedAt))
          ->count();
      $newAdmins   = \App\Models\User::where('is_admin', true)
          ->when($adminsViewedAt, fn($q) => $q->where('created_at', '>', $adminsViewedAt))
          ->count();
      $newGroups   = \App\Models\Group::query()
          ->when($groupsViewedAt, fn($q) => $q->where('created_at', '>', $groupsViewedAt))
          ->count();
    @endphp

    <div class="sl">People</div>
    <a class="slink {{ request()->routeIs('admin.users*') && request()->get('role') !== 'admin' ? 'active' : '' }}" href="{{ route('admin.users.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
      Students
      @if($newStudents > 0)
        <span class="sbadge" title="{{ $newStudents }} new student{{ $newStudents > 1 ? 's' : '' }}">{{ $newStudents }}</span>
      @endif
    </a>
    <a class="slink {{ request()->routeIs('admin.users*') && request()->get('role') === 'admin' ? 'active' : '' }}" href="{{ route('admin.users.index') }}?role=admin">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Zm4.879-2.773 4.264 2.559a.25.25 0 0 1 0 .428l-4.264 2.559A.25.25 0 0 1 6 10.559V5.442a.25.25 0 0 1 .379-.215Z"/></svg>
      Admins
      @if($newAdmins > 0)
        <span class="sbadge" title="{{ $newAdmins }} new admin{{ $newAdmins > 1 ? 's' : '' }}">{{ $newAdmins }}</span>
      @endif
    </a>

    <div class="sl">Groups & Content</div>
    <a class="slink {{ request()->routeIs('admin.groups*') ? 'active' : '' }}" href="{{ route('admin.groups.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5ZM11 4a3.001 3.001 0 0 1 2.22 5.018 5.01 5.01 0 0 1 2.56 3.012.749.749 0 0 1-.885.954.752.752 0 0 1-.549-.514 3.507 3.507 0 0 0-2.522-2.372.75.75 0 0 1-.574-.73v-.352a.75.75 0 0 1 .416-.672A1.5 1.5 0 0 0 11 5.5.75.75 0 0 1 11 4Zm-5.5-.5a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"/></svg>
      Groups
      @if($newGroups > 0)
        <span class="sbadge" title="{{ $newGroups }} new group{{ $newGroups > 1 ? 's' : '' }}">{{ $newGroups }}</span>
      @endif
    </a>
    <a class="slink {{ request()->routeIs('admin.activities*') ? 'active' : '' }}" href="{{ route('admin.activities.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M11.93 8.5a4.002 4.002 0 0 1-7.86 0H.75a.75.75 0 0 1 0-1.5h3.32a4.002 4.002 0 0 1 7.86 0h3.32a.75.75 0 0 1 0 1.5Zm-1.43-.75a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/></svg>
      Activity Feed
    </a>

    <div class="sl">Moderation</div>
    <a class="slink {{ request()->routeIs('admin.reports*') ? 'active' : '' }}" href="{{ route('admin.reports.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z"/></svg>
      Reports
      @php $pending = \App\Models\Report::where('status','pending')->count(); @endphp
      @if($pending)<span class="sbadge red">{{ $pending }}</span>@endif
    </a>
    <a class="slink {{ request()->routeIs('admin.audit*') ? 'active' : '' }}" href="{{ route('admin.audit.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M0 1.75C0 .784.784 0 1.75 0h12.5C15.216 0 16 .784 16 1.75v9.5A1.75 1.75 0 0 1 14.25 13H8.06l-2.573 2.573A1.458 1.458 0 0 1 3 14.543V13H1.75A1.75 1.75 0 0 1 0 11.25Zm1.75-.25a.25.25 0 0 0-.25.25v9.5c0 .138.112.25.25.25h2a.75.75 0 0 1 .75.75v2.19l2.72-2.72a.749.749 0 0 1 .53-.22h6.5a.25.25 0 0 0 .25-.25v-9.5a.25.25 0 0 0-.25-.25Z"/></svg>
      Audit Log
    </a>

    <div class="sl">Communication</div>
    <a class="slink {{ request()->routeIs('admin.announcements*') ? 'active' : '' }}" href="{{ route('admin.announcements.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M2 5.5a3.5 3.5 0 1 1 5.898 2.549 5.508 5.508 0 0 1 3.034 4.084.75.75 0 1 1-1.482.235 4.001 4.001 0 0 0-7.9 0 .75.75 0 0 1-1.482-.236A5.507 5.507 0 0 1 3.102 8.05 3.493 3.493 0 0 1 2 5.5Zm8.759 6.5H5.241A5.51 5.51 0 0 1 8 10.5c1.1 0 2.119.324 2.759.868v.132Z"/></svg>
      Announcements
    </a>

    <div class="sl">System</div>
    <a class="slink {{ request()->routeIs('admin.settings*') ? 'active' : '' }}" href="{{ route('admin.settings.index') }}">
      <svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor"><path d="M8 0a8.2 8.2 0 0 1 .701.031C9.444.095 9.99.645 10.16 1.29l.288 1.107c.018.066.079.158.212.224.231.114.454.243.668.386.123.082.233.09.299.071l1.103-.303c.644-.176 1.392.021 1.82.63.27.385.506.792.704 1.218.315.675.111 1.422-.364 1.891l-.814.806c-.049.048-.098.147-.088.294.016.257.016.515 0 .772-.01.147.038.246.088.294l.814.806c.475.469.679 1.216.364 1.891a7.977 7.977 0 0 1-.704 1.217c-.428.61-1.176.807-1.82.63l-1.103-.303c-.066-.019-.176-.011-.299.071a5.909 5.909 0 0 1-.668.386c-.133.066-.194.158-.211.224l-.29 1.106c-.168.646-.715 1.196-1.458 1.26a8.006 8.006 0 0 1-1.402 0c-.743-.064-1.289-.614-1.458-1.26l-.289-1.106c-.018-.066-.079-.158-.212-.224a5.738 5.738 0 0 1-.668-.386c-.123-.082-.233-.09-.299-.071l-1.103.303c-.644.176-1.392-.021-1.82-.63a8.12 8.12 0 0 1-.704-1.218c-.315-.675-.111-1.422.363-1.891l.815-.806c.05-.048.098-.147.088-.294a6.214 6.214 0 0 1 0-.772c.01-.147-.038-.246-.088-.294l-.815-.806C.635 6.045.431 5.298.746 4.623a7.92 7.92 0 0 1 .704-1.217c.428-.61 1.176-.807 1.82-.63l1.103.303c.066.019.176.011.299-.071.214-.143.437-.272.668-.386.133-.066.194-.158.211-.224l.29-1.106C6.009.645 6.556.095 7.299.03 7.53.01 7.764 0 8 0Zm-.571 1.525c-.036.003-.108.036-.137.146l-.289 1.105c-.147.561-.549.967-.998 1.189-.173.086-.34.183-.5.29-.417.278-.97.423-1.529.27l-1.103-.303c-.109-.03-.175.016-.195.045-.22.312-.412.644-.573.99-.014.031-.021.11.059.19l.815.806c.411.406.562.957.53 1.456a4.709 4.709 0 0 0 0 .582c.032.499-.119 1.05-.53 1.456l-.815.806c-.081.08-.073.159-.059.19.162.346.353.677.573.989.02.03.085.076.195.046l1.102-.303c.56-.153 1.113-.008 1.53.27.161.107.328.204.501.29.447.222.85.629.997 1.189l.289 1.105c.029.109.101.143.137.146a6.6 6.6 0 0 0 1.142 0c.036-.003.108-.036.137-.146l.289-1.105c.147-.561.549-.967.998-1.189.173-.086.34-.183.5-.29.417-.278.97-.423 1.529-.27l1.103.303c.109.029.175-.016.195-.045.22-.313.411-.644.573-.99.014-.031.021-.11-.059-.19l-.815-.806c-.411-.406-.562-.957-.53-1.456a4.709 4.709 0 0 0 0-.582c-.032-.499.119-1.05.53-1.456l.815-.806c.081-.08.073-.159.059-.19a6.464 6.464 0 0 0-.573-.989c-.02-.03-.085-.076-.195-.046l-1.102.303c-.56.153-1.113.008-1.53-.27a4.44 4.44 0 0 0-.501-.29c-.447-.222-.85-.629-.997-1.189l-.289-1.105c-.029-.11-.101-.143-.137-.146a6.6 6.6 0 0 0-1.142 0ZM11 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM9.5 8a1.5 1.5 0 1 0-3.001.001A1.5 1.5 0 0 0 9.5 8Z"/></svg>
      Settings
    </a>
  </aside>

  {{-- MAIN --}}
  <main class="main">
    @if(session('success'))
      <div class="flash flash-success">✓ {{ session('success') }}</div>
    @endif
    @if(session('error'))
      <div class="flash flash-error">⚠ {{ session('error') }}</div>
    @endif
    @yield('content')
  </main>
</div>

<script>
/* THEME */
const root = document.documentElement;
(function(){const t=localStorage.getItem('ts-theme')||'dark';root.setAttribute('data-theme',t);updateThemeIcons(t)})();
function updateThemeIcons(t){
  document.getElementById('i-moon').style.display=t==='dark'?'block':'none';
  document.getElementById('i-sun').style.display=t==='light'?'block':'none';
}
document.getElementById('theme-toggle').addEventListener('click',()=>{
  const c=root.getAttribute('data-theme');
  const n=c==='dark'?'light':'dark';
  root.setAttribute('data-theme',n);
  localStorage.setItem('ts-theme',n);
  updateThemeIcons(n);
});

/* PROFILE DROPDOWN */
function toggleDropdown(){document.getElementById('profile-dropdown').classList.toggle('open')}
document.addEventListener('click',e=>{
  const btn=document.getElementById('avatar-btn');
  const d=document.getElementById('profile-dropdown');
  if(d&&!btn?.contains(e.target)&&!d.contains(e.target))d.classList.remove('open');
});

/* NOTIFICATION PANEL */
let notifInterval;
function toggleNotifPanel(){
  const p=document.getElementById('notif-panel');
  const o=document.getElementById('notif-overlay');
  const open=p.classList.contains('open');
  if(open){closeNotifPanel();}
  else{p.classList.add('open');o.classList.add('open');loadNotifications();notifInterval=setInterval(loadNotifications,30000);}
}
function closeNotifPanel(){
  document.getElementById('notif-panel').classList.remove('open');
  document.getElementById('notif-overlay').classList.remove('open');
  clearInterval(notifInterval);
}
async function loadNotifications(){
  try{
    const r=await fetch('/admin/notifications/feed',{headers:{'X-CSRF-TOKEN':document.querySelector('meta[name=csrf-token]').content}});
    const d=await r.json();
    renderNotifications(d.notifications||[]);
  }catch(e){document.getElementById('notif-list').innerHTML='<div class="notif-empty">Failed to load notifications.</div>';}
}
function renderNotifications(items){
  if(!items.length){document.getElementById('notif-list').innerHTML='<div class="notif-empty">No notifications yet.</div>';return;}
  const icons={section_done:['✅','rgba(63,185,80,.12)'],member_joined:['👋','rgba(47,129,247,.12)'],section_updated:['✏️','rgba(210,153,34,.12)'],section_assigned:['📋','rgba(163,113,247,.12)']};
  const html=items.map(n=>{
    const [ic,bg]=icons[n.type]||['🔔','rgba(139,148,158,.12)'];
    return `<div class="notif-item">
      <div class="notif-icon" style="background:${bg}">${ic}</div>
      <div class="notif-body">
        <div class="notif-desc">${n.description}</div>
        <div class="notif-meta">${n.group?`<b>${n.group}</b> · `:''}${n.time}</div>
      </div>
    </div>`;
  }).join('');
  document.getElementById('notif-list').innerHTML=html;
  if(items.length){document.getElementById('notif-badge').classList.add('has-notif');}
}

/* MOBILE HAMBURGER */
if(window.innerWidth<=768){document.getElementById('menu-btn').style.display='flex';}
</script>
@stack('scripts')
</body>
</html>
