<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ToolReturn extends Model
{
    protected $fillable = ['loan_id', 'returned_at', 'late_days', 'fine', 'condition', 'note'];

    protected $casts = ['returned_at' => 'datetime'];

    public function loan() { return $this->belongsTo(Loan::class); }
}