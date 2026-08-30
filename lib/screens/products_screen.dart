import 'package:flutter/material.dart';

import '../services/business_data_service.dart';
import '../services/database_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const muted = Color(0xFFA7A7AD);

  final List<Product> _products = [];

  final BusinessDataService _service =
      BusinessDataService.instance;

  final DatabaseService _database =
      DatabaseService.instance;

  bool _loading = true;
  bool _refreshing = false;

  double get totalStockValue {
    return _products.fold(
      0,
      (sum, product) =>
          sum + (product.price * product.stock),
    );
  }

  int get lowStockCount {
    return _products
        .where((product) => product.stock <= 5)
        .length;
  }

  @override
  void initState() {
    super.initState();

    _service.addListener(_onBusinessDataChanged);

    _loadProducts();
  }

  @override
  void dispose() {
    _service.removeListener(_onBusinessDataChanged);
    super.dispose();
  }

  void _onBusinessDataChanged() {
    if (!mounted || _refreshing) {
      return;
    }

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (_refreshing) {
      return;
    }

    _refreshing = true;

    try {
      final savedProducts =
          await _database.getProducts();

      final products = savedProducts.map((item) {
        return Product(
          id: item['id']?.toString() ?? '',
          name: item['name']?.toString() ?? '',
          price:
              (item['price'] as num?)?.toDouble() ?? 0,
          stock:
              (item['stock'] as num?)?.toInt() ?? 0,
        );
      }).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _products
          ..clear()
          ..addAll(products);
        _loading = false;
      });

      _updateBusinessData();
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _saveProducts() async {
    await _database.saveProducts(
      _products
          .map((product) => product.toMap())
          .toList(),
    );
  }

  void _updateBusinessData() {
    _service.setProductCount(_products.length);
    _service.updateLowStock(lowStockCount);
  }

  void _showAddProduct() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(sheetContext)
                    .viewInsets
                    .bottom +
                20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'New Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price (UGX)',
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: stockController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock quantity',
                  prefixIcon: Icon(
                    Icons.numbers_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final name =
                        nameController.text
                            .trim();

                    final price =
                        double.tryParse(
                      priceController.text
                          .trim(),
                    );

                    final stock =
                        int.tryParse(
                      stockController.text
                          .trim(),
                    );

                    if (name.isEmpty ||
                        price == null ||
                        price <= 0 ||
                        stock == null ||
                        stock < 0) {
                      ScaffoldMessenger.of(
                        sheetContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid product, price and stock.',
                          ),
                        ),
                      );
                      return;
                    }

                    final product = Product(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      name: name,
                      price: price,
                      stock: stock,
                    );

                    setState(() {
                      _products.insert(
                        0,
                        product,
                      );
                    });

                    await _saveProducts();

                    _updateBusinessData();

                    if (!sheetContext.mounted) {
                      return;
                    }

                    Navigator.pop(
                      sheetContext,
                    );
                  },
                  child: const Text(
                    'Add Product',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditProduct(
    Product product,
  ) async {
    final nameController =
        TextEditingController(text: product.name);

    final priceController =
        TextEditingController(
      text: product.price.toStringAsFixed(0),
    );

    final stockController =
        TextEditingController(
      text: product.stock.toString(),
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(sheetContext)
                    .viewInsets
                    .bottom +
                20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price (UGX)',
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: stockController,
                keyboardType:
                    TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock quantity',
                  prefixIcon: Icon(
                    Icons.numbers_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final name =
                        nameController.text
                            .trim();

                    final price =
                        double.tryParse(
                      priceController.text
                          .trim(),
                    );

                    final stock =
                        int.tryParse(
                      stockController.text
                          .trim(),
                    );

                    if (name.isEmpty ||
                        price == null ||
                        price <= 0 ||
                        stock == null ||
                        stock < 0) {
                      ScaffoldMessenger.of(
                        sheetContext,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid product, price and stock.',
                          ),
                        ),
                      );
                      return;
                    }

                    final updated =
                        Product(
                      id: product.id,
                      name: name,
                      price: price,
                      stock: stock,
                    );

                    final index =
                        _products.indexWhere(
                      (item) =>
                          item.id ==
                          product.id,
                    );

                    if (index != -1) {
                      setState(() {
                        _products[index] =
                            updated;
                      });

                      await _saveProducts();
                      _updateBusinessData();
                    }

                    if (!sheetContext.mounted) {
                      return;
                    }

                    Navigator.pop(
                      sheetContext,
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }

  Future<void> _deleteProduct(
    Product product,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          title: const Text(
            'Delete Product?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Delete "${product.name}" from your catalogue?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _products.removeWhere(
        (item) => item.id == product.id,
      );
    });

    await _saveProducts();

    _updateBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: red,
        foregroundColor: Colors.white,
        onPressed: _showAddProduct,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: red,
              ),
            )
          : RefreshIndicator(
              color: red,
              onRefresh: _loadProducts,
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Products',
                            value:
                                '${_products.length}',
                            icon: Icons
                                .inventory_2_outlined,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _StatCard(
                            title: 'Low Stock',
                            value:
                                '$lowStockCount',
                            icon: Icons
                                .warning_amber_outlined,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _WideStatCard(
                      title: 'Stock Value',
                      value:
                          'UGX ${totalStockValue.toStringAsFixed(0)}',
                      icon: Icons
                          .account_balance_wallet_outlined,
                    ),

                    const SizedBox(height: 28),

                    const Align(
                      alignment:
                          Alignment.centerLeft,
                      child: Text(
                        'Product Catalogue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Expanded(
                      child: _products.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(
                                  height: 100,
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons
                                            .inventory_2_outlined,
                                        size: 52,
                                        color: muted,
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      Text(
                                        'No products yet',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              18,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        'Add your first product to build your catalogue.',
                                        textAlign:
                                            TextAlign
                                                .center,
                                        style:
                                            TextStyle(
                                          color:
                                              muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  _products.length,
                              itemBuilder:
                                  (context, index) {
                                final product =
                                    _products[index];

                                return _ProductTile(
                                  product:
                                      product,
                                  onEdit: () =>
                                      _showEditProduct(
                                    product,
                                  ),
                                  onDelete: () =>
                                      _deleteProduct(
                                    product,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151519),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF29292F),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFD71920),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _WideStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _WideStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151519),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF29292F),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFD71920),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFA7A7AD),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.stock <= 5;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151519),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF29292F),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFD71920)
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFFD71920),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'UGX ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFFA7A7AD),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '${product.stock}',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w900,
                  color: isLowStock
                      ? const Color(
                          0xFFD71920,
                        )
                      : Colors.white,
                ),
              ),
              Text(
                isLowStock
                    ? 'Low stock'
                    : 'In stock',
                style: const TextStyle(
                  color: Color(0xFFA7A7AD),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) =>
                const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                    ),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                    ),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
