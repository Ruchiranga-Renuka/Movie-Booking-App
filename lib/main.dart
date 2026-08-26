import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/booking_history_screen.dart';

void main() {
  runApp(const MovieBookingApp());
}

class MovieBookingApp extends StatelessWidget {
  const MovieBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF6B83F),
          brightness: Brightness.dark,
          surface: const Color(0xFF15171D),
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0E12),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0E12),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF15171D),
          indicatorColor: const Color(0xFFF6B83F),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const RootNav(),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    BookingHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final appWidth = constraints.maxWidth > 480 ? 480.0 : constraints.maxWidth;
        return ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: SizedBox(
              width: appWidth,
              height: constraints.maxHeight,
              child: Scaffold(
                body: _screens[_index],
                bottomNavigationBar: NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.movie), label: 'Movies'),
                    NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'My Tickets'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
