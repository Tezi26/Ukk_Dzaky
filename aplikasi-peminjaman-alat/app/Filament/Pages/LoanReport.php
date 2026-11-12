<?php

namespace App\Filament\Pages;

use App\Models\Loan;
use Filament\Pages\Page;

class LoanReport extends Page
{
    protected string $view = 'filament.pages.loan-report';

    protected static ?string $navigationLabel = 'Laporan';

    protected static ?string $title = 'Laporan Peminjaman';

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin', 'petugas');
    }

    protected function getViewData(): array
    {
        return [
            'loans' => Loan::with(['user', 'tool'])->latest()->limit(100)->get(),
        ];
    }
}