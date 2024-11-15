import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/admin/drawer_widget.dart';

class OrderTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderCard(
              ticketNo: '12345',
              orderDate: '2024-08-15',
              orderReceiveDate: '2024-08-16',
              status: 'Pending',
              productName: 'Nike Shoes',
              price: '\$29.99',
              businessName: 'Bata Store',
              vendorName: 'John Doe',
              deliveryLocation: '123 Pizza St, NY',
              productImageUrl:
                  'https://dxkvlfvncvqr8.cloudfront.net/media/images/cms-banner/image_path/sparx-featured-product-thumb-1708604035.png',
            ),
            SizedBox(height: 16.0),
            _buildOrderCard(
              ticketNo: '12346',
              orderDate: '2024-08-14',
              orderReceiveDate: '2024-08-15',
              status: 'Ready to Pick',
              productName: 'Sushi Roll',
              price: '\$19.99',
              businessName: 'Sushi Spot',
              vendorName: 'Jane Smith',
              deliveryLocation: '456 Sushi Ave, NY',
              productImageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp4wdXw7Gi1HNQDJNxAcnsxlcXnIKhZai_gg&s',
            ),
            SizedBox(height: 16.0),
            _buildOrderCard(
              ticketNo: '12347',
              orderDate: '2024-08-13',
              orderReceiveDate: '2024-08-14',
              status: 'Delivered',
              productName: 'Burger Combo',
              price: '\$24.99',
              businessName: 'Burger Joint',
              vendorName: 'Mike Johnson',
              deliveryLocation: '789 Burger Blvd, NY',
              productImageUrl:
                  'https://i.ytimg.com/vi/OYGNn1n651o/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAaJ4f7Myr5AyoreNEi79IO7lQZCg',
            ),
            // Add more order cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String ticketNo,
    required String orderDate,
    required String orderReceiveDate,
    required String status,
    required String productName,
    required String price,
    required String businessName,
    required String vendorName,
    required String deliveryLocation,
    required String productImageUrl,
  }) {
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Ready to Pick':
        statusColor = AppTheme.blue;
        break;
      case 'Delivered':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    productImageUrl,
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ticket No: $ticketNo',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Price: $price',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Business: $businessName',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Vendor: $vendorName',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Location: $deliveryLocation',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            _buildOrderDetail(
              label: 'Order Date',
              value: orderDate,
            ),
            _buildOrderDetail(
              label: 'Received Date',
              value: orderReceiveDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail({
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
