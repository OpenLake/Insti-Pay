import 'package:flutter/material.dart';
import 'package:instipay/services/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  String name = AuthService().name;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xbb2C0354), Color(0x60A725B2)])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                future: _getName(),
                builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) {
                          return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hey',style: TextStyle(color: Color(0xff2C0354),fontWeight: FontWeight.w700,fontSize: 32),),
                            GestureDetector(
                                onTap:()async{
                                  final supabase = Supabase.instance.client;
                                  await supabase.auth.signOut();
                                  context.go('/login');

                                },
                                child: Icon(Icons.logout))
                          ],
                        );
                        }
                        String? name=snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Hey , $name",style: TextStyle(color: Color(0xff2C0354),fontWeight: FontWeight.w700,fontSize: 32)),
                            GestureDetector(
                                onTap:()async{
                                  final supabase = Supabase.instance.client;
                                  await supabase.auth.signOut();
                                  context.go('/login');
                                },
                                child: Icon(Icons.logout)),
                          ],
                        );
                }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Card(
                    color: Color(0xff300757),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Text("Balance",style: TextStyle(color: Colors.yellow),),
                          SizedBox(width: 32,),
                          FutureBuilder(
                              future: _getWallet(),
                              builder:
                                  (BuildContext context, AsyncSnapshot<int> snapshot) {
                                if (!snapshot.hasData) return Text("₹",style: TextStyle(color: Colors.white),);
                                int? amount=snapshot.data;
                                return Text("₹ $amount",style: TextStyle(color: Colors.white));
                              }
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color(0xff300757),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: ()=>context.go('/pay'),
                      child: Text('Pay by ID',style:TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex:2,
                      child: Card(
                        color: Color(0xff300757),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                            onPressed: ()=>context.go('/paybyqr'),
                            child: Text('Pay by QR',style:TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.yellow.shade700,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                            onPressed: ()=>context.go('/myqr'),
                            child: Text('My QR',style:TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
}}

 Future <String> _getName() async{
   final supabase = Supabase.instance.client;
   final User? user = supabase.auth.currentUser;
   final data= await supabase
       .from("Data")
       .select()
       .eq("email",user?.email);
   return data[0]["name"];
}

Future <int> _getWallet() async{
  final supabase = Supabase.instance.client;
  final User? user = supabase.auth.currentUser;
  final data= await supabase
      .from("Data")
      .select()
      .eq("email",user?.email);
  return data[0]["amount"];
}