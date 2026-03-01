import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import 'add_edit_transaction_screen.dart';
import 'summary_screen.dart';

class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState
    extends State<TransactionListScreen> {

  String searchQuery = "";
  String filterType = "All";
  String filterCategory = "All";

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<TransactionProvider>(context);

    List<TransactionModel> transactions =
    provider.transactions.where((t) {

      final matchesSearch =
      t.title.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesType =
          filterType == "All" || t.type == filterType;

      final matchesCategory =
          filterCategory == "All" || t.category == filterCategory;

      return matchesSearch && matchesType && matchesCategory;

    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("MyExpenseLite"),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SummaryScreen(),
                ),
              );
            },
          )
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add"),
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTransactionScreen(),
            ),
          );
        },
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔍 Search Field
            TextField(
              decoration: InputDecoration(
                hintText: "Search transactions...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            SizedBox(height: 12),

            // 🔽 Filter by Type
            DropdownButtonFormField<String>(
              value: filterType,
              decoration: InputDecoration(
                labelText: "Filter by Type",
              ),
              items: ["All", "Income", "Expense"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  filterType = value!;
                });
              },
            ),

            SizedBox(height: 12),

            // 🔽 Filter by Category
            DropdownButtonFormField<String>(
              value: filterCategory,
              decoration: InputDecoration(
                labelText: "Filter by Category",
              ),
              items: [
                "All",
                "Food",
                "Travel",
                "Bills",
                "Shopping",
                "Other"
              ]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  filterCategory = value!;
                });
              },
            ),

            SizedBox(height: 15),

            // 📋 Transaction List
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No Transactions Yet",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {

                  final transaction =
                  transactions[index];

                  return Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8),
                    child: Padding(
                      padding:
                      EdgeInsets.all(12),
                      child: Row(
                        children: [

                          // 💰 Icon
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                            transaction.type ==
                                "Income"
                                ? Colors
                                .green.shade100
                                : Colors
                                .red.shade100,
                            child: Icon(
                              transaction.type ==
                                  "Income"
                                  ? Icons
                                  .arrow_downward
                                  : Icons
                                  .arrow_upward,
                              color:
                              transaction.type ==
                                  "Income"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  transaction
                                      .title,
                                  style:
                                  TextStyle(
                                    fontSize:
                                    16,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                                SizedBox(
                                    height: 4),
                                Text(
                                  "${transaction.category} • ${transaction.date.toLocal().toString().split(' ')[0]}",
                                  style:
                                  TextStyle(
                                    color: Colors
                                        .grey
                                        .shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Text(
                                "Rs ${transaction.amount.toStringAsFixed(0)}",
                                style:
                                TextStyle(
                                  fontSize:
                                  15,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: transaction
                                      .type ==
                                      "Income"
                                      ? Colors
                                      .green
                                      : Colors
                                      .red,
                                ),
                              ),

                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                        Icons
                                            .edit,
                                        size:
                                        18),
                                    onPressed:
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                              AddEditTransactionScreen(
                                                transaction:
                                                transaction,
                                                index:
                                                index,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                        Icons
                                            .delete,
                                        size:
                                        18),
                                    onPressed:
                                        () {
                                      provider
                                          .deleteTransaction(
                                          index);
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}