import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQR extends StatefulWidget {
  const MyQR({Key? key}) : super(key: key);

  @override
  State<MyQR> createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff300757),
    title: Text('Your QR'),
    ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xbb2C0354), Color(0x60A725B2)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FutureBuilder<String>(
                future: _getID(),
                builder: (BuildContext context,AsyncSnapshot<String> snapshot){
                  if(!snapshot.hasData){
                    return Container();
                  }
                  return QrImage(
                    data: snapshot.data!,
                  version: QrVersions.auto,
                      size: 200.0,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<String> _getID() async{
  final supabase = Supabase.instance.client;
  final User? user = supabase.auth.currentUser;
  final data= await supabase
      .from("Data")
      .select()
      .eq("email",user?.email);
  return data[0]["clgID"];

}