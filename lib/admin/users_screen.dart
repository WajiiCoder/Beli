import 'package:flutter/material.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'drawer_widget.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      // drawer: DrawerWidget(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Active Users'),
            SizedBox(height: 16.0),
            _buildUserList(isBlocked: false),
            SizedBox(height: 32.0),
            _buildSectionTitle('Blocked Users'),
            SizedBox(height: 16.0),
            _buildUserList(isBlocked: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        // color: Colors.black87,
      ),
    );
  }

  Widget _buildUserList({required bool isBlocked}) {
    // Placeholder data for users, replace with actual data
    List<Map<String, dynamic>> users = [
      {
        "userName": 'Alice Johnson',
        "location": 'San Francisco, CA',
        "isBlocked": false,
        "imageUrl":
            'https://franchisematch.com/wp-content/uploads/2015/02/john-doe.jpg',
      },
      {
        "userName": 'Bob Smith',
        "location": 'Los Angeles, CA',
        "isBlocked": true,
        "imageUrl":
            'https://franchisematch.com/wp-content/uploads/2015/02/john-doe.jpg',
      },
      // Add more users as needed
    ];

    List<Map<String, dynamic>> filteredUsers =
        users.where((user) => user['isBlocked'] == isBlocked).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    user['imageUrl'],
                    height: 60.0,
                    width: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['userName'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        user['location'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Block/Unblock user logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        user['isBlocked'] ? Colors.green : AppTheme.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(user['isBlocked'] ? 'Unblock' : 'Block'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
