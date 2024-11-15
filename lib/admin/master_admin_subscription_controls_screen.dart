import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendor_mate/Constants/app_theme.dart';

class SubscriptionPaymentsScreen extends StatefulWidget {
  @override
  _SubscriptionPaymentsScreenState createState() =>
      _SubscriptionPaymentsScreenState();
}

class _SubscriptionPaymentsScreenState
    extends State<SubscriptionPaymentsScreen> {
  DateTimeRange? _selectedDateRange;

  // Sample data
  final List<Map<String, dynamic>> _payments = [
    {
      'vendor': 'Vendor A',
      'amount': 1200.0,
      'date': DateTime(2024, 8, 1),
      'status': 'Paid'
    },
    {
      'vendor': 'Vendor B',
      'amount': 1500.0,
      'date': DateTime(2024, 8, 5),
      'status': 'Pending'
    },
    {
      'vendor': 'Vendor C',
      'amount': 800.0,
      'date': DateTime(2024, 8, 10),
      'status': 'Paid'
    },
    {
      'vendor': 'Vendor A',
      'amount': 500.0,
      'date': DateTime(2024, 7, 25),
      'status': 'Pending'
    },
  ];

  // Sample refund data
  final List<Map<String, dynamic>> _refunds = [
    {
      'vendor': 'Vendor A',
      'amount': 100.0,
      'dateRequested': DateTime(2024, 8, 2),
      'status': 'Requested'
    },
    {
      'vendor': 'Vendor B',
      'amount': 200.0,
      'dateRequested': DateTime(2024, 8, 6),
      'status': 'Investigating'
    },
    {
      'vendor': 'Vendor C',
      'amount': 150.0,
      'dateRequested': DateTime(2024, 8, 12),
      'status': 'Processed'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalPayments = _payments.fold<double>(
      0.0,
      (sum, payment) => sum + (payment['amount'] as double),
    );
    final activeSubscriptions =
        _payments.where((payment) => payment['status'] == 'Paid').length;

    final now = DateTime.now();
    final upcomingPayments = _payments.where((payment) {
      final date = payment['date'] as DateTime;
      return date.isAfter(now) &&
          (_selectedDateRange == null ||
              (date.isAfter(_selectedDateRange!.start) &&
                  date.isBefore(_selectedDateRange!.end)));
    }).toList();

    final delayedPayments = _payments.where((payment) {
      final date = payment['date'] as DateTime;
      return date.isBefore(now) &&
          payment['status'] == 'Pending' &&
          (_selectedDateRange == null ||
              (date.isAfter(_selectedDateRange!.start) &&
                  date.isBefore(_selectedDateRange!.end)));
    }).toList();

    final vendorRevenue =
        _payments.fold<Map<String, double>>({}, (map, payment) {
      final vendor = payment['vendor'] as String;
      final amount = payment['amount'] as double;
      map.update(vendor, (value) => value + amount, ifAbsent: () => amount);
      return map;
    });

    final sortedVendors = vendorRevenue.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final refundStatus = {
      'Requested': Colors.orange[50],
      'Investigating': Colors.yellow[50],
      'Processed': Colors.green[50],
      'Declined': Colors.red[50],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Subscription Payments'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Handle export functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 8)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription Summary',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                        'Total Payments: \$${totalPayments.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16)),
                    Text('Active Subscriptions: $activeSubscriptions',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Date Range Filter
              Row(
                children: [
                  Text('Filter by Date: ', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTimeRange? newRange =
                            await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          initialDateRange: _selectedDateRange,
                        );
                        if (newRange != null) {
                          setState(() {
                            _selectedDateRange = newRange;
                          });
                        }
                      },
                      child: Text(_selectedDateRange == null
                          ? 'Select Date Range'
                          : '${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.end)}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Upcoming Payments Section
              Text('Upcoming Payments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              _buildPaymentList(upcomingPayments, AppTheme.red, Icons.payment),

              // Dummy card for upcoming payments
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(Icons.calendar_today, color: AppTheme.blue),
                  title: Text('Vendor A'),
                  subtitle: Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.now().add(Duration(days: 7)))}'),
                  trailing: Text('\$150.00'),
                  tileColor: Colors.blue[50],
                ),
              ),

              // Delayed Payments Section
              SizedBox(height: 16),
              Text('Delayed Payments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildPaymentList(delayedPayments, AppTheme.red, Icons.pending),

              // Vendor Revenue Ranking Section
              SizedBox(height: 16),
              Text('Vendors by Revenue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildVendorList(sortedVendors),

              // Refund Requests Section
              SizedBox(height: 16),
              Text('Refund Requests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildRefundList(_refunds, refundStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentList(
      List<Map<String, dynamic>> payments, Color color, IconData icon) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Icon(icon, color: color),
            title: Text(payment['vendor'] as String),
            subtitle: Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(payment['date'] as DateTime)}'),
            trailing:
                Text('\$${(payment['amount'] as double).toStringAsFixed(2)}'),
            tileColor: Colors.blue[50],
          ),
        );
      },
    );
  }

  Widget _buildVendorList(List<MapEntry<String, double>> vendors) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Icon(Icons.store, color: AppTheme.blue),
            title: Text(vendor.key),
            trailing: Text('\$${vendor.value.toStringAsFixed(2)}',
                style: TextStyle(color: AppTheme.red)),
            tileColor: Colors.blue[50],
          ),
        );
      },
    );
  }

  Widget _buildRefundList(
      List<Map<String, dynamic>> refunds, Map<String, Color?> refundStatus) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: refunds.length,
      itemBuilder: (context, index) {
        final refund = refunds[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Icon(Icons.monetization_on, color: Colors.red),
            title: Text(refund['vendor'] as String),
            subtitle: Text(
                'Date Requested: ${DateFormat('MMM dd, yyyy').format(refund['dateRequested'] as DateTime)}'),
            trailing:
                Text('\$${(refund['amount'] as double).toStringAsFixed(2)}'),
            tileColor: refundStatus[refund['status']] ?? Colors.white,
          ),
        );
      },
    );
  }
}
