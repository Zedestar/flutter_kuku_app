import 'package:flutter/material.dart';
import 'package:kuku_app/widgets/app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: theAppBar(
        context,
        "My profile",
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Picture and Name
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "James Bondness",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Chip(
                    label:
                        Text("Free plan", style: TextStyle(color: Colors.blue)),
                    avatar: Icon(Icons.verified, color: Colors.blue, size: 18),
                    // backgroundColor: Colors.blue.shade50,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
              const Text(
                "Paris, France",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _StatBox(title: "24", subtitle: "Guides Created"),
              _StatBox(title: "343 KM", subtitle: "Distance Travelled"),
              _StatBox(title: "8", subtitle: "Trips Planned"),
            ],
          ),

          const SizedBox(height: 30),

          // Settings List
          const Divider(),
          _ProfileItem(icon: Icons.edit, text: "Edit profile"),
          _ProfileItem(icon: Icons.credit_card, text: "Billing"),
          _ProfileItem(icon: Icons.settings, text: "Settings"),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatBox({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
