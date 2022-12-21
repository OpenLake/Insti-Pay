import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:instipay/services/auth.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  String email="";
  String password="";
  String clgID='';
  String error = '';
  String name="";
  bool loading = false;
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex:1,
                child: Column(
                  children:[
                Text("Hi There! 👋"),
                Text("Welcome back, Sign in to your account"),]
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  children:[
                Card(
                  color: Color(0xddf9fafb),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Email"),
                      onChanged: (val) {
                        setState(() => email = val);
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
                      decoration: InputDecoration(hintText: "Name"),
                      onChanged: (val) {
                        setState(() => name = val);
                      },),
                  ),
                ),
                Card(
                  color: Color(0xddf9fafb),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Password"),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
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
                      decoration: InputDecoration(hintText: "ID No."),
                      onChanged: (val) {
                        setState(() => clgID = val);
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
                      'Sign Up',
                      style: TextStyle(color: Colors.white),

                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await AuthService().signUp(email, password,clgID,name);
                      if(result == true) {
                        setState(() {
                          loading = false;
                          error = 'Verification Link has been sent to your email. Confirm and then login ';
                        });
                      }
                      else{
                            error="Something was wrong, Please retry";
                      }
                    }


                ),]
                ),
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
