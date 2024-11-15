import 'package:flutter/material.dart';

class MasterAdminControlsScreen extends StatefulWidget {
  @override
  _MasterAdminControlsScreenState createState() =>
      _MasterAdminControlsScreenState();
}

class _MasterAdminControlsScreenState extends State<MasterAdminControlsScreen> {
  String selectedUserStatus = 'All';
  String searchQuery = '';
  final List<Map<String, String>> vendors = [
    {'name': 'Vendor A', 'status': 'Active'},
    {'name': 'Vendor B', 'status': 'Active'},
    {'name': 'Vendor C', 'status': 'Blacklisted'},
    // Add more vendors here
  ];

  final List<Map<String, String>> users = [
    {
      'name': 'User A',
      'status': 'Active',
      'mobile': '4445556666',
      'area': 'Area 1'
    },
    {
      'name': 'User B',
      'status': 'Flagged for Investigation',
      'mobile': '7778889999',
      'area': 'Area 2'
    },
    {
      'name': 'User C',
      'status': 'Investigation in Progress',
      'mobile': '0001112222',
      'area': 'Area 3'
    },
    {
      'name': 'User D',
      'status': 'Blacklisted',
      'mobile': '1112223333',
      'area': 'Area 4'
    },
    {
      'name': 'User E',
      'status': 'Unblock',
      'mobile': '2223334444',
      'area': 'Area 5'
    },
    // Add more users here
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Master Admin Controls'),
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'Vendors'),
              Tab(text: 'Users'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVendorManagement(), // Assuming you already have the vendor management method
            _buildUserManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Vendor',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle search functionality
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(vendor['name']!),
                  subtitle: Text('Status: ${vendor['status']}'),
                  trailing: vendor['status'] == 'Active'
                      ? IconButton(
                          icon: Icon(Icons.block),
                          onPressed: () {
                            _toggleBlacklistStatus('Vendor', index);
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.restore),
                          onPressed: () {
                            _toggleBlacklistStatus('Vendor', index);
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search User',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 6),
              DropdownButton<String>(
                value: selectedUserStatus,
                items: [
                  'All',
                  'Active',
                  'Flagged for Investigation',
                  'Investigation in Progress',
                  'Blacklisted',
                  'Unblock'
                ].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserStatus = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: users
                .where((user) {
                  bool matchesStatus = selectedUserStatus == 'All' ||
                      user['status'] == selectedUserStatus;
                  bool matchesQuery = user['name']!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      user['mobile']!.contains(searchQuery) ||
                      user['area']!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                  return matchesStatus && matchesQuery;
                })
                .toList()
                .length,
            itemBuilder: (context, index) {
              final user = users.where((user) {
                bool matchesStatus = selectedUserStatus == 'All' ||
                    user['status'] == selectedUserStatus;
                bool matchesQuery = user['name']!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()) ||
                    user['mobile']!.contains(searchQuery) ||
                    user['area']!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                return matchesStatus && matchesQuery;
              }).toList()[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(user['name']!),
                  subtitle: Text('Status: ${user['status']}'),
                  trailing: user['status'] == 'Active'
                      ? IconButton(
                          icon: Icon(Icons.block),
                          onPressed: () {
                            _toggleBlacklistStatus('User', users.indexOf(user));
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.restore),
                          onPressed: () {
                            _toggleBlacklistStatus('User', users.indexOf(user));
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _toggleBlacklistStatus(String type, int index) {
    setState(() {
      if (type == 'User') {
        if (users[index]['status'] == 'Active') {
          users[index]['status'] = 'Blacklisted';
        } else {
          users[index]['status'] = 'Active';
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type status updated successfully'),
      ),
    );
  }
}
