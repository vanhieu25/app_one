import 'package:app_one/models/coffee.dart';
import 'package:flutter/foundation.dart';

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop =[
    Coffee(
      name: 'Espresso',
      imagePath: 'assets/cappuccino.png',
      price: '2.50',
    ),
    Coffee(
      name: 'Latte',
      imagePath: 'assets/latte.png',
      price: '3.00',
    ),
    Coffee(
      name: 'Cappuccino',
      imagePath: 'assets/cappuccino.png',
      price: '3.50',
    ),
  ];
  List<Coffee> _userCart = [];

  List<Coffee> get coffeeShop => _shop;

  List<Coffee> get userCart => _userCart;

  void addItemToCart(Coffee coffee) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    int existingIndex = _userCart.indexWhere((item) => 
      item.name == coffee.name && item.size == coffee.size);
    
    if (existingIndex != -1) {
      // Nếu đã có, tăng số lượng
      Coffee existingItem = _userCart[existingIndex];
      Coffee updatedItem = existingItem.copyWith(
        quantity: (existingItem.quantity ?? 1) + (coffee.quantity ?? 1)
      );
      _userCart[existingIndex] = updatedItem;
    } else {
      // Nếu chưa có, thêm mới
      _userCart.add(coffee);
    }
    notifyListeners();
  }
  void removeItemFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }
}
