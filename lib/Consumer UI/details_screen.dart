import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:vendor_mate/Constants/app_theme.dart';
import 'package:vendor_mate/Constants/user_status.dart';
import 'package:vendor_mate/screens/fullScreenView.dart';

class ItemDetailScreen extends StatefulWidget {
  final ParseObject itemDetails;

  ItemDetailScreen({required this.itemDetails});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _currentIndex = 0;
  String coverImage = '';
  List<String> optionalImages = [];
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    coverImage = widget.itemDetails.get<ParseFile>('cover_image')?.url ?? "";
    fetchProductImages();
  }

  fetchProductImages() async {
    try {
      final fetchedImages =
          await fetchOptionalImages(widget.itemDetails.objectId ?? "");

      if (fetchedImages.isEmpty && coverImage.isNotEmpty) {
        images = [coverImage];
      } else {
        if (coverImage.isNotEmpty) {
          fetchedImages.insert(0, coverImage);
        }
        images = fetchedImages;
      }

      setState(() {
        optionalImages = fetchedImages;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  Future<List<String>> fetchOptionalImages(String productId) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('ProductsImages'));

    query.whereEqualTo(
        'product', ParseObject('Products')..objectId = productId);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((result) {
        final image = result['image'] as ParseFile;
        return image.url!;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenGallery(
                                images: images,
                                initialIndex: _currentIndex,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 300.0,
                          child: PageView.builder(
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/shoes.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 16.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            '${_currentIndex + 1} / ${images.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemDetails.get<String>('name').toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${(widget.itemDetails.get('price') is int ? (widget.itemDetails.get('price') as int).toDouble() : widget.itemDetails.get('price')).toString()}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        UserStatus.vendorId != null
                            ? SizedBox()
                            : IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${widget.itemDetails.get('name')} added to cart"),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_shopping_cart),
                                iconSize: 28.0,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.itemDetails.get<String>('description') ?? "",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6,
              left: 10,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppTheme.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
