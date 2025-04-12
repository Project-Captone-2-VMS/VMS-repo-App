import 'package:flutter/material.dart';
import 'package:vms_app/features/wallet/data/models/transaction.dart';
import 'transaction_section.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final todayTransactions = [
      Transaction(
        icon: Icons.shopping_bag,
        iconColor: Colors.amber,
        title: 'Shopping',
        subtitle: 'Buy some grocery',
        amount: -120,
        time: '10:00 AM',
      ),
      Transaction(
        icon: Icons.subscriptions,
        iconColor: Colors.purple,
        title: 'Subscription',
        subtitle: 'Disney+ Annual',
        amount: -80,
        time: '03:30 PM',
      ),
      Transaction(
        icon: Icons.fastfood,
        iconColor: Colors.pink,
        title: 'Food',
        subtitle: 'Buy a ramen',
        amount: -32,
        time: '07:30 PM',
      ),
    ];

    final yesterdayTransactions = [
      Transaction(
        icon: Icons.account_balance_wallet,
        iconColor: Colors.green,
        title: 'Salary',
        subtitle: 'Salary for July',
        amount: 5000,
        time: '04:30 PM',
      ),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transaction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TransactionSection(title: 'Today', transactions: todayTransactions),
        const SizedBox(height: 16),
        TransactionSection(
          title: 'Yesterday',
          transactions: yesterdayTransactions,
        ),
      ],
    );
  }
}
