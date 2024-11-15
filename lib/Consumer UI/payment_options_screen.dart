import 'package:flutter/material.dart';

class PaymentOptionsScreen extends StatefulWidget {
  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  final double _processingFee = 2.5; // Example fee percentage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
        elevation: 4,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            Text(
              'Choose Payment Method',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),

            // Payment Method Tiles
            PaymentMethodTile(
              title: 'Credit Card',
              icon: Icons.credit_card,
              isSelected: _selectedPaymentMethod == 'Credit Card',
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = 'Credit Card';
                });
              },
            ),
            PaymentMethodTile(
              title: 'UPI',
              icon: Icons.payment,
              isSelected: _selectedPaymentMethod == 'UPI',
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = 'UPI';
                });
              },
            ),

            SizedBox(height: 24),

            // Processing Fee Information
            Text(
              'Processing Fee:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'A processing fee of \$${_processingFee.toStringAsFixed(2)} will be applied for prepaid orders. The fee will be routed to a specified account, and the remaining amount will go to the vendor.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red, // Use for emphasis
                  ),
            ),

            SizedBox(height: 24),

            // Proceed Button
            ElevatedButton(
              onPressed: () {
                _submitPayment();
                Navigator.pushNamed(context, '/consumer_home');
              },
              child: Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPayment() {
    // Handle the payment submission
    print('Payment method: $_selectedPaymentMethod');
    // Example implementation
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  PaymentMethodTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: 32,
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[600],
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary)
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
