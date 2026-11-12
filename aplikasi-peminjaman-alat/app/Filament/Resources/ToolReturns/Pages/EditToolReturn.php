<?php

namespace App\Filament\Resources\ToolReturns\Pages;

use App\Filament\Resources\ToolReturns\ToolReturnResource;
use Filament\Actions\DeleteAction;
use Filament\Actions\ViewAction;
use Filament\Resources\Pages\EditRecord;

class EditToolReturn extends EditRecord
{
    protected static string $resource = ToolReturnResource::class;

    protected function getHeaderActions(): array
    {
        return [
            ViewAction::make(),
            DeleteAction::make(),
        ];
    }
}
