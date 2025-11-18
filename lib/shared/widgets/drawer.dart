import 'package:correspondence_tracker/correspondences/screens/correspondences_page.dart';
import 'package:correspondence_tracker/departments/screens/departments_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (int index) {
        // Close the drawer first
        Navigator.of(context).pop();
        
        // Navigate to the selected page based on index
        switch (index) {
          case 0:
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CorrespondencesPage()),
            );
            break;
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DepartmentsPage()),
            );
            break;
        }
      },
      children: [
        // Header equivalent
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 20),
          child: Text(
            'منظومة متابعة الخطابات',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        // Navigation items - without GestureDetector wrappers
        NavigationDrawerDestination(
          label: const Text('الخطابات'),
          icon: const Icon(Icons.mail),
        ),
        NavigationDrawerDestination(
          label: const Text('الإدارات'),
          icon: const Icon(Icons.build),
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