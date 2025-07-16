part of 'trip_expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {
  final String tripId;

  LoadExpenses(this.tripId);
}

class AddExpense extends ExpenseEvent {
  final String tripId;
  final Expense expense;

  AddExpense(this.tripId, this.expense);
}

class UpdateExpense extends ExpenseEvent {
  final String tripId;
  final Expense expense;
  UpdateExpense(this.tripId, this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String tripId;
  final String expenseId;

  DeleteExpense(this.expenseId, this.tripId);
}
