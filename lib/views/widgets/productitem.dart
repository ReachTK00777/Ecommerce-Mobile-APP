import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_detail/product_detail.dart';

Widget productCard(
    BuildContext context,
    Product product,
    List<Product> allProducts,
    ) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetail(
            product: product,
            relatedProducts: allProducts,
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Container
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  product.rating?.rate?.toStringAsFixed(1) ?? '4.5',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FutureBuilder<bool>(
              future: _isProductInFavorites(product.id),
              builder: (context, snapshot) {
                bool isFavorite = snapshot.data ?? false;
                return InkWell(
                  onTap: () async {
                    bool success = await saveProduct(product);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to favorites!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 24,
                      color: isFavorite ? Colors.red : Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
  )
  );
}

Future<bool> _isProductInFavorites(int productId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? data = prefs.getString('listFavorite');

  if (data != null && data.isNotEmpty) {
    try {
      List<dynamic> jsonList = jsonDecode(data);
      return jsonList.any((json) => json['id'] == productId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }
  return false;
}

Future<bool> saveProduct(Product p) async {
  try {
    List<Product> listData = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('listFavorite');

    if (data != null && data.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(data);
      listData = jsonList.map((json) => Product.fromJson(json)).toList();

      if (listData.any((product) => product.id == p.id)) {
        listData.removeWhere((product) => product.id == p.id);
      } else {
        listData.add(p);
      }
    } else {
      listData = [p];
    }

    String encodedData = jsonEncode(listData.map((product) => product.toJson()).toList());
    await prefs.setString('listFavorite', encodedData);
    return true;
  } catch (e) {
    print('Error saving product to favorites: $e');
    return false;
  }
}