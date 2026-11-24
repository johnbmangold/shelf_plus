import 'package:material_ui/material_ui.dart';

/// Supported sort orders in the Library browser.
enum BookSortOrder {
  /// Alphabetical by title (A–Z).
  titleAsc,

  /// Alphabetical by primary author (A–Z).
  authorAsc,

  /// Most recently added to Audiobookshelf first.
  addedDesc,

  /// Longest total duration first.
  durationDesc,
}

/// Supported progress filters in the Library browser.
enum BookFilterMode {
  /// Show every book regardless of progress.
  all,

  /// Show books with `0 < progress < 1` and not finished.
  inProgress,

  /// Show books marked finished.
  finished,

  /// Show unstarted books (`position == 0` and not finished).
  notStarted,
}

/// Domain representation of an Audiobookshelf library.
@immutable
class LibrarySummary {
  /// Creates a [LibrarySummary].
  const new({
    required this.id,
    required this.name,
    required this.mediaType,
    required this.icon,
    required this.displayOrder,
  });

  /// Library ID.
  final String id;

  /// Display name.
  final String name;

  /// Media type (`book` in v1).
  final String mediaType;

  /// Icon identifier.
  final String icon;

  /// Sort order.
  final int displayOrder;
}

/// Domain listening progress for an audiobook.
@immutable
class BookProgress {
  /// Creates a [BookProgress].
  const new({
    required this.positionSec,
    required this.durationSec,
    required this.progress,
    required this.isFinished,
    required this.hideFromContinueListening,
    required this.updatedAtMs,
  });

  /// Active listening position in seconds.
  final double positionSec;

  /// Book duration in seconds.
  final double durationSec;

  /// Completion fraction in `[0.0, 1.0]`.
  final double progress;

  /// Whether finished.
  final bool isFinished;

  /// Whether hidden from Continue Listening.
  final bool hideFromContinueListening;

  /// Latest update timestamp (UTC ms).
  final int updatedAtMs;

  /// Remaining seconds left in the audiobook.
  double get remainingSec =>
      (durationSec - positionSec).clamp(0, durationSec).toDouble();

  /// Whether the book is actively in progress.
  bool get isInProgress => !isFinished && positionSec > 0 && progress < 0.999;
}

/// Series reference associated with a book.
@immutable
class SeriesRef {
  /// Creates a [SeriesRef].
  const new({required this.id, required this.name, this.sequence});

  /// Series ID.
  final String id;

  /// Series name.
  final String name;

  /// Sequence string (e.g., `"1"` or `"2.5"`).
  final String? sequence;

  /// Numeric sort key parsed from [sequence], or `null` if non-numeric.
  double? get sequenceNumber =>
      sequence == null ? null : double.tryParse(sequence!.trim());
}

/// Lightweight audiobook model used in shelves, grids, and search results.
@immutable
class BookSummary {
  /// Creates a [BookSummary].
  const new({
    required this.id,
    required this.serverId,
    required this.libraryId,
    required this.title,
    required this.authorsDisplay,
    required this.authorNames,
    required this.narratorsDisplay,
    required this.narratorNames,
    required this.seriesRefs,
    required this.genres,
    required this.durationSec,
    required this.numChapters,
    required this.hasCover,
    required this.addedAtMs,
    this.subtitle,
    this.seriesName,
    this.seriesSequence,
    this.description,
    this.publisher,
    this.publishedYear,
    this.progress,
  });

  /// Library item ID.
  final String id;

  /// Server profile ID.
  final String serverId;

  /// Library ID.
  final String libraryId;

  /// Book title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Display-ready comma-separated authors.
  final String authorsDisplay;

  /// Individual author names.
  final List<String> authorNames;

  /// Display-ready comma-separated narrators.
  final String narratorsDisplay;

  /// Individual narrator names.
  final List<String> narratorNames;

  /// Primary series name.
  final String? seriesName;

  /// Primary series sequence.
  final String? seriesSequence;

  /// All series memberships.
  final List<SeriesRef> seriesRefs;

  /// Genres list.
  final List<String> genres;

  /// Optional synopsis.
  final String? description;

  /// Optional publisher.
  final String? publisher;

  /// Optional published year.
  final String? publishedYear;

  /// Total audio duration in seconds.
  final double durationSec;

  /// Chapter count.
  final int numChapters;

  /// Whether a cover exists on the server.
  final bool hasCover;

  /// Added timestamp (ms).
  final int addedAtMs;

  /// Optional listening progress.
  final BookProgress? progress;

  /// Remaining seconds left.
  double get remainingSec => progress?.remainingSec ?? durationSec;

  /// Completion fraction `[0.0, 1.0]`.
  double get completionRatio {
    if (progress == null) return 0;
    if (progress!.isFinished) return 1;
    if (progress!.progress > 0) return progress!.progress.clamp(0, 1);
    if (durationSec <= 0) return 0;
    return (progress!.positionSec / durationSec).clamp(0, 1);
  }
}

/// Chapter metadata for an audiobook.
@immutable
class ChapterInfo {
  /// Creates a [ChapterInfo].
  const new({
    required this.index,
    required this.title,
    required this.startSec,
    required this.endSec,
  });

  /// Zero-based chapter index.
  final int index;

  /// Chapter title.
  final String title;

  /// Start offset in seconds.
  final double startSec;

  /// End offset in seconds.
  final double endSec;

  /// Chapter duration in seconds.
  double get durationSec => (endSec - startSec).clamp(0, double.infinity);
}

/// User bookmark entry for an audiobook.
@immutable
class BookmarkEntry {
  /// Creates a [BookmarkEntry].
  const new({
    required this.timeSec,
    required this.title,
    required this.createdAtMs,
    this.note,
  });

  /// Timestamp in seconds.
  final double timeSec;

  /// Bookmark title.
  final String title;

  /// Optional extended note.
  final String? note;

  /// Creation timestamp (ms).
  final int createdAtMs;
}

/// Expanded audiobook detail combining summary, chapters, and bookmarks.
@immutable
class BookDetail {
  /// Creates a [BookDetail].
  const new({
    required this.book,
    required this.chapters,
    required this.bookmarks,
  });

  /// Core book summary and metadata.
  final BookSummary book;

  /// Ordered chapters.
  final List<ChapterInfo> chapters;

  /// Ordered bookmarks.
  final List<BookmarkEntry> bookmarks;
}

/// Aggregated series group for the Library Series browser.
@immutable
class SeriesGroup {
  /// Creates a [SeriesGroup].
  const new({required this.name, required this.books});

  /// Series name.
  final String name;

  /// Books ordered by series sequence then title.
  final List<BookSummary> books;
}

/// Aggregated author group for the Library Authors browser.
@immutable
class AuthorGroup {
  /// Creates an [AuthorGroup].
  const new({required this.name, required this.books});

  /// Author name.
  final String name;

  /// Books by this author ordered by title.
  final List<BookSummary> books;
}

/// Domain collection for the Library Collections browser.
@immutable
class BookCollection {
  /// Creates a [BookCollection].
  const new({
    required this.id,
    required this.libraryId,
    required this.name,
    required this.books,
    this.description,
  });

  /// Collection ID.
  final String id;

  /// Library ID.
  final String libraryId;

  /// Collection name.
  final String name;

  /// Optional collection description.
  final String? description;

  /// Books belonging to this collection that are present in local cache.
  final List<BookSummary> books;
}

/// Pure formatting helpers for audiobook durations and chapter timestamps.
abstract final class DurationFormatter {
  /// Formats [seconds] compactly (for example, `"4h 12m"` or `"38m"`).
  static String formatShort(double seconds) {
    final totalMinutes = (seconds / 60).round().clamp(0, 999999);
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    if (minutes > 0) return '${minutes}m';
    return '< 1m';
  }

  /// Formats [seconds] as a tabular timestamp (`HH:MM:SS` or `MM:SS`).
  static String formatTimestamp(double seconds) {
    final total = seconds.floor().clamp(0, 359999);
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    final secs = total % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = secs.toString().padLeft(2, '0');
    if (hours > 0) {
      final hh = hours.toString().padLeft(2, '0');
      return '$hh:$mm:$ss';
    }
    return '$mm:$ss';
  }
}

/// Pure grouping, sorting, and filtering helpers for [BookSummary] lists.
abstract final class LibraryCatalogHelpers {
  /// Filters and sorts [books] according to [filter] and [sort].
  static List<BookSummary> applyFilterAndSort(
    List<BookSummary> books, {
    required BookFilterMode filter,
    required BookSortOrder sort,
  }) {
    final filtered =
        books
            .where((book) {
              final p = book.progress;
              return switch (filter) {
                BookFilterMode.all => true,
                BookFilterMode.inProgress => p != null && p.isInProgress,
                BookFilterMode.finished => p != null && p.isFinished,
                BookFilterMode.notStarted =>
                  p == null || (!p.isFinished && p.positionSec <= 0),
              };
            })
            .toList(growable: true)
          ..sort((a, b) {
            return switch (sort) {
              BookSortOrder.titleAsc => a.title.toLowerCase().compareTo(
                b.title.toLowerCase(),
              ),
              BookSortOrder.authorAsc =>
                a.authorsDisplay.toLowerCase().compareTo(
                  b.authorsDisplay.toLowerCase(),
                ),
              BookSortOrder.addedDesc => b.addedAtMs.compareTo(a.addedAtMs),
              BookSortOrder.durationDesc => b.durationSec.compareTo(
                a.durationSec,
              ),
            };
          });

    return List<BookSummary>.unmodifiable(filtered);
  }

  /// Groups [books] into sorted [SeriesGroup]s ordered by series sequence.
  static List<SeriesGroup> groupBySeries(List<BookSummary> books) {
    final map = <String, List<BookSummary>>{};
    for (final book in books) {
      final refs = book.seriesRefs;
      if (refs.isNotEmpty) {
        for (final ref in refs) {
          if (ref.name.isEmpty) continue;
          map.putIfAbsent(ref.name, () => <BookSummary>[]).add(book);
        }
      } else if (book.seriesName != null && book.seriesName!.isNotEmpty) {
        map.putIfAbsent(book.seriesName!, () => <BookSummary>[]).add(book);
      }
    }

    final groups = <SeriesGroup>[];
    final sortedNames = map.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (final name in sortedNames) {
      final list = map[name]!
        ..sort((a, b) {
          final seqA = _sequenceForSeries(a, name);
          final seqB = _sequenceForSeries(b, name);
          if (seqA != null && seqB != null) {
            final cmp = seqA.compareTo(seqB);
            if (cmp != 0) return cmp;
          } else if (seqA != null) {
            return -1;
          } else if (seqB != null) {
            return 1;
          }
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
      groups.add(
        SeriesGroup(name: name, books: List<BookSummary>.unmodifiable(list)),
      );
    }
    return List<SeriesGroup>.unmodifiable(groups);
  }

  /// Groups [books] into sorted [AuthorGroup]s.
  static List<AuthorGroup> groupByAuthor(List<BookSummary> books) {
    final map = <String, List<BookSummary>>{};
    for (final book in books) {
      if (book.authorNames.isEmpty) continue;
      for (final author in book.authorNames) {
        if (author.isEmpty) continue;
        map.putIfAbsent(author, () => <BookSummary>[]).add(book);
      }
    }

    final sortedAuthors = map.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return List<AuthorGroup>.unmodifiable(<AuthorGroup>[
      for (final author in sortedAuthors)
        AuthorGroup(
          name: author,
          books: List<BookSummary>.unmodifiable(
            map[author]!..sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            ),
          ),
        ),
    ]);
  }

  static double? _sequenceForSeries(BookSummary book, String seriesName) {
    for (final ref in book.seriesRefs) {
      if (ref.name == seriesName) return ref.sequenceNumber;
    }
    if (book.seriesName == seriesName && book.seriesSequence != null) {
      return double.tryParse(book.seriesSequence!.trim());
    }
    return null;
  }
}
