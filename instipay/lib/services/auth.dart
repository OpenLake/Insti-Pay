import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthService{
  final supabase = Supabase.instance.client;
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
          email: 'example@email.com',
          password: 'example-password'
      );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

