import 'package:flutter/material.dart';
import '../widgets/account_header.dart';
import '../widgets/balance_cards.dart';
import '../widgets/add_expense_button.dart';
import '../widgets/spend_frequency_chart.dart';
import '../widgets/transaction_list.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AccountHeader(month: 'October'),
                const SizedBox(height: 16),
                const Text(
                  'Account Balance',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹6200',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const BalanceCards(),
                const SizedBox(height: 16),
                const AddExpenseButton(),
                const SizedBox(height: 24),
                const SpendFrequencyChart(),
                const SizedBox(height: 24),
                const TransactionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
