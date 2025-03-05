import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Dehradun, India'), Text('petroleumpedia')],
          ),
          Container(
            height: 200,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/trucks_image.png',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Trucker'),
                      Text('Trucker D: EXAP989F82'),
                      Text('Total Truck Number: 20'),
                      Icon(Icons.local_shipping),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildTileGrid(),
            ),
          ),
          LinearProgressIndicator(color: Colors.orange, value: 0.5),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.orange,
      ),
    );
  }

  Widget buildTileGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            buildTile('New Job', Colors.purple, Icons.add),
            buildTile('Assign Driver', Colors.orange, Icons.person),
            buildTile('Recruit New Driver', Colors.pink, Icons.add),
            buildTile('Expenses', Colors.green, Icons.money),
          ],
        ),
      ),
    );
  }

  Widget buildTile(String title, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title),
          Icon(icon),
          Text(
            'Start your Trip Today by publishing and graphics design, Lorem ipsum is a placeholder text commonly...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
