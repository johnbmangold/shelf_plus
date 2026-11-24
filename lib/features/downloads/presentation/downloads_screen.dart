import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Downloads tab displaying background transfers and offline audiobooks.
class DownloadsScreen extends StatelessWidget {
  /// Creates a [DownloadsScreen].
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDownloads)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.download_for_offline_outlined,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.downloadsEmptyTitle,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.downloadsEmptySubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
