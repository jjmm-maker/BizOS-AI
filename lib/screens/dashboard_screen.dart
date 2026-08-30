import 'package:flutter/material.dart';

import '../services/business_data_service.dart';
import '../services/auth_service.dart';
import 'sales_screen.dart';
import 'customers_screen.dart';
import 'products_screen.dart';
import 'subscription_screen.dart';
import 'expenses_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const border = Color(0xFF29292F);
  static const muted = Color(0xFFA7A7AD);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: BusinessDataService.instance,
      builder: (context, child) {
        final data = BusinessDataService.instance.data;
        final account = AuthService.instance.currentAccount;

        final businessName =
            account?.businessName.isNotEmpty == true
                ? account!.businessName
                : 'BizOS';

        final firstName =
            account?.fullName.isNotEmpty == true
                ? account!.fullName.split(' ').first
                : 'there';

        final currency =
            account?.currency.isNotEmpty == true
                ? account!.currency
                : 'UGX';

        final netProfit =
            data.totalRevenue - data.totalExpenses;

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
            elevation: 0,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Business command center',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 18),
                child: CircleAvatar(
                  backgroundColor: red,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Good evening, $firstName 👋',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Here is your business overview.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 24),

                // REVENUE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFD71920),
                        Color(0xFF8E0F14),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons
                                .account_balance_wallet_outlined,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Total Revenue',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.white.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: const Text(
                              'All time',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        '$currency ${_format(data.totalRevenue)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 17,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Revenue from recorded sales',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _FinancialCard(
                        icon:
                            Icons.receipt_long_outlined,
                        title: 'Expenses',
                        value:
                            '$currency ${_format(data.totalExpenses)}',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _FinancialCard(
                        icon:
                            Icons.trending_up_rounded,
                        title: 'Net Profit',
                        value:
                            '$currency ${_format(netProfit)}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  'Business Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _StatCard(
                      icon:
                          Icons.point_of_sale_outlined,
                      title: 'Sales',
                      value:
                          '${data.totalSales}',
                      subtitle: 'Transactions',
                    ),

                    _StatCard(
                      icon: Icons.people_outline,
                      title: 'Customers',
                      value:
                          '${data.totalCustomers}',
                      subtitle: 'Active customers',
                    ),

                    _StatCard(
                      icon:
                          Icons.inventory_2_outlined,
                      title: 'Products',
                      value:
                          '${data.totalProducts}',
                      subtitle: 'In inventory',
                    ),

                    _StatCard(
                      icon:
                          Icons.warning_amber_rounded,
                      title: 'Low Stock',
                      value:
                          '${data.lowStockProducts}',
                      subtitle:
                          'Products need attention',
                    ),

                    _StatCard(
                      icon:
                          Icons.receipt_long_outlined,
                      title: 'Expenses',
                      value:
                          '$currency ${_format(data.totalExpenses)}',
                      subtitle:
                          '${data.totalExpensesCount} recorded',
                    ),

                    _StatCard(
                      icon:
                          Icons.account_balance_outlined,
                      title: 'Net Profit',
                      value:
                          '$currency ${_format(netProfit)}',
                      subtitle:
                          'Revenue minus expenses',
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // AI INSIGHT
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius:
                        BorderRadius.circular(18),
                    border: Border.all(
                      color: border,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: red.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: red,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BizOS AI',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              'Your AI business assistant is ready. Ask about sales, customers, products or business performance.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.8,
                  children: [
                    _ActionButton(
                      icon:
                          Icons.add_shopping_cart,
                      label: 'New Sale',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SalesScreen(),
                          ),
                        );
                      },
                    ),

                    _ActionButton(
                      icon:
                          Icons.person_add_alt_1,
                      label: 'Add Customer',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CustomersScreen(),
                          ),
                        );
                      },
                    ),

                    _ActionButton(
                      icon:
                          Icons.add_box_outlined,
                      label: 'Add Product',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ProductsScreen(),
                          ),
                        );
                      },
                    ),

                    _ActionButton(
                      icon:
                          Icons.receipt_long_outlined,
                      label: 'Expenses',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ExpensesScreen(),
                          ),
                        );
                      },
                    ),

                    _ActionButton(
                      icon:
                          Icons.bar_chart_rounded,
                      label: 'View Reports',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SubscriptionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _format(double value) {
    return value.toStringAsFixed(0);
  }
}

class _FinancialCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _FinancialCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            size: 23,
          ),
          const SizedBox(height: 12),
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
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(
                icon,
                color:
                    const Color(0xFFD71920),
                size: 23,
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color:
                      Color(0xFFA7A7AD),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(15),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151519),
          borderRadius:
              BorderRadius.circular(15),
          border: Border.all(
            color:
                const Color(0xFF29292F),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFFD71920),
              size: 19,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            Icon(
              icon,
              size: 20,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
