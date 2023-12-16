import 'package:flutter/material.dart';
import 'registration_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: const RegistrationScreen(),
    ),
  ));
}

