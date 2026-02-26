import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Crash Detection'),
            subtitle: const Text('Monitors sensors in background'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Auto-sync to Cloud'),
            value: false,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
