<?php

namespace App\Filament\Resources\ToolReturns\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class ToolReturnForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('loan_id')
                    ->label('Pinjaman')
                    ->relationship('loan', 'id')
                    ->required(),
                DateTimePicker::make('returned_at')
                    ->label('Tanggal Kembali')
                    ->required()
                    ->default(now()),
                TextInput::make('late_days')
                    ->label('Hari Telat')
                    ->required()
                    ->numeric()
                    ->default(0),
                TextInput::make('fine')
                    ->label('Denda (Rp)')
                    ->required()
                    ->numeric()
                    ->default(0),
                TextInput::make('condition')
                    ->label('Kondisi')
                    ->required()
                    ->default('good'),
                Textarea::make('note')
                    ->label('Catatan')
                    ->columnSpanFull(),
            ]);
    }
}