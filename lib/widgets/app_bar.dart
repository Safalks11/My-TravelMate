import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final bool showDrawer;
  final bool isAdmin;
  final Widget? title;
  const CustomAppBar(
      {super.key,
      this.actions,
      this.showDrawer = false,
      this.title,
      this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: title,
        centerTitle: true,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: showDrawer == true
              ? IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.grid_view_outlined,
                    color: Colors.amber[700],
                  ),
                )
              : isAdmin == true
                  ? Icon(Icons.home_outlined)
                  : IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.amber[500]),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                      ),
                    ),
        ),
        actions: [if (actions != null) ...actions!, const SizedBox(width: 10)]);
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300, // Set the height you want for the notification container
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.notifications,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Notifications",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Close",
                              style: TextStyle(color: Colors.red)),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                            leading:
                                CircleAvatar(backgroundColor: Colors.blueGrey),
                            tileColor: Colors.grey,
                            title: Text("Notification 1"),
                            subtitle: Text("Content"),
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: 3),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
