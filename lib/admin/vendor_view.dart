import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/admin/vendor_inventory_screen.dart';
import 'drawer_widget.dart';

class VendorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendors'),
      ),
      // drawer: DrawerWidget(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Unblocked Vendors'),
            SizedBox(height: 16.0),
            _buildVendorList(isBlocked: false),
            SizedBox(height: 32.0),
            _buildSectionTitle('Blocked Vendors'),
            SizedBox(height: 16.0),
            _buildVendorList(isBlocked: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildVendorList({required bool isBlocked}) {
    // Placeholder data for vendors, replace with actual data
    List<Map<String, dynamic>> vendors = [
      {
        "vendorName": 'John Doe',
        "businessName": 'John\'s Liquor Store',
        "vendorType": 'Liquor Vendor',
        "rating": 4.7,
        "location": 'New York, NY',
        "contactNumber": '(123) 456-7890',
        "isBlocked": false,
        "imageUrl":
            'https://franchisematch.com/wp-content/uploads/2015/02/john-doe.jpg',
      },
      {
        "vendorName": 'Vendor B',
        "businessName": 'Business B',
        "vendorType": 'Store Vendor',
        "rating": 3.8,
        "location": 'Los Angeles, CA',
        "contactNumber": '(987) 654-3210',
        "isBlocked": true,
        "imageUrl":
            'https://franchisematch.com/wp-content/uploads/2015/02/john-doe.jpg',
      },
      // Add more vendors as needed
    ];

    List<Map<String, dynamic>> filteredVendors =
        vendors.where((vendor) => vendor['isBlocked'] == isBlocked).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredVendors.length,
      itemBuilder: (context, index) {
        final vendor = filteredVendors[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorInventoryScreen(),
              ),
            );
          },
          child: _buildVendorCard(vendor),
        );
      },
    );
  }

  Widget _buildVendorCard(Map<String, dynamic> vendor) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    vendor['imageUrl'],
                    height: 60.0,
                    width: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor['vendorName'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        vendor['businessName'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        vendor['vendorType'],
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Location: ${vendor['location']}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.red, size: 20.0),
                    SizedBox(width: 4.0),
                    Text(
                      vendor['rating'].toString(),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Contact: ${vendor['contactNumber']}',
              style: TextStyle(fontSize: 14.0, color: AppTheme.blue),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Block/Unblock vendor logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        vendor['isBlocked'] ? Colors.green : AppTheme.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(vendor['isBlocked'] ? 'Unblock' : 'Block'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
