import 'package:flutter/material.dart';

class ChipItem {
  final String coinName;
  final String symbol;
  final double amount;
  final double price;
  final double priceChangePercentage;

  ChipItem({
    required this.coinName,
    required this.symbol,
    required this.amount,
    required this.price,
    required this.priceChangePercentage,
  });
}

class WalletChipsScreen extends StatefulWidget {
  const WalletChipsScreen({super.key});

  @override
  State<WalletChipsScreen> createState() => _WalletChipsScreenState();
}

class _WalletChipsScreenState extends State<WalletChipsScreen> {
  // Temporary list of chips for demonstration
  final List<ChipItem> _chips = [
    ChipItem(
      coinName: 'Bitcoin',
      symbol: 'BTC',
      amount: 0.5,
      price: 853134.900,
      priceChangePercentage: 10.2,
    ),
  ];

  void _deleteChip(int index) {
    setState(() {
      _chips.removeAt(index);
    });
  }


  Widget _buildChipItem(ChipItem chip, int index) {
    return Dismissible(
      key: Key(chip.symbol + index.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete action
          _deleteChip(index);
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          // Add action
          // TODO: Implement add action
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
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB119),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                chip.symbol[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            chip.coinName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            chip.symbol,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${chip.price.toStringAsFixed(3)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: chip.priceChangePercentage >= 0
                      ? const Color(0x33008000)
                      : const Color(0x33FF0000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${chip.priceChangePercentage >= 0 ? '+' : ''}${chip.priceChangePercentage}%',
                  style: TextStyle(
                    color: chip.priceChangePercentage >= 0
                        ? Colors.green
                        : Colors.red,
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
        child: _chips.isEmpty
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
                itemCount: _chips.length,
                itemBuilder: (context, index) => _buildChipItem(_chips[index], index),
              ),
      ),
    );
  }
} 