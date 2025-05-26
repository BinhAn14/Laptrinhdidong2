import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gki/models/Product.dart';

void main() => runApp(MaterialApp(
      home: ProductApp(),
      debugShowCheckedModeBanner: false,
    ));

class ProductApp extends StatefulWidget {
  @override
  State<ProductApp> createState() => _ProductAppState();
}

class _ProductAppState extends State<ProductApp> {
  List<Product> products = [];
  bool isLoading = false;
  String error = '';
  String keyword = '';
  bool filterUnder500 = false;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final res = await http.get(Uri.parse('https://dummyjson.com/products'));
      final data = json.decode(res.body);
      setState(() {
        products =
            (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      setState(() => error = 'Lỗi tải sản phẩm');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addProduct(String title, String desc, int price) async {
    try {
      final res = await http.post(
        Uri.parse('https://dummyjson.com/products/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": title,
          "description": desc,
          "price": price,
          "category": "beauty",
          "discountPercentage": 10.48,
          "rating": 4.5,
          "stock": 50,
          "tags": ["beauty", "new"],
          "brand": "Your Brand",
          "sku": "SKU-001",
          "weight": 5,
          "dimensions": {"width": 10.0, "height": 15.0, "depth": 3.0},
          "warrantyInformation": "1 year warranty",
          "shippingInformation": "Ships in 1-3 days",
          "availabilityStatus": "In Stock",
          "reviews": [],
          "returnPolicy": "Return within 7 days",
          "minimumOrderQuantity": 1,
          "meta": {
            "createdAt": DateTime.now().toIso8601String(),
            "updatedAt": DateTime.now().toIso8601String(),
            "barcode": "1234567890123",
            "qrCode": "https://dummyjson.com/qr.png"
          },
          "images": ["https://dummyjson.com/product-images/sample1.jpg"],
          "thumbnail": "https://dummyjson.com/product-images/sample-thumb.jpg"
        }),
      );

      final newProduct = Product.fromJson(json.decode(res.body));
      setState(() => products.insert(0, newProduct));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Thêm thất bại')));
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await http.delete(Uri.parse('https://dummyjson.com/products/$id'));
      setState(() => products.removeWhere((item) => item.id == id));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xoá thất bại')));
    }
  }

  Future<void> searchProduct(String keyword) async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final res = await http
          .get(Uri.parse('https://dummyjson.com/products/search?q=$keyword'));
      final data = json.decode(res.body);
      setState(() {
        products =
            (data['products'] as List).map((e) => Product.fromJson(e)).toList();
      });
    } catch (e) {
      setState(() => error = 'Tìm kiếm lỗi');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProduct(
      int id, String title, String desc, int price) async {
    try {
      final res = await http.put(
        Uri.parse('https://dummyjson.com/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": title,
          "description": desc,
          "price": price,
          "category": "beauty", // Bạn có thể thay đổi category tùy ý
          "discountPercentage": 10.48,
          "rating": 4.5,
          "stock": 50,
          "tags": ["beauty", "updated"],
          "brand": "Updated Brand",
          "sku": "SKU-001",
          "weight": 5,
          "dimensions": {"width": 10.0, "height": 15.0, "depth": 3.0},
          "warrantyInformation": "1 year updated warranty",
          "shippingInformation": "Ships in 1-2 days",
          "availabilityStatus": "In Stock",
          "reviews": [],
          "returnPolicy": "Return within 10 days",
          "minimumOrderQuantity": 1,
          "meta": {"updatedAt": DateTime.now().toIso8601String()},
          "images": ["https://dummyjson.com/product-images/updated1.jpg"],
          "thumbnail": "https://dummyjson.com/product-images/updated-thumb.jpg"
        }),
      );

      if (res.statusCode == 200) {
        final updated = Product.fromJson(json.decode(res.body));
        setState(() {
          int index = products.indexWhere((item) => item.id == id);
          if (index != -1) products[index] = updated;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sản phẩm đã được cập nhật')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cập nhật thất bại')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật sản phẩm')));
    }
  }

  void showProductDialog({Product? product}) {
    if (product != null) {
      titleController.text = product.title;
      descController.text = product.description;
      priceController.text = product.price.toString();
    } else {
      titleController.clear();
      descController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Tên')),
              TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Mô tả')),
              TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Giá'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Huỷ'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Lưu'),
            onPressed: () {
              final title = titleController.text;
              final desc = descController.text;
              final price = int.tryParse(priceController.text) ?? 0;

              if (product == null) {
                addProduct(title, desc, price);
              } else {
                updateProduct(product.id, title, desc, price);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget productItem(Product p) {
    return Card(
      child: ListTile(
        title: Text(p.title),
        subtitle: Text('${p.description}\nGiá: \$${p.price}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showProductDialog(product: p)),
          IconButton(
              icon: Icon(Icons.delete), onPressed: () => deleteProduct(p.id)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = filterUnder500
        ? products.where((e) => e.price < 500).toList()
        : products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: () => showProductDialog()),
          IconButton(
              icon: Icon(filterUnder500
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined),
              onPressed: () =>
                  setState(() => filterUnder500 = !filterUnder500)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Tìm sản phẩm', border: OutlineInputBorder()),
              onChanged: (value) {
                keyword = value;
                if (value.isEmpty)
                  fetchProducts();
                else
                  searchProduct(value);
              },
            ),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (error.isNotEmpty)
            Text(error)
          else if (displayList.isEmpty)
            Text('Không có sản phẩm nào')
          else
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) =>
                    productItem(displayList[index]),
              ),
            ),
        ],
      ),
    );
  }
}
