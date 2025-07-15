import 'package:flutter/material.dart';
import '../services/coin_database.dart';
import 'wallet_chips_screen.dart';

class RemoveChipsScreen extends StatefulWidget {
  final PortfolioCoin coin;
  const RemoveChipsScreen({Key? key, required this.coin}) : super(key: key);

  @override
  State<RemoveChipsScreen> createState() => _RemoveChipsScreenState();
}

class _RemoveChipsScreenState extends State<RemoveChipsScreen> {
  String amount = '';
  bool _isRemoving = false;

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

  Future<void> _removeChips() async {
    setState(() => _isRemoving = true);
    // For demo: remove the coin entirely if any amount is entered
    await CoinDatabase.instance.removeCoin(widget.coin.id!);
    setState(() => _isRemoving = false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WalletChipsScreen()),
      );
    }
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
          'Remove chips',
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
                      widget.coin.symbol[0],
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
                        widget.coin.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.coin.symbol,
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
                      '\$${widget.coin.value.toStringAsFixed(3)}',
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
                        color: widget.coin.change >= 0
                            ? const Color(0x33008000)
                            : const Color(0x33FF0000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${widget.coin.change >= 0 ? '+' : ''}${widget.coin.change.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: widget.coin.change >= 0
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
                  'Please specify the amount you would like to less',
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
                    _buildNumberButton(','),
                    _buildNumberButton('0'),
                    _buildNumberButton('<'),
                  ],
                ),
              ],
            ),
          ),
          // Remove Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Opacity(
              opacity: amount.isEmpty || _isRemoving ? 0.5 : 1.0,
              child: GestureDetector(
                onTap: amount.isEmpty || _isRemoving ? null : _removeChips,
                child: Image.asset(
                  'assets/images/remove_button.png',
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