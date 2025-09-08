import 'package:app_one/models/coffee.dart';
import 'package:app_one/pages/coffee_detail_page.dart';
import 'package:flutter/material.dart';

class CoffeeTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onPressed;
  final Widget icon;
   CoffeeTile({
    super.key,
    required this.coffee,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Image.asset(coffee.imagePath),
          title: Text(coffee.name),
          subtitle: Text('\$${coffee.price}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoffeeDetailPage(coffee: coffee),
              ),
            );
          },
          trailing: IconButton(onPressed: onPressed, icon: icon),
        ),
      
    );
  }
}