<?php

namespace App\Filament\Resources\Loans\Schemas;

use Illuminate\Database\Eloquent\Builder;
use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;


class LoanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('user_id')
                    ->label('Peminjam')
                    ->relationship('user', 'name')
                    ->default(fn () => auth()->id())
                    ->disabled(fn () => auth()->user()->hasRole('peminjam'))
                    ->dehydrated()
                    ->required(),
                Select::make('tool_id')
                    ->label('Alat')
                    ->relationship(
                        name: 'tool',
                        titleAttribute: 'name',
                        modifyQueryUsing: fn (Builder $query) => $query->where('is_active', true)
                            ->where('stock', '>', 0),
                    )
                    ->required(),
                TextInput::make('quantity')
                    ->label('Jumlah')
                    ->required()
                    ->numeric()
                    ->minValue(1)
                    ->default(1),
                DatePicker::make('loan_date')
                    ->label('Tanggal Pinjam')
                    ->required()
                    ->default(now()),
                DatePicker::make('due_date')
                    ->label('Jatuh Tempo')
                    ->required(),
                Select::make('status')
                    ->options([
                        'pending' => 'Pending',
                        'approved' => 'Approved',
                        'rejected' => 'Rejected',
                        'returned' => 'Returned',
                    ])
                    ->default('pending')
                    ->visible(fn () => auth()->user()->hasRole('admin'))
                    ->required(),
            ]);
    }
}