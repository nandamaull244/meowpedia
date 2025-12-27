import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthService {
  static String _toEmail(String username) {
    return '$username@app.local';
  }

  // ======================
  // REGISTER
  // ======================
  static Future<void> register({
    required String username,
    required String password,
    required String fullName,
    required DateTime tgl_lahir,
  }) async {
    final email = _toEmail(username);

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Register gagal');

    await supabase.from('users').insert({
      'id_user': user.id,
      'username': username,
      'full_name': fullName,
      'tgl_lahir': tgl_lahir.toIso8601String(),
      'image_url': null,
    });
  }

  // ======================
  // LOGIN
  // ======================
  static Future<void> login({
    required String username,
    required String password,
  }) async {
    final email = _toEmail(username);

    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ======================
  // LOGOUT
  // ======================
  static Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // ======================
  // CHECK SESSION
  // ======================
  static bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }
}
