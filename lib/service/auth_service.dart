import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /* ================= REGISTER ================= */
  Future<void> register({
    required UserModel user,
    required String password,
  }) async {
    if (user.username.trim().isEmpty) {
      throw 'Username tidak boleh kosong';
    }

    if (password.length < 6) {
      throw 'Password minimal 6 karakter';
    }

    try {
      // Register Auth
      final authResponse = await _supabase.auth.signUp(
        email: '${user.username}@meowmedia.com',
        password: password,
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        throw 'Register gagal';
      }

      // Simpan ke tabel users
      await _supabase.from('users').insert({
        'id_user': userId,
        ...user.toMap(),
      });
    } on AuthException catch (e) {
      throw e.message;
    } on PostgrestException catch (e) {
      throw 'Gagal menyimpan data user: ${e.message}';
    }
  }

  /* ================= LOGIN ================= */
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty) {
      throw 'Username tidak boleh kosong';
    }

    if (password.isEmpty) {
      throw 'Password tidak boleh kosong';
    }

    try {
      final email = '$username@meowmedia.com';

      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw e.message; // username/email salah / password salah
    }
  }

  Future<UserModel> getCurrentUser() async {
    final authUser = _supabase.auth.currentUser;

    if (authUser == null) {
      throw 'User belum login';
    }

    final response = await _supabase
        .from('users')
        .select()
        .eq('id_user', authUser.id)
        .single();

    return UserModel.fromMap(response);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
