<?php

namespace App\Filament\Resources\ToolReturns;

use Illuminate\Database\Eloquent\Model;
use App\Filament\Resources\ToolReturns\Pages\CreateToolReturn;
use App\Filament\Resources\ToolReturns\Pages\EditToolReturn;
use App\Filament\Resources\ToolReturns\Pages\ListToolReturns;
use App\Filament\Resources\ToolReturns\Pages\ViewToolReturn;
use App\Filament\Resources\ToolReturns\Schemas\ToolReturnForm;
use App\Filament\Resources\ToolReturns\Schemas\ToolReturnInfolist;
use App\Filament\Resources\ToolReturns\Tables\ToolReturnsTable;
use App\Models\ToolReturn;
use BackedEnum;
use UnitEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ToolReturnResource extends Resource
{
    protected static ?string $model = ToolReturn::class;

 protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-arrow-uturn-left';
protected static string|BackedEnum|null $activeNavigationIcon = 'heroicon-s-arrow-uturn-left';
protected static string|UnitEnum|null $navigationGroup = 'Transaksi';
protected static ?int $navigationSort = 2;

    protected static ?string $recordTitleAttribute = 'id';

    public static function form(Schema $schema): Schema
    {
        return ToolReturnForm::configure($schema);
    }

    public static function infolist(Schema $schema): Schema
    {
        return ToolReturnInfolist::configure($schema);
    }
    public static function canAccess(): bool
{
    return auth()->user()->hasRole('admin', 'petugas');
}
public static function canCreate(): bool { return auth()->user()->hasRole('admin'); }
public static function canEdit(Model $record): bool { return auth()->user()->hasRole('admin'); }
public static function canDelete(Model $record): bool { return auth()->user()->hasRole('admin'); }

    public static function table(Table $table): Table
    {
        return ToolReturnsTable::configure($table);
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
            'index' => ListToolReturns::route('/'),
            'create' => CreateToolReturn::route('/create'),
            'view' => ViewToolReturn::route('/{record}'),
            'edit' => EditToolReturn::route('/{record}/edit'),
        ];
    }
}
