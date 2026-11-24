import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';

/// Offline-first repository providing reactive library streams, instant FTS5
/// search, server synchronization, and live Socket.IO event ingestion.
abstract interface class LibraryRepository {
  /// Watches cached audiobook libraries for [serverId].
  Stream<List<LibrarySummary>> watchLibraries(String serverId);

  /// Watches cached books with joined progress for [serverId], optionally
  /// scoped to [libraryId].
  Stream<List<BookSummary>> watchBooks(String serverId, {String? libraryId});

  /// Watches expanded details (book, chapters, bookmarks) for [itemId].
  Stream<BookDetail?> watchBookDetail(String serverId, String itemId);

  /// Watches collections for [libraryId], hydrated with cached books.
  Stream<List<BookCollection>> watchCollections(
    String serverId,
    String libraryId,
  );

  /// Runs an instant offline FTS5 search across cached books for [serverId].
  Future<List<BookSummary>> searchBooks({
    required String serverId,
    required String query,
    String? libraryId,
  });

  /// Synchronizes libraries, items, progress, bookmarks, and collections for
  /// [session] into local Drift storage.
  Future<void> syncAll(ServerSession session);

  /// Fetches and caches expanded chapters and metadata for [itemId].
  Future<void> syncBookDetail(ServerSession session, String itemId);

  /// Applies a real-time [event] received from the server Socket.IO stream.
  Future<void> handleSocketEvent(String serverId, AbsSocketEvent event);
}
