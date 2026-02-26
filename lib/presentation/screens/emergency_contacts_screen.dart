import 'package:flutter/material.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('John Doe (Spouse)'),
            subtitle: Text('+1 555-0100'),
            trailing: Icon(Icons.phone),
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Insurance Provider'),
            subtitle: Text('Policy #123456'),
            trailing: Icon(Icons.phone),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
