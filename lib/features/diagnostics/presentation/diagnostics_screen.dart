import 'dart:async';

import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/theme/app_theme.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/features/diagnostics/domain/log_exporter.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Minimum severity level filter used in [DiagnosticsScreen].
enum _LogLevelFilter {
  all(Level.ALL),
  info(Level.INFO),
  warning(Level.WARNING),
  severe(Level.SEVERE);

  new(this.minLevel);

  final Level minLevel;
}

/// Live redacted diagnostic log viewer with level filtering, export, and
/// buffer clearing.
class DiagnosticsScreen extends StatefulWidget {
  /// Creates a [DiagnosticsScreen].
  const new({required this.logger, required this.logExporter, super.key});

  /// Application logger providing redacted diagnostic entries.
  final AppLogger logger;

  /// Exporter invoked when the user taps Export logs.
  final LogExporter logExporter;

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  _LogLevelFilter _filter = _LogLevelFilter.all;

  Future<void> _exportLogs() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = widget.logger.exportAsText();

    if (text.trim().isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.diagnosticsExportEmpty)),
      );
      return;
    }

    try {
      await widget.logExporter.exportLogs(text);
    } on Exception catch (err) {
      widget.logger.warning(
        'Failed to export diagnostic logs',
        scope: 'diagnostics',
        error: err,
      );
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.diagnosticsExportFailed)),
        );
      }
    }
  }

  void _clearLogs() {
    setState(() {
      widget.logger.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    final filtered = widget.logger.entries
        .where((entry) => entry.level >= _filter.minLevel)
        .toList()
        .reversed
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diagnosticsTitle),
        actions: <Widget>[
          IconButton(
            key: const Key('diagnostics_export_button'),
            tooltip: l10n.diagnosticsExportTooltip,
            onPressed: _exportLogs,
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            key: const Key('diagnostics_clear_button'),
            tooltip: l10n.diagnosticsClearTooltip,
            onPressed: _clearLogs,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                _buildFilterChip(
                  filter: _LogLevelFilter.all,
                  label: l10n.diagnosticsFilterAll,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  filter: _LogLevelFilter.info,
                  label: l10n.diagnosticsFilterInfo,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  filter: _LogLevelFilter.warning,
                  label: l10n.diagnosticsFilterWarning,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  filter: _LogLevelFilter.severe,
                  label: l10n.diagnosticsFilterError,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.diagnosticsEmpty,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _LogEntryCard(entry: filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required _LogLevelFilter filter,
    required String label,
  }) {
    return FilterChip(
      selected: _filter == filter,
      label: Text(label),
      onSelected: (_) {
        setState(() {
          _filter = filter;
        });
      },
    );
  }
}

class _LogEntryCard extends StatelessWidget {
  const new({required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;
    final isError = entry.level >= Level.SEVERE;
    final isWarning = entry.level == Level.WARNING;

    final badgeColor = isError
        ? theme.colorScheme.errorContainer
        : isWarning
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.surfaceContainerHigh;
    final badgeTextColor = isError
        ? theme.colorScheme.onErrorContainer
        : isWarning
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onSurface;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entry.level.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: badgeTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.loggerName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  entry.timestamp.toUtc().toIso8601String().substring(11, 19),
                  style: AppTheme.tabularFigureStyle(
                    theme.textTheme.labelSmall!.copyWith(
                      color: tokens.subtleMetaText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(entry.message, style: theme.textTheme.bodyMedium),
            if (entry.error != null && entry.error!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 6),
              SelectableText(
                entry.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
