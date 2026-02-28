import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc_boilerplate/blocs/bloc.dart';
import 'package:bloc_boilerplate/ui/widgets/theme_toggle_button.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool _showBalance = false;
  Timer? _balanceTimer;

  void _toggleBalance() {
    setState(() {
      _showBalance = !_showBalance;
    });

    _balanceTimer?.cancel();
    _balanceTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showBalance) {
        setState(() {
          _showBalance = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _balanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AppBloc.userCubit.state;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            const ThemeToggleButton(),
            IconButton(
              onPressed: () {
                AppBloc.authenticateCubit.onLock();
              },
              icon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).primaryColor,
              ),
              tooltip: "Lock App",
            ),
            IconButton(
              onPressed: () {
                AppBloc.authenticateCubit.onLogout();
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              tooltip: "Logout",
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            centerTitle: false,
            title: Text(
              "Hello, ${user?.name ?? 'User'}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _toggleBalance,
                  child: _buildBalanceCard(context),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(context, "Quick Actions"),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  context,
                  "Recent Transactions",
                  onSeeAll: () {
                    // In a real app, this might switch the tab or navigate
                  },
                ),
                const SizedBox(height: 16),
                _buildRecentTransactions(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _showBalance ? "\$45,230.00" : "********",
              key: ValueKey<bool>(_showBalance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceDetail("Card Number", "**** 4521"),
              _buildBalanceDetail("Expiry", "12/26"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              "See All",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(context, Icons.add_circle_outline, "Top Up"),
        _buildActionItem(context, Icons.swap_horiz_rounded, "Transfer"),
        _buildActionItem(
          context,
          Icons.account_balance_wallet_outlined,
          "Bills",
        ),
        _buildActionItem(context, Icons.more_horiz_rounded, "More"),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        final titles = ["Netflix Subscription", "Apple Store", "Grocery Store"];
        final dates = ["Feb 28, 2026", "Feb 27, 2026", "Feb 25, 2026"];
        final amounts = ["-\$12.99", "-\$99.00", "-\$45.50"];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              index == 0
                  ? Icons.movie_outlined
                  : index == 1
                  ? Icons.apple
                  : Icons.shopping_basket_outlined,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          title: Text(
            titles[index],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            dates[index],
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          trailing: Text(
            amounts[index],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        );
      },
    );
  }
}
