import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/subscription_service.dart';
import 'auth/auth_gate.dart';
import 'reports_screen.dart';
import 'subscription_screen.dart';
import 'business_profile_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = AuthService.instance.currentAccount;
    final subscription = SubscriptionService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0D),
        title: const Text(
          'More',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileCard(account),
          const SizedBox(height: 28),

          const Text(
            'Business',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: Icons.business_outlined,
            title: 'Business Profile',
            subtitle: 'Manage your business information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BusinessProfileScreen(),
                ),
              );
            },
          ),

          _SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Currency',
            subtitle: account?.currency == 'UGX'
                ? 'Ugandan Shilling (UGX)'
                : account?.currency ?? 'Not set',
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.notifications_none_outlined,
            title: 'Notifications',
            subtitle: 'Manage business alerts',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          const Text(
            'Reports',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: subscription.hasReports
                ? Icons.bar_chart_outlined
                : Icons.lock_outline,
            title: 'Business Reports',
            subtitle: subscription.hasReports
                ? 'View business performance and insights'
                : 'Upgrade your plan to unlock reports',
            onTap: () {
              if (!subscription.hasReports) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF151519),
                      title: const Text(
                        'Reports are locked',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      content: const Text(
                        'Business Reports are available on the Basic, Pro and Advanced plans.',
                        style: TextStyle(
                          color: Color(0xFFA7A7AD),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFFA7A7AD),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SubscriptionScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD71920),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Plans'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Security',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Security',
            subtitle: 'PIN, authentication and privacy',
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.backup_outlined,
            title: 'Backup & Data',
            subtitle: 'Manage your business data',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          const Text(
            'Subscription',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Subscription & Plans',
            subtitle: account?.subscriptionName ??
                'Free',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubscriptionScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'App',
            style: TextStyle(
              color: Color(0xFFA7A7AD),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About BizOS',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with BizOS',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            subtitle: 'Sign out of your BizOS account',
            onTap: () async {
              await AuthService.instance.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const AuthGate(),
                ),
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              'BizOS AI',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              'Business Operating System',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.22),
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileCard(dynamic account) {
    final businessName =
        account?.businessName ?? 'My Business';

    final ownerName =
        account?.fullName ?? 'Business owner';

    final subscription =
        account?.subscriptionName ?? 'Free';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF241014),
            Color(0xFF151519),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3A2024),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFD71920),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  ownerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFA7A7AD),
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD71920)
                        .withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                  child: Text(
                    '$subscription PLAN',
                    style: const TextStyle(
                      color: Color(0xFFF04444),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFFA7A7AD),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF19191D),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFD71920),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFFA7A7AD),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF6E6E75),
      ),
      onTap: onTap,
    );
  }
}
