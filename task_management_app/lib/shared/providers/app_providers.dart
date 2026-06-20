import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing the current theme mode (light/dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// Provider for the current bottom nav tab index.
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// Provider for search query text.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for selected task filter category.
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

/// Provider to track if onboarding has been completed.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Provider to track if user is "logged in" (UI state only).
final isLoggedInProvider = StateProvider<bool>((ref) => false);

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
