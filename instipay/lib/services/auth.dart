import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthService{
  String name="";
  String? email="";
  final supabase = Supabase.instance.client;
  Future signInWithEmailAndPassword(String clgID, String password) async {
    final data = await supabase
        .from('Data')
        .select('email')
        .eq('clgID',clgID);
    final AuthResponse res = await supabase.auth.signInWithPassword(
        email: data[0]["email"].toString(),
        password: password
    );
    final User? user = supabase.auth.currentUser;
    print(user?.id);
    return user!=null;

  }
  Future userData() async{
    final data= await supabase
        .from("Data")
        .select()
        .eq("email",this.email);
    this.name=data[0]["name"].toString() ;
    print(this.name);

  }

  bool redirectLogin(){
    final User? user = supabase.auth.currentUser;
    if(user!=null){
      this.email=user.email;
      this.userData();
    }
    return user==null;
  }
  Future signUp(String email, String password,String clgID,String name) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    final User? user = supabase.auth.currentUser;
    await supabase
        .from('Data')
        .insert({'name': name, 'clgID': clgID,"email":email});

    return user==null;

  }

}

