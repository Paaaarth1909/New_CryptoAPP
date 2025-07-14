import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:candlesticks/candlesticks.dart';
import '../config/api_config.template.dart';

class CandleData {
  final DateTime date;
  final double high;
  final double low;
  final double open;
  final double close;
  final double volume;
  final double changePct;

  CandleData({
    required this.date,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
    required this.changePct,
  });

  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      date: DateTime.parse(json['date']),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      open: json['rate'] != null ? (json['rate'] as num).toDouble() : 0.0,
      close: json['rate'] != null ? (json['rate'] as num).toDouble() : 0.0,
      volume: (json['volume'] as num).toDouble(),
      changePct: (json['change_pct'] as num).toDouble(),
    );
  }
}

class CryptoGraphData {
  final List<CandleData> candles;
  final String currency;
  final String fullName;
  final double diffRate;

  CryptoGraphData({
    required this.candles,
    required this.currency,
    required this.fullName,
    required this.diffRate,
  });

  factory CryptoGraphData.fromJson(Map<String, dynamic> json) {
    return CryptoGraphData(
      candles: (json['data'] as List)
          .map((item) => CandleData.fromJson(item))
          .toList(),
      currency: json['currency'] as String,
      fullName: json['fullname'] as String,
      diffRate: double.parse(json['diffRate']),
    );
  }
}

class CandleApiService {
  Future<CryptoGraphData> getCryptoGraph({
    required String symbol,
    String type = 'Week',
    String currency = 'USD',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/Bitcoin/resources/getBitcoinCryptoGraph?type=$type&name=$symbol&currency=$currency',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return CryptoGraphData.fromJson(data);
        } else {
          throw Exception('Failed to load graph data: ${data['error']}');
        }
      } else {
        throw Exception('Failed to load graph data');
      }
    } catch (e) {
      throw Exception('Failed to load graph data: $e');
    }
  }

  Future<List<Candle>> getCandleData(String symbol, String interval) async {
    try {
      // Return sample candle data for now
      // TODO: Replace with your actual candle data API implementation
      return List.generate(
        30,
        (index) => Candle(
          date: DateTime.now().subtract(Duration(minutes: index * 15)),
          high: 853.34 + (index * 2),
          low: 850.34 - (index * 1),
          open: 851.34 + (index * 1.5),
          close: 852.34 + (index * 1.8),
          volume: 1234.56 + (index * 100),
        ),
      ).reversed.toList();
    } catch (e) {
      throw Exception('Failed to load candle data: $e');
    }
  }
} 