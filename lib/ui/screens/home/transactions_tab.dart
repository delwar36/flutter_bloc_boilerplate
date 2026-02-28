import 'package:flutter/material.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.payment,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Payment to Merchant",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Feb ${28 - index}, 2026",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "-\$50.00",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
