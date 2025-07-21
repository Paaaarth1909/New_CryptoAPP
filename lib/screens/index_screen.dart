import 'package:flutter/material.dart';
import 'package:crypto_app/screens/home_screen.dart';
import 'package:crypto_app/screens/trending_screen.dart';
import 'package:crypto_app/screens/news_screen.dart';
import 'package:crypto_app/screens/portfolio_screen.dart';
import 'package:crypto_app/screens/settings_screen.dart';
import 'package:crypto_app/widgets/bottom_nav_bar.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TrendingScreen(),
    const NewsScreen(),
    const PortfolioScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
