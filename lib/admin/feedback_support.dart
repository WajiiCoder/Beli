import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'drawer_widget.dart';

class FeedbackAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Feedback and Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('User Feedback'),
              SizedBox(height: 8.0),
              _buildFeedbackList(),
              SizedBox(height: 16.0),
              _buildSectionTitle('Vendor Feedback'),
              SizedBox(height: 8.0),
              _buildFeedbackList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFeedbackList() {
    return Column(
      children: List.generate(
        5, // Number of feedback items (you can replace this with your dynamic data)
        (index) => _buildFeedbackCard(
          name: 'User $index',
          feedback: 'This is a sample feedback message from user $index.',
          date: '2024-08-17',
          onResolve: () {
            // Handle resolve feedback
          },
          onDelete: () {
            // Handle delete feedback
          },
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({
    required String name,
    required String feedback,
    required String date,
    required VoidCallback onResolve,
    required VoidCallback onDelete,
  }) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              feedback,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onResolve,
                  child: Text('Resolve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red,
                    // Text color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
