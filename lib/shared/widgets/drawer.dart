import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        // Header equivalent
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 20),
          child: Text(
            'Drawer Header',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        
        // Navigation items
        NavigationDrawerDestination(
          label: Text('Item 1'),
          icon: Icon(Icons.circle_outlined),
        ),
        NavigationDrawerDestination(
          label: Text('Item 2'),
          icon: Icon(Icons.circle_outlined),
        ),
        
        // Divider for separation (optional)
        const Divider(indent: 28, endIndent: 28),
        
        // You can add more sections if needed
        /*
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 8),
          child: Text(
            'Other Section',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        NavigationDrawerDestination(
          label: Text('Item 3'),
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
        ),
        */
      ],
    );
  }
}