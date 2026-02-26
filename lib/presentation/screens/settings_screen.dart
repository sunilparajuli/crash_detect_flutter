import 'package:flutter/material.dart';
import '../../injection_container.dart' as di;
import '../../domain/repositories/sensor_repository.dart';

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
          const Divider(),
          ListTile(
            title: const Text('Simulate Crash Event', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            subtitle: const Text('Injects synthetic 10G impact and rotation'),
            leading: const Icon(Icons.warning, color: Colors.red),
            onTap: () {
              final sensorRepo = di.sl<SensorRepository>() as di.DummySensorRepository;
              sensorRepo.simulateCrash();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulated High-Impact Crash Data!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
