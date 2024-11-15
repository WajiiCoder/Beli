import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/Consumer%20UI/delivery_partner_selection_screen.dart';
import '../Consumer UI/order_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items with images
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Item 1',
      'quantity': 1,
      'price': 29.99,
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 2',
      'quantity': 2,
      'price': 15.49,
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 3',
      'quantity': 1,
      'price': 42.00,
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
  ];

  // Simulate service fee amount controlled from an admin panel
  final double serviceFees =
      5.00; // Example amount; replace with dynamic value if needed

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
      0.0,
      (previousValue, item) =>
          previousValue + (item['quantity'] * item['price']),
    );

    double deliveryFees = 10.0; // Fixed delivery fee
    double finalTotal = totalPrice + deliveryFees + serviceFees;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, size: 50);
                          },
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Quantity: ${item['quantity']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Text(
                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fees:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${deliveryFees.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Fees:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${serviceFees.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${finalTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    '* Delivery charges (if applicable) are extra and will be added during checkout.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      DateTime initialDate = now.add(Duration(hours: 2));

                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: now,
                        lastDate: now.add(Duration(days: 7)),
                      );

                      if (selectedDate != null) {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(initialDate),
                        );

                        if (selectedTime != null) {
                          DateTime pickupDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Pickup Scheduled'),
                                content: Text(
                                    'Your pickup is scheduled for ${DateFormat('yyyy-MM-dd – kk:mm').format(pickupDateTime)}.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Navigate to the next screen (Order Confirmation)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeliveryPartnerSelectionScreen(),
                                        ),
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.schedule),
                    label: Text('Schedule Home Delivery'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
