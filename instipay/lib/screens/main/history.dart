// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _ShowHistory();
}

class _ShowHistory extends State<History> {
  List myTransactions = [];
  String myid = '';
  DateTime time = DateTime.now();
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
    });
  }

  Future<void> _getmyID() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    setState(() {
      myid = data[0]["clgID"];
    });
  }

  @override
  void initState() {
    _getTransactions();
    _getmyID();
    super.initState();
  }

  Future<String> _getName() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    return data[0]["name"];
  }

  //create a function that returns a list and use listviwe bulder to return the data

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Do you want to go back?'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff300757),
              title: Text('YOUR HISTORY'),
            ),
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
                                      '',
                                      style: TextStyle(
                                          color: Color(0xff2C0354),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32),
                                    );
                                  }
                                  return const Text("",
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
                                      var res1 =
                                          myTransactions[index]['senderID'];
                                      String now =
                                          myTransactions[index]["datetime"];
                                      time = DateTime.tryParse(now)!;
                                      var contime = time.toLocal();
                                      contime = contime
                                          .add(Duration(hours: 5, minutes: 30));
                                      String formattedDate =
                                          DateFormat.yMMMEd().format(contime);
                                      String formattedtime =
                                          DateFormat('H:m:s').format(contime);
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
                                                    child:
                                                        (res1.compareTo(myid) ==
                                                                0)
                                                            ? Text(
                                                                "Sent to ${myTransactions[index]['receivername']} (${myTransactions[index]['receiverID']})",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            : Text(
                                                                'Received from ${myTransactions[index]['sendername']}(${myTransactions[index]['senderID']})',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                  )),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Container(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: (res1.compareTo(
                                                                      myid) ==
                                                                  0)
                                                              ? Text(
                                                                  '- ₹${myTransactions[index]['amount']}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              : Text(
                                                                  '+₹${myTransactions[index]['amount']}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ))),
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
                                                              '$formattedDate ($formattedtime)',
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
