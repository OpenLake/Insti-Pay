// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  Future<String> _getName() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    return data[0]["name"];
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
                                  return const Text("Your History",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 218, 212, 224),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32));
                                }),
                            const SizedBox(
                              width: 544,
                            ),
                            (myTransactions.isEmpty)
                                ? const Text('Your history will be shown here')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(16),
                                    itemCount: myTransactions.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SingleChildScrollView(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color.fromRGBO(
                                                    249, 250, 251, 0.867)),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'SenderID :${myTransactions[index]['senderID']}',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )),
                                                  Container(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Amount :${myTransactions[index]['amount']}',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              'ReceiverID :${myTransactions[index]['receiverID']}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )))
                                                  ]),
                                              Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              )
                                            ]),
                                          ));
                                    })
                          ])
                        ])))));
  }
}
