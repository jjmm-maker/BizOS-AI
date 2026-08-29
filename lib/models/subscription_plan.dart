enum SubscriptionTier {
  free,
  basic,
  pro,
  advanced,
}

class SubscriptionPlan {
  final SubscriptionTier tier;
  final String name;
  final int priceUgx;
  final bool basicAI;
  final bool advancedAI;
  final bool basicReports;
  final bool advancedReports;
  final int maxUsers;
  final bool socialMediaAI;

  const SubscriptionPlan({
    required this.tier,
    required this.name,
    required this.priceUgx,
    required this.basicAI,
    required this.advancedAI,
    required this.basicReports,
    required this.advancedReports,
    required this.maxUsers,
    required this.socialMediaAI,
  });

  bool get hasAI => basicAI || advancedAI;

  bool get hasReports => basicReports || advancedReports;

  bool get unlimitedUsers => maxUsers == -1;

  static const free = SubscriptionPlan(
    tier: SubscriptionTier.free,
    name: 'Free',
    priceUgx: 0,
    basicAI: false,
    advancedAI: false,
    basicReports: false,
    advancedReports: false,
    maxUsers: 1,
    socialMediaAI: false,
  );

  static const basic = SubscriptionPlan(
    tier: SubscriptionTier.basic,
    name: 'Basic',
    priceUgx: 50000,
    basicAI: true,
    advancedAI: false,
    basicReports: false,
    advancedReports: false,
    maxUsers: 1,
    socialMediaAI: false,
  );

  static const pro = SubscriptionPlan(
    tier: SubscriptionTier.pro,
    name: 'Pro',
    priceUgx: 100000,
    basicAI: true,
    advancedAI: false,
    basicReports: true,
    advancedReports: false,
    maxUsers: 1,
    socialMediaAI: false,
  );

  static const advanced = SubscriptionPlan(
    tier: SubscriptionTier.advanced,
    name: 'Advanced',
    priceUgx: 250000,
    basicAI: true,
    advancedAI: true,
    basicReports: true,
    advancedReports: true,
    maxUsers: -1,
    socialMediaAI: true,
  );

  static const List<SubscriptionPlan> all = [
    free,
    basic,
    pro,
    advanced,
  ];

  static SubscriptionPlan fromName(String name) {
    switch (name.toLowerCase()) {
      case 'basic':
        return basic;
      case 'pro':
        return pro;
      case 'advanced':
        return advanced;
      case 'free':
      default:
        return free;
    }
  }
}
