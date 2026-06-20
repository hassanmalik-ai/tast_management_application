import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/providers/app_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(dio: dio, prefs: prefs, ref: ref);
});

class AuthRepository {
  final Dio _dio;
  final SharedPreferences _prefs;
  final Ref _ref;

  AuthRepository({required Dio dio, required SharedPreferences prefs, required Ref ref}) 
      : _dio = dio, _prefs = prefs, _ref = ref;

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _prefs.setString('jwt_token', token);
        _ref.read(isLoggedInProvider.notifier).state = true;
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<bool> register(String name, String username, String email, String phone, String password) async {
    try {
      final response = await _dio.post('/users/register', data: {
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _prefs.remove('jwt_token');
    _ref.read(isLoggedInProvider.notifier).state = false;
  }
}
