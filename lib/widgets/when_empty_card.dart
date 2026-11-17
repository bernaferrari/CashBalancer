import 'package:material_ui/material_ui.dart';

import '../app/theme.dart';
import '../l10n/l10n.dart';
import '../util/wallet_colors.dart';
import 'ledger.dart';

class const WhenEmptyCard({
  required final String title,
  required final String subtitle,
  final Widget? action,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BalanceIllustration(height: 150),
              const SizedBox(height: 32),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: context.ledger.muted),
              ),
              if (action != null) ...[const SizedBox(height: 28), ?action],
            ],
          ),
        ),
      ),
    );
  }
}

/// A peek at the sample portfolio: its three wallets as allocation bars.
class const SamplePortfolioTile({
  required final VoidCallback onPressed,
  super.key,
}) extends StatelessWidget {
  static const _wallets = [
    (WalletColor.emerald, 1.0),
    (WalletColor.amber, 0.66),
    (WalletColor.indigo, 0.38),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.ledger;
    final title = context.l10n.loadSamplePortfolio;
    return Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      onTap: onPressed,
      child: Material(
        color: l.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SegmentedColumn.outer),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  decoration: BoxDecoration(
                    color: l.sunken,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      for (final (color, width) in _wallets)
                        FractionallySizedBox(
                          widthFactor: width,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color.seed,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        context.l10n.sampleDescription,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: l.muted),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: l.faint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
