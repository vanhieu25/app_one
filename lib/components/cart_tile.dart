import 'package:app_one/models/coffee.dart';
import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onPressed;
  final Widget icon;
  
  const CartTile({
    super.key,
    required this.coffee,
    required this.onPressed,
    required this.icon,
  });

  double _calculateItemTotal() {
    double basePrice = double.parse(coffee.price);
    Map<String, double> sizePrices = {
      'Small': 0.0,
      'Medium': 0.5,
      'Large': 1.0,
    };
    double sizePrice = sizePrices[coffee.size ?? 'Medium'] ?? 0.0;
    return (basePrice + sizePrice) * (coffee.quantity ?? 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Hình ảnh
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                coffee.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coffee.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${coffee.size ?? "Medium"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Số lượng: ${coffee.quantity ?? 1}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${_calculateItemTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          
          // Nút xóa
          IconButton(
            onPressed: onPressed,
            icon: icon,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
