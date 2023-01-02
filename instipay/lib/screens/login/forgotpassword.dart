import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  String email = "";
  String error = "";
  bool loading = false;

  @override
  void initState() {
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((data) {
      context.go('/login/forgotpassword/resetpassword/');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(children: [
                      const Text(
                        "Hi There! 👋",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                      const Text(
                        "Forgot Password? Recover here",
                        style: TextStyle(color: Color(0xff6b7200)),
                      ),
                    ]),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(children: [
                        Card(
                          color: Color(0xddf9fafb),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(hintText: "Email"),
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 64,
                        ),
                        ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            child: Text(
                              'Send link',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              setState(() => loading = true);
                              final supabase = Supabase.instance.client;
                              final result = await supabase.auth
                                  .resetPasswordForEmail(email,
                                      redirectTo:
                                          'com.example.instipay://reset-callback/');
                              setState(() {
                                error =
                                    'Reset password link has been sent to your email.';
                              });
                            }),
                      ])),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
