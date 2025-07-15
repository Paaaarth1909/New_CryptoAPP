import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'news_screen.dart';
import 'trending_screen.dart';
import 'portfolio_screen.dart';
import 'remove_chips_screen.dart';
import '../services/coin_database.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TrendingScreen(),
    const NewsScreen(),
    const PortfolioScreen(),
    const Center(child: Text('Profile', style: TextStyle(color: Colors.white))),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onRemoveChips() async {
    if (_currentIndex == 3) {
      // On Wallet tab, get coins and show a dialog to pick one to remove
      final coins = await CoinDatabase.instance.getCoins();
      if (coins.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No coins'),
            content: const Text('You have no coins to remove.'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
        return;
      }
      showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
          children: coins.map((coin) => ListTile(
            leading: Image.asset(coin.iconPath, width: 32),
            title: Text(coin.name),
            subtitle: Text(coin.symbol),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RemoveChipsScreen(coin: coin)),
              );
            },
          )).toList(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove Chips'),
          content: const Text('Go to the Wallet tab to remove chips from your portfolio.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        onRemoveChips: _onRemoveChips,
      ),
    );
  }
} 