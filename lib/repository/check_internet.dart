import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});
  static Widget builder(BuildContext context) {
    return const NoInternetScreen();
  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Text("Offline",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
