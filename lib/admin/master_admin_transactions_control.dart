import 'package:flutter/material.dart';

class MasterAdminTransactionScreen extends StatefulWidget {
  @override
  _MasterAdminTransactionScreenState createState() =>
      _MasterAdminTransactionScreenState();
}

class _MasterAdminTransactionScreenState
    extends State<MasterAdminTransactionScreen> {
  final List<Map<String, dynamic>> transactions = [
    {'date': '2024-08-25', 'vendor': 'Vendor A', 'amount': 1000},
    {'date': '2024-08-25', 'vendor': 'Vendor B', 'amount': 1500},
    {'date': '2024-08-24', 'vendor': 'Vendor A', 'amount': 2000},
    // Add more transactions here
  ];

  final List<Map<String, dynamic>> vendors = [
    {'name': 'Vendor A', 'fee': 5},
    {'name': 'Vendor B', 'fee': 10},
    // Add more vendors here
  ];

  String selectedVendor = 'Vendor A';
  TextEditingController feeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    feeController.text = vendors
        .firstWhere((vendor) => vendor['name'] == selectedVendor)['fee']
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Admin Transactions & Fees'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Transactions Overview
            Text(
              'Daily Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(transaction['vendor']),
                      subtitle: Text('Date: ${transaction['date']}'),
                      trailing: Text('Amount: \$${transaction['amount']}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Set Transaction Fees
            Text(
              'Set Transaction Fees',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedVendor,
              onChanged: (String? newValue) {
                setState(() {
                  selectedVendor = newValue!;
                  feeController.text = vendors
                      .firstWhere(
                          (vendor) => vendor['name'] == selectedVendor)['fee']
                      .toString();
                });
              },
              items: vendors.map<DropdownMenuItem<String>>((vendor) {
                return DropdownMenuItem<String>(
                  value: vendor['name'],
                  child: Text(vendor['name']),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: feeController,
              decoration: InputDecoration(
                labelText: 'Transaction Fee (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Handle fee change
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Update transaction fee
                final updatedFee = double.tryParse(feeController.text);
                if (updatedFee != null) {
                  setState(() {
                    vendors.firstWhere((vendor) =>
                        vendor['name'] == selectedVendor)['fee'] = updatedFee;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Transaction fee updated successfully for $selectedVendor'),
                    ),
                  );
                }
              },
              child: Text('Update Fee'),
            ),
          ],
        ),
      ),
    );
  }
}
