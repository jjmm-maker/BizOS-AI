import 'package:flutter/material.dart';

import '../services/business_data_service.dart';
import '../services/database_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  static const red = Color(0xFFD71920);
  static const background = Color(0xFF0B0B0D);
  static const card = Color(0xFF151519);
  static const border = Color(0xFF29292F);
  static const muted = Color(0xFFA7A7AD);

  final List<Customer> _customers = [];

  final BusinessDataService _service =
      BusinessDataService.instance;

  final DatabaseService _database =
      DatabaseService.instance;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final savedCustomers = await _database.getCustomers();

    final customers = savedCustomers.map((item) {
      return Customer(
        id: item['id']?.toString() ?? '',
        name: item['name']?.toString() ?? '',
        phone: item['phone']?.toString() ?? '',
      );
    }).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _customers
        ..clear()
        ..addAll(customers);
      _loading = false;
    });

    _updateBusinessData();
  }

  Future<void> _saveCustomers() async {
    await _database.saveCustomers(
      _customers.map((customer) => customer.toMap()).toList(),
    );
  }

  void _updateBusinessData() {
    _service.setCustomerCount(_customers.length);
  }

  void _showAddCustomer() {
    _showCustomerForm();
  }

  void _showEditCustomer(Customer customer) {
    _showCustomerForm(customer: customer);
  }

  void _showCustomerForm({Customer? customer}) {
    final nameController =
        TextEditingController(text: customer?.name ?? '');

    final phoneController =
        TextEditingController(text: customer?.phone ?? '');

    final isEditing = customer != null;

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
            MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Customer' : 'New Customer',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Customer name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final phone = phoneController.text.trim();

                      if (name.isEmpty) {
                        ScaffoldMessenger.of(sheetContext)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Enter the customer name.',
                            ),
                          ),
                        );
                        return;
                      }

                      if (isEditing) {
                        final index = _customers.indexWhere(
                          (item) => item.id == customer.id,
                        );

                        if (index != -1) {
                          setState(() {
                            _customers[index] = Customer(
                              id: customer.id,
                              name: name,
                              phone: phone,
                            );
                          });
                        }
                      } else {
                        final newCustomer = Customer(
                          id: DateTime.now()
                              .microsecondsSinceEpoch
                              .toString(),
                          name: name,
                          phone: phone,
                        );

                        setState(() {
                          _customers.insert(0, newCustomer);
                        });
                      }

                      await _saveCustomers();
                      _updateBusinessData();

                      if (!sheetContext.mounted) {
                        return;
                      }

                      Navigator.pop(sheetContext);

                      if (!mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing
                                ? 'Customer updated successfully.'
                                : 'Customer added successfully.',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      isEditing
                          ? 'Save Changes'
                          : 'Add Customer',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      phoneController.dispose();
    });
  }

  void _showCustomerActions(Customer customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: red,
                      child: Text(
                        _initial(customer.name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            customer.phone.isEmpty
                                ? 'No phone number'
                                : customer.phone,
                            style: const TextStyle(
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Edit Customer',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showEditCustomer(customer);
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: red,
                  ),
                  title: const Text(
                    'Delete Customer',
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDeleteCustomer(customer);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteCustomer(
    Customer customer,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          title: const Text(
            'Delete Customer?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${customer.name}? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _customers.removeWhere(
        (item) => item.id == customer.id,
      );
    });

    await _saveCustomers();
    _updateBusinessData();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${customer.name} deleted.',
        ),
      ),
    );
  }

  String _initial(String name) {
    if (name.trim().isEmpty) {
      return '?';
    }

    return name.trim().substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Customers',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: red,
        foregroundColor: Colors.white,
        onPressed: _showAddCustomer,
        icon: const Icon(
          Icons.person_add_outlined,
        ),
        label: const Text(
          'Add Customer',
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
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                red.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.people_outline,
                            color: red,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Customers',
                              style: TextStyle(
                                color: muted,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '${_customers.length}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Customer List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: _customers.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 52,
                                  color: muted,
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'No customers yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Add your first customer to get started.',
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
                            itemCount: _customers.length,
                            itemBuilder:
                                (context, index) {
                              final customer =
                                  _customers[index];

                              return _CustomerTile(
                                customer: customer,
                                onTap: () {
                                  _showCustomerActions(
                                    customer,
                                  );
                                },
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

class Customer {
  final String id;
  final String name;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class _CustomerTile extends StatelessWidget {
  static const red = Color(0xFFD71920);
  static const muted = Color(0xFFA7A7AD);

  final Customer customer;
  final VoidCallback onTap;

  const _CustomerTile({
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = customer.name.isEmpty
        ? '?'
        : customer.name
            .substring(0, 1)
            .toUpperCase();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151519),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF29292F),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: red,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    customer.phone.isEmpty
                        ? 'No phone number'
                        : customer.phone,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: muted,
            ),
          ],
        ),
      ),
    );
  }
}