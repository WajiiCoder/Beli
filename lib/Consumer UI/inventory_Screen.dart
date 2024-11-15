import '../Consumer UI/KYC_verification_screen.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'name': 'Item 1',
      'price': '\$10.00',
      'isLiquor': 'false',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 2',
      'price': '\$15.00',
      'isLiquor': 'true',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'name': 'Item 3',
      'price': '\$20.00',
      'isLiquor': 'false',
      'image':
          'https://plus.unsplash.com/premium_photo-1673125287084-e90996bad505?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    // Add more items here
  ];

  @override
  Widget build(BuildContext context) {
    // Check if there is any liquor in the inventory
    bool hasLiquor = items.any((item) => item['isLiquor'] == 'true');

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.0,
                  mainAxisSpacing: 14.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0)),
                          child: Image.network(
                            item['image']!,
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Price: ${item['price']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (hasLiquor)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KYCVerificationScreen(),
                    ),
                  );
                },
                child: Text('Complete KYC to Proceed'),
              ),
          ],
        ),
      ),
    );
  }
}
