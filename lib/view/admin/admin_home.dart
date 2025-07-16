import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_project/view/admin/hotels/add_hotels_screen.dart';
import 'package:main_project/view/admin/hotels/view_hotels_screen.dart';
import 'package:main_project/view/admin/places/add_places_screen.dart';
import 'package:main_project/view/admin/places/view_places_screen.dart';
import 'package:main_project/widgets/app_bar.dart';

import '../../widgets/logout_dialog.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isAdmin: true,
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => showLogoutDialog(context, false),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final List<Map<String, dynamic>> options = [
              {
                'icon': Icons.place,
                'label': 'View Places',
                'onTap': () => Get.to(() => const ViewPlacesScreen())
              },
              {
                'icon': Icons.add_location_alt,
                'label': 'Add Places',
                'onTap': () => Get.to(() => const AddPlacesScreen())
              },
              {
                'icon': Icons.hotel,
                'label': 'View Hotels',
                'onTap': () => Get.to(() => const ViewHotelsScreen())
              },
              {
                'icon': Icons.add_business,
                'label': 'Add Hotels',
                'onTap': () => Get.to(() => const AddHotelsScreen())
              },
            ];

            return _buildOptionCard(
              icon: options[index]['icon'],
              label: options[index]['label'],
              onTap: options[index]['onTap'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
