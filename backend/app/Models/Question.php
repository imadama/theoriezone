<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Question extends Model
{
    protected $guarded = [];

    protected $casts = [
        'options' => 'array',
        'is_active' => 'boolean',
    ];

    public function exams(): BelongsToMany
    {
        return $this->belongsToMany(Exam::class);
    }
}
