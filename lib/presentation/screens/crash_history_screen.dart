import 'package:flutter/material.dart';

class CrashHistoryScreen extends StatelessWidget {
  const CrashHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crash History')),
      body: const Center(
        child: Text('No crashes recorded yet.', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
