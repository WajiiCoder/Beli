import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:vendor_mate/Repository/products_repo.dart';
import 'package:vendor_mate/widgets/loader.dart';
import '../Consumer UI/cart_screen.dart';
import '../Consumer UI/details_screen.dart';
import 'package:flutter/material.dart';

class BrowseInventoryScreen extends StatefulWidget {
  String? retailesId;
  BrowseInventoryScreen({required this.retailesId});
  @override
  State<BrowseInventoryScreen> createState() => _BrowseInventoryScreenState();
}

class _BrowseInventoryScreenState extends State<BrowseInventoryScreen>
    with SingleTickerProviderStateMixin {
  List<ParseObject>? retailersInventory;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final List<Map<String, String>> items = [
    {
      'name': 'Item 1',
      'price': '\$10.00',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 2',
      'price': '\$15.00',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 3',
      'price': '\$20.00',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 4',
      'price': '\$25.00',
      'image':
          'https://images.unsplash.com/photo-1596609548086-85bbf8ddb6b9?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 5',
      'price': '\$30.00',
      'image':
          'https://plus.unsplash.com/premium_photo-1675186049366-64a655f8f537?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    _slideAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    final fetchretailerProducts =
        await ProductsRepo().fetchProducts(context, widget.retailesId ?? "");
    setState(() {
      retailersInventory = fetchretailerProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Inventory'),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: retailersInventory == null
            ? Loader()
            : retailersInventory!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/empty_box.png',
                          width: 130,
                          height: 130,
                        ),
                        SizedBox(height: 20),
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'No inventory available yet.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio:
                          0.75, // Adjust aspect ratio for better fit
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: retailersInventory?.length,
                    itemBuilder: (context, index) {
                      final item = retailersInventory![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetailScreen(itemDetails: item),
                              ));
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                  image: DecorationImage(
                                    image: item.get<ParseFile>('cover_image') !=
                                                null &&
                                            item
                                                    .get<ParseFile>(
                                                        'cover_image')!
                                                    .url !=
                                                null
                                        ? NetworkImage(item
                                            .get<ParseFile>('cover_image')!
                                            .url!)
                                        : AssetImage('assets/shoes.jpg')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.get<String>('name') ?? "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Price: \$${(item.get('price') is int ? (item.get('price') as int).toDouble() : item.get('price')).toString()}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(Icons.add_shopping_cart),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${item['name']} added to cart!'),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        },
        icon: Icon(Icons.shopping_cart),
        label: Text('Finished Ordering'),
      ),
    );
  }
}
