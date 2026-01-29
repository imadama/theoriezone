<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('student'); // student, instructor, admin
            $table->unsignedBigInteger('instructor_id')->nullable();
            
            $table->foreign('instructor_id')->references('id')->on('users')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['instructor_id']);
            $table->dropColumn(['role', 'instructor_id']);
        });
    }
};
