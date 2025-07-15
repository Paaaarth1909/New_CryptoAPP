import 'package:flutter/material.dart';
import '../services/coin_database.dart';
import 'wallet_chips_screen.dart';
import '../services/crypto_api_service.dart';
import '../models/crypto_coin.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<PortfolioCoin> _coins = [];
  bool _isLoading = true;
  double _totalUsdValue = 0;

  @override
  void initState() {
    super.initState();
    _fetchCoinsAndPrices();
  }

  Future<void> _fetchCoinsAndPrices() async {
    setState(() {
      _isLoading = true;
    });
    final coins = await CoinDatabase.instance.getCoins();
    final apiCoins = await CryptoApiService().getCryptoList();
    double total = 0;
    for (final portfolioCoin in coins) {
      final apiCoin = apiCoins.firstWhere(
        (c) => c.symbol == portfolioCoin.symbol,
        orElse: () => CryptoCoin(
          symbol: portfolioCoin.symbol,
          name: portfolioCoin.name,
          fullName: portfolioCoin.name,
          icon: '',
          rate: 0,
          changePct: 0,
          change: 0,
          volume: 0,
          high: 0,
          low: 0,
          cap: 0,
        ),
      );
      // Assume portfolioCoin.value is the amount of coins held
      total += portfolioCoin.value * apiCoin.rate;
    }
    setState(() {
      _coins = coins;
      _totalUsdValue = total;
      _isLoading = false;
    });
  }

  Widget _buildPortfolioValueCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1DE9B6), Color(0xFF1DC8E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Total Portfolio Value", style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "\$ ${_totalUsdValue.toStringAsFixed(3)}",
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPortfolio() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset('assets/images/empty_portfolio.png', width: 220),
      ],
    );
  }

  Widget _buildCoinList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _coins.length,
      itemBuilder: (context, index) {
        final coin = _coins[index];
        return ListTile(
          leading: Image.asset(coin.iconPath, width: 40),
          title: Text(coin.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(coin.symbol, style: const TextStyle(color: Colors.white70)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$ ${coin.value.toStringAsFixed(3)}',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                '▲ ${coin.change.toStringAsFixed(2)}%',
                style: const TextStyle(color: Color(0xFF1DE9B6), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("My Portfolio", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              _buildPortfolioValueCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Added chips", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WalletChipsScreen()),
                        );
                      },
                      child: const Text("See All Coin →", style: TextStyle(color: Color(0xFF1DE9B6))),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _coins.isEmpty
                      ? _buildEmptyPortfolio()
                      : _buildCoinList(),
            ],
          ),
        ),
      ),
    );
  }
} 