import 'package:flutter/material.dart';

class moi extends StatelessWidget {
  const moi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0101),
        title: Text(
          "Moi",
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