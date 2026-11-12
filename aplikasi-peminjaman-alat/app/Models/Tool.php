<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tool extends Model
{
    protected $fillable = [
        'category_id', 'name', 'code',
        'stock', 'condition', 'is_active',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }
}