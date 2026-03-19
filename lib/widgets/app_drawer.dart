import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/login_screen.dart';
import '../screens/profile.dart';

class AppDrawer extends StatelessWidget {

  final String name;
  final String email;
  AppDrawer({Key? key, required this.name, required this.email}) : super(key: key);

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _contactUs() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+1234567890');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: TextStyle(fontSize: 40.0, color: Colors.blue[800]),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[600],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Home', style: TextStyle(fontSize: 16)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading:Icon(Icons.book_online, color: Colors.blue),
            title: const Text('My Bookings', style: TextStyle(fontSize: 16)),
            onTap: () {}, // Future implementation
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text('Profile', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(name: widget.name, email: widget.email),
                ),
              );
            }, // Future implementation
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone, color: Colors.blue),
            title: const Text('Contact Us', style: TextStyle(fontSize: 16)),
            onTap: _contactUs,
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}