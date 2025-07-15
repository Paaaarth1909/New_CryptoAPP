import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000), // 20% opacity black
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: const Color(0xFF1A1A1A),
            selectedItemColor: const Color(0xFF00BFB3),
            unselectedItemColor: const Color(0xFF9E9E9E),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            elevation: 0,
            items: [
              _buildNavItem('assets/images/nav_home.png', 'Home'),
              _buildTrendingNavItem(),
              _buildExploreNavItem(),
              _buildWalletNavItem(),
              _buildProfileNavItem(),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String imagePath, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ImageIcon(
          AssetImage(imagePath),
          size: 24,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ImageIcon(
          AssetImage(imagePath),
          size: 24,
          color: const Color(0xFF00BFB3),
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildTrendingNavItem() {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ImageIcon(
          const AssetImage('assets/images/nav_trending.png'),
          size: 24,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(
          'assets/images/trending_click.png',
          width: 24,
          height: 24,
        ),
      ),
      label: 'Trending',
    );
  }

  BottomNavigationBarItem _buildExploreNavItem() {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ImageIcon(
          const AssetImage('assets/images/nav_explore.png'),
          size: 24,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(
          'assets/images/explore_click.png',
          width: 24,
          height: 24,
        ),
      ),
      label: 'Explore',
    );
  }

  BottomNavigationBarItem _buildWalletNavItem() {
    final isSelected = currentIndex == 3;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(
          isSelected ? 'assets/images/wallet_click.png' : 'assets/images/nav_wallet.png',
          width: 24,
          height: 24,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(
          'assets/images/wallet_click.png',
          width: 24,
          height: 24,
        ),
      ),
      label: 'Wallet',
    );
  }

  BottomNavigationBarItem _buildProfileNavItem() {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ImageIcon(
          const AssetImage('assets/images/nav_profile.png'),
          size: 24,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Image.asset(
          'assets/images/profile_click.png',
          width: 24,
          height: 24,
        ),
      ),
      label: 'Profile',
    );
  }
}
