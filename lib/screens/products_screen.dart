
import 'package:flutter/material.dart';

import '../services/business_data_service.dart';

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

  double get totalStockValue {
    return _products.fold(
      0,
      (sum, product) =>
          sum + (product.price * product.stock),
    );
  }

  void _showAddProduct() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
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
                decoration:
                    const InputDecoration(
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
                    TextInputType.number,
                decoration:
                    const InputDecoration(
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
                decoration:
                    const InputDecoration(
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
                  ),
                  onPressed: () {
                    final name =
                        nameController.text.trim();

                    final price =
                        double.tryParse(
                      priceController.text.trim(),
                    );

                    final stock =
                        int.tryParse(
                      stockController.text.trim(),
                    );

                    if (name.isEmpty ||
                        price == null ||
                        price <= 0 ||
                        stock == null ||
                        stock < 0) {
                      return;
                    }

                    setState(() {
                      _products.insert(
                        0,
                        Product(
                          name: name,
                          price: price,
                          stock: stock,
                        ),
                      );
                    });

                    _service.addProduct();

                    final lowStock = _products
                        .where(
                          (product) =>
                              product.stock <= 5,
                        )
                        .length;

                    _service.updateLowStock(
                      lowStock,
                    );

                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final lowStock = _products
        .where(
          (product) => product.stock <= 5,
        )
        .length;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
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
        label: const Text('Add Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
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
                    value: '$lowStock',
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
              alignment: Alignment.centerLeft,
              child: Text(
                'Product Catalogue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: _products.isEmpty
                  ? const Center(
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

                          SizedBox(height: 14),

                          Text(
                            'No products yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Add your first product to build your catalogue.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          _products.length,
                      itemBuilder:
                          (context, index) {
                        return _ProductTile(
                          product:
                              _products[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final int stock;

  Product({
    required this.name,
    required this.price,
    required this.stock,
  });
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

  const _ProductTile({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        product.stock <= 5;

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
        ],
      ),
    );
  }
}