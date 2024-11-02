import 'package:flutter/material.dart';
import 'package:gemini_clone/core/config/root_binding.dart';
import 'package:gemini_clone/presention/pages/home_page.dart';
import 'package:gemini_clone/presention/pages/starter_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StarterPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
      initialBinding: RootBinding(),
    );
  }
}

