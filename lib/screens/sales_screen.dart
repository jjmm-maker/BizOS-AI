
import 'package:flutter/material.dart';

import '../services/business_data_service.dart';
import '../services/database_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const border = Color(0xFF29292F);
  static const muted = Color(0xFFA7A7AD);

  final List<Sale> _sales = [];

  final BusinessDataService _service =
      BusinessDataService.instance;

  final DatabaseService _database =
      DatabaseService.instance;

  bool _loading = true;

  double get totalRevenue {
    return _sales.fold(
      0,
      (sum, sale) => sum + sale.total,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final savedSales = await _database.getSales();

    final sales = savedSales.map((item) {
      return Sale(
        id: item['id']?.toString() ?? '',
        product: item['product']?.toString() ?? '',
        quantity:
            (item['quantity'] as num?)?.toInt() ?? 1,
        unitPrice:
            (item['unitPrice'] as num?)?.toDouble() ??
                (item['total'] as num?)?.toDouble() ??
                0,
        total:
            (item['total'] as num?)?.toDouble() ?? 0,
        date: DateTime.tryParse(
              item['date']?.toString() ?? '',
            ) ??
            DateTime.now(),
      );
    }).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _sales
        ..clear()
        ..addAll(sales);
      _loading = false;
    });

    _updateBusinessData();
  }

  Future<void> _saveSales() async {
    await _database.saveSales(
      _sales.map((sale) => sale.toMap()).toList(),
    );
  }

  void _updateBusinessData() {
    _service.setRevenue(totalRevenue);
    _service.setSalesCount(_sales.length);
  }

  Future<void> _showAddSale() async {
    final quantityController =
        TextEditingController(text: '1');

    final products =
        await _database.getProducts();

    if (!mounted) {
      quantityController.dispose();
      return;
    }

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add a product before recording a sale.',
          ),
        ),
      );
      quantityController.dispose();
      return;
    }

    String? selectedProductName =
        products.first['name']?.toString();

    double selectedPrice =
        (products.first['price'] as num?)?.toDouble() ??
            0;

    int selectedStock =
        (products.first['stock'] as num?)?.toInt() ??
            0;

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
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color:
                              red.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.point_of_sale_rounded,
                          color: red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'New Sale',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  DropdownButtonFormField<String>(
                    initialValue: selectedProductName,
                    decoration:
                        const InputDecoration(
                      labelText: 'Product',
                      prefixIcon: Icon(
                        Icons.inventory_2_outlined,
                      ),
                    ),
                    items: products.map((product) {
                      final name =
                          product['name']?.toString() ??
                              '';

                      final stock =
                          (product['stock'] as num?)
                                  ?.toInt() ??
                              0;

                      final price =
                          (product['price'] as num?)
                                  ?.toDouble() ??
                              0;

                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(
                          '$name • UGX ${price.toStringAsFixed(0)} • Stock: $stock',
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      final selected =
                          products.firstWhere(
                        (product) =>
                            product['name']
                                ?.toString() ==
                            value,
                      );

                      setSheetState(() {
                        selectedProductName = value;

                        selectedPrice =
                            (selected['price'] as num?)
                                    ?.toDouble() ??
                                0;

                        selectedStock =
                            (selected['stock'] as num?)
                                    ?.toInt() ??
                                0;
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Available stock: $selectedStock',
                    style: const TextStyle(
                      color: muted,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: quantityController,
                    keyboardType:
                        TextInputType.number,
                    decoration:
                        const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(
                        Icons.numbers_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'Sale Total',
                          style: TextStyle(
                            color: muted,
                          ),
                        ),
                        Text(
                          'UGX ${selectedPrice.toStringAsFixed(0)} × quantity',
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
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
                        final quantity =
                            int.tryParse(
                          quantityController.text
                              .trim(),
                        );

                        if (quantity == null ||
                            quantity <= 0) {
                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Enter a valid quantity.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (selectedProductName ==
                                null ||
                            selectedProductName!
                                .isEmpty) {
                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Select a product.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (quantity >
                            selectedStock) {
                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Insufficient stock. Only $selectedStock available.',
                              ),
                            ),
                          );
                          return;
                        }

                        final saleTotal =
                            selectedPrice *
                                quantity;

                        final stockReduced =
                            await _database
                                .reduceProductStock(
                          selectedProductName!,
                          quantity,
                        );

                        if (!stockReduced) {
                          if (!sheetContext
                              .mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(
                            sheetContext,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Unable to update product stock.',
                              ),
                            ),
                          );
                          return;
                        }

                        final sale = Sale(
                          id: DateTime.now()
                              .microsecondsSinceEpoch
                              .toString(),
                          product:
                              selectedProductName!,
                          quantity: quantity,
                          unitPrice:
                              selectedPrice,
                          total: saleTotal,
                          date: DateTime.now(),
                        );

                        setState(() {
                          _sales.insert(
                            0,
                            sale,
                          );
                        });

                        await _saveSales();

                        _updateBusinessData();

                        // Tell ProductsScreen that
                        // inventory has changed.
                        _service
                            .notifyInventoryChanged();

                        if (!sheetContext.mounted) {
                          return;
                        }

                        Navigator.pop(
                          sheetContext,
                        );

                        if (!mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              'Sale recorded. $quantity × $selectedProductName. Stock updated.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check_rounded,
                      ),
                      label: const Text(
                        'Record Sale',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Sales',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: red,
        foregroundColor: Colors.white,
        onPressed: _showAddSale,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Sale',
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
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                100,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Track your sales',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Monitor revenue, transactions and inventory movement.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Revenue',
                          value:
                              'UGX ${_format(totalRevenue)}',
                          icon:
                              Icons.payments_outlined,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _SummaryCard(
                          title: 'Sales',
                          value:
                              '${_sales.length}',
                          icon: Icons
                              .point_of_sale_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (_sales.isEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                        border: Border.all(
                          color: border,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: muted,
                          ),
                          SizedBox(height: 14),
                          Text(
                            'No sales yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Record your first sale to start tracking revenue.',
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._sales.map(
                      (sale) => _SaleTile(
                        sale: sale,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  String _format(double value) {
    return value.toStringAsFixed(0);
  }
}

class Sale {
  final String id;
  final String product;
  final int quantity;
  final double unitPrice;
  final double total;
  final DateTime date;

  Sale({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
      'date': date.toIso8601String(),
    };
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
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
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  final Sale sale;

  const _SaleTile({
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFD71920)
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
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
                  sale.product,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${sale.quantity} × UGX ${sale.unitPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFFA7A7AD),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${sale.date.day.toString().padLeft(2, '0')}/'
                  '${sale.date.month.toString().padLeft(2, '0')}/'
                  '${sale.date.year} '
                  '${sale.date.hour.toString().padLeft(2, '0')}:'
                  '${sale.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Color(0xFFA7A7AD),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Text(
            'UGX ${sale.total.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}