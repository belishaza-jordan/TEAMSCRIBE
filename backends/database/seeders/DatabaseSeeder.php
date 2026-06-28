<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'belishazamahuvi99@gmail.com'],
            [
                'name' => 'Baraka Mahuvi',
                'password' => 'Shazam@255',
                'is_admin' => true,
            ]
        );
    }
}
