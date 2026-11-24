import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Settings tab for server account, appearance, diagnostics, and flavor info.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const new({
    required this.themeController,
    required this.flavorConfig,
    required this.authController,
    required this.diagnosticsRoute,
    super.key,
  });

  /// Controller managing the active [AppThemeMode].
  final ThemeController themeController;

  /// Active build flavor configuration.
  final FlavorConfig flavorConfig;

  /// Active authentication controller.
  final AuthController authController;

  /// Route path opened when tapping Diagnostics.
  final String diagnosticsRoute;

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsSignOutTitle),
        content: Text(l10n.settingsSignOutBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            key: const Key('confirm_sign_out_button'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await authController.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListenableBuilder(
              listenable: authController,
              builder: (context, _) {
                final session = authController.session;
                if (session == null) return const SizedBox.shrink();
                final version = session.serverVersion;
                final subtitleParts = <String>[
                  session.username,
                  session.baseUrl,
                  if (version != null && version.isNotEmpty)
                    l10n.settingsVersionPrefix(version),
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.settingsServerSection,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.dns_outlined),
                            title: Text(session.displayName),
                            subtitle: Text(subtitleParts.join(' • ')),
                          ),
                          const Divider(),
                          ListTile(
                            key: const Key('settings_sign_out_tile'),
                            leading: Icon(
                              Icons.logout,
                              color: theme.colorScheme.error,
                            ),
                            title: Text(
                              l10n.settingsSignOut,
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                            onTap: () => unawaited(_confirmSignOut(context)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
            Text(l10n.settingsAppearance, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListenableBuilder(
                  listenable: themeController,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.settingsThemeLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: tokens.subtleMetaText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<AppThemeMode>(
                            showSelectedIcon: false,
                            segments: <ButtonSegment<AppThemeMode>>[
                              ButtonSegment<AppThemeMode>(
                                value: AppThemeMode.system,
                                label: Text(l10n.themeSystem),
                              ),
                              ButtonSegment<AppThemeMode>(
                                value: AppThemeMode.light,
                                label: Text(l10n.themeLight),
                              ),
                              ButtonSegment<AppThemeMode>(
                                value: AppThemeMode.dark,
                                label: Text(l10n.themeDark),
                              ),
                              ButtonSegment<AppThemeMode>(
                                value: AppThemeMode.amoled,
                                label: Text(l10n.themeAmoled),
                              ),
                            ],
                            selected: <AppThemeMode>{themeController.mode},
                            onSelectionChanged: (selected) {
                              themeController.setMode(selected.first);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.settingsEnvironment, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    key: const Key('settings_diagnostics_tile'),
                    leading: const Icon(Icons.article_outlined),
                    title: Text(l10n.settingsDiagnosticsTitle),
                    subtitle: Text(l10n.settingsDiagnosticsSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => unawaited(context.push(diagnosticsRoute)),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(l10n.settingsFlavorLabel),
                    trailing: Text(
                      flavorConfig.flavor.name.toUpperCase(),
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(l10n.settingsBundleIdLabel),
                    subtitle: Text(flavorConfig.applicationId),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
