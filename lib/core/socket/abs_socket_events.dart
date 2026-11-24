import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';

/// Base sealed event emitted by `AbsSocketService`.
@immutable
sealed class AbsSocketEvent {
  /// Creates an [AbsSocketEvent].
  const new();
}

/// Emitted when a library item's metadata or chapters are updated on the
/// server.
class LibraryItemUpdatedEvent extends AbsSocketEvent {
  /// Creates a [LibraryItemUpdatedEvent].
  const new(this.item);

  /// Updated library item DTO.
  final AbsBookItemDto item;
}

/// Emitted when a new library item is added to an Audiobookshelf library.
class LibraryItemAddedEvent extends AbsSocketEvent {
  /// Creates a [LibraryItemAddedEvent].
  const new(this.item);

  /// Added library item DTO.
  final AbsBookItemDto item;
}

/// Emitted when a library item is removed on the server.
class LibraryItemRemovedEvent extends AbsSocketEvent {
  /// Creates a [LibraryItemRemovedEvent].
  const new(this.itemId);

  /// Removed library item ID.
  final String itemId;
}

/// Emitted when the authenticated user's listening progress updates remotely.
class UserProgressUpdatedEvent extends AbsSocketEvent {
  /// Creates a [UserProgressUpdatedEvent].
  const new(this.progress);

  /// Updated progress DTO.
  final AbsMediaProgressDto progress;
}
