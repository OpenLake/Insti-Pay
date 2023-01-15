import 'package:flutter/material.dart';
import 'package:instipay/screens/profile/CreateProfile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: button(),
    );
  }

  Widget button() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap the button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),

          Card(
            color: Color(0xff300757),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () => context.go('/profile/CreateProfile'),
                child: Text(
                  'Add Profile data',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // Container(
          //     height: 50,
          //     width: 150,
          //     decoration: BoxDecoration(
          //       color: Colors.blueGrey,
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     child: Center(
          //       onPressed: () => context.go('/profile'),
          //       child: Text(
          //         "Add Profile data",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18,
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
