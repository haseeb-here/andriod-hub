import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddEditTransactionScreen extends StatefulWidget {

  final TransactionModel? transaction;
  final int? index;

  AddEditTransactionScreen({this.transaction, this.index});

  @override
  _AddEditTransactionScreenState createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends State<AddEditTransactionScreen> {

  final _formKey = GlobalKey<FormState>();

  String title = "";
  double amount = 0;
  String type = "Income";
  String category = "Food";
  DateTime selectedDate = DateTime.now();
  String notes = "";

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      title = widget.transaction!.title;
      amount = widget.transaction!.amount;
      type = widget.transaction!.type;
      category = widget.transaction!.category;
      selectedDate = widget.transaction!.date;
      notes = widget.transaction!.notes ?? "";
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? "Add Transaction"
            : "Edit Transaction"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                initialValue: title,
                decoration:
                InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Required";
                  return null;
                },
                onSaved: (value) => title = value!,
              ),

              TextFormField(
                initialValue:
                amount == 0 ? "" : amount.toString(),
                decoration:
                InputDecoration(labelText: "Amount"),
                keyboardType:
                TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0)
                    return "Enter valid amount";
                  return null;
                },
                onSaved: (value) =>
                amount = double.parse(value!),
              ),

              DropdownButtonFormField(
                value: type,
                items: ["Income", "Expense"]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => type = value!),
              ),

              DropdownButtonFormField(
                value: category,
                items: [
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
                onChanged: (value) =>
                    setState(() => category = value!),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Text(
                      "Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                  Spacer(),
                  TextButton(
                    onPressed: pickDate,
                    child: Text("Select Date"),
                  )
                ],
              ),

              TextFormField(
                initialValue: notes,
                decoration:
                InputDecoration(labelText: "Notes"),
                onSaved: (value) =>
                notes = value ?? "",
              ),

              SizedBox(height: 20),

              ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newTransaction =
                    TransactionModel(
                      title: title,
                      amount: amount,
                      type: type,
                      category: category,
                      date: selectedDate,
                      notes: notes,
                    );

                    if (widget.transaction == null) {
                      provider
                          .addTransaction(newTransaction);
                    } else {
                      provider.updateTransaction(
                          widget.index!,
                          newTransaction);
                    }

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}