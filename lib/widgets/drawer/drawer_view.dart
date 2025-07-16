import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:main_project/controller/firebase_helper/firebase_helper.dart';
import 'package:main_project/view/help_screen/help_screen.dart';
import 'package:main_project/view/home/home_screen.dart';

import '../logout_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          buildDrawerHeader(),
          Expanded(
            child: buildDrawerItems(context),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerHeader() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 275,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildUserAvatar(),
          buildSocialIcons(),
          buildUserInfo(),
        ],
      ),
    );
  }

  Widget buildUserAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade700,
      radius: 35,
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget buildSocialIcons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSocialIcon(FontAwesomeIcons.facebook, Colors.blue[900]!),
          buildSocialIcon(FontAwesomeIcons.instagram, Colors.pink),
          buildSocialIcon(FontAwesomeIcons.twitter, Colors.blueAccent),
          buildSocialIcon(FontAwesomeIcons.google, Colors.red),
        ],
      ),
    );
  }

  Widget buildSocialIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FaIcon(icon, color: color),
    );
  }

  Widget buildUserInfo() {
    final firebaseHelper = FirebaseHelper();
    final username = firebaseHelper.getUserName() ?? "Guest";
    final email = firebaseHelper.user?.email ?? "No email available";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            username,
            style:
                GoogleFonts.aBeeZee(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          email,
          style: GoogleFonts.aBeeZee(fontSize: 10),
        ),
      ],
    );
  }

  Widget buildDrawerItems(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.pink.shade50]),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        children: [
          SizedBox(height: 50),
          // buildListTile(Icons.dark_mode_outlined, "Change Theme",
          //     () => _showThemeDialog(context)),
          // buildSizedBox(15),
          // buildListTile(Icons.favorite, "Favourite", () {}),
          // buildSizedBox(15),
          buildListTile(Icons.home, "Home", () {
            Get.to(() => HomeScreen(index: 0));
          }),
          buildSizedBox(15),
          buildListTile(Icons.help, "Help & Support", () {
            Get.to(() => HelpScreen());
          }),
          buildSizedBox(15),
          buildListTile(Icons.settings, "Settings", () {}),
          buildSizedBox(15),
          buildListTile(Icons.add_reaction, "Invite a friend", () {}),
          buildSizedBox(15),
          buildListTile(Icons.logout, "Logout", () {
            showLogoutDialog(context, true);
          }),
        ],
      ),
    );
  }

  Widget buildListTile(IconData leadingIcon, String title, Function() onTap) {
    return ListTile(
      onTap: onTap,
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      leading: Icon(leadingIcon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 15),
    );
  }

  Widget buildSizedBox(double height) {
    return SizedBox(height: height);
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildElevatedButton("Dark Theme", () {
                Get.changeTheme(ThemeData.dark());
                Navigator.of(context).pop(); // Close the dialog
              }),
              buildElevatedButton("Light Theme", () {
                Get.changeTheme(ThemeData.light());
                Navigator.of(context).pop(); // Close the dialog
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
