<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Video extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     */
    protected $fillable = [
        'title',
        'description',
        'url',
        'user_id',
        'views',
        'is_public',
    ];

    /**
     * Relationships
     */

    // Each video belongs to a user (the uploader)
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

