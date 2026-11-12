<?php

namespace App\Filament\Resources\Tools;

use Illuminate\Database\Eloquent\Model;
use App\Filament\Resources\Tools\Pages\CreateTool;
use App\Filament\Resources\Tools\Pages\EditTool;
use App\Filament\Resources\Tools\Pages\ListTools;
use App\Filament\Resources\Tools\Pages\ViewTool;
use App\Filament\Resources\Tools\Schemas\ToolForm;
use App\Filament\Resources\Tools\Schemas\ToolInfolist;
use App\Filament\Resources\Tools\Tables\ToolsTable;
use App\Models\Tool;
use BackedEnum;
use UnitEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ToolResource extends Resource
{
    protected static ?string $model = Tool::class;

   protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-wrench-screwdriver';
protected static string|BackedEnum|null $activeNavigationIcon = 'heroicon-s-wrench-screwdriver';
protected static string|UnitEnum|null $navigationGroup = 'Master Data';
protected static ?int $navigationSort = 2;

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return ToolForm::configure($schema);
    }

    public static function infolist(Schema $schema): Schema
    {
        return ToolInfolist::configure($schema);
    }

   

    public static function table(Table $table): Table
    {
        return ToolsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListTools::route('/'),
            'create' => CreateTool::route('/create'),
            'view' => ViewTool::route('/{record}'),
            'edit' => EditTool::route('/{record}/edit'),
        ];
    }
     public static function canCreate(): bool { return auth()->user()->hasRole('admin'); }
public static function canEdit(Model $record): bool { return auth()->user()->hasRole('admin'); }
public static function canDelete(Model $record): bool { return auth()->user()->hasRole('admin'); }
public static function canDeleteAny(): bool { return auth()->user()->hasRole('admin'); }
}
