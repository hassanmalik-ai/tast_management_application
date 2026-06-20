import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/app_providers.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // Use 127.0.0.1:8000 for iOS or Web
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = prefs.getString('jwt_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      if (e.response?.statusCode == 401) {
        // Handle unauthorized access (e.g., clear token and logout)
        prefs.remove('jwt_token');
        ref.read(isLoggedInProvider.notifier).state = false;
      }
      return handler.next(e);
    },
  ));

  return dio;
});
