import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/Consumer%20UI/order_confirmation_screen.dart';
import '../Consumer UI/delivery_tracking_screen.dart'; // Ensure this path is correct

class DeliveryPartnerSelectionScreen extends StatefulWidget {
  @override
  _DeliveryPartnerSelectionScreenState createState() =>
      _DeliveryPartnerSelectionScreenState();
}

class _DeliveryPartnerSelectionScreenState
    extends State<DeliveryPartnerSelectionScreen> {
  String? _selectedPartner;
  String? _orderNumber = '123456'; // Example order number
  bool _isBulkOrder = false; // Track bulk order state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Partner'),
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
          children: [
            if (_isBulkOrder) _buildBulkOrderBanner(),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final partners = [
                    {
                      'name': 'Partner A',
                      'price': '\$5.99',
                      'eta': '30-45 min'
                    },
                    {
                      'name': 'Partner B',
                      'price': '\$4.99',
                      'eta': '20-30 min'
                    },
                    {
                      'name': 'Partner C',
                      'price': '\$6.49',
                      'eta': '40-50 min'
                    },
                  ];
                  final partner = partners[index];
                  return DeliveryPartnerCard(
                    name: partner['name']!,
                    price: partner['price']!,
                    eta: partner['eta']!,
                    isSelected: _selectedPartner == partner['name'],
                    onTap: () {
                      setState(() {
                        _selectedPartner = partner['name'];
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            minimumSize: Size(100, 56), // Adjust the size as needed
          ),
          onPressed: _selectedPartner == null
              ? null
              : () {
                  if (_isBulkOrder) {
                    _notifyBulkOrder();
                  } else {
                    _navigateToOrderConfirmationScreen();
                  }
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: 24),
              SizedBox(width: 8),
              Text('Confirm', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulkOrderBanner() {
    return Container(
      color: Colors.yellow[100],
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.warning, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This is a bulk order. Additional charges will apply.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderConfirmationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderConfirmationScreen()),
    );

    // Reset the bulk order state based on result if needed
    if (result != null && result['resetBulkOrder'] == true) {
      setState(() {
        _isBulkOrder = false;
      });
    }
  }

  void _notifyBulkOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Order Notice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This is a bulk order. Additional charges will apply.'),
            SizedBox(height: 16),
            Text(
              'Additional Charges: \$10.00', // Example charge
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Please confirm to proceed with the updated charges.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToOrderConfirmationScreen(); // Proceed to the tracking screen after dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class DeliveryPartnerCard extends StatelessWidget {
  final String name;
  final String price;
  final String eta;
  final bool isSelected;
  final VoidCallback onTap;

  DeliveryPartnerCard({
    required this.name,
    required this.price,
    required this.eta,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          Icons.local_shipping, // Placeholder icon
          color: isSelected ? AppTheme.blue : Colors.grey[700],
          size: 40,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.blue : Colors.black,
          ),
        ),
        subtitle: Text(
          'Price: $price\nETA: $eta',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: AppTheme.blue, size: 30)
            : null,
        onTap: onTap,
      ),
    );
  }
}
