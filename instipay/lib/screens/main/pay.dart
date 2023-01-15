import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class Pay extends StatefulWidget {
  String? id;
  Pay({this.id});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  @override
  String ID = "";
  String error = "";
  int amount = 0;
  int? bal;

  @override
  Future checkID(String id, int amount) async {
    if (bal == 0) {
      setState(() {
        error = "Can't pay if balance is zero";
      });
    }
    final supabase = Supabase.instance.client;
    final data = await supabase.from("Data").select().eq("clgID", id);
    if (data.length == 0) {
      setState(() {
        if (error == "") {
          error = "User not present on Instipay rn";
        }
        ;
      });
    } else {
      if (bal == 0) {
        setState(() {
          error = "Can't pay if balance is zero";
        });
      } else if (amount > bal!) {
        setState(() {
          error = "Amount more than balance";
        });
      } else {
        final User? user = supabase.auth.currentUser;
        final data =
            await supabase.from("Data").select().eq("email", user?.email);
        if (data[0]['clgID'] == id) {
          setState(() {
            error = "Can't pay to yourself";
          });
        } else {
          setState(() {
            error = "Processing";
          });
          await supabase.from('Data').update({'amount': bal! - amount}).match(
              {'clgID': data[0]["clgID"]});

          final data2 = await supabase.from("Data").select().eq("clgID", id);

          await supabase.from('Data').update(
              {'amount': data2[0]["amount"] + amount}).match({'clgID': id});

          await supabase.from('Transactions').insert({
            'senderID': data[0]["clgID"],
            'sendername': data[0]['name'],
            'receivername': data2[0]['name'],
            'receiverID': id,
            'amount': amount
          });
          setState(() {
            error = "Payment Successful";
            context.go('/');
          });
        }
      }
    }
  }

  Widget build(BuildContext context) {
    print(widget.id);
    if (widget.id != null) {
      setState(() {
        ID = widget.id!;
        print(ID);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff300757),
        title: Text('Pay By ID'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                  future: _getBalance(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    bal = snapshot.data;
                    return Text(
                      "Balance    : ₹ $bal",
                      style: TextStyle(
                          color: Color(0xff2C0354),
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                      textAlign: TextAlign.right,
                    );
                  }),
            ),
            Card(
              color: Color.fromRGBO(249, 250, 251, 0.867),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: "ID No."),
                  initialValue: ID,
                  onChanged: (val) {
                    setState(() => ID = val);
                  },
                ),
              ),
            ),
            Card(
              color: Color(0xddf9fafb),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Amount"),
                  onChanged: (val) {
                    setState(() => amount = int.parse(val));
                  },
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    checkID(ID, amount);
                  });
                },
                child: Text(
                  'Pay',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w800,
                      color: Colors.yellow),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<int> _getBalance() async {
  final supabase = Supabase.instance.client;
  final User? user = supabase.auth.currentUser;
  final data = await supabase.from("Data").select().eq("email", user?.email);
  return data[0]["amount"];
}
