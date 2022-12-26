import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _showhistory();
}

class _showhistory extends State<history> {
  List? dashlist;

  get senderID => null;
  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    final supabase = Supabase.instance.client;
    final User? user = supabase.auth.currentUser;
    var response =
        await supabase.from('Transactions').select().eq("senderID", user?.id);
    setState(() {
      dashlist = response.data.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your history"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 15, right: 10),
        child: dashlist != null
            ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.00,
                    crossAxisSpacing: 6.00),
                physics: const BouncingScrollPhysics(),
                itemCount: dashlist?.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                            (dashlist![index]["dash_position"]).toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 4,
                          right: 16,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.00),
                              border: Border.all(color: Colors.blue, width: 1)),
                        ),
                      ),
                    ],
                  );
                })
            : const Center(
                child: Text("No Data Found"),
              ),
      ),
    );
  }
}
