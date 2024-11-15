import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:vendor_mate/Constants/user_status.dart';
import 'package:vendor_mate/Consumer%20UI/browse_inventory_screen.dart';
import 'package:vendor_mate/Repository/vendor_profile_setup_repo.dart';
import 'package:vendor_mate/widgets/loader.dart';

class ExploreRetailersScreen extends StatefulWidget {
  @override
  _ExploreRetailersScreenState createState() => _ExploreRetailersScreenState();
}

class _ExploreRetailersScreenState extends State<ExploreRetailersScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isKycCompleted = true;
  List<ParseObject>? retailers;

  @override
  void initState() {
    super.initState();
    _fetchRetailers(); // Fetch data asynchronously
  }

  // Fetch retailers from Back4App excluding the signed-in user
  Future<void> _fetchRetailers() async {
    final fetchedRetailers = await ProfileSetupRepo()
        .fetchVendorsExcludingSignedInUser(UserStatus.vendorId ?? "");
    setState(() {
      retailers = fetchedRetailers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Retailers...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : const Text('Explore'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: retailers == null
            ? Center(
                child: Loader(),
              )
            : _buildRetailerGrid(),
      ),
    );
  }

  Widget _buildRetailerGrid() {
    List<ParseObject> filteredRetailers = retailers!
        .where((retailer) => retailer['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredRetailers.length,
      itemBuilder: (context, index) {
        final retailer = filteredRetailers[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrowseInventoryScreen(
                    retailesId: retailers![index].objectId ?? "",
                  ),
                ));
          },
          child: RetailerCard(
            operationHours: retailer['operational_hours'],
            retailerName: retailer['name'].toString(),
            // rating: retailer['rating'] ?? 4.5,
            // distance: retailer['distance'] ?? 'Unknown',
            phoneNumber: retailer['contact_number'],
            imageUrl: retailer['image'] ?? '',
            onFavoriteToggle: () {},
          ),
        );
      },
    );
  }
}

class RetailerCard extends StatelessWidget {
  final String retailerName;
  final String operationHours;
  final String phoneNumber;
  final String imageUrl;
  final VoidCallback onFavoriteToggle;

  RetailerCard({
    required this.retailerName,
    required this.operationHours,
    required this.phoneNumber,
    required this.imageUrl,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Container(
            // height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png', // Path to your default asset image
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/trusted_vendors.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Text(
                          retailerName,
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Icon(
                          Icons.favorite_outline_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        phoneNumber,
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                // SizedBox(
                //   height: 7,
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_alarm),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Text(
                          operationHours,
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Widget _buildRatingStars(double rating) {
//   int fullStars = rating.floor();
//   bool hasHalfStar = rating - fullStars >= 0.5;
//   List<Widget> stars = List.generate(5, (index) {
//     if (index < fullStars) {
//       return Icon(Icons.star, color: Colors.yellow[700]);
//     } else if (index == fullStars && hasHalfStar) {
//       return Icon(Icons.star_half, color: Colors.yellow[700]);
//     } else {
//       return Icon(Icons.star_border, color: Colors.yellow[700]);
//     }
//   });
//   return Row(children: stars);
// }
