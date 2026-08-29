
import 'package:flutter/material.dart';

import '../services/business_data_service.dart';

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

  final BusinessDataService _service =
      BusinessDataService.instance;

  final List<Sale> _sales = [];

  double get totalRevenue =>
      _sales.fold(0, (sum, sale) => sum + sale.total);

  void _showAddSale() {
    final productController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
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

              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: red.withValues(alpha: 0.15),
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

              TextField(
                controller: productController,
                textInputAction:
                    TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Product / Service',
                  prefixIcon: Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (UGX)',
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {
                    final product =
                        productController.text.trim();

                    final amount = double.tryParse(
                      amountController.text.trim(),
                    );

                    if (product.isEmpty ||
                        amount == null ||
                        amount <= 0) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid product and amount.',
                          ),
                        ),
                      );
                      return;
                    }

                    final sale = Sale(
                      product: product,
                      total: amount,
                      date: DateTime.now(),
                    );

                    setState(() {
                      _sales.insert(0, sale);
                    });

                    // UPDATE GLOBAL BUSINESS DATA
                    _service.addSale(amount);

                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.check_rounded,
                  ),

                  label: const Text(
                    'Record Sale',
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

      body: SingleChildScrollView(
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
              'Monitor revenue and recent transactions.',
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
                    icon:
                        Icons.point_of_sale_outlined,
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
                      BorderRadius.circular(18),
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
                      textAlign: TextAlign.center,
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


/// SALE MODEL
class Sale {
  final String product;
  final double total;
  final DateTime date;

  Sale({
    required this.product,
    required this.total,
    required this.date,
  });
}


/// SUMMARY CARD
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
      padding:
          const EdgeInsets.all(18),

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


/// SALE TILE
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

      padding:
          const EdgeInsets.all(16),

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
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${sale.date.hour.toString().padLeft(2, '0')}:${sale.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Color(0xFFA7A7AD),
                    fontSize: 12,
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