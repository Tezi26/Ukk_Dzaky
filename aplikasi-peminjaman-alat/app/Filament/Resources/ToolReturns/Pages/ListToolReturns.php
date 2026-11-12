<?php

namespace App\Filament\Resources\ToolReturns\Pages;

use App\Filament\Resources\ToolReturns\ToolReturnResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListToolReturns extends ListRecords
{
    protected static string $resource = ToolReturnResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
