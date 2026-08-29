import 'package:flutter/material.dart';

import 'screens/ai_screen.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/customers_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/more_screen.dart';
import 'screens/products_screen.dart';
import 'screens/sales_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.instance.initialize();

  runApp(const BizOSApp());
}

class BizOSApp extends StatelessWidget {
  const BizOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFD71920);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizOS AI',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B0D),

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryRed,
          brightness: Brightness.dark,
          primary: primaryRed,
          secondary: const Color(0xFFF04444),
          surface: const Color(0xFF151519),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0B0D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF151519),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF29292F),
            ),
          ),
        ),

        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF111114),
          indicatorColor: Color(0xFFD71920),
          elevation: 0,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF151519),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF29292F),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF29292F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryRed,
              width: 2,
            ),
          ),
        ),
      ),

      home: const AuthGate(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SalesScreen(),
    CustomersScreen(),
    ProductsScreen(),
    AIScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),

          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Customers',
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),

          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),

          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
