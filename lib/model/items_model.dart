class ItemsModel {
  final String id;
  final String itemName;
  final int quantity;
  final String notes;
  final bool packed;

  ItemsModel({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.notes,
    required this.packed,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'notes': notes,
      'packed': packed
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      id: map['id'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      notes: map['notes'],
      packed: map['packed'],
    );
  }
}
