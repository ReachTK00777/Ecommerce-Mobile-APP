import 'package:flutter/material.dart';
import 'package:mobileapp/services/product_service.dart';
import 'package:mobileapp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/productitem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getAllProduct();
  }

  Future<void> _removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logout"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          InkWell(
              onTap: (){
                _removeToken();
              },
              child: Icon(Icons.search, color: Colors.black)),
          SizedBox(width: 15),
          Icon(Icons.shopping_cart_outlined, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 BANNER
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 CATEGORIES TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Shop By Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("See All", style: TextStyle(color: Colors.green)),
                ],
              ),

              const SizedBox(height: 15),

              // 🔥 CATEGORIES
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryItem(Icons.devices, "Electronics"),
                    _space(),
                    _categoryItem(Icons.diamond, "Jewelery"),
                    _space(),
                    _categoryItem(Icons.man, "Men"),
                    _space(),
                    _categoryItem(Icons.woman, "Women"),
                    _space(),
                    _categoryItem(Icons.devices, "Phone"),
                    _space(),
                    _categoryItem(Icons.diamond, "Bag"),
                    _space(),
                    _categoryItem(Icons.man, "HeadPhone"),
                    _space(),
                    _categoryItem(Icons.woman, "Tablet"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🔥 PRODUCTS TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("See All", style: TextStyle(color: Colors.green)),
                ],
              ),

              const SizedBox(height: 15),


              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Failed to load products"),
                    );
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const Center(
                      child: Text("No products available"),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.70,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return productCard(
                        context,
                        products[index],
                        products,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== helpers =====
  static Widget _space() => const SizedBox(width: 20);

  static Widget _categoryItem(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green, size: 30),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
