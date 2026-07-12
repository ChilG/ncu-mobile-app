import 'package:flutter/material.dart';
import 'screens/rectangle_screen.dart';
import 'screens/triangle_screen.dart';
import 'screens/circle_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Area Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RectangleScreen(key: Key('rectangle_screen')),
    TriangleScreen(key: Key('triangle_screen')),
    CircleScreen(key: Key('circle_screen')),
  ];

  final List<String> _titles = const [
    'คำนวณพื้นที่สี่เหลี่ยม',
    'คำนวณพื้นที่สามเหลี่ยม',
    'คำนวณพื้นที่วงกลม',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        key: const Key('bottom_nav_bar'),
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            key: Key('nav_rectangle'),
            icon: Icon(Icons.crop_square_outlined),
            selectedIcon: Icon(Icons.crop_square_rounded),
            label: 'สี่เหลี่ยม',
          ),
          NavigationDestination(
            key: Key('nav_triangle'),
            icon: Icon(Icons.change_history_outlined),
            selectedIcon: Icon(Icons.change_history_rounded),
            label: 'สามเหลี่ยม',
          ),
          NavigationDestination(
            key: Key('nav_circle'),
            icon: Icon(Icons.circle_outlined),
            selectedIcon: Icon(Icons.circle_rounded),
            label: 'วงกลม',
          ),
        ],
      ),
    );
  }
}
