import 'package:app_one/components/coffee_tile.dart';
import 'package:app_one/models/coffee.dart';
import 'package:app_one/models/coffee_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  void _addToCart(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).addItemToCart(coffee);
    // Handle add to cart
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Added to Cart'),
        content: Text('${coffee.name} has been added to your cart.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'How do you take your coffee?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: value.coffeeShop.length,
                   // Set itemCount to avoid RangeError
                  itemBuilder: (context, index) {
                    Coffee coffee = value.coffeeShop[index];
                    return CoffeeTile(
                      coffee: coffee,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _addToCart(coffee);
                      },
                    );
                  },
                ),
              ),
              // Add more widgets here as needed
            ],
          ),
        ),
      ),
    );
  }
}
