<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AdminController;
use App\Http\Controllers\SchoolController;
use App\Http\Controllers\WebAuthController;
use App\Http\Controllers\SuperAdminController;

Route::get('/', function () {
    return redirect('/login-web'); 
});

// Web Auth
Route::get('/login-web', [WebAuthController::class, 'loginForm'])->name('login.web');
Route::post('/login-web', [WebAuthController::class, 'login'])->name('login.web.post');
Route::post('/logout-web', [WebAuthController::class, 'logout'])->name('logout.web');

Route::middleware(['auth'])->group(function () {
    
    // Super Admin Dashboard
    Route::get('/admin/dashboard', [SuperAdminController::class, 'dashboard'])->name('admin.dashboard');
    Route::get('/admin/school/create', [SuperAdminController::class, 'createSchool'])->name('admin.school.create');
    Route::post('/admin/school/store', [SuperAdminController::class, 'storeSchool'])->name('admin.school.store');

    // Content Editor (Questions)
    Route::get('/admin/questions', [AdminController::class, 'index'])->name('admin.index');
    Route::get('/admin/questions/{id}', [AdminController::class, 'edit'])->name('admin.edit');
    Route::post('/admin/questions/{id}', [AdminController::class, 'update'])->name('admin.update');

    // School Portal (For Instructors)
    Route::get('/school/dashboard', [SchoolController::class, 'dashboard'])->name('school.dashboard');
    Route::get('/school/create', [SchoolController::class, 'createStudent'])->name('school.create');
    Route::post('/school/store', [SchoolController::class, 'storeStudent'])->name('school.store');
    Route::get('/school/student/{id}', [SchoolController::class, 'showStudent'])->name('school.student');
});
