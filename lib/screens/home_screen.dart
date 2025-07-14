import 'package:flutter/material.dart';
import '../services/crypto_api_service.dart';
import '../models/crypto_coin.dart';
import '../widgets/bottom_nav_bar.dart';
import 'settings_screen.dart';
import 'coin_details_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/candle_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CryptoApiService _apiService = CryptoApiService();
  final CandleApiService _candleApiService = CandleApiService();
  List<CryptoCoin> _coins = [];
  bool _isLoading = true;
  String _error = '';
  int _currentIndex = 0;
  String _selectedFilter = 'Profit';
  Map<String, List<double>> _miniGraphData = {};

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
  }

  Future<void> _loadCryptoData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      final coins = await _apiService.getCryptoList();
      setState(() {
        _coins = coins;
        _isLoading = false;
      });
      _fetchMiniGraphs();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMiniGraphs() async {
    // Pick 2 random coins for the top cards
    final randomCoins = _coins.length > 2 ? (_coins.toList()..shuffle()).take(2).toList() : _coins;
    for (var coin in randomCoins) {
      try {
        final graphData = await _candleApiService.getCryptoGraph(symbol: coin.symbol, type: 'Week');
        setState(() {
          _miniGraphData[coin.symbol] = graphData.candles.map((c) => c.close).toList();
        });
      } catch (_) {}
    }
  }

  List<CryptoCoin> _getSortedCoins() {
    final List<CryptoCoin> sortedCoins = List.from(_coins);
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

  void _onNavTap(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildMiniGraph(List<double> data) {
    if (data.isEmpty) return const SizedBox(height: 40);
    return SizedBox(
      height: 40,
      width: 80,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: const Color(0xFF00BFB3),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final randomCoins = _coins.length > 2 ? (_coins.toList()..shuffle()).take(2).toList() : _coins;
    return Row(
      children: randomCoins.map((coin) {
        final miniGraph = _miniGraphData[coin.symbol] ?? [];
        final isPositive = coin.changePct >= 0;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      coin.icon,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.currency_bitcoin, color: Colors.amber),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      coin.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      coin.symbol,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildMiniGraph(miniGraph),
                const SizedBox(height: 8),
                Text(
                  '\$${coin.rate.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${isPositive ? '+' : ''}${coin.changePct.toStringAsFixed(2)}%',
                  style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
            color: isSelected ? const Color(0xFF00BFB3) : Colors.transparent,
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

  Widget _buildMarketRank() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(top: 8, left: 0, right: 0),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.show_chart, color: Color(0xFF00BFB3)),
                  const SizedBox(width: 8),
                  const Text('Market Rank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('See All Coin →', style: TextStyle(color: Color(0xFF00BFB3), fontSize: 13)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF232323),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: const [
                  Expanded(flex: 2, child: Text('Coin', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Last Price', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Vol 24h', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                      : ListView.builder(
                          itemCount: _getSortedCoins().length,
                          itemBuilder: (context, index) {
                            final coin = _getSortedCoins()[index];
                            final isPositiveChange = coin.changePct >= 0;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoinDetailsScreen(coin: coin),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Image.network(
                                            coin.icon,
                                            width: 28,
                                            height: 28,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.currency_bitcoin, color: Colors.amber, size: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(coin.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                              Text(coin.symbol, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '\$${coin.rate.toStringAsFixed(3)}',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${isPositiveChange ? '+' : ''}${coin.changePct.toStringAsFixed(2)}%',
                                        style: TextStyle(color: isPositiveChange ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search Cryptocurrencies',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            _buildInfoCards(),
            _buildMarketRank(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
