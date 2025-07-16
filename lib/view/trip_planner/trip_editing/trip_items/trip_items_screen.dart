import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_project/view/trip_planner/trip_editing/trip_items/trip_items_bloc.dart';
import 'package:main_project/widgets/app_bar.dart';

import '../../../../model/items_model.dart';
import '../../../../widgets/section_title.dart';

class TripItemsScreen extends StatefulWidget {
  final String tripId;
  const TripItemsScreen({super.key, required this.tripId});

  @override
  State<TripItemsScreen> createState() => _TripItemsScreenState();
}

class _TripItemsScreenState extends State<TripItemsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TripItemsBloc>().add(LoadItems(widget.tripId));
  }

  void _showAddItemBottomSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blue.shade50,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
              const Text(
                "Add Packing Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "Notes (Optional)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(Colors.green)),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty) {
                        final newItem = ItemsModel(
                          itemName: nameController.text,
                          quantity: int.parse(quantityController.text),
                          notes: notesController.text,
                          packed: false,
                          id: '',
                        );

                        context
                            .read<TripItemsBloc>()
                            .add(AddItem(widget.tripId, newItem));
                        Navigator.pop(context);
                      }
                    },
                    label: const Text("Save"),
                    icon: Icon(Icons.check_circle),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemBottomSheet,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Item", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Packing List'),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<TripItemsBloc, TripItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ItemsLoaded) {
                    final items = state.items;
                    return items.isEmpty
                        ? const Center(
                            child: Text(
                              "No items added yet!",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: item.packed,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        context.read<TripItemsBloc>().add(
                                            UpdatePackedStatus(
                                                widget.tripId, item.id, value));
                                      }
                                    },
                                  ),
                                  title: Text(
                                    "${item.itemName} (x${item.quantity})",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: item.packed
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: item.notes.isNotEmpty
                                      ? Text(item.notes,
                                          style: const TextStyle(
                                              color: Colors.grey))
                                      : null,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Delete Item ?'),
                                                content: Text(
                                                    'Item will be removed from the list'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                TripItemsBloc>()
                                                            .add(DeleteItem(
                                                                widget.tripId,
                                                                item.id));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok')),
                                                ],
                                              ));
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                  } else if (state is ItemsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
