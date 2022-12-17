import 'package:flutter/material.dart';
import 'package:insti_payment/services/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  String email='';
  final _formKey = GlobalKey<FormState>();
  String password="";
  String error = '';
  bool loading = false;

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              TextField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              ElevatedButton(
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),

                  ),
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await AuthService().signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'Could not sign in with those credentials';
                      });
                    }
                  }

              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    )
    ;
  }
}
