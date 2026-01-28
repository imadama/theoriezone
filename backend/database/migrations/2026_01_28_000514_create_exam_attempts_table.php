<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('exam_attempts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('exam_id')->constrained()->onDelete('cascade');
            
            $table->string('status')->default('in_progress'); // in_progress, completed, terminated
            $table->timestamp('started_at');
            $table->timestamp('finished_at')->nullable();
            
            $table->integer('score')->nullable();
            $table->boolean('passed')->nullable();
            
            // Snapshot of answers: { "question_id": selected_index }
            $table->json('answers')->nullable();
            
            // Audit log for integrity events (focus lost, etc)
            $table->json('integrity_log')->nullable();
            $table->string('termination_reason')->nullable(); // e.g. "tab_switch_limit_exceeded"

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exam_attempts');
    }
};
