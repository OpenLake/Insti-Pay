import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:instipay/services/auth.dart';
import 'package:go_router/go_router.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  String ID = "";
  String password = "";
  String error = '';
  bool loading = false;
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:1,
                    child:Column(children: [
                      const Text("Hi There! 👋",style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.w700,fontSize: 24),),
                      const Text("Welcome back, Sign in to your account",style: TextStyle(color: Color(0xff6b7200)),),]
                  ),
                  ),
                      Expanded(
                        flex:3,
                        child: Column(
                        children:[Card(
                          color: Color(0xddf9fafb),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(hintText: "ID No."),
                              onChanged: (val) {
                                setState(() => ID = val);
                              },
                            ),
                          ),
                        ),
                        Card(
                          color: Color(0xddf9fafb),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Password"
                              ),
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                        ),
                       SizedBox(height: 64,),
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            dynamic result = await AuthService()
                                .signInWithEmailAndPassword(ID, password);
                            if (result == false) {
                              setState(() {
                                loading = false;
                                error = 'Could not sign in with those credentials';
                              });
                            } else {
                              context.go('/');
                            }
                          }),])),
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
