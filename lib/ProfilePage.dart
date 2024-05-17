import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Nb Store'),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/user.jpg'),
                radius: 40,
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[800],
              thickness: 1,
            ),
            const SizedBox(height: 20),
            const Text(
              'Name',
              style:
                  TextStyle(color: Colors.grey, letterSpacing: 2, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'El Bigg',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Number of Orders',
              style:
                  TextStyle(color: Colors.grey, letterSpacing: 2, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '8',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'NabilHakimi@Gmail.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
