<?php

namespace App\Filament\Resources\ToolReturns\Pages;

use App\Filament\Resources\ToolReturns\ToolReturnResource;
use Filament\Actions\EditAction;
use Filament\Resources\Pages\ViewRecord;

class ViewToolReturn extends ViewRecord
{
    protected static string $resource = ToolReturnResource::class;

    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
        ];
    }
}
