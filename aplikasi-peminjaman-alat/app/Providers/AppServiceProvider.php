<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Models\ActivityLog;
use Illuminate\Auth\Events\Login;
use Illuminate\Auth\Events\Logout;
use Illuminate\Support\Facades\Event;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
         Event::listen(Login::class, fn ($e) =>
        ActivityLog::record('login', $e->user->name . ' login', $e->user->id));

    Event::listen(Logout::class, fn ($e) =>
        ActivityLog::record('logout', ($e->user?->name) . ' logout', $e->user?->id));
    }
}
