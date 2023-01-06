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
                                  if (!snapshot.hasData)
                                    return Text(
                                      'Transaction History',
                                      style: TextStyle(
                                          color: Color(0xff2C0354),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32),
                                    );
                                  String? name = snapshot.data;
                                  return const Text("Transaction History",
                                      style: TextStyle(
                                          color: Color(0xff2C0354),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32));
                                }),
                            (myTransactions.isEmpty)
                                ? const Text('Your history will be shown here')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(16),
                                    itemCount: myTransactions.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return DataTable(
                                          onSelectAll: (b) {},
                                          sortAscending: true,
                                          columnSpacing: 19,
                                          columns: const [
                                            DataColumn(
                                                label: Text(
                                              'SenderID',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                            DataColumn(
                                                label: Text('ReceiverID',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                            DataColumn(
                                                label: Text('Amount',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              DataCell(Text(
                                                  '${myTransactions[index]['senderID']}')),
                                              DataCell(Text(
                                                  '${myTransactions[index]['receiverID']}')),
                                              DataCell(Text(
                                                  '${myTransactions[index]['amount']}'))
                                            ])
                                          ]);
                                    }),
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
