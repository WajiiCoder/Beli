import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'drawer_widget.dart';
import 'feedback_chatlist.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatListScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardCard(
                    icon: Icons.people,
                    title: 'Total Vendors',
                    count: '150',
                  ),
                  _buildDashboardCard(
                    icon: Icons.person,
                    title: 'Total Users',
                    count: '1200',
                  ),
                  _buildDashboardCard(
                    icon: Icons.pending_actions,
                    title: 'Pending Orders',
                    count: '25',
                  ),
                  _buildDashboardCard(
                    icon: Icons.check_circle,
                    title: 'Completed Orders',
                    count: '100',
                  ),
                  _buildDashboardCard(
                    icon: Icons.cancel,
                    title: 'Canceled Orders',
                    count: '10',
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildEarningsCard(),
              SizedBox(height: 16),
              _buildSummaryCards(),
              SizedBox(height: 16),
              _buildOrdersSummary(),
              SizedBox(height: 16),
              _buildOrderComparisonChart(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String count,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: AppTheme.blue,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Earnings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$150,000',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEarningsTimeframe('Daily'),
                _buildEarningsTimeframe('Weekly'),
                _buildEarningsTimeframe('Monthly'),
                _buildEarningsTimeframe('Yearly'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsTimeframe(String timeframe) {
    return Column(
      children: [
        Text(timeframe, style: TextStyle(fontSize: 16)),
        Text('\$15,000',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrdersSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOrderStatusCard('Successful Orders', 1200, AppTheme.red),
        _buildOrderStatusCard('Unsuccessful Orders', 50, AppTheme.red),
      ],
    );
  }

  Widget _buildOrderStatusCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(count.toString(),
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderComparisonChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Order Success Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 12, color: Colors.green)
                    ]),
                    BarChartGroupData(
                        x: 1,
                        barRods: [BarChartRodData(toY: 2, color: Colors.red)]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Successful',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12));
                            case 1:
                              return Text('Unsuccessful',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12));
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSummaryCard(
              title: 'Total Payments',
              value: '\$150,000',
              color: AppTheme.blue),
          _buildSummaryCard(
            title: 'Total Fees',
            value: '\$5,000',
            color: AppTheme.red,
          ),
          _buildSummaryCard(
            title: 'Net Income',
            value: '\$145,000',
            color: AppTheme.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 8.0, // Increased elevation for better visibility
      margin: EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 4.0), // Adjusted margins
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
