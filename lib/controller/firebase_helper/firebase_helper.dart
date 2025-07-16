import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:main_project/model/items_model.dart';

import '../../model/expense_model.dart';
import '../../model/note_model.dart';
import '../../model/places&hotels_model.dart';
import '../../model/trips_model.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/help_snackbar.dart';
import '../form_validation/form_validator.dart';

class FirebaseHelper {
  final _auth = FirebaseAuth.instance;
  final _databaseRef = FirebaseDatabase.instance.ref();
  User? get user => _auth.currentUser;

  // Register User
  Future<String?> register({
    required String regEmail,
    required String regPass,
    required String regUsername,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: regEmail, password: regPass);
      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(regUsername);
      }
      return null; // Registration successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "This email is already registered. Please log in or use a different email.";
      }
      return e.message;
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  // Login User
  Future<String?> login({
    required String loginEmail,
    required String loginPass,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: loginEmail, password: loginPass);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred.";
    }
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An unknown error occurred.");
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    // Use the custom form validator
    String? validationMessage = FormValidator.simpleEmailValidator(email);

    if (validationMessage != null) {
      showError(context, 'Invalid Email', validationMessage);
      return;
    }

    try {
      await FirebaseHelper().resetPassword(email);
      if (context.mounted) {
        showHelp(
          context,
          'Password Reset',
          'A password reset link has been sent to your email.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (context.mounted) {
        showError(context, 'Error', e.message ?? 'An unknown error occurred.');
      }
    } catch (error) {
      // Handle other errors
      if (context.mounted) {
        showError(context, 'Error', error.toString());
      }
    }
  }

  bool isSignedIn() {
    return user != null;
  }

  String? getUserName() {
    return user?.displayName;
  }

  Future<Map<String, dynamic>> fetchTripData() async {
    try {
      final tripsSnapshot = await _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .get();
      List<GetTrips> trips = [];
      // Handle trips data
      if (tripsSnapshot.exists && tripsSnapshot.value != null) {
        final tripsMap = tripsSnapshot.value as Map<dynamic, dynamic>;
        trips = tripsMap.entries.map((entry) {
          final tripData = Map<String, dynamic>.from(entry.value);
          return GetTrips.fromJson(tripData);
        }).toList();
      }

      return {'trips': trips};
    } catch (e) {
      print("Error fetching trip data: $e");
      return {'trips': []};
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final placesSnapshot = await _databaseRef.child('GetPlaces').get();
      final hotelsSnapshot = await _databaseRef.child('GetHotels').get();
      final tripsSnapshot = await _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .get();

      List<GetPlace> places = [];
      List<GetHotel> hotels = [];
      List<GetTrips> trips = [];

      if (placesSnapshot.exists && placesSnapshot.value != null) {
        if (placesSnapshot.value is List) {
          places = (placesSnapshot.value as List)
              .whereType<Map<dynamic, dynamic>>() // Ensure correct type
              .map((e) => GetPlace.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          print("Unexpected data format for GetPlaces");
        }
      }

      if (hotelsSnapshot.exists && hotelsSnapshot.value != null) {
        if (hotelsSnapshot.value is List) {
          hotels = (hotelsSnapshot.value as List)
              .whereType<Map<dynamic, dynamic>>() // Ensure correct type
              .map((e) => GetHotel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          print("Unexpected data format for GetHotels");
        }
      }
      // Handle trips data
      if (tripsSnapshot.exists && tripsSnapshot.value != null) {
        final tripsMap = tripsSnapshot.value as Map<dynamic, dynamic>;
        trips = tripsMap.entries.map((entry) {
          final tripData = Map<String, dynamic>.from(entry.value);
          return GetTrips.fromJson(tripData);
        }).toList();
      }

      return {'places': places, 'hotels': hotels, 'trips': trips};
    } catch (e, st) {
      print("Error fetching userdata: $e , $st");
      return {'places': [], 'hotels': [], 'trips': []};
    }
  }

  Future<void> addPlace(GetPlace place) async {}
  Future<void> addTrip(GetTrips trip) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference userTripsRef =
          _databaseRef.child('Users').child(user!.uid).child('Trips').push();

      await userTripsRef.set({
        'id': userTripsRef.key, // Assign the generated key as ID
        'dateRange': {
          'start': trip.dateRange?.start.toString(),
          'end': trip.dateRange?.end.toString(),
        },
        'place': trip.place,
        'travelType': trip.travelType,
        'peopleCount': trip.peopleCount,
        'budget': trip.budget,
        'tripStatus': 1, // Default to "Pending"
      });
    } catch (e) {
      print("Error adding trip: $e");
      throw Exception("Failed to add trip");
    }
  }

  Future<void> updateTrip(GetTrips trip) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }
      DatabaseReference tripRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(trip.id);
      await tripRef.update({
        'dateRange': {
          'start': trip.dateRange?.start.toIso8601String(),
          'end': trip.dateRange?.end.toIso8601String(),
        },
        'place': trip.place,
        'travelType': trip.travelType,
        'peopleCount': trip.peopleCount,
        'budget': trip.budget,
      });
    } catch (e) {
      print("Error updating trip: $e");
      throw Exception("Failed to update trip");
    }
  }

  Future<void> updateTripStatus(
      String tripId, DateTime endDate, int tripStatus) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }
      DatabaseReference tripRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId);
      final snapshot = await tripRef.get();
      if (!snapshot.exists) {
        throw Exception("Trip with ID $tripId does not exist");
      }

      final currentData = snapshot.value as Map<dynamic, dynamic>;
      final startDate = currentData['dateRange']?['start'] ?? null;

      await tripRef.update({
        'dateRange': {
          'start': startDate, // Preserve the existing `start` date
          'end': endDate.toString(), // Updated `end` date
        },
        'tripStatus': tripStatus,
      });
    } catch (e) {
      print("Error updating trip status: $e");
      throw Exception("Failed to update trip status");
    }
  }

  Future<void> addExpense(String tripId, Expense expense) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference expenseRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Expenses')
          .push();

      await expenseRef.set({
        'id': expenseRef.key, // Unique expense ID
        'category': expense.category,
        'amount': expense.amount,
        'notes': expense.notes,
        'timestamp': expense.timestamp.toIso8601String(),
      });
    } catch (e) {
      throw Exception("Failed to add expense: $e");
    }
  }

  Future<void> updateExpense(String tripId, Expense expense) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference expenseRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Expenses')
          .child(expense.id);

      await expenseRef.update({
        'amount': expense.amount,
        'notes': expense.notes,
        'category': expense.category,
        'timestamp': expense.timestamp.toIso8601String(),
      });
    } catch (e) {
      throw Exception("Failed to update expense: $e");
    }
  }

  Future<void> deleteExpense(String tripId, String expenseId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference expenseRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Expenses')
          .child(expenseId);

      await expenseRef.remove();
    } catch (e) {
      throw Exception("Failed to delete epense: $e");
    }
  }

  Future<void> addItem(String tripId, ItemsModel item) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference itemRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Items')
          .push();

      await itemRef.set({
        'id': itemRef.key, // Unique expense ID
        'itemName': item.itemName,
        'quantity': item.quantity,
        'notes': item.notes,
        'packed': item.packed,
      });
    } catch (e) {
      throw Exception("Failed to add item: $e");
    }
  }

  Future<void> addNote(String tripId, NoteModel note) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference noteRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Notes')
          .push();

      await noteRef.set({
        'id': noteRef.key, // Unique expense ID
        'title': note.title,
        'description': note.description,
        'date': note.date,
      });
    } catch (e) {
      throw Exception("Failed to add note: $e");
    }
  }

  Future<void> updateNote(String tripId, NoteModel note) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference noteRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Notes')
          .child(note.id);

      await noteRef.update({
        'title': note.title,
        'description': note.description,
        'date': note.date,
      });
    } catch (e) {
      throw Exception("Failed to update note: $e");
    }
  }

  Future<void> deleteNote(String tripId, String noteId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference noteRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Notes')
          .child(noteId);

      await noteRef.remove();
    } catch (e) {
      throw Exception("Failed to delete note: $e");
    }
  }

  Future<void> updatePackedStatus(
      String tripId, String itemId, bool packed) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference itemRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Items')
          .child(itemId);

      await itemRef.update({'packed': packed});
    } catch (e) {
      throw Exception("Failed to update packed status: $e");
    }
  }

  Future<void> deleteItem(String tripId, String itemId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference itemRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Items')
          .child(itemId);

      await itemRef.remove();
    } catch (e) {
      throw Exception("Failed to delete item: $e");
    }
  }

  Future<List<NoteModel>> getNotes(String tripId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference noteRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Notes');

      final snapshot = await noteRef.once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return data.entries.map((entry) {
          return NoteModel.fromMap(Map<String, dynamic>.from(entry.value));
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch notes: $e");
    }
  }

  Future<List<ItemsModel>> getItems(String tripId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference expenseRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Items');

      final snapshot = await expenseRef.once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return data.entries.map((entry) {
          return ItemsModel.fromMap(Map<String, dynamic>.from(entry.value));
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch items: $e");
    }
  }

  Future<List<Expense>> getExpense(String tripId) async {
    try {
      if (user == null) {
        throw Exception("User not authenticated");
      }

      DatabaseReference expenseRef = _databaseRef
          .child('Users')
          .child(user!.uid)
          .child('Trips')
          .child(tripId)
          .child('Expenses');

      final snapshot = await expenseRef.once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return data.entries.map((entry) {
          return Expense.fromMap(Map<String, dynamic>.from(entry.value));
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch expenses: $e");
    }
  }
}
