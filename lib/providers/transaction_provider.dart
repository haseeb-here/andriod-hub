import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {

  final Box<TransactionModel> _box =
  Hive.box<TransactionModel>('transactions');

  List<TransactionModel> get transactions =>
      _box.values.toList();

  void addTransaction(TransactionModel transaction) {
    _box.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    _box.deleteAt(index);
    notifyListeners();
  }

  void updateTransaction(int index, TransactionModel transaction) {
    _box.putAt(index, transaction);
    notifyListeners();
  }

  double get totalIncome =>
      transactions
          .where((t) => t.type == "Income")
          .fold(0, (sum, item) => sum + item.amount);

  double get totalExpense =>
      transactions
          .where((t) => t.type == "Expense")
          .fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;
}