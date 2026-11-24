import 'package:shelf_plus/features/library/domain/library_models.dart';

/// Deterministic sanitized Audiobookshelf JSON fixtures and domain models.
abstract final class AbsLibraryFixtures {
  /// Sample libraries response JSON (`GET /api/libraries`).
  static Map<String, Object?> librariesResponseJson() => <String, Object?>{
    'libraries': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'lib-main',
        'name': 'Audiobooks',
        'mediaType': 'book',
        'icon': 'book',
        'displayOrder': 0,
      },
      <String, Object?>{
        'id': 'lib-scifi',
        'name': 'Sci-Fi Vault',
        'mediaType': 'book',
        'icon': 'book',
        'displayOrder': 1,
      },
      <String, Object?>{
        'id': 'lib-pods',
        'name': 'Podcasts',
        'mediaType': 'podcast',
        'icon': 'podcast',
        'displayOrder': 2,
      },
    ],
  };

  /// Sample paginated library items response for `lib-main`.
  static Map<String, Object?> libraryItemsPageJson() => <String, Object?>{
    'results': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'item-1',
        'libraryId': 'lib-main',
        'mediaType': 'book',
        'addedAt': 1717000000000,
        'updatedAt': 1717500000000,
        'media': <String, Object?>{
          'metadata': <String, Object?>{
            'title': 'Project Hail Mary',
            'subtitle': 'A Novel',
            'authors': <Map<String, Object?>>[
              <String, Object?>{'id': 'au-1', 'name': 'Andy Weir'},
            ],
            'narrators': <String>['Ray Porter'],
            'series': <Map<String, Object?>>[
              <String, Object?>{
                'id': 'ser-1',
                'name': 'Cosmic Tales',
                'sequence': '2',
              },
            ],
            'genres': <String>['Science Fiction', 'Space Opera'],
            'publisher': 'Audible Studios',
            'publishedYear': '2021',
            'description': 'A lone astronaut must save Earth.',
          },
          'coverPath': '/metadata/items/item-1/cover.jpg',
          'tags': <String>['sci-fi', 'space'],
          'numChapters': 2,
          'duration': 58200.0,
        },
      },
      <String, Object?>{
        'id': 'item-2',
        'libraryId': 'lib-main',
        'mediaType': 'book',
        'addedAt': 1716000000000,
        'updatedAt': 1716500000000,
        'media': <String, Object?>{
          'metadata': <String, Object?>{
            'title': 'Piranesi',
            'authors': <Map<String, Object?>>[
              <String, Object?>{'id': 'au-2', 'name': 'Susanna Clarke'},
            ],
            'narrators': <String>['Chiwetel Ejiofor'],
            'series': <Map<String, Object?>>[],
            'genres': <String>['Fantasy'],
            'publisher': 'Bloomsbury',
            'publishedYear': '2020',
            'description': 'Piranesi lives in the House.',
          },
          'coverPath': '/metadata/items/item-2/cover.jpg',
          'tags': <String>['labyrinth', 'mystery'],
          'numChapters': 1,
          'duration': 25200.0,
        },
      },
    ],
    'total': 2,
    'limit': 100,
    'page': 0,
  };

  /// Expanded single item JSON (`GET /api/items/item-1?expanded=1`).
  static Map<String, Object?> expandedItem1Json() => <String, Object?>{
    'id': 'item-1',
    'libraryId': 'lib-main',
    'mediaType': 'book',
    'addedAt': 1717000000000,
    'updatedAt': 1717500000000,
    'media': <String, Object?>{
      'metadata': <String, Object?>{
        'title': 'Project Hail Mary',
        'subtitle': 'A Novel',
        'authors': <Map<String, Object?>>[
          <String, Object?>{'id': 'au-1', 'name': 'Andy Weir'},
        ],
        'narrators': <String>['Ray Porter'],
        'series': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'ser-1',
            'name': 'Cosmic Tales',
            'sequence': '2',
          },
        ],
        'genres': <String>['Science Fiction', 'Space Opera'],
        'publisher': 'Audible Studios',
        'publishedYear': '2021',
        'description': 'A lone astronaut must save Earth.',
      },
      'coverPath': '/metadata/items/item-1/cover.jpg',
      'tags': <String>['sci-fi', 'space'],
      'numChapters': 2,
      'duration': 58200.0,
      'chapters': <Map<String, Object?>>[
        <String, Object?>{
          'id': 0,
          'start': 0.0,
          'end': 1800.0,
          'title': 'Chapter 1: Awakening',
        },
        <String, Object?>{
          'id': 1,
          'start': 1800.0,
          'end': 58200.0,
          'title': 'Chapter 2: Tau Ceti',
        },
      ],
      'audioFiles': <Map<String, Object?>>[
        <String, Object?>{
          'index': 0,
          'ino': 'ino-1',
          'duration': 1800.0,
          'mimeType': 'audio/mp4',
          'metadata': <String, Object?>{
            'filename': 'hail_mary_01.m4b',
            'size': 2048,
          },
          'metaTags': <String, Object?>{'tagTitle': 'Part 1'},
        },
        <String, Object?>{
          'index': 1,
          'ino': 'ino-2',
          'duration': 56400.0,
          'mimeType': 'audio/mp4',
          'metadata': <String, Object?>{
            'filename': 'hail_mary_02.m4b',
            'size': 2048,
          },
          'metaTags': <String, Object?>{'tagTitle': 'Part 2'},
        },
      ],
    },
  };

  /// Sample `GET /api/me` response JSON.
  static Map<String, Object?> meResponseJson() => <String, Object?>{
    'id': 'abs-user-1',
    'username': 'reader',
    'mediaProgress': <Map<String, Object?>>[
      <String, Object?>{
        'libraryItemId': 'item-1',
        'episodeId': null,
        'duration': 58200.0,
        'currentTime': 14200.0,
        'progress': 0.244,
        'isFinished': false,
        'hideFromContinueListening': false,
        'lastUpdate': 1718100000000,
      },
    ],
    'bookmarks': <Map<String, Object?>>[
      <String, Object?>{
        'libraryItemId': 'item-1',
        'time': 620.0,
        'title': 'Rocky arrives',
        'createdAt': 1718000000000,
      },
    ],
  };

  /// Sample `GET /api/libraries/lib-main/collections` response JSON.
  static Map<String, Object?> collectionsResponseJson() => <String, Object?>{
    'results': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'col-1',
        'libraryId': 'lib-main',
        'name': 'Favorites',
        'description': 'All-time favorite listens',
        'lastUpdate': 1718000000000,
        'books': <Map<String, Object?>>[
          <String, Object?>{'id': 'item-1'},
          <String, Object?>{'id': 'item-2'},
        ],
      },
    ],
  };

  /// Domain fixture for a sample in-progress audiobook.
  static const BookSummary bookOne = BookSummary(
    id: 'item-1',
    serverId: 'test-server-1',
    libraryId: 'lib-main',
    title: 'Project Hail Mary',
    subtitle: 'A Novel',
    authorsDisplay: 'Andy Weir',
    authorNames: <String>['Andy Weir'],
    narratorsDisplay: 'Ray Porter',
    narratorNames: <String>['Ray Porter'],
    seriesName: 'Cosmic Tales',
    seriesSequence: '2',
    seriesRefs: <SeriesRef>[
      SeriesRef(id: 'ser-1', name: 'Cosmic Tales', sequence: '2'),
    ],
    genres: <String>['Science Fiction'],
    description: 'A lone astronaut must save Earth.',
    publisher: 'Audible Studios',
    publishedYear: '2021',
    durationSec: 58200,
    numChapters: 2,
    hasCover: true,
    addedAtMs: 1717000000000,
    progress: BookProgress(
      positionSec: 14200,
      durationSec: 58200,
      progress: 0.244,
      isFinished: false,
      hideFromContinueListening: false,
      updatedAtMs: 1718100000000,
    ),
  );

  /// Domain fixture for an unstarted audiobook.
  static const BookSummary bookTwo = BookSummary(
    id: 'item-2',
    serverId: 'test-server-1',
    libraryId: 'lib-main',
    title: 'Piranesi',
    authorsDisplay: 'Susanna Clarke',
    authorNames: <String>['Susanna Clarke'],
    narratorsDisplay: 'Chiwetel Ejiofor',
    narratorNames: <String>['Chiwetel Ejiofor'],
    seriesRefs: <SeriesRef>[],
    genres: <String>['Fantasy'],
    description: 'Piranesi lives in the House.',
    publisher: 'Bloomsbury',
    publishedYear: '2020',
    durationSec: 25200,
    numChapters: 1,
    hasCover: true,
    addedAtMs: 1716000000000,
  );

  /// Domain fixture for a finished audiobook in the same series as [bookOne].
  static const BookSummary bookThree = BookSummary(
    id: 'item-3',
    serverId: 'test-server-1',
    libraryId: 'lib-main',
    title: 'The Martian',
    authorsDisplay: 'Andy Weir',
    authorNames: <String>['Andy Weir'],
    narratorsDisplay: 'R.C. Bray',
    narratorNames: <String>['R.C. Bray'],
    seriesName: 'Cosmic Tales',
    seriesSequence: '1',
    seriesRefs: <SeriesRef>[
      SeriesRef(id: 'ser-1', name: 'Cosmic Tales', sequence: '1'),
    ],
    genres: <String>['Science Fiction'],
    durationSec: 39600,
    numChapters: 20,
    hasCover: false,
    addedAtMs: 1715000000000,
    progress: BookProgress(
      positionSec: 39600,
      durationSec: 39600,
      progress: 1,
      isFinished: true,
      hideFromContinueListening: false,
      updatedAtMs: 1715500000000,
    ),
  );
}
