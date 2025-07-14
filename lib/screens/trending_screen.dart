import 'package:flutter/material.dart';
import '../services/crypto_api_service.dart';
import '../models/crypto_coin.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final CryptoApiService _apiService = CryptoApiService();
  List<CryptoCoin> _cryptoCoins = [];
  String _selectedFilter = 'Profit'; // Default selected filter

  @override
  void initState() {
    super.initState();
    _fetchCryptoData();
  }

  Future<void> _fetchCryptoData() async {
    try {
      final coins = await _apiService.getCryptoList();
      setState(() {
        _cryptoCoins = coins;
      });
    } catch (e) {
      // Handle error
      debugPrint('Error fetching crypto data: $e');
    }
  }

  List<CryptoCoin> _getSortedCoins() {
    final List<CryptoCoin> sortedCoins = List.from(_cryptoCoins);
    switch (_selectedFilter) {
      case 'Loss':
        sortedCoins.sort((a, b) => a.changePct.compareTo(b.changePct));
        return sortedCoins.where((coin) => coin.changePct < 0).toList();
      case 'Profit':
        sortedCoins.sort((a, b) => b.changePct.compareTo(a.changePct));
        return sortedCoins.where((coin) => coin.changePct > 0).toList();
      case '24h Vol':
        sortedCoins.sort((a, b) => b.volume.compareTo(a.volume));
        return sortedCoins;
      default:
        return sortedCoins;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Market',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildFilterButton('Loss'),
                _buildFilterButton('Profit'),
                _buildFilterButton('24h Vol'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getSortedCoins().length,
              itemBuilder: (context, index) {
                final coin = _getSortedCoins()[index];
                return _buildCryptoListItem(coin);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    final isSelected = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00FFA3) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            filter,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoListItem(CryptoCoin coin) {
    final priceChangeColor =
        coin.changePct >= 0 ? const Color(0xFF00FFA3) : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Image.network(
            coin.icon,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.currency_bitcoin, color: Colors.white),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  coin.symbol.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${coin.rate.toStringAsFixed(3)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${coin.changePct >= 0 ? "+" : ""}${coin.changePct.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: priceChangeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
