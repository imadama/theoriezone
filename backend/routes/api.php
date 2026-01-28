<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\ExamController;

// Auth (Mock for MVP)
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Entitlements
Route::get('/entitlements/check', function (Request $request) {
    $userId = 1; 
    $entitlement = DB::table('entitlements')
        ->where('user_id', $userId)
        ->where('expires_at', '>', now())
        ->first();

    return response()->json([
        'active' => $entitlement !== null,
        'entitlement' => $entitlement
    ]);
});

Route::post('/entitlements/grant-demo', function (Request $request) {
    $userId = 1;
    $productId = $request->input('product_id', 'com.theoriezone.car.90days');
    
    DB::table('entitlements')->insert([
        'user_id' => $userId,
        'product_id' => $productId,
        'platform' => 'manual_demo',
        'receipt_data' => 'demo_receipt',
        'purchased_at' => now(),
        'expires_at' => now()->addDays(90),
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return response()->json(['status' => 'granted']);
});

// Exams
Route::get('/exams', [ExamController::class, 'index']);
Route::post('/exams/random', [ExamController::class, 'startRandom']);
Route::get('/exams/{id}', [ExamController::class, 'show']);
