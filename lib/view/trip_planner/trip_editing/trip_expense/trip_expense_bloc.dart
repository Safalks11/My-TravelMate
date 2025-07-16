import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/firebase_helper/firebase_helper.dart';
import '../../../../model/expense_model.dart';

part 'trip_expense_event.dart';
part 'trip_expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();

      final expenses = await firebaseHelper.getExpense(event.tripId);
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError("Failed to load expenses: $e"));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<ExpenseState> emit) async {
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      await firebaseHelper.addExpense(event.tripId, event.expense);
      add(LoadExpenses(event.tripId)); // Refresh expenses
    } catch (e) {
      emit(ExpenseError("Failed to add expense: $e"));
    }
  }

  FutureOr<void> _onUpdateExpense(
      UpdateExpense event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());

    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      firebaseHelper.updateExpense(event.tripId, event.expense);
      add(LoadExpenses(event.tripId)); // Refresh expenses
    } catch (e) {
      emit(ExpenseError("Failed to update expense: $e"));
    }
  }

  FutureOr<void> _onDeleteExpense(
      DeleteExpense event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    try {
      final FirebaseHelper firebaseHelper = FirebaseHelper();
      firebaseHelper.deleteExpense(event.tripId, event.expenseId);
      add(LoadExpenses(event.tripId)); // Refresh expenses
    } catch (e) {
      emit(ExpenseError("Failed to delete expense: $e"));
    }
  }
}
