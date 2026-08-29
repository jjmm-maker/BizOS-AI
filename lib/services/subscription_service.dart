import 'package:flutter/foundation.dart';

import '../models/subscription_plan.dart';
import 'auth_service.dart';

class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService instance =
      SubscriptionService._internal();

  factory SubscriptionService() {
    return instance;
  }

  SubscriptionService._internal();

  SubscriptionPlan get currentPlan {
    final account = AuthService.instance.currentAccount;

    if (account == null) {
      return SubscriptionPlan.free;
    }

    return account.subscription;
  }

  SubscriptionTier get currentTier => currentPlan.tier;

  bool get hasAI => currentPlan.hasAI;

  bool get hasBasicAI => currentPlan.basicAI;

  bool get hasAdvancedAI => currentPlan.advancedAI;

  bool get hasReports => currentPlan.hasReports;

  bool get hasBasicReports => currentPlan.basicReports;

  bool get hasAdvancedReports => currentPlan.advancedReports;

  bool get hasSocialMediaAI => currentPlan.socialMediaAI;

  bool get hasUnlimitedUsers => currentPlan.unlimitedUsers;

  int get maxUsers => currentPlan.maxUsers;

  bool canUseAI({bool advanced = false}) {
    if (advanced) {
      return hasAdvancedAI;
    }

    return hasAI;
  }

  bool canUseReports({bool advanced = false}) {
    if (advanced) {
      return hasAdvancedReports;
    }

    return hasReports;
  }

  bool canAddUser(int currentUserCount) {
    if (hasUnlimitedUsers) {
      return true;
    }

    return currentUserCount < maxUsers;
  }

  void refresh() {
    notifyListeners();
  }
}
