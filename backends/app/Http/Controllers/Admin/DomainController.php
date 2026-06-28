<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;

class DomainController extends Controller
{
    public function index()
    {
        return redirect()->route('admin.settings.index');
    }
}
