import 'package:flutter/material.dart';

class AccountHeader extends StatelessWidget {
  final String month;

  const AccountHeader({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/046/463/338/small/happy-young-man-celebrating-with-fists-raised-on-transparent-background-png.png',
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.orange,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.menu),
        ],
      ),
    );
  }
}
