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
      home: const LikesPage(),
    );
  }
}

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File localFile = File('${directory.path}/data.json');
      final String jsonString = await localFile.readAsString();
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        products = data.map((product) => Product.fromJson(product)).toList();
      });
      print('JSON data loaded successfully.');
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final likedProducts = products.where((product) => product.like).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Nb Store',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: likedProducts.isEmpty
          ? const Center(child: Text('No liked products.'))
          : ListView.builder(
              itemCount: likedProducts.length,
              itemBuilder: (context, index) {
                final product = likedProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(product.image,
                        fit: BoxFit.cover, width: 50, height: 50),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: IconButton(
                      onPressed: () {
                        _confirmDislikeProduct(product);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: product.like ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _confirmDislikeProduct(Product product) async {
    bool confirmDislike = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to remove this product from your liked list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Dismiss the dialog and return false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Dismiss the dialog and return true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDislike) {
      setState(() {
        product.like = false;
      });
      _updateProductLike(product);
    }
  }

  Future<void> _updateProductLike(Product product) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File localFile = File('${directory.path}/data.json');
      final String jsonString = await localFile.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      final index =
          jsonList.indexWhere((item) => item['title'] == product.title);
      if (index != -1) {
        jsonList[index]['like'] = product.like;
        await localFile.writeAsString(json.encode(jsonList));
        print('JSON updated successfully.');
      }
    } catch (e) {
      print('Error updating JSON data: $e');
    }
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'like': like,
    };
  }
}
