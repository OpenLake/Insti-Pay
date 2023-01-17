import 'package:flutter/material.dart';
import 'package:instipay/screens/main/home.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Rpay extends StatefulWidget {
  const Rpay({super.key});

  @override
  State<Rpay> createState() => _Rpay();
}

class _Rpay extends State<Rpay> {
  late Razorpay razorpay;
  TextEditingController textEditingController = TextEditingController();
  int? bal;
  String error = '';
  int amt = 0;

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    var options = {
      "key": 'rzp_test_3CtrMlZPwU2Rep',
      "amount": num.parse(textEditingController.text) * 100,
      "name": data[0]['name'],
      "description": "PAY TO E-wallet",
      "prefill": {"Your id": data[0]['clgID'], "email": data[0]['email']},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success");
    Fluttertoast.showToast(msg: 'Payment success');
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    final data = await supabase.from("Data").select().eq("email", user?.email);
    await supabase
        .from('Data')
        .update({'amount': bal! + num.parse(textEditingController.text)}).match(
            {'clgID': data[0]["clgID"]});
    setState(() {
      error = "Payment Successful";
      context.go('/');
    });
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment error");
    Fluttertoast.showToast(msg: 'Payment error');
    setState(() {
      error = "Payment Unsuccessful";
      context.go('/');
    });
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print("External Wallet");
    Fluttertoast.showToast(msg: 'External Wallet');
  }

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
            backgroundColor: const Color(0xff300757),
            title: const Text("Add money to wallet"),
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
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              bal = snapshot.data;
                              return Text(
                                "Balance    : ₹ $bal",
                                style: const TextStyle(
                                    color: Color(0xff2C0354),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                                textAlign: TextAlign.right,
                              );
                            })),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Card(
                              color: Color.fromRGBO(249, 250, 251, 0.867),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: textEditingController,
                                    decoration: const InputDecoration(
                                        hintText: "Enter your amonut"),
                                  ))),
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton(
                            onPressed: () {
                              openCheckout();
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w800,
                                  color: Colors.yellow),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]))),
    );
  }
}

Future<int> _getBalance() async {
  final supabase = Supabase.instance.client;
  final User? user = supabase.auth.currentUser;
  final data = await supabase.from("Data").select().eq("email", user?.email);
  return data[0]["amount"];
}
