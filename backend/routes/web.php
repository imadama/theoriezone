<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AdminController;

Route::get('/', function () {
    return view('welcome');
});

// Admin Routes (Quick MVP)
Route::get('/admin', [AdminController::class, 'index'])->name('admin.index');
Route::get('/admin/{id}', [AdminController::class, 'edit'])->name('admin.edit');
Route::post('/admin/{id}', [AdminController::class, 'update'])->name('admin.update');
