import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<bool> isLikedList = List.generate(50, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Nb Store'),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text('Product ${index + 1}'),
              subtitle: Text('Description of Product ${index + 1}'),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isLikedList[index] = !isLikedList[index];
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Your Favorite List Updated !',
                    );
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color: isLikedList[index] ? Colors.grey : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
