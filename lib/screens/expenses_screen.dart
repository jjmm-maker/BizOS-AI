import 'package:flutter/material.dart';

import '../services/business_data_service.dart';
import '../services/database_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const border = Color(0xFF29292F);
  static const muted = Color(0xFFA7A7AD);

  final List<Expense> _expenses = [];

  final DatabaseService _database =
      DatabaseService.instance;

  final BusinessDataService _service =
      BusinessDataService.instance;

  bool _loading = true;

  double get totalExpenses {
    return _expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final savedExpenses =
        await _database.getExpenses();

    final expenses = savedExpenses.map((item) {
      return Expense(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? '',
        amount:
            (item['amount'] as num?)?.toDouble() ?? 0,
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
      _expenses
        ..clear()
        ..addAll(expenses);
      _loading = false;
    });

    _updateBusinessData();
  }

  Future<void> _saveExpenses() async {
    await _database.saveExpenses(
      _expenses.map((expense) => expense.toMap()).toList(),
    );
  }

  void _updateBusinessData() {
    _service.setExpenseTotal(totalExpenses);
    _service.setExpenseCount(_expenses.length);
  }

  void _showAddExpense() {
    final titleController =
        TextEditingController();

    final amountController =
        TextEditingController();

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
            MediaQuery.of(context)
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
                      Icons.receipt_long_outlined,
                      color: red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New Expense',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              TextField(
                controller: titleController,
                textInputAction:
                    TextInputAction.next,
                decoration:
                    const InputDecoration(
                  labelText: 'Expense title',
                  prefixIcon: Icon(
                    Icons.description_outlined,
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
                decoration:
                    const InputDecoration(
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
                    final title =
                        titleController.text
                            .trim();

                    final amount =
                        double.tryParse(
                      amountController.text
                          .trim(),
                    );

                    if (title.isEmpty ||
                        amount == null ||
                        amount <= 0) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid expense and amount.',
                          ),
                        ),
                      );
                      return;
                    }

                    final expense = Expense(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      title: title,
                      amount: amount,
                      date: DateTime.now(),
                    );

                    setState(() {
                      _expenses.insert(
                        0,
                        expense,
                      );
                    });

                    await _saveExpenses();

                    _updateBusinessData();

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_rounded,
                  ),
                  label: const Text(
                    'Record Expense',
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
          'Expenses',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: red,
        foregroundColor: Colors.white,
        onPressed: _showAddExpense,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Expense',
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
              padding:
                  const EdgeInsets.fromLTRB(
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
                    'Track your expenses',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Monitor business spending and recent expenses.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(20),
                    decoration:
                        BoxDecoration(
                      color: card,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration:
                              BoxDecoration(
                            color: red.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .account_balance_wallet_outlined,
                            color: red,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Total Expenses',
                              style: TextStyle(
                                color: muted,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'UGX ${totalExpenses.toStringAsFixed(0)}',
                              style:
                                  const TextStyle(
                                fontSize: 25,
                                fontWeight:
                                    FontWeight
                                        .w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (_expenses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 50,
                        horizontal: 20,
                      ),
                      decoration:
                          BoxDecoration(
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
                            Icons
                                .receipt_long_outlined,
                            size: 52,
                            color: muted,
                          ),
                          SizedBox(height: 14),
                          Text(
                            'No expenses yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Record your first expense to start tracking spending.',
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
                    ..._expenses.map(
                      (expense) =>
                          _ExpenseTile(
                        expense: expense,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

class _ExpenseTile extends StatelessWidget {
  static const red = Color(0xFFD71920);
  static const muted = Color(0xFFA7A7AD);

  final Expense expense;

  const _ExpenseTile({
    required this.expense,
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  red.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: red,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${expense.date.day.toString().padLeft(2, '0')}/'
                  '${expense.date.month.toString().padLeft(2, '0')}/'
                  '${expense.date.year} • '
                  '${expense.date.hour.toString().padLeft(2, '0')}:'
                  '${expense.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            'UGX ${expense.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
