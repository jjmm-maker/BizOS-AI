import 'package:flutter/material.dart';

import '../models/user_account.dart';
import '../services/auth_service.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState
    extends State<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _businessType = 'Retail';
  String _country = 'Uganda';
  String _currency = 'UGX';

  final List<String> _businessTypes = [
    'Retail',
    'Wholesale',
    'Restaurant & Food',
    'Services',
    'Manufacturing',
    'Agriculture',
    'Technology',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final UserAccount? account =
        AuthService.instance.currentAccount;

    if (account != null) {
      _fullNameController.text = account.fullName;
      _businessNameController.text = account.businessName;
      _emailController.text = account.email;
      _phoneController.text = account.phone;

      _businessType = account.businessType;
      _country = account.country;
      _currency = account.currency;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFF151519),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF29292F),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF29292F),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFD71920),
          width: 1.5,
        ),
      ),
    );
  }

  void _showSavedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Business profile updated.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0D),
      appBar: AppBar(
        title: const Text(
          'Business Profile',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),
            children: [
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD71920),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Your Business',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Manage the information used across BizOS.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA7A7AD),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Full name',
                  icon: Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _businessNameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Business name',
                  icon: Icons.storefront_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your business name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Email address',
                  icon: Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your email address';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Phone number',
                  icon: Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _businessType,
                decoration: _inputDecoration(
                  label: 'Business type',
                  icon: Icons.business_outlined,
                ),
                dropdownColor: const Color(0xFF151519),
                items: _businessTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _businessType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _country,
                decoration: _inputDecoration(
                  label: 'Country',
                  icon: Icons.public_outlined,
                ),
                dropdownColor: const Color(0xFF151519),
                items: const [
                  DropdownMenuItem(
                    value: 'Uganda',
                    child: Text('Uganda'),
                  ),
                  DropdownMenuItem(
                    value: 'Kenya',
                    child: Text('Kenya'),
                  ),
                  DropdownMenuItem(
                    value: 'Tanzania',
                    child: Text('Tanzania'),
                  ),
                  DropdownMenuItem(
                    value: 'Rwanda',
                    child: Text('Rwanda'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _country = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _currency,
                decoration: _inputDecoration(
                  label: 'Currency',
                  icon: Icons.payments_outlined,
                ),
                dropdownColor: const Color(0xFF151519),
                items: const [
                  DropdownMenuItem(
                    value: 'UGX',
                    child: Text('Ugandan Shilling (UGX)'),
                  ),
                  DropdownMenuItem(
                    value: 'KES',
                    child: Text('Kenyan Shilling (KES)'),
                  ),
                  DropdownMenuItem(
                    value: 'TZS',
                    child: Text('Tanzanian Shilling (TZS)'),
                  ),
                  DropdownMenuItem(
                    value: 'RWF',
                    child: Text('Rwandan Franc (RWF)'),
                  ),
                  DropdownMenuItem(
                    value: 'USD',
                    child: Text('US Dollar (USD)'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _currency = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD71920),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
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

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showSavedMessage();
  }
}
