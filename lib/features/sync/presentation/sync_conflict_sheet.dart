import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/database/app_database.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/sync/domain/progress_conflict_resolver.dart';
import 'package:shelf_plus/features/sync/presentation/offline_sync_controller.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Opens the modal bottom sheet allowing the user to resolve divergent device
/// vs. server listening positions.
Future<void> showSyncConflictSheet({
  required BuildContext context,
  required OfflineSyncController syncController,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) =>
        _SyncConflictSheet(syncController: syncController),
  );
}

class _SyncConflictSheet extends StatelessWidget {
  const new({required this.syncController});

  final OfflineSyncController syncController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: syncController,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        final tokens = context.shelfTokens;
        final conflicts = syncController.conflicts;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  l10n.syncConflictSheetTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final row in conflicts)
                  _ConflictCard(
                    row: row,
                    tokens: tokens,
                    onChoose: (choice) async {
                      final wasLastConflict = conflicts.length <= 1;
                      await syncController.resolveConflict(
                        itemId: row.item.id,
                        choice: choice,
                      );
                      if (context.mounted && wasLastConflict) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConflictCard extends StatelessWidget {
  const new({required this.row, required this.tokens, required this.onChoose});

  final ConflictedProgressRow row;
  final ShelfThemeTokens tokens;
  final Future<void> Function(ConflictResolutionChoice choice) onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(row.item.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.syncConflictDeviceLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                      Text(
                        DurationFormatter.formatTimestamp(
                          row.progress.localPositionSec,
                        ),
                        key: Key('conflict_device_pos_${row.item.id}'),
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.syncConflictServerLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                      Text(
                        DurationFormatter.formatTimestamp(
                          row.progress.serverPositionSec,
                        ),
                        key: Key('conflict_server_pos_${row.item.id}'),
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                FilledButton(
                  key: Key('conflict_keep_device_${row.item.id}'),
                  onPressed: () {
                    unawaited(onChoose(ConflictResolutionChoice.keepDevice));
                  },
                  child: Text(l10n.syncConflictKeepDevice),
                ),
                OutlinedButton(
                  key: Key('conflict_use_server_${row.item.id}'),
                  onPressed: () {
                    unawaited(onChoose(ConflictResolutionChoice.useServer));
                  },
                  child: Text(l10n.syncConflictUseServer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
