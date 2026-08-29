import 'subscription_plan.dart';

class UserAccount {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String businessName;
  final String businessType;
  final String country;
  final String currency;
  final String password;
  final SubscriptionTier subscriptionTier;

  UserAccount({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessType,
    required this.country,
    required this.currency,
    required this.password,
    required this.subscriptionTier,
  });

  SubscriptionPlan get subscription =>
      SubscriptionPlan.all.firstWhere(
        (plan) => plan.tier == subscriptionTier,
        orElse: () => SubscriptionPlan.free,
      );

  String get subscriptionName => subscription.name;

  int get subscriptionPriceUgx => subscription.priceUgx;
}
