<?php

namespace App\Filament\Resources\Loans\Tables;

use App\Models\Loan;
use App\Models\ToolReturn;
use Filament\Actions\Action;
use Filament\Actions\ActionGroup;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Notifications\Notification;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;
use Illuminate\Support\Facades\DB;

class LoansTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('user.name')
                    ->label('Peminjam')
                    ->searchable(),
                TextColumn::make('tool.name')
                    ->label('Alat'),
                TextColumn::make('quantity')
                    ->label('Jumlah'),
                TextColumn::make('loan_date')
                    ->label('Tgl Pinjam')
                    ->date('d/m/Y'),
                TextColumn::make('due_date')
                    ->label('Jatuh Tempo')
                    ->date('d/m/Y'),
                TextColumn::make('status')
                    ->badge()
                    ->color(fn (string $state) => match ($state) {
                        'pending' => 'warning',
                        'approved' => 'info',
                        'returned' => 'success',
                        default => 'danger',
                    }),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->options([
                        'pending' => 'Pending',
                        'approved' => 'Approved',
                        'returned' => 'Returned',
                        'rejected' => 'Rejected',
                    ]),
            ])
            ->recordActions([
                Action::make('approve')
                    ->label('Setujui')
                    ->icon('heroicon-o-check-circle')
                    ->color('success')
                    ->requiresConfirmation()
                    ->visible(fn (Loan $record) => $record->status === 'pending'
                        && auth()->user()->hasRole('admin', 'petugas'))
                    ->action(function (Loan $record) {
                        try {
                            DB::statement('CALL sp_setujui_peminjaman(?, ?)',
                                [$record->id, auth()->id()]);
                            Notification::make()->title('Peminjaman disetujui')->success()->send();
                        } catch (\Throwable $e) {
                            Notification::make()->title('Gagal')
                                ->body($e->getMessage())->danger()->send();
                        }
                    }),
                Action::make('reject')
                    ->label('Tolak')
                    ->icon('heroicon-o-x-circle')
                    ->color('danger')
                    ->requiresConfirmation()
                    ->visible(fn (Loan $record) => $record->status === 'pending'
                        && auth()->user()->hasRole('admin', 'petugas'))
                    ->action(fn (Loan $record) => $record->update(['status' => 'rejected'])),
                Action::make('return')
                    ->label('Kembalikan')
                    ->icon('heroicon-o-arrow-uturn-left')
                    ->color('warning')
                    ->requiresConfirmation()
                    ->visible(fn (Loan $record) => $record->status === 'approved'
                        && auth()->user()->hasRole('admin', 'peminjam'))
                    ->action(function (Loan $record) {
                        DB::beginTransaction();
                        try {
                            $late = max(0, (int) $record->due_date->diffInDays(today(), false));
                            $fine = DB::selectOne('SELECT hitung_denda(?, ?) AS d', [
                                $record->due_date->toDateString(), today()->toDateString(),
                            ])->d;
                            ToolReturn::create([
                                'loan_id' => $record->id,
                                'returned_at' => now(),
                                'late_days' => $late,
                                'fine' => $fine,
                            ]);
                            DB::commit();
                            Notification::make()->title("Dikembalikan. Denda: Rp $fine")
                                ->success()->send();
                        } catch (\Throwable $e) {
                            DB::rollBack();
                            Notification::make()->title('Gagal')
                                ->body($e->getMessage())->danger()->send();
                        }
                    }),
                ActionGroup::make([
                    ViewAction::make(),
                    EditAction::make(),
                ]),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}