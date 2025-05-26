import 'package:flutter/material.dart';
import 'google_map_page.dart'; // thêm import file đã tạo ở trên

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapPage(),
    );
  }
}
