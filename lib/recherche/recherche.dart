import 'package:flutter/material.dart';

class recherche extends StatelessWidget {
  const recherche({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0101),
        title: Text(
          "Recherche",
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

