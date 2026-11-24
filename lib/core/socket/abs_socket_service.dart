import 'dart:async';

import 'package:shelf_plus/core/logging/app_logger.dart';
import 'package:shelf_plus/core/network/abs_library_models.dart';
import 'package:shelf_plus/core/network/abs_url_builder.dart';
import 'package:shelf_plus/core/socket/abs_socket_events.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;

/// Real-time Audiobookshelf Socket.IO connection manager.
abstract interface class AbsSocketService {
  /// Broadcast stream of parsed, self-echo-filtered server events.
  Stream<AbsSocketEvent> get events;

  /// Whether the socket is currently connected.
  bool get isConnected;

  /// Connects and authenticates against [baseUrl] using [accessToken] and
  /// [customHeaders].
  Future<void> connect({
    required String baseUrl,
    required String accessToken,
    Map<String, String> customHeaders = const <String, String>{},
  });

  /// Cleanly disconnects the active socket (for example on app backgrounding or
  /// sign-out).
  Future<void> disconnect();

  /// Registers an active playback [sessionId] so matching server echo events
  /// are suppressed.
  void registerSelfSessionId(String sessionId);

  /// Unregisters [sessionId] when its playback session closes.
  void unregisterSelfSessionId(String sessionId);

  /// Releases stream and socket resources.
  void dispose();
}

/// Pure helper parsing raw Audiobookshelf Socket.IO packets and building
/// subpath-aware connection endpoints.
abstract final class AbsSocketEventParser {
  /// Resolves a normalized [baseUrl] (including optional reverse-proxy subpath)
  /// into Socket.IO `origin` and `path`.
  static ({String origin, String path}) buildEndpoint(String baseUrl) {
    final normalized = AbsUrlBuilder.normalizeBaseUrl(baseUrl);
    final uri = Uri.parse(normalized);
    final origin = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
    ).toString();
    final prefix = uri.path == '/' ? '' : uri.path;
    return (origin: origin, path: '$prefix/socket.io');
  }

  /// Parses an incoming Socket.IO [eventName] and [payload], returning `null`
  /// if unsupported, malformed, or originating from [selfSessionIds].
  static AbsSocketEvent? parse(
    String eventName,
    Object? payload, {
    Set<String> selfSessionIds = const <String>{},
  }) {
    if (payload is! Map<String, dynamic>) return null;

    switch (eventName) {
      case 'library_item_updated':
        final item = AbsBookItemDto.fromJson(payload);
        return item.id.isEmpty ? null : LibraryItemUpdatedEvent(item);
      case 'library_item_added':
        final item = AbsBookItemDto.fromJson(payload);
        return item.id.isEmpty ? null : LibraryItemAddedEvent(item);
      case 'library_item_removed':
        final itemId = payload['id'] as String?;
        if (itemId == null || itemId.isEmpty) return null;
        return LibraryItemRemovedEvent(itemId);
      case 'user_item_progress_updated':
        final sessionId = payload['sessionId'] as String?;
        if (sessionId != null && selfSessionIds.contains(sessionId)) {
          return null;
        }
        final data = payload['data'];
        if (data is! Map<String, dynamic>) return null;
        final progress = AbsMediaProgressDto.fromJson(data);
        if (progress.libraryItemId.isEmpty || progress.episodeId != null) {
          return null;
        }
        return UserProgressUpdatedEvent(progress);
      default:
        return null;
    }
  }
}

/// Production [AbsSocketService] backed by `socket_io_client`.
class SocketIoAbsService implements AbsSocketService {
  /// Creates a [SocketIoAbsService].
  new({required this._logger});

  final AppLogger _logger;
  final StreamController<AbsSocketEvent> _controller =
      StreamController<AbsSocketEvent>.broadcast();
  final Set<String> _selfSessionIds = <String>{};

  sio.Socket? _socket;
  String? _activeUrl;
  String? _activeToken;
  bool _isConnected = false;

  @override
  Stream<AbsSocketEvent> get events => _controller.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect({
    required String baseUrl,
    required String accessToken,
    Map<String, String> customHeaders = const <String, String>{},
  }) async {
    final normalized = AbsUrlBuilder.normalizeBaseUrl(baseUrl);
    if (_socket != null &&
        _activeUrl == normalized &&
        _activeToken == accessToken &&
        _isConnected) {
      return;
    }

    await disconnect();
    _activeUrl = normalized;
    _activeToken = accessToken;

    final endpoint = AbsSocketEventParser.buildEndpoint(normalized);
    final socket = sio.io(endpoint.origin, <String, dynamic>{
      'path': endpoint.path,
      'transports': <String>['websocket'],
      'autoConnect': false,
      'forceNew': true,
      if (customHeaders.isNotEmpty) 'extraHeaders': customHeaders,
    });

    void authenticate() {
      final token = _activeToken;
      if (token != null && token.isNotEmpty) {
        socket.emit('auth', token);
      }
    }

    socket
      ..onConnect((_) {
        _isConnected = true;
        _logger.fine('Socket.IO connected', scope: 'socket');
        authenticate();
      })
      ..onReconnect((_) {
        _isConnected = true;
        _logger.fine('Socket.IO reconnected', scope: 'socket');
        authenticate();
      })
      ..onDisconnect((_) {
        _isConnected = false;
        _logger.fine('Socket.IO disconnected', scope: 'socket');
      })
      ..on('invalid_token', (_) {
        _logger.warning('Socket.IO reported invalid_token', scope: 'socket');
      })
      ..on('library_item_updated', (data) {
        _emitIfParsed('library_item_updated', data);
      })
      ..on('library_item_added', (data) {
        _emitIfParsed('library_item_added', data);
      })
      ..on('library_item_removed', (data) {
        _emitIfParsed('library_item_removed', data);
      })
      ..on('user_item_progress_updated', (data) {
        _emitIfParsed('user_item_progress_updated', data);
      });

    _socket = socket;
    socket.connect();
  }

  void _emitIfParsed(String eventName, Object? data) {
    final parsed = AbsSocketEventParser.parse(
      eventName,
      data,
      selfSessionIds: _selfSessionIds,
    );
    if (parsed != null && !_controller.isClosed) {
      _controller.add(parsed);
    }
  }

  @override
  Future<void> disconnect() async {
    final socket = _socket;
    _socket = null;
    _activeUrl = null;
    _activeToken = null;
    _isConnected = false;
    if (socket != null) {
      socket
        ..disconnect()
        ..dispose();
    }
  }

  @override
  void registerSelfSessionId(String sessionId) {
    _selfSessionIds.add(sessionId);
  }

  @override
  void unregisterSelfSessionId(String sessionId) {
    _selfSessionIds.remove(sessionId);
  }

  @override
  void dispose() {
    unawaited(disconnect());
    unawaited(_controller.close());
  }
}
