import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'StartPage.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.help,
                size: 100,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Categories Page",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.category),
            onTap: () {
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
          ListTile(
            title: Text(
              "Contact",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.contact_page),
            onTap: () {
// Navigator.pushNamed(
// context, ContactPage.id); // Navigate to the LoginPage
            },
          ),
          ListTile(
            title: Text(
              "Sign out",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.pushNamed(
                  context, Start.id); // Navigate to the LoginPage
            },
          ),
        ],
      ),
    );
  }
}
