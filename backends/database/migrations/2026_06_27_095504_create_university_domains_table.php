<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('university_domains', function (Blueprint $table) {
            $table->id();
            $table->string('domain')->unique();        // e.g. university.edu
            $table->string('university_name')->nullable();
            $table->boolean('is_allowed')->default(true);
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('university_domains');
    }
};
