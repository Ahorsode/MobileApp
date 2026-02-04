import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super .key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INFT 425 - Ahorsode Benjamin Delali',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HelloWorldScreen(),
    );
  }
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INFT 425 - Ahorsode Benjamin Delali'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hello, World!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              ),
            const SizedBox(height: 20),
            Icon(
              Icons.code,
              size: 50,
              color: Colors.green,
              ),
            const SizedBox(height: 20),
            Text(
              'Department of Computer Sciences and Engineering',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
