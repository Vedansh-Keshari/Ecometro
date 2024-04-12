import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String itemName;
  final String productType;
  final String vendorName;
  final String email;
  final String contactNo;
  final String location;
  final String workingDays;
  final String workingTime;

  Product({
    required this.itemName,
    required this.productType,
    required this.vendorName,
    required this.email,
    required this.contactNo,
    required this.location,
    required this.workingDays,
    required this.workingTime,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      itemName: json['item_name'],
      productType: json['product_type'],
      vendorName: json['vendor_name'],
      email: json['email'],
      contactNo: json['contact_no'],
      location: json['location'],
      workingDays: json['working_days'],
      workingTime: json['working_time'],
    );
  }
}

class ProcurementPage extends StatefulWidget {
  @override
  _ProcurementPageState createState() => _ProcurementPageState();
}

class _ProcurementPageState extends State<ProcurementPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        products = jsonData.map((item) => Product.fromJson(item)).toList();
        filteredProducts = List.from(products);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) =>
          product.itemName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procurement'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Products',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => filterProducts(query),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Handle product tap
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredProducts[index].itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            filteredProducts[index].vendorName,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
