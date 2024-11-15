import 'package:flutter/material.dart';

class VendorManagementScreen extends StatefulWidget {
  @override
  State<VendorManagementScreen> createState() => _VendorManagementScreenState();
}

class _VendorManagementScreenState extends State<VendorManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildVendorApprovalSection(),
          SizedBox(height: 16),
          _buildBlacklistVendorsSection(),
          SizedBox(height: 16),
          _buildInventoryManagementSection(),
        ],
      ),
    );
  }

  Widget _buildVendorApprovalSection() {
    return _buildSectionCard(
      title: 'Approve/Reject Vendor Registrations',
      onTap: () {},
    );
  }

  Widget _buildBlacklistVendorsSection() {
    return _buildSectionCard(
      title: 'Blacklist Vendors',
      onTap: () {},
    );
  }

  Widget _buildInventoryManagementSection() {
    return _buildSectionCard(
      title: 'Inventory Management',
      onTap: () {},
    );
  }

  Widget _buildSectionCard(
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
