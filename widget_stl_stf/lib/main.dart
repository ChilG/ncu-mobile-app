import 'package:flutter/material.dart';
import 'widgets/stateful_counter_card.dart';
import 'widgets/stateless_info_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateless vs Stateful Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stateless vs Stateful Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0x339E9E9E), height: 1.0),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatelessInfoCard(
                icon: Icons.info_outline,
                title: 'Stateless Widget Example',
                description:
                    'This card displays static information. Its content does not change after it is built.',
              ),
              SizedBox(height: 16.0),
              StatefulCounterCard(),
              SizedBox(height: 16.0),
              StatelessInfoCard(
                icon: Icons.lightbulb_outline,
                title: 'Another Static Card',
                description:
                    'Even if the app rebuilds, this card will not change unless its parent provides new data.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
