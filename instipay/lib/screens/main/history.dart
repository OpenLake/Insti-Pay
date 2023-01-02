import 'package:flutter/material.dart';
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
      myTransactions.forEach((element) => print(element));
    });
  }

  @override
  void initState() {
    _getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff300757),
        centerTitle: true,
        title: const Text('Your History'),
      ),
      body: Center(
          child: (myTransactions.isEmpty)
              ? const Text('Your history will be shown here')
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.00,
                      crossAxisSpacing: 6.00),
                  padding: const EdgeInsets.all(8),
                  itemCount: myTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                            Color.fromRGBO(44, 3, 84, 0.733),
                            Color.fromRGBO(167, 37, 178, 0.376)
                          ])),
                      height: 50,
                      child: Center(child: Text('$myTransactions')),
                    );
                  },
                )),
      backgroundColor: const Color.fromRGBO(167, 37, 178, 0.376),
    );
  }
}
