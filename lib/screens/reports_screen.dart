import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../services/subscription_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const border = Color(0xFF29292F);
  static const muted = Color(0xFFA7A7AD);

  final DatabaseService _database = DatabaseService.instance;
  final SubscriptionService _subscription =
      SubscriptionService.instance;

  bool _loading = true;

  List<Map<String, dynamic>> _sales = [];
  List<Map<String, dynamic>> _expenses = [];

  bool get _hasReports => _subscription.hasReports;

  double get totalRevenue {
    return _sales.fold(
      0,
      (sum, sale) =>
          sum + ((sale['total'] as num?)?.toDouble() ?? 0),
    );
  }

  double get totalExpenses {
    return _expenses.fold(
      0,
      (sum, expense) =>
          sum + ((expense['amount'] as num?)?.toDouble() ?? 0),
    );
  }

  double get profit {
    return totalRevenue - totalExpenses;
  }

  @override
  void initState() {
    super.initState();

    if (_hasReports) {
      _loadReports();
    } else {
      _loading = false;
    }
  }

  Future<void> _loadReports() async {
    final sales = await _database.getSales();
    final expenses = await _database.getExpenses();

    if (!mounted) {
      return;
    }

    setState(() {
      _sales = sales;
      _expenses = expenses;
      _loading = false;
    });
  }

  String _formatMoney(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasReports) {
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: const Text(
            'Reports',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 42,
                    color: red,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Reports are locked',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upgrade your BizOS plan to unlock business reports and insights.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Reports',
          style: TextStyle(
            fontWeight: FontWeight.w900,
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
              onRefresh: _loadReports,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  30,
                ),
                children: [
                  const Text(
                    'Business Reports',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Understand your revenue, expenses and profit.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ReportCard(
                    title: 'Total Revenue',
                    value: 'UGX ${_formatMoney(totalRevenue)}',
                    icon: Icons.trending_up_rounded,
                    highlighted: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallReportCard(
                          title: 'Sales',
                          value: '${_sales.length}',
                          icon: Icons.point_of_sale_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SmallReportCard(
                          title: 'Expenses',
                          value:
                              'UGX ${_formatMoney(totalExpenses)}',
                          icon: Icons.money_off_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _ReportCard(
                    title: 'Estimated Profit',
                    value: 'UGX ${_formatMoney(profit)}',
                    icon: profit >= 0
                        ? Icons.account_balance_wallet_outlined
                        : Icons.warning_amber_rounded,
                    highlighted: false,
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Sales Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: _sales.isEmpty
                        ? const Text(
                            'No sales have been recorded yet.',
                            style: TextStyle(
                              color: muted,
                            ),
                          )
                        : Column(
                            children: [
                              _InfoRow(
                                label: 'Transactions',
                                value: '${_sales.length}',
                              ),
                              const Divider(
                                color: border,
                              ),
                              _InfoRow(
                                label: 'Average Sale',
                                value:
                                    'UGX ${_formatMoney(totalRevenue / _sales.length)}',
                              ),
                              const Divider(
                                color: border,
                              ),
                              _InfoRow(
                                label: 'Highest Sale',
                                value:
                                    'UGX ${_formatMoney(_highestSale())}',
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Report Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: red,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Reports are calculated from the sales and expense records stored on this device.',
                            style: TextStyle(
                              color: muted,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  double _highestSale() {
    if (_sales.isEmpty) {
      return 0;
    }

    double highest = 0;

    for (final sale in _sales) {
      final amount =
          (sale['total'] as num?)?.toDouble() ?? 0;

      if (amount > highest) {
        highest = amount;
      }
    }

    return highest;
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool highlighted;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: highlighted
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD71920),
                  Color(0xFF8E0F14),
                ],
              )
            : null,
        color: highlighted
            ? null
            : const Color(0xFF151519),
        borderRadius: BorderRadius.circular(18),
        border: highlighted
            ? null
            : Border.all(
                color: const Color(0xFF29292F),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: highlighted
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFD71920)
                      .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: highlighted
                  ? Colors.white
                  : const Color(0xFFD71920),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlighted
                        ? Colors.white70
                        : const Color(0xFFA7A7AD),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SmallReportCard({
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
        borderRadius: BorderRadius.circular(18),
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
          const SizedBox(height: 14),
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
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFA7A7AD),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
