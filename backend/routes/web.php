<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AdminController;
use App\Http\Controllers\SchoolController;
use App\Http\Controllers\WebAuthController;

Route::get('/', function () {
    return redirect('/login-web'); // Redirect root to login for now
});

// Web Auth
Route::get('/login-web', [WebAuthController::class, 'loginForm'])->name('login.web');
Route::post('/login-web', [WebAuthController::class, 'login'])->name('login.web.post');
Route::post('/logout-web', [WebAuthController::class, 'logout'])->name('logout.web');

// Admin Routes (Quick MVP) - Should be protected by middleware in real app
Route::middleware(['auth'])->group(function () {
    Route::get('/admin', [AdminController::class, 'index'])->name('admin.index');
    Route::get('/admin/{id}', [AdminController::class, 'edit'])->name('admin.edit');
    Route::post('/admin/{id}', [AdminController::class, 'update'])->name('admin.update');

    // School Portal
    Route::get('/school/dashboard', [SchoolController::class, 'dashboard'])->name('school.dashboard');
    Route::get('/school/create', [SchoolController::class, 'createStudent'])->name('school.create');
    Route::post('/school/store', [SchoolController::class, 'storeStudent'])->name('school.store');
    Route::get('/school/student/{id}', [SchoolController::class, 'showStudent'])->name('school.student');
});
