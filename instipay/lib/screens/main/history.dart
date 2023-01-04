import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instipay/screens/main/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _ShowHistory();
}

class _ShowHistory extends State<History> {
  List myTransactions = [];

  Future<void> _getTransactions() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    String myID = data[0]["clgID"];
    List response = await supabase
        .from('Transactions')
        .select('*')
        .or('senderID.eq.$myID,receiverID.eq.$myID');

    setState(() {
      myTransactions = response;
      for (var element in myTransactions) {
        print(element);
      }
    });
  }

  @override
  void initState() {
    _getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                    onTap: () => context.go('/'),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  title: Center(
                    child: Text('Your history'),
                  ),
                  backgroundColor: Color(0x60A725B2),
                ),
                body: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                        Color(0xbb2C0354),
                        Color(0x60A725B2)
                      ])),
                  child: Wrap(alignment: WrapAlignment.spaceAround, children: [
                    (myTransactions.isEmpty)
                        ? const Text('Your history will be shown here')
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Text('$myTransactions');
                            })
                  ]),
                ))));
  }
}
