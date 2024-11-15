import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/Consumer%20UI/subscriptions_management_screen.dart';
import 'package:vendor_mate/admin/feedback_support.dart';
import 'package:vendor_mate/admin/master_admin_control_screen.dart';
import 'package:vendor_mate/admin/master_admin_subscription_controls_screen.dart';
import 'package:vendor_mate/admin/master_admin_transactions_control.dart';
import 'package:vendor_mate/admin/new_vendor_requests.dart';
import 'package:vendor_mate/main_selection.dart';
import 'package:vendor_mate/screens/daily_vendor.dart';
import 'package:vendor_mate/screens/welcome_screen.dart';

import 'order_tracking_admin.dart';
import 'users_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.pending_actions),
            title: Text('New Vendor Requests'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewVendorsRequestScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Control Transactions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasterAdminTransactionScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Manage Users and Vendors'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasterAdminControlsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit SubVendors'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSubvendorScreen(
                        subvendor: {"user": "A"}, skus: ['A', 'B']),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Daily Transactions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionManagementScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.subscriptions),
            title: Text('Monthly  Subscriptions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionPaymentsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Vendors'),
            onTap: () {
              Navigator.pushNamed(context, '/vendors');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.track_changes),
            title: Text('Order Tracking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderTrackingScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Financial Reports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FeedbackAndSupportScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Main Page'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainSelectionScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
