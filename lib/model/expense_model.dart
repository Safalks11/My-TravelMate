class Expense {
  final String id;
  final String category;
  final double amount;
  final String notes;
  final DateTime timestamp;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.notes,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      category: map['category'],
      amount: (map['amount'] as num).toDouble(),
      notes: map['notes'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
