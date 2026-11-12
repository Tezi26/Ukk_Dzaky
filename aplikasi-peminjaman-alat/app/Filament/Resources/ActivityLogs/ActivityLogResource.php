<?php

namespace App\Filament\Resources\ActivityLogs;

use Illuminate\Database\Eloquent\Model;
use App\Filament\Resources\ActivityLogs\Pages\CreateActivityLog;
use App\Filament\Resources\ActivityLogs\Pages\EditActivityLog;
use App\Filament\Resources\ActivityLogs\Pages\ListActivityLogs;
use App\Filament\Resources\ActivityLogs\Pages\ViewActivityLog;
use App\Filament\Resources\ActivityLogs\Schemas\ActivityLogForm;
use App\Filament\Resources\ActivityLogs\Schemas\ActivityLogInfolist;
use App\Filament\Resources\ActivityLogs\Tables\ActivityLogsTable;
use App\Models\ActivityLog;
use BackedEnum;
use UnitEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class ActivityLogResource extends Resource
{
    protected static ?string $model = ActivityLog::class;

  protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-clock';
protected static string|BackedEnum|null $activeNavigationIcon = 'heroicon-s-clock';
protected static string|UnitEnum|null $navigationGroup = 'User Management';
protected static ?int $navigationSort = 2;

    protected static ?string $recordTitleAttribute = 'id';

    public static function form(Schema $schema): Schema
    {
        return ActivityLogForm::configure($schema);
    }

     public static function canAccess(): bool { return auth()->user()->hasRole('admin'); }
public static function canCreate(): bool { return false; }
public static function canEdit(Model $record): bool { return false; }
public static function canDelete(Model $record): bool { return false; }
public static function canDeleteAny(): bool { return false; }
    

    public static function infolist(Schema $schema): Schema
    {
        return ActivityLogInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ActivityLogsTable::configure($table);
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
            'index' => ListActivityLogs::route('/'),
            'create' => CreateActivityLog::route('/create'),
            'view' => ViewActivityLog::route('/{record}'),
            'edit' => EditActivityLog::route('/{record}/edit'),
        ];
    }
}
