<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $users = [
            ['Admin', 'admin@mail.com', 'admin'],
            ['Petugas', 'petugas@mail.com', 'petugas'],
            ['Peminjam', 'peminjam@mail.com', 'peminjam'],
        ];

        foreach ($users as [$name, $email, $role]) {
            User::create([
                'name' => $name,
                'email' => $email,
                'password' => 'password',
                'role' => $role,
            ]);
        }
    }
}