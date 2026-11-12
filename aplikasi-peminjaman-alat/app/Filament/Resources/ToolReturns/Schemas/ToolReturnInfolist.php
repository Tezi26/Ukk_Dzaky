<?php

namespace App\Filament\Resources\ToolReturns\Schemas;

use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Schema;

class ToolReturnInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextEntry::make('loan_id')
                    ->numeric(),
                TextEntry::make('returned_at')
                    ->dateTime(),
                TextEntry::make('late_days')
                    ->numeric(),
                TextEntry::make('fine')
                    ->numeric(),
                TextEntry::make('condition'),
                TextEntry::make('note')
                    ->placeholder('-')
                    ->columnSpanFull(),
                TextEntry::make('created_at')
                    ->dateTime()
                    ->placeholder('-'),
                TextEntry::make('updated_at')
                    ->dateTime()
                    ->placeholder('-'),
            ]);
    }
}
