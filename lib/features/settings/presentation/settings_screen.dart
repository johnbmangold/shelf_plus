import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/app/flavor_config.dart';
import 'package:shelf_plus/core/theme/app_theme_mode.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/core/theme/theme_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Settings tab for appearance, flavor environment info, and diagnostics.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const new({
    required this.themeController,
    required this.flavorConfig,
    super.key,
  });

  /// Controller managing the active [AppThemeMode].
  final ThemeController themeController;

  /// Active build flavor configuration.
  final FlavorConfig flavorConfig;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
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
    );
  }
}
