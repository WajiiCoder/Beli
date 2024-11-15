import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/Constants/session.dart';
import 'package:vendor_mate/Constants/user_status.dart';
import 'package:vendor_mate/Consumer%20UI/vendor_search_screen.dart';
import 'package:vendor_mate/screens/home_screen.dart';
import 'package:vendor_mate/screens/profile_setup_screen.dart';
import 'package:vendor_mate/screens/signup_screen.dart';

import '../Consumer UI/explore_retailer_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsumerHomeScreen extends StatefulWidget {
  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  SessionManager sessionManager = SessionManager();

  final String vendorAppUrl = 'https://vendor-app-url.com';
  // Replace with the actual URL
  final String beliPartnerAppStoreUrl =
      'https://apps.apple.com/app/beli-partner/id123456789';
  // Replace with the actual App Store URL
  Future<void> _launchVendorApp() async {
    if (await canLaunch(vendorAppUrl)) {
      await launch(vendorAppUrl);
    } else {
      throw 'Could not launch $vendorAppUrl';
    }
  }

  Future<void> _loadVendorObjectId() async {
    String? id = await sessionManager.getVendorId();
    setState(() {
      UserStatus.vendorId = id;
    });
  }

  Future<void> _launchBeliPartnerApp() async {
    if (await canLaunch(beliPartnerAppStoreUrl)) {
      await launch(beliPartnerAppStoreUrl);
    } else {
      throw 'Could not launch $beliPartnerAppStoreUrl';
    }
  }

  List<Map<String, dynamic>> trustedVendors = [
    {
      'name': 'Shahrukh',
      'image':
          'https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWVufGVufDB8fDB8fHww',
      'isStarred': true,
      'isGreyedOut': true, // Greyed out for demo
    },
    {
      'name': 'Neeraj',
      'image':
          'https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWVufGVufDB8fDB8fHww',
      'isStarred': true,
      'isGreyedOut': false, // Not greyed out
    },
    // Add more vendors here with the `isGreyedOut` property
  ];

  void _addVendor(String vendorName, String vendorImage) {
    if (trustedVendors.length < 100) {
      setState(() {
        trustedVendors.add({
          'name': vendorName,
          'image': vendorImage,
          'isStarred': false,
          'isGreyedOut': false, // Default to not greyed out
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only add up to 100 vendors.'),
        ),
      );
    }
  }

  void _showAddVendorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newVendorName = '';
        String newVendorImage = ''; // Placeholder for image path
        return AlertDialog(
          title: Text('Add New Vendor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter vendor name',
                ),
                onChanged: (value) {
                  newVendorName = value;
                },
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter vendor image path',
                ),
                onChanged: (value) {
                  newVendorImage = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newVendorName.isNotEmpty && newVendorImage.isNotEmpty) {
                  _addVendor(newVendorName, newVendorImage);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _removeVendor(int index) {
    setState(() {
      trustedVendors.removeAt(index);
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Vendor'),
        content:
            Text('Are you sure you want to remove the vendor from the list?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _removeVendor(index);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showUnstarConfirmationDialog(int index) {
    String vendorName = trustedVendors[index]['name'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unstar $vendorName'),
        content: Text(
            'Are you sure you want to unstar $vendorName? This will remove it from the list.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _removeVendor(index);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadVendorObjectId();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu), // Hamburger icon
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Open the drawer when tapped
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(),
                child: Text(
                  'Consumer Panel',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: AppTheme.blue,
                ),
                title: Text('Order History'),
                onTap: () {
                  Navigator.pushNamed(context, '/orderManagement');
                },
              ),
              // ListTile(
              //   leading: Icon(
              //     UserStatus.vendorId != null && UserStatus.vendorId!.isNotEmpty
              //         ? Icons.dashboard
              //         : Icons.person,
              //     color: AppTheme.blue,
              //   ),
              //   title: UserStatus.vendorId != null &&
              //           UserStatus.vendorId!.isNotEmpty
              //       ? Text('Vendor Dashboard')
              //       : Text('Become a Vendor'),
              //   onTap: () {
              //     debugPrint("VENDOR ID >> ${UserStatus.vendorId}");
              //     if (UserStatus.vendorId == null ||
              //         UserStatus.vendorId!.isEmpty) {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //               ProfileSetupScreen(role: 'vendor'),
              //         ),
              //       );
              //     } else {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => VendorDashboardScreen(),
              //         ),
              //       );
              //     }
              //   },
              // ),

              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: AppTheme.blue,
                ),
                title: Text('Trusted Retailers'),
                onTap: () {
                  Navigator.pushNamed(context, '/trustedRetailers');
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.folder_special,
                  color: AppTheme.blue,
                ),
                title: Text('Special Category'),
                onTap: () {
                  Navigator.pushNamed(context, '/specialCategory');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.qr_code,
                  color: AppTheme.blue,
                ),
                title: Text('Scan QR Code '),
                onTap: () {
                  Navigator.pushNamed(context, '/vendorScanQRCode');
                },
              ),

              // Add more items here if needed
            ],
          ),
        ),
        body: Stack(
          children: [
            // Background with "trusted vendors" theme
            Positioned.fill(
              child: Opacity(
                opacity: 0.2, // Adjust opacity for the background
                child: Image.asset(
                  'assets/trusted_vendors.jpg', // Replace with your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Space from top
                // Buttons moved to the top and set to the same width
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExploreRetailersScreen())); // Fixed route name
                          },
                          child: Text('Explore'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // Space between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          child: Text('Grow My Business'),
                          style: ElevatedButton.styleFrom(
                            // Set button color
                            padding: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40), // Add more space to separate content
                // Add content for "My Circle: Trusted Vendors"
                Expanded(
                  child: Center(
                    child: Text(
                      'My Circle: Trusted Vendors',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage your trusted vendors here. You can add up to 100 vendors to your list.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: trustedVendors.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  _showDeleteConfirmationDialog(index);
                                  return false; // Prevent immediate dismissal, wait for user confirmation
                                }
                                return false;
                              },
                              child: VendorCard(
                                name: trustedVendors[index]['name']!,
                                image: trustedVendors[index]['image']!,
                                isStarred: trustedVendors[index]['isStarred']!,
                                isGreyedOut: trustedVendors[index]
                                    ['isGreyedOut']!,
                                onUnstar: () {
                                  _showUnstarConfirmationDialog(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _launchBeliPartnerApp,
                  child: Text('Download Beli Partner App'),
                  style: ElevatedButton.styleFrom(
                    // Set button color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space from bottom
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorSearchScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class VendorCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isStarred;
  final bool isGreyedOut;
  final VoidCallback onUnstar;

  VendorCard({
    required this.name,
    required this.image,
    required this.isStarred,
    required this.isGreyedOut,
    required this.onUnstar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: isGreyedOut ? 0 : 5,
      color: isGreyedOut ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 30,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isGreyedOut ? Colors.grey : Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isStarred ? Icons.star : Icons.star_border_outlined,
                color: isStarred ? Colors.red : Colors.grey,
              ),
              onPressed: isGreyedOut ? null : onUnstar,
            ),
          ],
        ),
        trailing:
            isGreyedOut ? null : Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
