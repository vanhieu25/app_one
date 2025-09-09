// Import các thư viện cần thiết
import 'package:app_one/models/coffee.dart';        // Model Coffee để lưu thông tin cà phê
import 'package:app_one/models/coffee_shop.dart';   // Model CoffeeShop để quản lý giỏ hàng
import 'package:flutter/material.dart';              // Thư viện UI của Flutter
import 'package:provider/provider.dart';             // Thư viện quản lý state

// StatefulWidget để tạo trang chi tiết sản phẩm cà phê có thể thay đổi state
class CoffeeDetailPage extends StatefulWidget {
  final Coffee coffee; // Biến lưu thông tin cà phê được truyền từ trang trước
  
  const CoffeeDetailPage({super.key, required this.coffee});

  @override
  State<CoffeeDetailPage> createState() => _CoffeeDetailPageState();
}

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  // Biến lưu số lượng sản phẩm khách hàng muốn mua (mặc định là 1)
  int quantity = 1;
  
  // Biến lưu kích thước được chọn (mặc định là Medium)
  String selectedSize = 'Medium';
  
  // Danh sách các kích thước có thể chọn
  final List<String> sizes = ['Small', 'Medium', 'Large'];
  
  // Map lưu giá phụ thu cho từng kích thước
  final Map<String, double> sizePrices = {
    'Small': 0.0,   // Không phụ thu cho size nhỏ
    'Medium': 0.5,  // Phụ thu $0.5 cho size vừa
    'Large': 1.0,   // Phụ thu $1.0 cho size lớn
  };

  // Hàm xử lý thêm sản phẩm vào giỏ hàng
  void _addToCart() {
    // Tạo một bản sao của coffee với thông tin size và số lượng đã chọn
    final coffeeWithDetails = widget.coffee.copyWith(
      size: selectedSize,
      quantity: quantity,
    );
    
    // Thêm sản phẩm vào giỏ hàng thông qua CoffeeShop provider
    Provider.of<CoffeeShop>(context, listen: false).addItemToCart(coffeeWithDetails);
    
    // Hiển thị dialog thông báo đã thêm thành công
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đã thêm vào giỏ hàng'),
          content: Text('${quantity}x ${widget.coffee.name} (${selectedSize}) đã được thêm vào giỏ hàng.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();    // Đóng dialog
                Navigator.of(context).pop();    // Quay lại trang shop
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Hàm tính tổng giá tiền dựa trên giá gốc, phụ thu size và số lượng
  double _calculateTotalPrice() {
    double basePrice = double.parse(widget.coffee.price);  // Chuyển giá từ String sang double
    double sizePrice = sizePrices[selectedSize] ?? 0.0;    // Lấy phụ thu theo size (nếu null thì = 0)
    return (basePrice + sizePrice) * quantity;             // Tính tổng: (giá gốc + phụ thu) * số lượng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh điều hướng phía trên với tên sản phẩm
      appBar: AppBar(
        title: Text(widget.coffee.name),
        backgroundColor: Colors.brown[100],
        elevation: 0, // Bỏ đổ bóng
      ),
      // Nội dung chính có thể cuộn được
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding xung quanh nội dung
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Căn trái các widget con
            children: [
              // === SECTION 1: Hình ảnh sản phẩm ===
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Bo góc container
                    color: Colors.grey[100], // Màu nền xám nhạt
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Bo góc hình ảnh
                    child: Image.asset(
                      widget.coffee.imagePath, // Đường dẫn hình ảnh từ coffee object
                      fit: BoxFit.cover,       // Hình ảnh phủ đầy container
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30), // Khoảng cách giữa các phần
              
              // === SECTION 2: Tên và giá cơ bản ===
              Text(
                widget.coffee.name, // Tên sản phẩm
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'Giá cơ bản: \$${widget.coffee.price}', // Hiển thị giá gốc
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // === SECTION 3: Chọn kích thước ===
              const Text(
                'Chọn kích thước:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Container chứa danh sách các size có thể cuộn ngang
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Cuộn ngang
                  itemCount: sizes.length,          // Số lượng size
                  itemBuilder: (context, index) {
                    String size = sizes[index];           // Lấy size tại vị trí index
                    bool isSelected = selectedSize == size; // Kiểm tra size có được chọn không
                    
                    return GestureDetector(
                      // Xử lý khi người dùng chạm vào size
                      onTap: () {
                        setState(() {
                          selectedSize = size; // Cập nhật size được chọn
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10), // Khoảng cách giữa các item
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          // Màu nền thay đổi theo trạng thái được chọn
                          color: isSelected ? Colors.brown : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? Colors.brown : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$size (+\$${sizePrices[size]!.toStringAsFixed(1)})', // Hiển thị size và phụ thu
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
              
              // === SECTION 4: Chọn số lượng ===
              const Text(
                'Số lượng:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Row chứa nút giảm, hiển thị số lượng, và nút tăng
              Row(
                children: [
                  // Nút giảm số lượng
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      // Chỉ cho phép giảm khi quantity > 1
                      onPressed: quantity > 1 ? () {
                        setState(() {
                          quantity--; // Giảm số lượng
                        });
                      } : null, // null = disabled button
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  
                  // Hiển thị số lượng hiện tại
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      quantity.toString(), // Chuyển số thành string để hiển thị
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Nút tăng số lượng
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++; // Tăng số lượng
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // === SECTION 5: Hiển thị tổng giá ===
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown[50], // Màu nền nâu nhạt
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều 2 đầu
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotalPrice().toStringAsFixed(2)}', // Gọi hàm tính tổng và format 2 chữ số thập phân
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
              
              // === SECTION 6: Nút thêm vào giỏ hàng ===
              SizedBox(
                width: double.infinity, // Chiều rộng bằng màn hình
                height: 60,             // Chiều cao cố định
                child: ElevatedButton(
                  onPressed: _addToCart, // Gọi hàm thêm vào giỏ hàng
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,    // Màu nền nút
                    foregroundColor: Colors.white,    // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bo góc nút
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
