import 'package:app_one/models/coffee.dart';
import 'package:app_one/models/coffee_shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeDetailPage extends StatefulWidget {
  final Coffee coffee;
  
  const CoffeeDetailPage({super.key, required this.coffee});

  @override
  State<CoffeeDetailPage> createState() => _CoffeeDetailPageState();
}

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  int quantity = 1;
  String selectedSize = 'Medium';
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  final Map<String, double> sizePrices = {
    'Small': 0.0,
    'Medium': 0.5,
    'Large': 1.0,
  };

  void _addToCart() {
    final coffeeWithDetails = widget.coffee.copyWith(
      size: selectedSize,
      quantity: quantity,
    );
    
    Provider.of<CoffeeShop>(context, listen: false).addItemToCart(coffeeWithDetails);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đã thêm vào giỏ hàng'),
          content: Text('${quantity}x ${widget.coffee.name} (${selectedSize}) đã được thêm vào giỏ hàng.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay lại trang shop
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalPrice() {
    double basePrice = double.parse(widget.coffee.price);
    double sizePrice = sizePrices[selectedSize] ?? 0.0;
    return (basePrice + sizePrice) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coffee.name),
        backgroundColor: Colors.brown[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.coffee.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Tên và giá
              Text(
                widget.coffee.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'Giá cơ bản: \$${widget.coffee.price}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Chọn size
              const Text(
                'Chọn kích thước:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 15),
              
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sizes.length,
                  itemBuilder: (context, index) {
                    String size = sizes[index];
                    bool isSelected = selectedSize == size;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.brown : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? Colors.brown : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$size (+\$${sizePrices[size]!.toStringAsFixed(1)})',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Chọn số lượng
              const Text(
                'Số lượng:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 15),
              
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: quantity > 1 ? () {
                        setState(() {
                          quantity--;
                        });
                      } : null,
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Tổng giá
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(15),
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
                      '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Nút thêm vào giỏ hàng
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
