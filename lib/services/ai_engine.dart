import 'ai_data_service.dart';

class AIEngine {
  static final AIEngine instance = AIEngine._internal();

  factory AIEngine() {
    return instance;
  }

  AIEngine._internal();

  final AIDataService _dataService = AIDataService.instance;

  Future<String> answer(String message) async {
    final snapshot =
        await _dataService.getBusinessSnapshot();

    final question = message.toLowerCase().trim();

    if (_isGreeting(question)) {
      return _greeting(snapshot);
    }

    if (_isBusinessOverview(question)) {
      return _businessOverview(snapshot);
    }

    if (_isSalesQuestion(question)) {
      return _salesAnalysis(snapshot);
    }

    if (_isBestSellingQuestion(question)) {
      return _bestSelling(snapshot);
    }

    if (_isExpenseQuestion(question)) {
      return _expenseAnalysis(snapshot);
    }

    if (_isProfitQuestion(question)) {
      return _profitAnalysis(snapshot);
    }

    if (_isProductQuestion(question)) {
      return _productAnalysis(snapshot);
    }

    if (_isCustomerQuestion(question)) {
      return _customerAnalysis(snapshot);
    }

    if (_isStockQuestion(question)) {
      return _stockAnalysis(snapshot);
    }

    if (_isAdviceQuestion(question)) {
      return _businessAdvice(snapshot);
    }

    return _generalResponse(snapshot);
  }

  bool _isGreeting(String question) {
    return question == 'hi' ||
        question == 'hello' ||
        question == 'hey' ||
        question.contains('good morning') ||
        question.contains('good afternoon') ||
        question.contains('good evening');
  }

  bool _isBusinessOverview(String question) {
    return question.contains('how is my business') ||
        question.contains('business doing') ||
        question.contains('business performance') ||
        question.contains('business overview') ||
        question.contains('overall performance');
  }

  bool _isSalesQuestion(String question) {
    return question.contains('sales') ||
        question.contains('revenue') ||
        question.contains('selling');
  }

  bool _isBestSellingQuestion(String question) {
    return question.contains('best selling') ||
        question.contains('best-selling') ||
        question.contains('selling best') ||
        question.contains('top product') ||
        question.contains('most popular product');
  }

  bool _isExpenseQuestion(String question) {
    return question.contains('expense') ||
        question.contains('expenses') ||
        question.contains('spending') ||
        question.contains('costs') ||
        question.contains('cost');
  }

  bool _isProfitQuestion(String question) {
    return question.contains('profit') ||
        question.contains('profitable') ||
        question.contains('making money');
  }

  bool _isProductQuestion(String question) {
    return question.contains('product') ||
        question.contains('inventory') ||
        question.contains('stock');
  }

  bool _isCustomerQuestion(String question) {
    return question.contains('customer') ||
        question.contains('customers') ||
        question.contains('clients');
  }

  bool _isStockQuestion(String question) {
    return question.contains('low stock') ||
        question.contains('running out') ||
        question.contains('restock');
  }

  bool _isAdviceQuestion(String question) {
    return question.contains('improve') ||
        question.contains('advice') ||
        question.contains('recommend') ||
        question.contains('recommendation') ||
        question.contains('what should i') ||
        question.contains('what can i do') ||
        question.contains('business idea');
  }

  String _greeting(BusinessSnapshot snapshot) {
    if (snapshot.salesCount == 0) {
      return 'Hello! I’m your BizOS business advisor. '
          'You currently have no recorded sales, so we can start by setting up your products and recording your first transactions.';
    }

    return 'Hello! I’m ready to analyze your business. '
        'You currently have ${snapshot.salesCount} recorded sales, '
        '${snapshot.customerCount} customers and '
        '${snapshot.productCount} products.';
  }

  String _businessOverview(BusinessSnapshot snapshot) {
    final profit = snapshot.profit;

    final performance =
        profit > 0
            ? 'Your recorded revenue is currently higher than your expenses.'
            : profit < 0
                ? 'Your recorded expenses are currently higher than your revenue.'
                : 'Your recorded revenue and expenses are currently equal.';

    return 'Here is your current business picture:\n\n'
        'Revenue: UGX ${_money(snapshot.totalRevenue)}\n'
        'Expenses: UGX ${_money(snapshot.totalExpenses)}\n'
        'Estimated profit: UGX ${_money(profit)}\n'
        'Sales: ${snapshot.salesCount}\n'
        'Customers: ${snapshot.customerCount}\n'
        'Products: ${snapshot.productCount}\n'
        'Low-stock products: ${snapshot.lowStockCount}\n\n'
        '$performance';
  }

  String _salesAnalysis(BusinessSnapshot snapshot) {
    if (snapshot.salesCount == 0) {
      return 'There are no recorded sales yet. '
          'Once you record sales, I can analyze revenue, transaction volume, '
          'best-selling products and sales performance.';
    }

    final average =
        snapshot.totalRevenue / snapshot.salesCount;

    return 'Your sales currently show:\n\n'
        'Total revenue: UGX ${_money(snapshot.totalRevenue)}\n'
        'Transactions: ${snapshot.salesCount}\n'
        'Average sale: UGX ${_money(average)}\n'
        'Best-selling product: ${snapshot.bestSellingProduct}\n\n'
        'I can use these figures to help identify opportunities to increase revenue.';
  }

  String _bestSelling(BusinessSnapshot snapshot) {
    if (snapshot.salesCount == 0) {
      return 'I cannot identify a best-selling product yet because there are no recorded sales.';
    }

    return 'Your best-selling product by number of recorded transactions is '
        '${snapshot.bestSellingProduct}.\n\n'
        'It has generated approximately '
        'UGX ${_money(snapshot.bestSellingProductRevenue)} '
        'in recorded revenue.\n\n'
        'Consider keeping this product well stocked and examining why customers choose it.';
  }

  String _expenseAnalysis(BusinessSnapshot snapshot) {
    if (snapshot.expenses.isEmpty) {
      return 'You currently have no recorded expenses. '
          'Record your business costs so I can compare spending with revenue and identify areas where you may be able to reduce costs.';
    }

    final ratio = snapshot.totalRevenue > 0
        ? (snapshot.totalExpenses /
                snapshot.totalRevenue) *
            100
        : 0;

    return 'Your recorded expenses are:\n\n'
        'Total expenses: UGX ${_money(snapshot.totalExpenses)}\n'
        'Revenue: UGX ${_money(snapshot.totalRevenue)}\n'
        'Expense-to-revenue ratio: ${ratio.toStringAsFixed(1)}%\n\n'
        'Tracking this ratio over time can help you identify whether your operating costs are becoming too high.';
  }

  String _profitAnalysis(BusinessSnapshot snapshot) {
    final profit = snapshot.profit;

    if (snapshot.salesCount == 0 &&
        snapshot.expenses.isEmpty) {
      return 'There is not enough recorded financial activity to calculate meaningful profit yet.';
    }

    if (profit > 0) {
      return 'Your estimated recorded profit is UGX ${_money(profit)}.\n\n'
          'Revenue: UGX ${_money(snapshot.totalRevenue)}\n'
          'Expenses: UGX ${_money(snapshot.totalExpenses)}\n\n'
          'This means your recorded revenue currently exceeds your recorded expenses.';
    }

    if (profit < 0) {
      return 'Your current recorded result is a loss of UGX ${_money(profit.abs())}.\n\n'
          'Revenue: UGX ${_money(snapshot.totalRevenue)}\n'
          'Expenses: UGX ${_money(snapshot.totalExpenses)}\n\n'
          'The first thing I would investigate is which expenses are necessary and whether your prices and sales volume are sufficient.';
    }

    return 'Your recorded revenue and expenses currently balance at UGX 0 profit.';
  }

  String _productAnalysis(BusinessSnapshot snapshot) {
    if (snapshot.productCount == 0) {
      return 'You have no products recorded yet. '
          'Add your products so I can help analyze inventory, pricing and sales performance.';
    }

    return 'You currently have ${snapshot.productCount} products recorded.\n\n'
        'Low-stock products: ${snapshot.lowStockCount}\n'
        'Highest-priced product: ${snapshot.highestValueProduct}\n'
        'Best-selling product: ${snapshot.bestSellingProduct}\n\n'
        'I can use your sales and inventory information to help you decide what to stock and what to focus on.';
  }

  String _customerAnalysis(BusinessSnapshot snapshot) {
    if (snapshot.customerCount == 0) {
      return 'You currently have no customers recorded. '
          'Adding customer records will give BizOS more information to work with as we build customer intelligence.';
    }

    return 'You currently have ${snapshot.customerCount} customers recorded.\n\n'
        'As your sales history grows, I’ll be able to combine customer and sales information to identify purchasing patterns and valuable customers.';
  }

  String _stockAnalysis(BusinessSnapshot snapshot) {
    if (snapshot.productCount == 0) {
      return 'There are no products in your inventory yet.';
    }

    if (snapshot.lowStockCount == 0) {
      return 'Your inventory currently has no products at or below the low-stock threshold.';
    }

    return 'You currently have ${snapshot.lowStockCount} low-stock product(s).\n\n'
        'I recommend checking these products and restocking the ones that are selling consistently before they run out.';
  }

  String _businessAdvice(BusinessSnapshot snapshot) {
    final advice = <String>[];

    if (snapshot.salesCount == 0) {
      advice.add(
        'Start recording sales so BizOS can identify your strongest products and revenue patterns.',
      );
    }

    if (snapshot.productCount == 0) {
      advice.add(
        'Add your products and their prices so inventory and sales analysis becomes more useful.',
      );
    }

    if (snapshot.lowStockCount > 0) {
      advice.add(
        'Review your ${snapshot.lowStockCount} low-stock product(s) and prioritize restocking products that sell frequently.',
      );
    }

    if (snapshot.totalExpenses > snapshot.totalRevenue &&
        snapshot.totalExpenses > 0) {
      advice.add(
        'Your expenses currently exceed your revenue, so review major costs and look for ways to increase sales or reduce unnecessary spending.',
      );
    }

    if (snapshot.bestSellingProduct !=
        'No sales recorded yet') {
      advice.add(
        'Pay particular attention to ${snapshot.bestSellingProduct}, your current best-selling product.',
      );
    }

    if (advice.isEmpty) {
      advice.add(
        'Keep recording accurate sales, expenses, products and customers. The more reliable business data BizOS has, the better its recommendations will become.',
      );
    }

    return 'Here are my recommendations based on your current records:\n\n'
        '${advice.map((item) => '• $item').join('\n\n')}';
  }

  String _generalResponse(BusinessSnapshot snapshot) {
    return 'I can analyze your BizOS business data, including sales, '
        'revenue, expenses, profit, products, inventory, customers and '
        'low-stock items.\n\n'
        'Try asking:\n'
        '• What is selling best?\n'
        '• How is my business doing?\n'
        '• What is my profit?\n'
        '• What are my expenses?\n'
        '• What should I improve?\n'
        '• What products need restocking?';
  }

  String _money(double value) {
    return value.toStringAsFixed(0);
  }
}
