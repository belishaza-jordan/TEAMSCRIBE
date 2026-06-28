<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Add as nullable first so existing rows don't fail
        Schema::table('groups', function (Blueprint $table) {
            $table->string('join_code', 8)->nullable()->after('created_by');
        });

        // Backfill existing groups with unique codes
        $chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        DB::table('groups')->whereNull('join_code')->get()->each(function ($group) use ($chars) {
            do {
                $code = '';
                for ($i = 0; $i < 6; $i++) {
                    $code .= $chars[random_int(0, strlen($chars) - 1)];
                }
            } while (DB::table('groups')->where('join_code', $code)->exists());

            DB::table('groups')->where('id', $group->id)->update(['join_code' => $code]);
        });

        // Now enforce not-null + unique
        Schema::table('groups', function (Blueprint $table) {
            $table->string('join_code', 8)->nullable(false)->unique()->change();
        });
    }

    public function down(): void
    {
        Schema::table('groups', function (Blueprint $table) {
            $table->dropColumn('join_code');
        });
    }
};
