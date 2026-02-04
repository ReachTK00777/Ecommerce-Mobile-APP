import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileapp/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Product> listData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getFavoriteData();
  }

  _getFavoriteData() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('listFavorite');

    if (data != null && data.isNotEmpty) {
      try {
        List<dynamic> jsonList = jsonDecode(data);
        listData = jsonList.map((json) => Product.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing favorite data: $e');
        listData = [];
      }
    } else {
      listData = [];
    }

    print('Favorite Data : ${jsonEncode(listData)}');

    setState(() {
      isLoading = false;
    });
  }

  _removeFromFavorites(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Product> updatedList = List.from(listData)
      ..removeWhere((p) => p.id == product.id);

    listData = updatedList;

    var data = jsonEncode(listData.map((p) => p.toJson()).toList());
    await prefs.setString('listFavorite', data);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Items"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : listData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              "No Favorite Items Yet",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Tap the heart icon to add items",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return _productItem(listData[index]);
        },
      ),
    );
  }

  Widget _productItem(Product data) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.network(
              data.image,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey[400]),
                );
              },
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Price: \$${data.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () => _removeFromFavorites(data),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}