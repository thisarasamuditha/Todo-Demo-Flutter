import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
      // Update the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action for search button
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Action for more options button
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Count is $count",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                increment();
                print(count);
              },
              child: Text("Increment", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
