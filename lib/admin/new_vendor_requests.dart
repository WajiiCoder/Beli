import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'drawer_widget.dart';

class NewVendorsRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Vendor Requests'),
      ),
      // drawer: DrawerWidget(),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 5, // Replace with actual number of vendor requests
        itemBuilder: (context, index) {
          return _buildVendorRequestCard(
            imageUrl: 'https://via.placeholder.com/150', // Placeholder image
            vendorName: 'Vendor Name $index',
            businessName: 'Business Name $index',
            vendorType: 'Daily Vendor', // Example: Change accordingly
            location: 'Location $index',
            contactNumber: '123-456-7890',
          );
        },
      ),
    );
  }

  Widget _buildVendorRequestCard({
    required String imageUrl,
    required String vendorName,
    required String businessName,
    required String vendorType,
    required String location,
    required String contactNumber,
  }) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      "https://franchisematch.com/wp-content/uploads/2015/02/john-doe.jpg"),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendorName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      businessName,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      vendorType,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Location: $location',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Contact: $contactNumber',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Approve vendor logic
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Reject vendor logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red,
                  ),
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
