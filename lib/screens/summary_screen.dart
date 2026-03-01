import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class SummaryScreen extends StatelessWidget {

  Widget buildSummaryCard(
      String title,
      double amount,
      Color color,
      IconData icon) {

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          "Rs ${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            buildSummaryCard(
                "Total Income",
                provider.totalIncome,
                Colors.green,
                Icons.arrow_downward),

            buildSummaryCard(
                "Total Expense",
                provider.totalExpense,
                Colors.red,
                Icons.arrow_upward),

            buildSummaryCard(
                "Balance",
                provider.balance,
                Colors.indigo,
                Icons.account_balance_wallet),
          ],
        ),
      ),
    );
  }
}