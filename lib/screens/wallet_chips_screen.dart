import 'package:flutter/material.dart';
import '../services/coin_database.dart';
import '../services/crypto_api_service.dart';
import '../models/crypto_coin.dart';
import 'add_chips_screen.dart';
import 'remove_chips_screen.dart';

class WalletChipsScreen extends StatefulWidget {
  const WalletChipsScreen({super.key});

  @override
  State<WalletChipsScreen> createState() => _WalletChipsScreenState();
}

class _WalletChipsScreenState extends State<WalletChipsScreen> {
  List<PortfolioCoin> _portfolio = [];
  bool _isLoading = true;
  List<CryptoCoin> _allCoins = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final portfolio = await CoinDatabase.instance.getCoins();
    final apiCoins = await CryptoApiService().getCryptoList();
    setState(() {
      _portfolio = portfolio;
      _allCoins = apiCoins;
      _isLoading = false;
    });
  }

  CryptoCoin? _findApiCoin(String symbol) {
    try {
      return _allCoins.firstWhere((c) => c.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  Widget _buildChipItem(PortfolioCoin coin, int index) {
    return Dismissible(
      key: Key(coin.symbol + (coin.id?.toString() ?? '')),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RemoveChipsScreen(coin: coin),
            ),
          ).then((_) => _fetchData());
          return false;
        } else if (direction == DismissDirection.startToEnd) {
          final apiCoin = _findApiCoin(coin.symbol);
          if (apiCoin != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddChipsScreen(
                  coinName: apiCoin.name,
                  symbol: apiCoin.symbol,
                  currentPrice: apiCoin.rate,
                  priceChangePercentage: apiCoin.changePct,
                ),
              ),
            ).then((_) => _fetchData());
          }
          return false;
        }
        return false;
      },
      background: Container(
        color: const Color(0xFF4CAF50),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Image.asset(
          'assets/images/add_redbutton.png',
          width: 40,
          height: 40,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Image.asset(
          'assets/images/delete_button.png',
          width: 40,
          height: 40,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x80000000),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x33FFFFFF),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Image.asset(coin.iconPath, width: 40, height: 40),
          title: Text(
            coin.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            coin.symbol,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${coin.value.toStringAsFixed(3)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: coin.change >= 0
                      ? const Color(0x33008000)
                      : const Color(0x33FF0000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${coin.change >= 0 ? '+' : ''}${coin.change.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.change >= 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Added chips',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _portfolio.isEmpty
                ? const Center(
                    child: Text(
                      'No chips added yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _portfolio.length,
                    itemBuilder: (context, index) => _buildChipItem(_portfolio[index], index),
                  ),
      ),
    );
  }
} 