import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data from the local JSON file
    loadJsonData();
    searchController.addListener(_searchProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadJsonData() async {
    try {
      // Get the directory for the app's documents
      final Directory directory = await getApplicationDocumentsDirectory();
      final File localFile = File('${directory.path}/data.json');

      // Read the JSON data from the local file
      final String jsonString = await localFile.readAsString();

      // Decode the JSON data into a list of products
      final data = json.decode(jsonString) as List;

      // Update the state with the loaded products
      setState(() {
        products = data.map((product) => Product.fromJson(product)).toList();
        filteredProducts = products;
      });

      print('JSON data loaded successfully.');
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  void _searchProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        return product.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _updateProductLike(int index) async {
    setState(() {
      filteredProducts[index].like = !filteredProducts[index].like;
      products[products.indexOf(filteredProducts[index])].like =
          filteredProducts[index].like;
    });

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File localFile = File('${directory.path}/data.json');
      String jsonString = await localFile.readAsString();
      List<dynamic> jsonList = json.decode(jsonString);
      final productIndex = jsonList.indexWhere(
          (product) => product['title'] == filteredProducts[index].title);
      if (productIndex != -1) {
        jsonList[productIndex]['like'] = filteredProducts[index].like;
        jsonString = json.encode(jsonList);
        await localFile.writeAsString(jsonString);
      }

      print('JSON updated successfully.');
    } catch (e) {
      print('Error updating JSON data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Nb Store',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Text(
                'Nb Store',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _updateProductLike(index);
                        },
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            _updateProductLike(index);
                            // QuickAlert.show(
                            //   context: context,
                            //   type: QuickAlertType.success,
                            //   text: 'Your Favorite List Updated!',
                            // );
                          },
                          child: Icon(
                            Icons.favorite,
                            color: product.like ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Product {
  final String title;
  final int price;
  final String image;
  bool like;

  Product({
    required this.title,
    required this.price,
    required this.image,
    this.like = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] ?? '',
      price: json['price'] ?? 0,
      image: json['image'] ?? '',
      like: json['like'] ?? false,
    );
  }
}
