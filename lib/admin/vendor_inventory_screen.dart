import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:vendor_mate/Constants/user_status.dart';
import 'package:vendor_mate/Consumer%20UI/details_screen.dart';
import 'package:vendor_mate/Repository/Products_repo.dart';
import 'package:vendor_mate/Repository/vendor_profile_setup_repo.dart';
import 'package:vendor_mate/screens/add_category_screen.dart';
import 'package:vendor_mate/screens/add_product_inventory.dart';
import 'package:vendor_mate/widgets/loader.dart';
import 'package:vendor_mate/widgets/snack_bar.dart';

class VendorInventoryScreen extends StatefulWidget {
  @override
  State<VendorInventoryScreen> createState() => _VendorInventoryScreenState();
}

class _VendorInventoryScreenState extends State<VendorInventoryScreen> {
  List<ParseObject> products = [];
  bool isLoading = true;
  Map<String, String> categoryNameMap = {};
  String vendorName = "";
  String? categoryName;
  String? categoryId;

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedProducts =
          await ProductsRepo().fetchProducts(context, UserStatus.vendorId!);
      setState(() {
        products = fetchedProducts;
      });

      await _fetchCategoriesForProducts();
    } catch (error) {
      CustomSnackbar.show(context, "Error fetching products: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//fetched the current vendor name
  Future<void> _fetchVendorName() async {
    final name =
        await ProfileSetupRepo().getVendorName(UserStatus.vendorId ?? "");

    setState(() {
      vendorName = name ?? "";
    });
  }

  Future<void> _fetchCategoriesForProducts() async {
    final categoryIds = products
        .map((product) {
          final categoryObject = product.get<ParseObject>('category');
          return categoryObject?.objectId;
        })
        .where((id) => id != null)
        .cast<String>()
        .toList();

    if (categoryIds.isNotEmpty) {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Categories'))
        ..whereContainedIn('objectId', categoryIds);

      final ParseResponse response = await queryBuilder.query();
      if (response.success && response.results != null) {
        for (var category in response.results!) {
          final id = category.objectId;
          final name = category.get<String>('name') ?? 'Unknown Category';
          if (id != null) {
            categoryNameMap[id] = name;
          }
        }
      }
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Product"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        isLoading = true;
      });

      try {
        final response =
            await ProductsRepo().deleteCategory(context, productId);
        if (response.success) {
          setState(() {
            products.removeWhere((product) => product.objectId == productId);
          });
          CustomSnackbar.show(context, "Product deleted successfully");
        } else {
          CustomSnackbar.show(
              context, "Failed to delete product: ${response.error?.message}");
        }
      } catch (error) {
        CustomSnackbar.show(context, "Error deleting product: $error");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchProducts();
    _fetchVendorName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${vendorName} Inventory'),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Loader()
                : products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/empty_box.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "No products available.",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Please try to add products to your inventory by clicking the plus button.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final categoryObject =
                              product.get<ParseObject>('category');
                          categoryName = 'No Category';

                          if (categoryObject != null) {
                            categoryId = categoryObject.objectId ?? '';
                            categoryName =
                                categoryNameMap[categoryId] ?? 'No Category';
                          }

                          return _buildInventoryItemCard(
                            product: product,
                            index: index,
                            imageUrl:
                                (product.get<ParseFile>('cover_image')?.url ??
                                            '') !=
                                        ''
                                    ? product
                                        .get<ParseFile>('cover_image')!
                                        .url
                                        .toString()
                                    : 'https://via.placeholder.com/150',
                            itemName: product.get<String>('name') ?? 'No Name',
                            category: categoryName ?? "",
                            price: product.get('price') is int
                                ? (product.get<int>('price') ?? 0).toDouble()
                                : product.get<double>('price') ?? 0.0,
                            stockQuantity: product.get('stock') is int
                                ? (product.get<int>('stock') ?? 0)
                                : product.get<int>('stock') ?? 0,
                            rating: 0.0,
                          );
                        },
                      ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Loader(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInventoryProductScreen(),
            ),
          );
          if (shouldRefresh == true) {
            _fetchProducts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInventoryItemCard({
    required String imageUrl,
    required String itemName,
    required String category,
    required double price,
    required int stockQuantity,
    required double rating,
    required int index,
    required ParseObject product,
  }) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ItemDetailScreen(itemDetails: product)));
        },
        child: Card(
          elevation: 5.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageUrl,
                        height: 70.0,
                        width: 70.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '\$$price',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.0),
                        Text(
                          'Stock: $stockQuantity',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 20.0, color: Colors.grey[300]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final shouldRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddInventoryProductScreen(
                              isEdit: true,
                              product: products[index],
                              categoryname: categoryName,
                              categoryid: categoryId,
                            ),
                          ),
                        );
                        if (shouldRefresh == true) {
                          setState(() {
                            _fetchProducts();
                          });
                        }
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        _deleteProduct(products[index].objectId ?? "");
                      },
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
