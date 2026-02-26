import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/crash_event_bloc.dart';

class CrashAlertScreen extends StatelessWidget {
  const CrashAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: AppBar(
        title: const Text('Emergency Content'),
        backgroundColor: Colors.red[900],
        elevation: 0,
      ),
      body: BlocBuilder<CrashEventBloc, CrashEventBlocState>(
        builder: (context, state) {
          if (state is CrashDetected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'CRASH DETECTED',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Severity: ${state.crash.severity}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    onPressed: () {
                      // Call emergency services immediately or dismiss
                    },
                    child: const Text('I NEED HELP (CALL 911)'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.read<CrashEventBloc>().add(StopCrashMonitoringEvent());
                    },
                    child: const Text('I AM OKAY (DISMISS)', style: TextStyle(color: Colors.white70)),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('Monitoring for crashes...', style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}
