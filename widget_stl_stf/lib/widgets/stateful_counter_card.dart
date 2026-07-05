import 'package:flutter/material.dart';

class StatefulCounterCard extends StatefulWidget {
  const StatefulCounterCard({super.key});

  @override
  State<StatefulCounterCard> createState() => _StatefulCounterCardState();
}

class _StatefulCounterCardState extends State<StatefulCounterCard> {
  int _counter = 0;

  void _handleIncrement() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Counter:',
            style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8.0),
          Text(
            '$_counter',
            style: const TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 16.0),
          OutlinedButton(
            onPressed: _handleIncrement,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.indigo),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Increment Counter',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
