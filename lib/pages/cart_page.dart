import 'package:app_one/components/cart_tile.dart';
import 'package:app_one/models/coffee.dart';
import 'package:app_one/models/coffee_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).removeItemFromCart(coffee);
  }
  
  void pay() {
    // Implement payment logic here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thanh toán'),
          content: const Text('Chức năng thanh toán sẽ được triển khai sau!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotal(List<Coffee> cartItems) {
    double total = 0.0;
    Map<String, double> sizePrices = {
      'Small': 0.0,
      'Medium': 0.5,
      'Large': 1.0,
    };
    
    for (Coffee coffee in cartItems) {
      double basePrice = double.parse(coffee.price);
      double sizePrice = sizePrices[coffee.size ?? 'Medium'] ?? 0.0;
      total += (basePrice + sizePrice) * (coffee.quantity ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(builder: (context, value, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            const Text(
              'Giỏ hàng của bạn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: value.userCart.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Giỏ hàng trống',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.userCart.length,
                      itemBuilder: (context, index) {
                        Coffee coffee = value.userCart[index];
                        return CartTile(
                          coffee: coffee,
                          onPressed: () {
                            removeFromCart(coffee);
                          },
                          icon: const Icon(Icons.remove),
                        );
                      },
                    ),
            ),

            if (value.userCart.isNotEmpty) ...[
              const SizedBox(height: 20),
              
              // Hiển thị tổng tiền
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotal(value.userCart).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: pay,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Thanh toán ngay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ]),
        ),
      );
    });
  }
}
