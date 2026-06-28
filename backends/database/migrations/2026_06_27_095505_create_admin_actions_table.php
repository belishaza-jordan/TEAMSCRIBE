<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('admin_actions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('admin_id')->constrained('users')->cascadeOnDelete();
            $table->string('action');            // suspend_user, delete_group, etc.
            $table->string('target_type')->nullable();  // user, group, message
            $table->unsignedBigInteger('target_id')->nullable();
            $table->text('description');
            $table->json('metadata')->nullable();
            $table->timestamps();
            $table->index(['admin_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('admin_actions');
    }
};
