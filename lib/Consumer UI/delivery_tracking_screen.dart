import 'package:flutter/material.dart';
import 'package:vendor_mate/Consumer%20UI/payment_options_screen.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  final String partnerName;
  final String orderNumber;

  DeliveryTrackingScreen(
      {required this.partnerName, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Tracking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tracking Details for $partnerName',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Order Number: $orderNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            Text(
              'Order Status: In Transit',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Estimated Arrival: 30 minutes',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.access_time, color: Colors.blue),
                    title: Text('Order Received'),
                    subtitle: Text('10:00 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.orange),
                    title: Text('Order Ready to Ship'),
                    subtitle: Text('10:15 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_shipping, color: Colors.blue),
                    title: Text('In Transit'),
                    subtitle: Text('10:30 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.delivery_dining, color: Colors.blue),
                    title: Text('Out for Delivery'),
                    subtitle: Text('11:00 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Delivered'),
                    subtitle: Text('11:30 AM'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to payment options
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentOptionsScreen(), // Replace with your payment screen
                    ),
                  );
                },
                child: Text('Confirm Payment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
