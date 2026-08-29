import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _businessType = 'Retail';
  String _country = 'Uganda';
  String _currency = 'UGX';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await AuthService.instance.createAccount(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      businessName: _businessNameController.text,
      businessType: _businessType,
      country: _country,
      currency: _currency,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
      (route) => false,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0D),
        elevation: 0,
        title: const Text(
          'Create Account',
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
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFD71920),
                size: 48,
              ),

              const SizedBox(height: 14),

              const Text(
                'Welcome to BizOS AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Create your business account to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA7A7AD),
                  fontSize: 14,
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your full name';
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
                  if (value == null || value.trim().isEmpty) {
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your phone number';
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your business name';
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

              const SizedBox(height: 14),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a password';
                  }

                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  label: 'Confirm password',
                  icon: Icons.lock_reset_outlined,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  }

                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD71920),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Already have a BizOS account? Log in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA7A7AD),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
