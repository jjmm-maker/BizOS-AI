
import 'package:flutter/foundation.dart';

import '../models/business_data.dart';

class BusinessDataService extends ChangeNotifier {
  static final BusinessDataService instance =
      BusinessDataService._internal();

  factory BusinessDataService() {
    return instance;
  }

  BusinessDataService._internal();

  final BusinessData data = BusinessData();

  void addSale(double amount) {
    data.totalRevenue += amount;
    data.totalSales++;
    notifyListeners();
  }

  void setRevenue(double amount) {
    data.totalRevenue = amount;
    notifyListeners();
  }

  void setSalesCount(int count) {
    data.totalSales = count;
    notifyListeners();
  }

  void addCustomer() {
    data.totalCustomers++;
    notifyListeners();
  }

  void setCustomerCount(int count) {
    data.totalCustomers = count;
    notifyListeners();
  }

  void addProduct() {
    data.totalProducts++;
    notifyListeners();
  }

  void addProductCount(int count) {
    data.totalProducts = count;
    notifyListeners();
  }

  void setProductCount(int count) {
    data.totalProducts = count;
    notifyListeners();
  }

  void updateLowStock(int count) {
    data.lowStockProducts = count;
    notifyListeners();
  }

  void setExpenseTotal(double amount) {
    data.totalExpenses = amount;
    notifyListeners();
  }

  void setExpenseCount(int count) {
    data.totalExpensesCount = count;
    notifyListeners();
  }

  void notifyInventoryChanged() {
    notifyListeners();
  }
}