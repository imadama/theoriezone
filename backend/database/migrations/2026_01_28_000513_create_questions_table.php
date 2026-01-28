<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('questions', function (Blueprint $table) {
            $table->id();
            $table->text('text');
            $table->string('type')->default('multiple_choice'); // multiple_choice, boolean, hotspot
            $table->json('options'); // ["Ja", "Nee"]
            $table->integer('correct_index'); // 0
            $table->text('explanation')->nullable();
            $table->string('category')->index(); // Wetgeving, Gevaarherkenning
            $table->string('image_path')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Pivot table for Exam <-> Question (Many-to-Many)
        Schema::create('exam_question', function (Blueprint $table) {
            $table->id();
            $table->foreignId('exam_id')->constrained()->onDelete('cascade');
            $table->foreignId('question_id')->constrained()->onDelete('cascade');
            $table->integer('position')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exam_question');
        Schema::dropIfExists('questions');
    }
};
