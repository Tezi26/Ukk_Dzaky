<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Loan extends Model
{
    protected $fillable = [
        'user_id', 'tool_id', 'approved_by', 'quantity',
        'loan_date', 'due_date', 'status',
    ];

    protected $casts = [
        'loan_date' => 'date',
        'due_date' => 'date',
    ];

    public function user() { return $this->belongsTo(User::class); }
    public function tool() { return $this->belongsTo(Tool::class); }
    public function toolReturn() { return $this->hasOne(ToolReturn::class); }

    protected static function booted(): void
    {
        static::created(fn ($loan) =>
            ActivityLog::record('loan_request', 'Mengajukan pinjaman #' . $loan->id));
    }
}