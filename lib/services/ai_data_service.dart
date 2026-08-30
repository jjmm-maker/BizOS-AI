import 'database_service.dart';

class AIDataService {
  static final AIDataService instance = AIDataService._internal();

  factory AIDataService() {
    return instance;
  }

  AIDataService._internal();

  final DatabaseService _database = DatabaseService.instance;

  Future<BusinessSnapshot> getBusinessSnapshot() async {
    final products = await _database.getProducts();
    final customers = await _database.getCustomers();
    final sales = await _database.getSales();
    final expenses = await _database.getExpenses();

    return BusinessSnapshot(
      products: products,
      customers: customers,
      sales: sales,
      expenses: expenses,
    );
  }
}

class BusinessSnapshot {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> customers;
  final List<Map<String, dynamic>> sales;
  final List<Map<String, dynamic>> expenses;

  BusinessSnapshot({
    required this.products,
    required this.customers,
    required this.sales,
    required this.expenses,
  });

  double get totalRevenue {
    return sales.fold(
      0,
      (sum, sale) =>
          sum + ((sale['total'] as num?)?.toDouble() ?? 0),
    );
  }

  double get totalExpenses {
    return expenses.fold(
      0,
      (sum, expense) =>
          sum + ((expense['amount'] as num?)?.toDouble() ?? 0),
    );
  }

  double get profit {
    return totalRevenue - totalExpenses;
  }

  int get salesCount => sales.length;

  int get customerCount => customers.length;

  int get productCount => products.length;

  int get lowStockCount {
    return products.where((product) {
      final stock = (product['stock'] as num?)?.toInt() ?? 0;
      return stock <= 5;
    }).length;
  }

  String get bestSellingProduct {
    if (sales.isEmpty) {
      return 'No sales recorded yet';
    }

    final Map<String, int> counts = {};

    for (final sale in sales) {
      final product =
          sale['product']?.toString().trim() ?? '';

      if (product.isEmpty) {
        continue;
      }

      counts[product] = (counts[product] ?? 0) + 1;
    }

    if (counts.isEmpty) {
      return 'No product information available';
    }

    String best = counts.keys.first;

    for (final product in counts.keys) {
      if (counts[product]! > counts[best]!) {
        best = product;
      }
    }

    return best;
  }

  double get bestSellingProductRevenue {
    if (sales.isEmpty) {
      return 0;
    }

    final bestProduct = bestSellingProduct;

    double total = 0;

    for (final sale in sales) {
      final product =
          sale['product']?.toString().trim() ?? '';

      if (product == bestProduct) {
        total +=
            (sale['total'] as num?)?.toDouble() ?? 0;
      }
    }

    return total;
  }

  String get highestValueProduct {
    if (products.isEmpty) {
      return 'No products recorded yet';
    }

    Map<String, dynamic>? best;

    for (final product in products) {
      final price =
          (product['price'] as num?)?.toDouble() ?? 0;

      if (best == null ||
          price >
              ((best['price'] as num?)?.toDouble() ?? 0)) {
        best = product;
      }
    }

    return best?['name']?.toString() ??
        'No products recorded yet';
  }
}
