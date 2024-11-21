import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserRole(),
    );
  }
}

class UserRole extends StatelessWidget {
  const UserRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Role'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.lightGreen, Colors.cyan], // Gradient colors for AppBar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        // Full background gradient color mix for the body
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.lightGreen, Colors.cyan], // Gradient colors for the body
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center( // Wrap the Column in a Center widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the Column vertically
              children: [
                // Admin Role Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: Colors.blue),
                    title: Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text('Has full access to all features'),
                    onTap: () {
                      // Navigate to Admin Features screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminFeaturesScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),

                // User Role Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.green),
                    title: Text(
                      'User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    subtitle: Text('Has limited access to their branch'),
                    onTap: () {
                      // Navigate to User Features screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserFeaturesScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class AdminFeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Features'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent, Colors.yellowAccent], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen, Colors.lightGreenAccent, Colors.yellowAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFeatureCard(
                    context,
                    'User Management',
                    'Create, Edit, Delete Users, Assign Roles & Permissions',
                    Icons.manage_accounts
                ),
                _buildFeatureCard(
                    context,
                    'Product Management',
                    'Add, Edit, Delete Products, Manage Categories, Stock',
                    Icons.shopping_cart
                ),
                _buildFeatureCard(
                    context,
                    'Sales & Order Management',
                    'View All Sales, Create Sales Orders, Manage Discounts',
                    Icons.receipt
                ),
                _buildFeatureCard(
                    context,
                    'Branch Management',
                    'Add, Manage Branches, View Branch-Specific Sales',
                    Icons.business
                ),
                _buildFeatureCard(
                    context,
                    'Supplier Management',
                    'Create and Manage Suppliers, Manage Supplier Payments',
                    Icons.local_shipping
                ),
                _buildFeatureCard(
                    context,
                    'Reporting and Analytics',
                    'View Sales Reports, Export Financial Reports',
                    Icons.bar_chart
                ),
                _buildFeatureCard(
                    context,
                    'System Configuration & Settings',
                    'Configure Payment Methods, Tax Rates, System Integrations',
                    Icons.settings
                ),
                _buildFeatureCard(
                    context,
                    'Access Control',
                    'Assign Permissions, Configure Security Settings',
                    Icons.security
                ),
                _buildFeatureCard(
                    context,
                    'Audit and Log Management',
                    'Access Audit Logs, Track User Activities',
                    Icons.history
                ),
                _buildFeatureCard(
                    context,
                    'Customer Management',
                    'View Customer Data, Manage Loyalty Programs',
                    Icons.people
                ),
                _buildFeatureCard(
                    context,
                    'Inventory Management',
                    'Track and Update Inventory, Perform Audits',
                    Icons.inventory
                ),
                _buildFeatureCard(
                    context,
                    'System Maintenance',
                    'Database Backup, System Updates',
                    Icons.build
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        subtitle: Text(description),
        onTap: () {
          // Implement navigation or action based on the feature tapped
          print('$title tapped');
        },
      ),
    );
  }
}



class UserFeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Features'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent, Colors.yellowAccent], // Gradient colors for the AppBar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        // Full background gradient color mix
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen, Colors.green, Colors.yellowAccent], // Gradient colors for the body
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center( // Wrap the Column inside Center widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the cards vertically
                children: [
                  _buildFeatureCard(
                      context,
                      'Create Sales Orders',
                      'Create sales for your branch',
                      Icons.add_shopping_cart
                  ),
                  _buildFeatureCard(
                      context,
                      'Manage Branch Stock',
                      'View stock for your branch',
                      Icons.inventory
                  ),
                  _buildFeatureCard(
                      context,
                      'View Sales Reports',
                      'View sales reports',
                      Icons.bar_chart
                  ),
                  _buildFeatureCard(
                      context,
                      'Customer Management',
                      'Manage customers in your branch',
                      Icons.people
                  ),
                  _buildFeatureCard(
                      context,
                      'Inventory Management',
                      'Track inventory in your branch',
                      Icons.inventory_2
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        subtitle: Text(description),
        onTap: () {
          // Implement navigation or action based on the feature tapped
          print('$title tapped');
        },
      ),
    );
  }
}
