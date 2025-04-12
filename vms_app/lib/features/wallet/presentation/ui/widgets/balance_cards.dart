import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: BalanceCard(
            title: 'Income',
            amount: '₹5000',
            icon: Icons.account_balance_wallet,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: BalanceCard(
            title: 'Expenses',
            amount: '₹1200',
            icon: Icons.account_balance_wallet,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
