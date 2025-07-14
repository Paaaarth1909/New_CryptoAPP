import 'package:flutter/material.dart';
import 'package:crypto_app/screens/wallet_chips_screen.dart';

class AddChipsScreen extends StatefulWidget {
  final String coinName;
  final String symbol;
  final double currentPrice;
  final double priceChangePercentage;

  const AddChipsScreen({
    super.key,
    required this.coinName,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage,
  });

  @override
  State<AddChipsScreen> createState() => _AddChipsScreenState();
}

class _AddChipsScreenState extends State<AddChipsScreen> {
  String amount = '';

  void _onNumberTap(String value) {
    setState(() {
      if (value == '<') {
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
        }
      } else if (amount.length < 10) {
        amount += value;
      }
    });
  }

  Widget _buildNumberButton(String text) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: TextButton(
          onPressed: () => _onNumberTap(text),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: text == '<'
              ? const Icon(Icons.backspace_outlined, color: Colors.white)
              : Text(text),
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
          'Add chips',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Coin Info Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB119),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.symbol[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coinName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.symbol,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.currentPrice.toStringAsFixed(3)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.priceChangePercentage >= 0
                            ? const Color(0x33008000)
                            : const Color(0x33FF0000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${widget.priceChangePercentage >= 0 ? '+' : ''}${widget.priceChangePercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: widget.priceChangePercentage >= 0
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Amount Input Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please specify the amount you would like to add',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFB3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    amount.isEmpty ? '0' : amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Number Pad
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                  ],
                ),
                Row(
                  children: [
                    _buildNumberButton('.'),
                    _buildNumberButton('0'),
                    _buildNumberButton('<'),
                  ],
                ),
              ],
            ),
          ),
          // Add Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Opacity(
              opacity: amount.isEmpty ? 0.5 : 1.0,
              child: GestureDetector(
                onTap: amount.isEmpty
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WalletChipsScreen(),
                          ),
                        );
                      },
                child: Image.asset(
                  'assets/images/add_button.png',
                  width: double.infinity,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
