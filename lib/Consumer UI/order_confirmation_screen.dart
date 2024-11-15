import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';

class OrderConfirmationScreen extends StatefulWidget {
  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedDeliveryOption;

  final List<String> deliveryOptions = [
    'Standard Delivery',
    'Express Delivery'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submitOrder() {
    if (selectedDeliveryOption != null) {
      // Send order data to server
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Order Placed'),
          content: Text('Your order has been placed successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/orderManagement'),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incomplete'),
          content: Text('Please select a delivery option.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Your Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select Pickup Date (Optional)'),
              subtitle: Text(selectedDate != null
                  ? "${selectedDate!.toLocal()}".split(' ')[0]
                  : 'No date selected'),
              trailing: Icon(
                Icons.calendar_today,
                color: AppTheme.blue,
              ),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Select Pickup Time (Optional)'),
              subtitle: Text(selectedTime != null
                  ? selectedTime!.format(context)
                  : 'No time selected'),
              trailing: Icon(
                Icons.access_time,
                color: AppTheme.blue,
              ),
              onTap: () => _selectTime(context),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Delivery Option'),
              items: deliveryOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDeliveryOption = value;
                });
              },
              value: selectedDeliveryOption,
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
