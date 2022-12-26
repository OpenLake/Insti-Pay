import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'signup.dart';
import 'signin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF2C0354), Color(0x88A725B2)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            const Center(
                child: Text(
              "Instipay",
              style: TextStyle(
                  color: Colors.yellow,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                      child: TextButton(
                          onPressed: () => context.go('/login/signup'),
                          child: const Text(
                            "SignUp",
                            style: TextStyle(color: Colors.pink),
                          ))),
                  Card(
                    child: TextButton(
                        onPressed: () => context.go('/login/signin'),
                        child: const Text(
                          "SignIn",
                          style: TextStyle(color: Colors.pink),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
