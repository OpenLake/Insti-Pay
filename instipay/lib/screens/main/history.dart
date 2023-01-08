// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:instipay/Customui/Ccard.dart';
import 'package:go_router/go_router.dart';
import 'package:instipay/Customui/Ccard.dart';
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
    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                      Color.fromRGBO(44, 3, 84, 0.733),
                      Color.fromRGBO(167, 37, 178, 0.376)
                    ])),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(alignment: WrapAlignment.spaceAround, children: [
                            FutureBuilder(
                                future: _getName(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text(
                                      'Transaction History',
                                      style: TextStyle(
                                          color: Color(0xff2C0354),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32),
                                    );
                                  }
                                  return const Text("Transaction History",
                                      style: TextStyle(
                                          color: Color(0xff2C0354),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32));
                                }),
                            const SizedBox(
                              width: 544,
                            ),
                            (myTransactions.isEmpty)
                                ? const Text('Your history will be shown here')
                                : Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(16),
                                        itemCount: myTransactions.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(children: [
                                            ListTile(
                                              leading: Expanded(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'senderID :${myTransactions[index]['senderID']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            'receiverID :${myTransactions[index]['receiverID']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )
                                                        ],
                                                      ))),
                                              trailing: Column(children: [
                                                Text(
                                                  'amount :${myTransactions[index]['amount']}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 54),
                                                const Text(
                                                  'Done At',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ]),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              color: Colors.white,
                                            )
                                          ]);
                                        }))
                          ]),
                        ])))));
  }
}

Future<String> _getName() async {
  final supabase = Supabase.instance.client;
  final User? user = supabase.auth.currentUser;
  final data = await supabase.from("Data").select().eq("email", user?.email);
  return data[0]["name"];
}
