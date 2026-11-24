import 'package:material_ui/material_ui.dart';

/// Parsed Audiobookshelf library DTO from `GET /api/libraries`.
@immutable
class AbsLibraryDto {
  /// Creates an [AbsLibraryDto].
  const new({
    required this.id,
    required this.name,
    required this.mediaType,
    required this.icon,
    required this.displayOrder,
  });

  /// Parses an [AbsLibraryDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsLibraryDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Library',
      mediaType: json['mediaType'] as String? ?? 'book',
      icon: json['icon'] as String? ?? 'book',
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  /// Library ID.
  final String id;

  /// Display name.
  final String name;

  /// Media type (`book`, `podcast`, etc.).
  final String mediaType;

  /// Icon name.
  final String icon;

  /// Sort display order.
  final int displayOrder;
}

/// Author entry inside a library item's metadata.
@immutable
class AbsAuthorDto {
  /// Creates an [AbsAuthorDto].
  const new({required this.id, required this.name});

  /// Parses an [AbsAuthorDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsAuthorDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  /// Author ID.
  final String id;

  /// Author name.
  final String name;

  /// Serializes to JSON.
  Map<String, Object?> toJson() => <String, Object?>{'id': id, 'name': name};
}

/// Series entry inside a library item's metadata.
@immutable
class AbsSeriesRefDto {
  /// Creates an [AbsSeriesRefDto].
  const new({required this.id, required this.name, this.sequence});

  /// Parses an [AbsSeriesRefDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsSeriesRefDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sequence: json['sequence']?.toString(),
    );
  }

  /// Series ID.
  final String id;

  /// Series name.
  final String name;

  /// Optional book position within the series.
  final String? sequence;

  /// Serializes to JSON.
  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'sequence': sequence,
  };
}

/// Chapter entry inside an expanded Audiobookshelf library item.
@immutable
class AbsChapterDto {
  /// Creates an [AbsChapterDto].
  const new({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
  });

  /// Parses an [AbsChapterDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsChapterDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      start: (json['start'] as num?)?.toDouble() ?? 0,
      end: (json['end'] as num?)?.toDouble() ?? 0,
      title: json['title'] as String? ?? '',
    );
  }

  /// Chapter ID/index.
  final int id;

  /// Start timestamp in seconds.
  final double start;

  /// End timestamp in seconds.
  final double end;

  /// Chapter title.
  final String title;
}

/// Parsed Audiobookshelf library item DTO (summary or expanded).
@immutable
class AbsBookItemDto {
  /// Creates an [AbsBookItemDto].
  const new({
    required this.id,
    required this.libraryId,
    required this.mediaType,
    required this.title,
    required this.authors,
    required this.narrators,
    required this.series,
    required this.genres,
    required this.tags,
    required this.durationSec,
    required this.numChapters,
    required this.hasCover,
    required this.addedAtMs,
    required this.updatedAtMs,
    required this.chapters,
    this.subtitle,
    this.description,
    this.publisher,
    this.publishedYear,
  });

  /// Resiliently parses a library item JSON object from `/items` or `/items/:id`.
  factory fromJson(Map<String, dynamic> json) {
    final media = json['media'] is Map<String, dynamic>
        ? json['media'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final metadata = media['metadata'] is Map<String, dynamic>
        ? media['metadata'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final authors = _parseAuthors(metadata);
    final narrators = _parseNarrators(metadata);
    final series = _parseSeries(metadata);
    final genres = _parseStringList(metadata['genres']);
    final tags = _parseStringList(media['tags']);

    final rawChapters = media['chapters'];
    final chapters = rawChapters is List
        ? rawChapters
              .whereType<Map<String, dynamic>>()
              .map(AbsChapterDto.fromJson)
              .toList(growable: false)
        : const <AbsChapterDto>[];

    final numChapters =
        (media['numChapters'] as num?)?.toInt() ?? chapters.length;
    final coverPath = media['coverPath'] as String?;

    return AbsBookItemDto(
      id: json['id'] as String? ?? '',
      libraryId: json['libraryId'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'book',
      title: metadata['title'] as String? ?? 'Untitled',
      subtitle: _nonEmpty(metadata['subtitle']),
      authors: authors,
      narrators: narrators,
      series: series,
      genres: genres,
      tags: tags,
      description: _nonEmpty(metadata['description']),
      publisher: _nonEmpty(metadata['publisher']),
      publishedYear: _nonEmpty(metadata['publishedYear']?.toString()),
      durationSec: (media['duration'] as num?)?.toDouble() ?? 0,
      numChapters: numChapters,
      hasCover: coverPath != null && coverPath.isNotEmpty,
      addedAtMs: (json['addedAt'] as num?)?.toInt() ?? 0,
      updatedAtMs: (json['updatedAt'] as num?)?.toInt() ?? 0,
      chapters: chapters,
    );
  }

  /// Item ID.
  final String id;

  /// Owning library ID.
  final String libraryId;

  /// Media type (`book` in v1).
  final String mediaType;

  /// Title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Authors list.
  final List<AbsAuthorDto> authors;

  /// Narrators list.
  final List<String> narrators;

  /// Series references.
  final List<AbsSeriesRefDto> series;

  /// Genres list.
  final List<String> genres;

  /// Tags list.
  final List<String> tags;

  /// Synopsis/description.
  final String? description;

  /// Publisher name.
  final String? publisher;

  /// Published year string.
  final String? publishedYear;

  /// Duration in seconds.
  final double durationSec;

  /// Number of chapters.
  final int numChapters;

  /// Whether a cover image exists on the server.
  final bool hasCover;

  /// Added timestamp (ms).
  final int addedAtMs;

  /// Updated timestamp (ms).
  final int updatedAtMs;

  /// Chapters list (populated on expanded item responses).
  final List<AbsChapterDto> chapters;

  static List<AbsAuthorDto> _parseAuthors(Map<String, dynamic> metadata) {
    final raw = metadata['authors'];
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(AbsAuthorDto.fromJson)
          .where((a) => a.name.isNotEmpty)
          .toList(growable: false);
    }
    final authorName = _nonEmpty(metadata['authorName']);
    if (authorName != null) {
      return authorName
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .map((name) => AbsAuthorDto(id: '', name: name))
          .toList(growable: false);
    }
    return const <AbsAuthorDto>[];
  }

  static List<String> _parseNarrators(Map<String, dynamic> metadata) {
    final raw = metadata['narrators'];
    if (raw is List) {
      return raw
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
    }
    final narratorName = _nonEmpty(metadata['narratorName']);
    if (narratorName != null) {
      return narratorName
          .split(',')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
    }
    return const <String>[];
  }

  static List<AbsSeriesRefDto> _parseSeries(Map<String, dynamic> metadata) {
    final raw = metadata['series'];
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(AbsSeriesRefDto.fromJson)
          .where((s) => s.name.isNotEmpty)
          .toList(growable: false);
    }
    final seriesName = _nonEmpty(metadata['seriesName']);
    if (seriesName != null) {
      return <AbsSeriesRefDto>[AbsSeriesRefDto(id: '', name: seriesName)];
    }
    return const <AbsSeriesRefDto>[];
  }

  static List<String> _parseStringList(Object? raw) {
    if (raw is! List) return const <String>[];
    return raw
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }

  static String? _nonEmpty(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

/// Paginated response from `GET /api/libraries/:id/items`.
@immutable
class AbsLibraryItemsPageDto {
  /// Creates an [AbsLibraryItemsPageDto].
  const new({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  /// Parses an [AbsLibraryItemsPageDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    final rawList = json['results'] ?? json['items'];
    final items = rawList is List
        ? rawList
              .whereType<Map<String, dynamic>>()
              .map(AbsBookItemDto.fromJson)
              .toList(growable: false)
        : const <AbsBookItemDto>[];
    return AbsLibraryItemsPageDto(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      page: (json['page'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
    );
  }

  /// Items in this page.
  final List<AbsBookItemDto> items;

  /// Total items matching the query.
  final int total;

  /// Zero-based page index.
  final int page;

  /// Requested page size.
  final int limit;
}

/// Media progress DTO from `/api/me` or Socket.IO `user_item_progress_updated`.
@immutable
class AbsMediaProgressDto {
  /// Creates an [AbsMediaProgressDto].
  const new({
    required this.libraryItemId,
    required this.durationSec,
    required this.currentTimeSec,
    required this.progress,
    required this.isFinished,
    required this.hideFromContinueListening,
    required this.lastUpdateMs,
    this.episodeId,
  });

  /// Parses an [AbsMediaProgressDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsMediaProgressDto(
      libraryItemId: json['libraryItemId'] as String? ?? '',
      episodeId: json['episodeId'] as String?,
      durationSec: (json['duration'] as num?)?.toDouble() ?? 0,
      currentTimeSec: (json['currentTime'] as num?)?.toDouble() ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      isFinished: json['isFinished'] as bool? ?? false,
      hideFromContinueListening:
          json['hideFromContinueListening'] as bool? ?? false,
      lastUpdateMs: (json['lastUpdate'] as num?)?.toInt() ?? 0,
    );
  }

  /// Library item ID.
  final String libraryItemId;

  /// Podcast episode ID if applicable (null for audiobooks).
  final String? episodeId;

  /// Duration in seconds.
  final double durationSec;

  /// Current listening position in seconds.
  final double currentTimeSec;

  /// Completion percentage `[0.0, 1.0]`.
  final double progress;

  /// Whether finished.
  final bool isFinished;

  /// Whether hidden from Continue Listening.
  final bool hideFromContinueListening;

  /// Server update timestamp (ms).
  final int lastUpdateMs;
}

/// Bookmark DTO from `/api/me`.
@immutable
class AbsBookmarkDto {
  /// Creates an [AbsBookmarkDto].
  const new({
    required this.libraryItemId,
    required this.timeSec,
    required this.title,
    required this.createdAtMs,
  });

  /// Parses an [AbsBookmarkDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    return AbsBookmarkDto(
      libraryItemId: json['libraryItemId'] as String? ?? '',
      timeSec: (json['time'] as num?)?.toDouble() ?? 0,
      title: json['title'] as String? ?? '',
      createdAtMs: (json['createdAt'] as num?)?.toInt() ?? 0,
    );
  }

  /// Owning library item ID.
  final String libraryItemId;

  /// Timestamp in seconds.
  final double timeSec;

  /// Bookmark title.
  final String title;

  /// Created timestamp (ms).
  final int createdAtMs;
}

/// User progress and bookmarks bundle returned by `GET /api/me`.
@immutable
class AbsUserProfileSyncDto {
  /// Creates an [AbsUserProfileSyncDto].
  const new({required this.mediaProgress, required this.bookmarks});

  /// Parses an [AbsUserProfileSyncDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    final rawProgress = json['mediaProgress'];
    final mediaProgress = rawProgress is List
        ? rawProgress
              .whereType<Map<String, dynamic>>()
              .map(AbsMediaProgressDto.fromJson)
              .where((p) => p.libraryItemId.isNotEmpty && p.episodeId == null)
              .toList(growable: false)
        : const <AbsMediaProgressDto>[];

    final rawBookmarks = json['bookmarks'];
    final bookmarks = rawBookmarks is List
        ? rawBookmarks
              .whereType<Map<String, dynamic>>()
              .map(AbsBookmarkDto.fromJson)
              .where((b) => b.libraryItemId.isNotEmpty)
              .toList(growable: false)
        : const <AbsBookmarkDto>[];

    return AbsUserProfileSyncDto(
      mediaProgress: mediaProgress,
      bookmarks: bookmarks,
    );
  }

  /// Audiobook progress records.
  final List<AbsMediaProgressDto> mediaProgress;

  /// User bookmarks.
  final List<AbsBookmarkDto> bookmarks;
}

/// Collection DTO from `GET /api/libraries/:id/collections`.
@immutable
class AbsCollectionDto {
  /// Creates an [AbsCollectionDto].
  const new({
    required this.id,
    required this.libraryId,
    required this.name,
    required this.bookIds,
    required this.updatedAtMs,
    this.description,
  });

  /// Parses an [AbsCollectionDto] from JSON.
  factory fromJson(Map<String, dynamic> json) {
    final rawBooks = json['books'];
    final bookIds = <String>[];
    if (rawBooks is List) {
      for (final entry in rawBooks) {
        if (entry is String && entry.isNotEmpty) {
          bookIds.add(entry);
        } else if (entry is Map<String, dynamic>) {
          final id = entry['id'];
          if (id is String && id.isNotEmpty) bookIds.add(id);
        }
      }
    }

    return AbsCollectionDto(
      id: json['id'] as String? ?? '',
      libraryId: json['libraryId'] as String? ?? '',
      name: json['name'] as String? ?? 'Collection',
      description: json['description'] as String?,
      bookIds: bookIds,
      updatedAtMs: (json['lastUpdate'] as num?)?.toInt() ?? 0,
    );
  }

  /// Collection ID.
  final String id;

  /// Library ID.
  final String libraryId;

  /// Collection name.
  final String name;

  /// Optional description.
  final String? description;

  /// Ordered list of library item IDs.
  final List<String> bookIds;

  /// Updated timestamp (ms).
  final int updatedAtMs;
}
