import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_expense/trip_expense_bloc.dart';

import '../../../../model/expense_model.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/section_title.dart';

class TripExpensesScreen extends StatefulWidget {
  final String tripId;

  const TripExpensesScreen({super.key, required this.tripId});

  @override
  State<TripExpensesScreen> createState() => _TripExpensesScreenState();
}

class _TripExpensesScreenState extends State<TripExpensesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses(widget.tripId));
  }

  final Map<String, IconData> categoryIcons = {
    "Food": Icons.local_dining,
    "Transport": Icons.directions_car,
    "Hotel": Icons.hotel,
    "Shopping": Icons.shopping_bag,
    "Activities": Icons.local_activity,
    "Fuel": Icons.local_gas_station,
    "Others": Icons.miscellaneous_services,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseSheet,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Expense", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Expenses'),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ExpenseLoaded) {
                    double totalExpense = state.expenses
                        .fold(0.0, (sum, expense) => sum + expense.amount);

                    if (state.expenses.isEmpty) {
                      return const Center(
                          child: Text(
                        "No expenses added yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ));
                    }

                    // Grouping expenses by category
                    Map<String, List<Expense>> categorizedExpenses = {};
                    for (var expense in state.expenses) {
                      categorizedExpenses.putIfAbsent(
                          expense.category, () => []);
                      categorizedExpenses[expense.category]!.add(expense);
                    }

                    return Column(
                      children: [
                        Card(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Expense",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "Rs. ${totalExpense.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView(
                            children: categorizedExpenses.entries.map((entry) {
                              final category = entry.key;
                              final expenses = entry.value;
                              final totalCategoryExpense = expenses.fold(
                                  0.0, (sum, e) => sum + e.amount);

                              return ExpenseCategory(
                                category: category,
                                expenses: expenses,
                                icon: categoryIcons[category] ??
                                    Icons.miscellaneous_services,
                                totalExpense: totalCategoryExpense,
                                onEditExpense: (expense) {
                                  _showAddExpenseSheet(expense: expense);
                                },
                                tripId: widget.tripId,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  } else if (state is ExpenseError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No expenses added yet"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseSheet({Expense? expense}) {
    final TextEditingController amountController = TextEditingController(
        text: expense != null ? expense.amount.toString() : '');
    final TextEditingController notesController =
        TextEditingController(text: expense?.notes ?? '');
    String? selectedCategory = expense?.category;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blue.shade50,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                expense == null ? "Add Expense" : "Edit Expense",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: selectedCategory,
                items: categoryIcons.keys.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value;
                },
              ),
              const SizedBox(height: 10),

              // Amount Input
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Notes Input
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "Notes (Optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(
                          expense == null ? Colors.green : Colors.orange),
                    ),
                    onPressed: () {
                      if (selectedCategory != null &&
                          amountController.text.isNotEmpty) {
                        final updatedExpense = Expense(
                          id: expense?.id ?? '',
                          category: selectedCategory!,
                          amount: double.parse(amountController.text),
                          notes: notesController.text,
                          timestamp: DateTime.now(),
                        );

                        if (expense == null) {
                          context
                              .read<ExpenseBloc>()
                              .add(AddExpense(widget.tripId, updatedExpense));
                        } else {
                          context.read<ExpenseBloc>().add(
                              UpdateExpense(widget.tripId, updatedExpense));
                        }

                        Navigator.pop(context);
                      }
                    },
                    label: Text(expense == null ? "Save" : "Update"),
                    icon:
                        Icon(expense == null ? Icons.check_circle : Icons.edit),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpenseCategory extends StatefulWidget {
  final String category;
  final List<Expense> expenses;
  final IconData icon;
  final double totalExpense;
  final String tripId;
  final void Function(Expense) onEditExpense;

  const ExpenseCategory({
    super.key,
    required this.category,
    required this.expenses,
    required this.icon,
    required this.totalExpense,
    required this.onEditExpense,
    required this.tripId,
  });

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              child: Icon(widget.icon, color: Colors.blueAccent),
            ),
            title: Text(
              widget.category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Total: Rs. ${widget.totalExpense.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Column(
              children: widget.expenses.map((expense) {
                return ListTile(
                  title: Text("Rs. ${expense.amount.toStringAsFixed(2)}"),
                  subtitle: Text(expense.notes),
                  leading:
                      const Icon(Icons.monetization_on, color: Colors.green),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.outlined(
                          onPressed: () {
                            widget.onEditExpense(expense);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                      IconButton.outlined(
                          onPressed: () {
                            context
                                .read<ExpenseBloc>()
                                .add(DeleteExpense(expense.id, widget.tripId));
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
