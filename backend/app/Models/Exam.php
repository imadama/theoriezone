<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Exam extends Model
{
    protected $guarded = [];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function questions(): BelongsToMany
    {
        return $this->belongsToMany(Question::class)
            ->withPivot('position')
            ->orderByPivot('position');
    }
}
