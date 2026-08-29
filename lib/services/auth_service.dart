import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/subscription_plan.dart';
import '../models/user_account.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();

  factory AuthService() {
    return instance;
  }

  AuthService._internal();

  UserAccount? _account;
  bool _isLoggedIn = false;
  bool _initialized = false;

  UserAccount? get currentAccount => _account;

  bool get hasAccount => _account != null;

  bool get isLoggedIn => _isLoggedIn;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('account_id');
    final fullName = prefs.getString('account_full_name');
    final email = prefs.getString('account_email');
    final phone = prefs.getString('account_phone');
    final businessName = prefs.getString('account_business_name');
    final businessType = prefs.getString('account_business_type');
    final country = prefs.getString('account_country');
    final currency = prefs.getString('account_currency');
    final password = prefs.getString('account_password');
    final subscriptionPlan =
        prefs.getString('account_subscription_plan') ?? 'Free';

    final savedSession =
        prefs.getBool('is_logged_in') ?? false;

    if (id != null &&
        fullName != null &&
        email != null &&
        phone != null &&
        businessName != null &&
        businessType != null &&
        country != null &&
        currency != null &&
        password != null) {
      final plan =
          SubscriptionPlan.fromName(subscriptionPlan);

      _account = UserAccount(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        businessName: businessName,
        businessType: businessType,
        country: country,
        currency: currency,
        password: password,
        subscriptionTier: plan.tier,
      );

      _isLoggedIn = savedSession;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> createAccount({
    required String fullName,
    required String email,
    required String phone,
    required String businessName,
    required String businessType,
    required String country,
    required String currency,
    required String password,
  }) async {
    final account = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      businessName: businessName.trim(),
      businessType: businessType,
      country: country,
      currency: currency,
      password: password,
      subscriptionTier: SubscriptionTier.free,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('account_id', account.id);
    await prefs.setString('account_full_name', account.fullName);
    await prefs.setString('account_email', account.email);
    await prefs.setString('account_phone', account.phone);
    await prefs.setString(
      'account_business_name',
      account.businessName,
    );
    await prefs.setString(
      'account_business_type',
      account.businessType,
    );
    await prefs.setString(
      'account_country',
      account.country,
    );
    await prefs.setString(
      'account_currency',
      account.currency,
    );
    await prefs.setString(
      'account_password',
      account.password,
    );
    await prefs.setString(
      'account_subscription_plan',
      account.subscriptionName,
    );

    await prefs.setBool('is_logged_in', true);

    _account = account;
    _isLoggedIn = true;

    notifyListeners();
  }

  Future<void> changeSubscription(
    SubscriptionTier tier,
  ) async {
    if (_account == null) {
      return;
    }

    final updatedAccount = UserAccount(
      id: _account!.id,
      fullName: _account!.fullName,
      email: _account!.email,
      phone: _account!.phone,
      businessName: _account!.businessName,
      businessType: _account!.businessType,
      country: _account!.country,
      currency: _account!.currency,
      password: _account!.password,
      subscriptionTier: tier,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'account_subscription_plan',
      updatedAccount.subscriptionName,
    );

    _account = updatedAccount;

    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    if (_account == null) {
      return false;
    }

    final emailMatches =
        _account!.email.toLowerCase() ==
        email.trim().toLowerCase();

    final passwordMatches =
        _account!.password == password;

    if (emailMatches && passwordMatches) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('is_logged_in', true);

      _isLoggedIn = true;

      notifyListeners();

      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('is_logged_in', false);

    _isLoggedIn = false;

    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('account_id');
    await prefs.remove('account_full_name');
    await prefs.remove('account_email');
    await prefs.remove('account_phone');
    await prefs.remove('account_business_name');
    await prefs.remove('account_business_type');
    await prefs.remove('account_country');
    await prefs.remove('account_currency');
    await prefs.remove('account_password');
    await prefs.remove('account_subscription_plan');
    await prefs.remove('is_logged_in');

    _account = null;
    _isLoggedIn = false;

    notifyListeners();
  }
}
