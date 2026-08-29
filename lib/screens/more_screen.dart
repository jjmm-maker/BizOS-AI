
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'subscription_screen.dart';
import 'auth/auth_gate.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          _buildProfileCard(),
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
            onTap: () {},
          ),

          _SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Currency',
            subtitle: 'Ugandan Shilling (UGX)',
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
            subtitle: 'Manage your BizOS plan',
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

  Widget _buildProfileCard() {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Business',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Business owner',
                  style: TextStyle(
                    color: Color(0xFFA7A7AD),
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
