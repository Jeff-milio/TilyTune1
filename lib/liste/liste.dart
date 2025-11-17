import 'package:flutter/material.dart';

class liste extends StatelessWidget {
  const liste({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0101),
        title: Text(
          "Liste",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),

      ),
      body: Scaffold(
          backgroundColor: Color(0xFF120202)
      ),
    );
  }
}