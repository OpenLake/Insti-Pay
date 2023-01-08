import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              'sender id',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'receiverid',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        trailing: Text(
          'Amount',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(
        width: 15,
      ),
      Divider(
        thickness: 12,
        color: Colors.white,
      )
    ]);
  }
}
