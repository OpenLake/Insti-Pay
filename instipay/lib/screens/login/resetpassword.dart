import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  String password = "";
  String error = "";
  bool loading = false;

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
                        "Enter your new password",
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
                              decoration:
                                  InputDecoration(hintText: "New Password"),
                              onChanged: (val) {
                                setState(() => password = val);
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
                              'Change Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              setState(() => loading = true);
                              final supabase = Supabase.instance.client;
                              final UserResponse res =
                                  await supabase.auth.updateUser(
                                UserAttributes(
                                  password: password,
                                ),
                              );
                              final User? updatedUser = res.user;
                              print(updatedUser);
                              if (updatedUser != null) {
                                context.go('/signin');
                              } else {
                                error = "Something was wrong, Please retry";
                              }
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
