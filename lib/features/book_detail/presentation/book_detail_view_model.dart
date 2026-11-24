import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_api_client.dart';
import 'package:shelf_plus/core/theme/dynamic_cover_theme_service.dart';
import 'package:shelf_plus/features/auth/domain/server_session.dart';
import 'package:shelf_plus/features/library/domain/library_models.dart';
import 'package:shelf_plus/features/library/domain/library_repository.dart';

/// ViewModel backing the Book Detail screen with reactive chapter/bookmark
/// updates, expanded metadata hydration, and dynamic cover-art theming.
class BookDetailViewModel extends ChangeNotifier {
  /// Creates a [BookDetailViewModel].
  new({
    required this._libraryRepository,
    required this._coverThemeExtractor,
    required this._session,
    required this._itemId,
    required this._loadImageHeaders,
    required this._logger,
  });

  final LibraryRepository _libraryRepository;
  final CoverThemeExtractor _coverThemeExtractor;
  final ServerSession _session;
  final String _itemId;
  final Future<Map<String, String>> Function() _loadImageHeaders;
  final AppLogger _logger;

  StreamSubscription<BookDetail?>? _detailSub;
  BookDetail? _detail;
  Map<String, String> _imageHeaders = const <String, String>{};
  ColorScheme? _dynamicScheme;
  Brightness? _extractedBrightness;
  bool _hasLoadedInitial = false;
  bool _hasRequestedExpanded = false;
  bool _isLoadingDetail = false;

  /// Current cached [BookDetail], or `null` if unavailable.
  BookDetail? get detail => _detail;

  /// Authenticated headers for cover fetching.
  Map<String, String> get imageHeaders => _imageHeaders;

  /// Extracted cover-art [ColorScheme], if available.
  ColorScheme? get dynamicScheme => _dynamicScheme;

  /// Whether at least one cache snapshot has arrived.
  bool get hasLoadedInitial => _hasLoadedInitial;

  /// Whether an expanded detail fetch is currently in flight.
  bool get isLoadingDetail => _isLoadingDetail;

  /// Cover URL for the current book, if present on server.
  String? get coverUrl {
    final book = _detail?.book;
    if (book == null || !book.hasCover) return null;
    return AbsApiClient.buildCoverUrl(
      baseUrl: _session.baseUrl,
      itemId: book.id,
    );
  }

  /// Starts watching cached details and requests expanded chapters if needed.
  void start({required Brightness brightness, bool autoFetchDetail = true}) {
    _extractedBrightness = brightness;
    unawaited(_loadHeadersAndWatch(autoFetchDetail: autoFetchDetail));
  }

  /// Re-extracts the cover palette if the app brightness changes.
  void updateBrightness(Brightness brightness) {
    if (_extractedBrightness == brightness) return;
    _extractedBrightness = brightness;
    _dynamicScheme = null;
    unawaited(_extractCoverTheme());
  }

  Future<void> _loadHeadersAndWatch({required bool autoFetchDetail}) async {
    _imageHeaders = await _loadImageHeaders();
    _detailSub ??= _libraryRepository
        .watchBookDetail(_session.serverId, _itemId)
        .listen((value) {
          _detail = value;
          _hasLoadedInitial = true;
          notifyListeners();
          if (value != null) {
            unawaited(_extractCoverTheme());
            if (autoFetchDetail &&
                !_hasRequestedExpanded &&
                value.chapters.isEmpty) {
              _hasRequestedExpanded = true;
              unawaited(refreshDetail());
            }
          }
        });
  }

  /// Fetches expanded metadata and chapters from the server.
  Future<void> refreshDetail() async {
    if (_isLoadingDetail) return;
    _isLoadingDetail = true;
    notifyListeners();
    try {
      await _libraryRepository.syncBookDetail(_session, _itemId);
    } on Exception catch (err) {
      _logger.warning(
        'Failed to hydrate expanded book detail for $_itemId',
        scope: 'book_detail',
        error: err,
      );
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> _extractCoverTheme() async {
    final url = coverUrl;
    final brightness = _extractedBrightness;
    if (url == null || brightness == null) return;
    final extracted = await _coverThemeExtractor.extractScheme(
      coverUrl: url,
      brightness: brightness,
      headers: _imageHeaders,
    );
    if (extracted != null && _extractedBrightness == brightness) {
      _dynamicScheme = extracted;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(_detailSub?.cancel());
    super.dispose();
  }
}
