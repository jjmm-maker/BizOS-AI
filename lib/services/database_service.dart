import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static final DatabaseService instance =
      DatabaseService._internal();

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  static const String _productsKey = 'bizos_products';
  static const String _customersKey = 'bizos_customers';
  static const String _salesKey = 'bizos_sales';
  static const String _expensesKey = 'bizos_expenses';

  Future<List<Map<String, dynamic>>> getProducts() async {
    return _getList(_productsKey);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    return _getList(_customersKey);
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    return _getList(_salesKey);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    return _getList(_expensesKey);
  }

  Future<void> saveProducts(
    List<Map<String, dynamic>> products,
  ) async {
    await _saveList(_productsKey, products);
  }

  Future<void> saveCustomers(
    List<Map<String, dynamic>> customers,
  ) async {
    await _saveList(_customersKey, customers);
  }

  Future<void> saveSales(
    List<Map<String, dynamic>> sales,
  ) async {
    await _saveList(_salesKey, sales);
  }

  Future<void> saveExpenses(
    List<Map<String, dynamic>> expenses,
  ) async {
    await _saveList(_expensesKey, expenses);
  }

  Future<bool> reduceProductStock(
    String productName,
    int quantity,
  ) async {
    if (quantity <= 0) {
      return false;
    }

    final products = await getProducts();

    final index = products.indexWhere(
      (product) =>
          product['name']?.toString().trim().toLowerCase() ==
          productName.trim().toLowerCase(),
    );

    if (index == -1) {
      return false;
    }

    final currentStock =
        (products[index]['stock'] as num?)?.toInt() ?? 0;

    if (currentStock < quantity) {
      return false;
    }

    products[index]['stock'] = currentStock - quantity;

    await saveProducts(products);

    return true;
  }

  Future<bool> increaseProductStock(
    String productName,
    int quantity,
  ) async {
    if (quantity <= 0) {
      return false;
    }

    final products = await getProducts();

    final index = products.indexWhere(
      (product) =>
          product['name']?.toString().trim().toLowerCase() ==
          productName.trim().toLowerCase(),
    );

    if (index == -1) {
      return false;
    }

    final currentStock =
        (products[index]['stock'] as num?)?.toInt() ?? 0;

    products[index]['stock'] = currentStock + quantity;

    await saveProducts(products);

    return true;
  }

  Future<Map<String, dynamic>?> getProductByName(
    String productName,
  ) async {
    final products = await getProducts();

    for (final product in products) {
      final name =
          product['name']?.toString().trim().toLowerCase();

      if (name == productName.trim().toLowerCase()) {
        return product;
      }
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> _getList(
    String key,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveList(
    String key,
    List<Map<String, dynamic>> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      key,
      jsonEncode(data),
    );
  }

  Future<void> clearBusinessData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_productsKey);
    await prefs.remove(_customersKey);
    await prefs.remove(_salesKey);
    await prefs.remove(_expensesKey);
  }
}
