import 'package:flutter/material.dart';
import 'package:vms_app/features/wallet/data/models/transaction.dart';
import 'transaction_item.dart';

class TransactionSection extends StatelessWidget {
  final String title;
  final List<Transaction> transactions;

  const TransactionSection({
    super.key,
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...transactions
            .map((transaction) => TransactionItem(transaction: transaction))
            .toList(),
      ],
    );
  }
}
