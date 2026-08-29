import 'package:flutter/material.dart';

import '../models/subscription_plan.dart';
import '../services/auth_service.dart';
import '../services/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final currentPlan =
        SubscriptionService.instance.currentPlan;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0D),
        title: const Text(
          'Subscription & Plans',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Choose the plan that fits your business.',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 24),

          ...SubscriptionPlan.all.map(
            (plan) => _PlanCard(
              plan: plan,
              isCurrent: plan.tier == currentPlan.tier,
              onSelect: () => _selectPlan(plan),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Payment processing will be connected later.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6E6E75),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<void> _selectPlan(
    SubscriptionPlan plan,
  ) async {
    await AuthService.instance.changeSubscription(
      plan.tier,
    );

    SubscriptionService.instance.refresh();

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${plan.name} plan selected.',
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isCurrent;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.plan,
    required this.isCurrent,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151519),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent
              ? const Color(0xFFD71920)
              : const Color(0xFF29292F),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD71920),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            plan.priceUgx == 0
                ? 'Free'
                : 'UGX ${plan.priceUgx}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFFD71920),
            ),
          ),

          const SizedBox(height: 18),

          _FeatureRow(
            enabled: true,
            text: 'Core BizOS features',
          ),

          _FeatureRow(
            enabled: plan.hasAI,
            text: plan.advancedAI
                ? 'Advanced AI'
                : 'Basic AI',
          ),

          _FeatureRow(
            enabled: plan.hasReports,
            text: plan.advancedReports
                ? 'Advanced reports'
                : 'Basic reports',
          ),

          _FeatureRow(
            enabled: plan.unlimitedUsers,
            text: plan.unlimitedUsers
                ? 'Unlimited users'
                : '${plan.maxUsers} user',
          ),

          _FeatureRow(
            enabled: plan.socialMediaAI,
            text: 'Social-media AI',
          ),

          const SizedBox(height: 18),

          if (!isCurrent)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onSelect,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFFD71920),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  plan.priceUgx == 0
                      ? 'Select Free'
                      : 'Select ${plan.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final bool enabled;
  final String text;

  const _FeatureRow({
    required this.enabled,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 19,
            color: enabled
                ? const Color(0xFFD71920)
                : const Color(0xFF55555C),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: enabled
                    ? Colors.white
                    : const Color(0xFF6E6E75),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
