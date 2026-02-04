import 'package:http/http.dart' as http;
import 'package:mobileapp/configs/app_config.dart';
import 'package:mobileapp/models/product_model.dart';

class ProductService {
  Future<List<Product>> getAllProduct() async {
    final url = Uri.https(AppConfig.baseUrl, AppConfig.product);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
