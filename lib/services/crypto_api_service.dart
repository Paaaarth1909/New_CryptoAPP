import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.template.dart';
import '../models/crypto_coin.dart';

class CryptoApiService {
  Future<List<CryptoCoin>> getCryptoList({String currency = 'USD', int size = 0}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cryptoEndpoint}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          return (data['data'] as List)
              .map((coin) => CryptoCoin.fromJson(coin))
              .toList();
        }
      }
      throw Exception('Failed to load crypto data');
    } catch (e) {
      throw Exception('Error fetching crypto data: $e');
    }
  }

  Future<List<CryptoCoin>> getCryptoLoserList({String currency = 'USD', int size = 0}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.cryptoLoserEndpoint}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          return (data['data'] as List)
              .map((coin) => CryptoCoin.fromJson(coin))
              .toList();
        }
      }
      throw Exception('Failed to load crypto loser data');
    } catch (e) {
      throw Exception('Error fetching crypto loser data: $e');
    }
  }
} 