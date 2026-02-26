import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/crash_alert_screen.dart';
import 'presentation/screens/emergency_contacts_screen.dart';
import 'presentation/screens/crash_history_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/blocs/location_sensor_bloc.dart';
import 'presentation/blocs/crash_event_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const CrashDetectorApp());
}

class CrashDetectorApp extends StatelessWidget {
  const CrashDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LocationSensorBloc>()..add(CheckPermissionsEvent())),
        // BlocProvider(create: (_) => di.sl<CrashEventBloc>()..add(StartCrashMonitoringEvent())),
      ],
      child: MaterialApp(
        title: 'Crash Detector',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const AppMainScreen(),
      ),
    );
  }
}

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CrashAlertScreen(),
    const EmergencyContactsScreen(),
    const CrashHistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alert'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
