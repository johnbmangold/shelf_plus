// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServerProfilesTable extends ServerProfiles
    with TableInfo<$ServerProfilesTable, ServerProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<String> serverVersion = GeneratedColumn<String>(
    'server_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userTypeMeta = const VerificationMeta(
    'userType',
  );
  @override
  late final GeneratedColumn<String> userType = GeneratedColumn<String>(
    'user_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultLibraryIdMeta = const VerificationMeta(
    'defaultLibraryId',
  );
  @override
  late final GeneratedColumn<String> defaultLibraryId = GeneratedColumn<String>(
    'default_library_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supportsRefreshTokensMeta =
      const VerificationMeta('supportsRefreshTokens');
  @override
  late final GeneratedColumn<bool> supportsRefreshTokens =
      GeneratedColumn<bool>(
        'supports_refresh_tokens',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("supports_refresh_tokens" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastConnectedAtMeta = const VerificationMeta(
    'lastConnectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastConnectedAt =
      GeneratedColumn<DateTime>(
        'last_connected_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseUrl,
    displayName,
    serverVersion,
    userId,
    username,
    userType,
    defaultLibraryId,
    supportsRefreshTokens,
    isActive,
    lastConnectedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('user_type')) {
      context.handle(
        _userTypeMeta,
        userType.isAcceptableOrUnknown(data['user_type']!, _userTypeMeta),
      );
    }
    if (data.containsKey('default_library_id')) {
      context.handle(
        _defaultLibraryIdMeta,
        defaultLibraryId.isAcceptableOrUnknown(
          data['default_library_id']!,
          _defaultLibraryIdMeta,
        ),
      );
    }
    if (data.containsKey('supports_refresh_tokens')) {
      context.handle(
        _supportsRefreshTokensMeta,
        supportsRefreshTokens.isAcceptableOrUnknown(
          data['supports_refresh_tokens']!,
          _supportsRefreshTokensMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_connected_at')) {
      context.handle(
        _lastConnectedAtMeta,
        lastConnectedAt.isAcceptableOrUnknown(
          data['last_connected_at']!,
          _lastConnectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastConnectedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_version'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      userType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_type'],
      ),
      defaultLibraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_library_id'],
      ),
      supportsRefreshTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_refresh_tokens'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastConnectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_connected_at'],
      )!,
    );
  }

  @override
  $ServerProfilesTable createAlias(String alias) {
    return $ServerProfilesTable(attachedDatabase, alias);
  }
}

class ServerProfile extends DataClass implements Insertable<ServerProfile> {
  /// Stable UUID identifying this server profile.
  final String id;

  /// Normalized server base URL (including optional subpath prefix).
  final String baseUrl;

  /// User-facing display name (host or server title).
  final String displayName;

  /// Reported Audiobookshelf server version string, if known.
  final String? serverVersion;

  /// Authenticated Audiobookshelf user ID.
  final String userId;

  /// Authenticated Audiobookshelf username.
  final String username;

  /// User role/type reported by Audiobookshelf (`admin`, `user`, etc.).
  final String? userType;

  /// Default library ID reported by the user profile, if any.
  final String? defaultLibraryId;

  /// Whether the server returned a refresh token (ABS v2.26+).
  final bool supportsRefreshTokens;

  /// Whether this profile is the currently active server.
  final bool isActive;

  /// UTC timestamp of the most recent successful connection.
  final DateTime lastConnectedAt;
  const ServerProfile({
    required this.id,
    required this.baseUrl,
    required this.displayName,
    this.serverVersion,
    required this.userId,
    required this.username,
    this.userType,
    this.defaultLibraryId,
    required this.supportsRefreshTokens,
    required this.isActive,
    required this.lastConnectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_url'] = Variable<String>(baseUrl);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    map['user_id'] = Variable<String>(userId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || userType != null) {
      map['user_type'] = Variable<String>(userType);
    }
    if (!nullToAbsent || defaultLibraryId != null) {
      map['default_library_id'] = Variable<String>(defaultLibraryId);
    }
    map['supports_refresh_tokens'] = Variable<bool>(supportsRefreshTokens);
    map['is_active'] = Variable<bool>(isActive);
    map['last_connected_at'] = Variable<DateTime>(lastConnectedAt);
    return map;
  }

  ServerProfilesCompanion toCompanion(bool nullToAbsent) {
    return ServerProfilesCompanion(
      id: Value(id),
      baseUrl: Value(baseUrl),
      displayName: Value(displayName),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      userId: Value(userId),
      username: Value(username),
      userType: userType == null && nullToAbsent
          ? const Value.absent()
          : Value(userType),
      defaultLibraryId: defaultLibraryId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultLibraryId),
      supportsRefreshTokens: Value(supportsRefreshTokens),
      isActive: Value(isActive),
      lastConnectedAt: Value(lastConnectedAt),
    );
  }

  factory ServerProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerProfile(
      id: serializer.fromJson<String>(json['id']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      displayName: serializer.fromJson<String>(json['displayName']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
      userId: serializer.fromJson<String>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      userType: serializer.fromJson<String?>(json['userType']),
      defaultLibraryId: serializer.fromJson<String?>(json['defaultLibraryId']),
      supportsRefreshTokens: serializer.fromJson<bool>(
        json['supportsRefreshTokens'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastConnectedAt: serializer.fromJson<DateTime>(json['lastConnectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'displayName': serializer.toJson<String>(displayName),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'userId': serializer.toJson<String>(userId),
      'username': serializer.toJson<String>(username),
      'userType': serializer.toJson<String?>(userType),
      'defaultLibraryId': serializer.toJson<String?>(defaultLibraryId),
      'supportsRefreshTokens': serializer.toJson<bool>(supportsRefreshTokens),
      'isActive': serializer.toJson<bool>(isActive),
      'lastConnectedAt': serializer.toJson<DateTime>(lastConnectedAt),
    };
  }

  ServerProfile copyWith({
    String? id,
    String? baseUrl,
    String? displayName,
    Value<String?> serverVersion = const Value.absent(),
    String? userId,
    String? username,
    Value<String?> userType = const Value.absent(),
    Value<String?> defaultLibraryId = const Value.absent(),
    bool? supportsRefreshTokens,
    bool? isActive,
    DateTime? lastConnectedAt,
  }) => ServerProfile(
    id: id ?? this.id,
    baseUrl: baseUrl ?? this.baseUrl,
    displayName: displayName ?? this.displayName,
    serverVersion: serverVersion.present
        ? serverVersion.value
        : this.serverVersion,
    userId: userId ?? this.userId,
    username: username ?? this.username,
    userType: userType.present ? userType.value : this.userType,
    defaultLibraryId: defaultLibraryId.present
        ? defaultLibraryId.value
        : this.defaultLibraryId,
    supportsRefreshTokens: supportsRefreshTokens ?? this.supportsRefreshTokens,
    isActive: isActive ?? this.isActive,
    lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
  );
  ServerProfile copyWithCompanion(ServerProfilesCompanion data) {
    return ServerProfile(
      id: data.id.present ? data.id.value : this.id,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      userType: data.userType.present ? data.userType.value : this.userType,
      defaultLibraryId: data.defaultLibraryId.present
          ? data.defaultLibraryId.value
          : this.defaultLibraryId,
      supportsRefreshTokens: data.supportsRefreshTokens.present
          ? data.supportsRefreshTokens.value
          : this.supportsRefreshTokens,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastConnectedAt: data.lastConnectedAt.present
          ? data.lastConnectedAt.value
          : this.lastConnectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfile(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('displayName: $displayName, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('userType: $userType, ')
          ..write('defaultLibraryId: $defaultLibraryId, ')
          ..write('supportsRefreshTokens: $supportsRefreshTokens, ')
          ..write('isActive: $isActive, ')
          ..write('lastConnectedAt: $lastConnectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseUrl,
    displayName,
    serverVersion,
    userId,
    username,
    userType,
    defaultLibraryId,
    supportsRefreshTokens,
    isActive,
    lastConnectedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerProfile &&
          other.id == this.id &&
          other.baseUrl == this.baseUrl &&
          other.displayName == this.displayName &&
          other.serverVersion == this.serverVersion &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.userType == this.userType &&
          other.defaultLibraryId == this.defaultLibraryId &&
          other.supportsRefreshTokens == this.supportsRefreshTokens &&
          other.isActive == this.isActive &&
          other.lastConnectedAt == this.lastConnectedAt);
}

class ServerProfilesCompanion extends UpdateCompanion<ServerProfile> {
  final Value<String> id;
  final Value<String> baseUrl;
  final Value<String> displayName;
  final Value<String?> serverVersion;
  final Value<String> userId;
  final Value<String> username;
  final Value<String?> userType;
  final Value<String?> defaultLibraryId;
  final Value<bool> supportsRefreshTokens;
  final Value<bool> isActive;
  final Value<DateTime> lastConnectedAt;
  final Value<int> rowid;
  const ServerProfilesCompanion({
    this.id = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.displayName = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.userType = const Value.absent(),
    this.defaultLibraryId = const Value.absent(),
    this.supportsRefreshTokens = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServerProfilesCompanion.insert({
    required String id,
    required String baseUrl,
    required String displayName,
    this.serverVersion = const Value.absent(),
    required String userId,
    required String username,
    this.userType = const Value.absent(),
    this.defaultLibraryId = const Value.absent(),
    this.supportsRefreshTokens = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime lastConnectedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseUrl = Value(baseUrl),
       displayName = Value(displayName),
       userId = Value(userId),
       username = Value(username),
       lastConnectedAt = Value(lastConnectedAt);
  static Insertable<ServerProfile> custom({
    Expression<String>? id,
    Expression<String>? baseUrl,
    Expression<String>? displayName,
    Expression<String>? serverVersion,
    Expression<String>? userId,
    Expression<String>? username,
    Expression<String>? userType,
    Expression<String>? defaultLibraryId,
    Expression<bool>? supportsRefreshTokens,
    Expression<bool>? isActive,
    Expression<DateTime>? lastConnectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseUrl != null) 'base_url': baseUrl,
      if (displayName != null) 'display_name': displayName,
      if (serverVersion != null) 'server_version': serverVersion,
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (userType != null) 'user_type': userType,
      if (defaultLibraryId != null) 'default_library_id': defaultLibraryId,
      if (supportsRefreshTokens != null)
        'supports_refresh_tokens': supportsRefreshTokens,
      if (isActive != null) 'is_active': isActive,
      if (lastConnectedAt != null) 'last_connected_at': lastConnectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServerProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? baseUrl,
    Value<String>? displayName,
    Value<String?>? serverVersion,
    Value<String>? userId,
    Value<String>? username,
    Value<String?>? userType,
    Value<String?>? defaultLibraryId,
    Value<bool>? supportsRefreshTokens,
    Value<bool>? isActive,
    Value<DateTime>? lastConnectedAt,
    Value<int>? rowid,
  }) {
    return ServerProfilesCompanion(
      id: id ?? this.id,
      baseUrl: baseUrl ?? this.baseUrl,
      displayName: displayName ?? this.displayName,
      serverVersion: serverVersion ?? this.serverVersion,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      defaultLibraryId: defaultLibraryId ?? this.defaultLibraryId,
      supportsRefreshTokens:
          supportsRefreshTokens ?? this.supportsRefreshTokens,
      isActive: isActive ?? this.isActive,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<String>(serverVersion.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (userType.present) {
      map['user_type'] = Variable<String>(userType.value);
    }
    if (defaultLibraryId.present) {
      map['default_library_id'] = Variable<String>(defaultLibraryId.value);
    }
    if (supportsRefreshTokens.present) {
      map['supports_refresh_tokens'] = Variable<bool>(
        supportsRefreshTokens.value,
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastConnectedAt.present) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('displayName: $displayName, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('userType: $userType, ')
          ..write('defaultLibraryId: $defaultLibraryId, ')
          ..write('supportsRefreshTokens: $supportsRefreshTokens, ')
          ..write('isActive: $isActive, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibrariesTable extends Libraries
    with TableInfo<$LibrariesTable, Library> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibrariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('book'),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncedAtMsMeta = const VerificationMeta(
    'lastSyncedAtMs',
  );
  @override
  late final GeneratedColumn<int> lastSyncedAtMs = GeneratedColumn<int>(
    'last_synced_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    name,
    mediaType,
    icon,
    displayOrder,
    lastSyncedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'libraries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Library> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at_ms')) {
      context.handle(
        _lastSyncedAtMsMeta,
        lastSyncedAtMs.isAcceptableOrUnknown(
          data['last_synced_at_ms']!,
          _lastSyncedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  Library map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Library(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      lastSyncedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_synced_at_ms'],
      )!,
    );
  }

  @override
  $LibrariesTable createAlias(String alias) {
    return $LibrariesTable(attachedDatabase, alias);
  }
}

class Library extends DataClass implements Insertable<Library> {
  /// Owning server profile ID.
  final String serverId;

  /// Audiobookshelf library ID.
  final String id;

  /// User-facing library name.
  final String name;

  /// Media type discriminator (`book` in v1; `podcast` / `ebook` later).
  final String mediaType;

  /// Library icon key reported by Audiobookshelf.
  final String icon;

  /// Display sort index.
  final int displayOrder;

  /// UTC epoch milliseconds when this library was last synced.
  final int lastSyncedAtMs;
  const Library({
    required this.serverId,
    required this.id,
    required this.name,
    required this.mediaType,
    required this.icon,
    required this.displayOrder,
    required this.lastSyncedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['media_type'] = Variable<String>(mediaType);
    map['icon'] = Variable<String>(icon);
    map['display_order'] = Variable<int>(displayOrder);
    map['last_synced_at_ms'] = Variable<int>(lastSyncedAtMs);
    return map;
  }

  LibrariesCompanion toCompanion(bool nullToAbsent) {
    return LibrariesCompanion(
      serverId: Value(serverId),
      id: Value(id),
      name: Value(name),
      mediaType: Value(mediaType),
      icon: Value(icon),
      displayOrder: Value(displayOrder),
      lastSyncedAtMs: Value(lastSyncedAtMs),
    );
  }

  factory Library.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Library(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      icon: serializer.fromJson<String>(json['icon']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      lastSyncedAtMs: serializer.fromJson<int>(json['lastSyncedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mediaType': serializer.toJson<String>(mediaType),
      'icon': serializer.toJson<String>(icon),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'lastSyncedAtMs': serializer.toJson<int>(lastSyncedAtMs),
    };
  }

  Library copyWith({
    String? serverId,
    String? id,
    String? name,
    String? mediaType,
    String? icon,
    int? displayOrder,
    int? lastSyncedAtMs,
  }) => Library(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    name: name ?? this.name,
    mediaType: mediaType ?? this.mediaType,
    icon: icon ?? this.icon,
    displayOrder: displayOrder ?? this.displayOrder,
    lastSyncedAtMs: lastSyncedAtMs ?? this.lastSyncedAtMs,
  );
  Library copyWithCompanion(LibrariesCompanion data) {
    return Library(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      icon: data.icon.present ? data.icon.value : this.icon,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      lastSyncedAtMs: data.lastSyncedAtMs.present
          ? data.lastSyncedAtMs.value
          : this.lastSyncedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Library(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mediaType: $mediaType, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('lastSyncedAtMs: $lastSyncedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    name,
    mediaType,
    icon,
    displayOrder,
    lastSyncedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Library &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.name == this.name &&
          other.mediaType == this.mediaType &&
          other.icon == this.icon &&
          other.displayOrder == this.displayOrder &&
          other.lastSyncedAtMs == this.lastSyncedAtMs);
}

class LibrariesCompanion extends UpdateCompanion<Library> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> name;
  final Value<String> mediaType;
  final Value<String> icon;
  final Value<int> displayOrder;
  final Value<int> lastSyncedAtMs;
  final Value<int> rowid;
  const LibrariesCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.icon = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.lastSyncedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibrariesCompanion.insert({
    required String serverId,
    required String id,
    required String name,
    required String mediaType,
    this.icon = const Value.absent(),
    this.displayOrder = const Value.absent(),
    required int lastSyncedAtMs,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       name = Value(name),
       mediaType = Value(mediaType),
       lastSyncedAtMs = Value(lastSyncedAtMs);
  static Insertable<Library> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mediaType,
    Expression<String>? icon,
    Expression<int>? displayOrder,
    Expression<int>? lastSyncedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mediaType != null) 'media_type': mediaType,
      if (icon != null) 'icon': icon,
      if (displayOrder != null) 'display_order': displayOrder,
      if (lastSyncedAtMs != null) 'last_synced_at_ms': lastSyncedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibrariesCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? name,
    Value<String>? mediaType,
    Value<String>? icon,
    Value<int>? displayOrder,
    Value<int>? lastSyncedAtMs,
    Value<int>? rowid,
  }) {
    return LibrariesCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      name: name ?? this.name,
      mediaType: mediaType ?? this.mediaType,
      icon: icon ?? this.icon,
      displayOrder: displayOrder ?? this.displayOrder,
      lastSyncedAtMs: lastSyncedAtMs ?? this.lastSyncedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (lastSyncedAtMs.present) {
      map['last_synced_at_ms'] = Variable<int>(lastSyncedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibrariesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mediaType: $mediaType, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('lastSyncedAtMs: $lastSyncedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryItemsTable extends LibraryItems
    with TableInfo<$LibraryItemsTable, LibraryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryIdMeta = const VerificationMeta(
    'libraryId',
  );
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('book'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorsMeta = const VerificationMeta(
    'authors',
  );
  @override
  late final GeneratedColumn<String> authors = GeneratedColumn<String>(
    'authors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _authorsJsonMeta = const VerificationMeta(
    'authorsJson',
  );
  @override
  late final GeneratedColumn<String> authorsJson = GeneratedColumn<String>(
    'authors_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _narratorsMeta = const VerificationMeta(
    'narrators',
  );
  @override
  late final GeneratedColumn<String> narrators = GeneratedColumn<String>(
    'narrators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _narratorsJsonMeta = const VerificationMeta(
    'narratorsJson',
  );
  @override
  late final GeneratedColumn<String> narratorsJson = GeneratedColumn<String>(
    'narrators_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _seriesNameMeta = const VerificationMeta(
    'seriesName',
  );
  @override
  late final GeneratedColumn<String> seriesName = GeneratedColumn<String>(
    'series_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesSequenceMeta = const VerificationMeta(
    'seriesSequence',
  );
  @override
  late final GeneratedColumn<String> seriesSequence = GeneratedColumn<String>(
    'series_sequence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seriesJsonMeta = const VerificationMeta(
    'seriesJson',
  );
  @override
  late final GeneratedColumn<String> seriesJson = GeneratedColumn<String>(
    'series_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _genresJsonMeta = const VerificationMeta(
    'genresJson',
  );
  @override
  late final GeneratedColumn<String> genresJson = GeneratedColumn<String>(
    'genres_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedYearMeta = const VerificationMeta(
    'publishedYear',
  );
  @override
  late final GeneratedColumn<String> publishedYear = GeneratedColumn<String>(
    'published_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<double> durationSec = GeneratedColumn<double>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _numChaptersMeta = const VerificationMeta(
    'numChapters',
  );
  @override
  late final GeneratedColumn<int> numChapters = GeneratedColumn<int>(
    'num_chapters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hasCoverMeta = const VerificationMeta(
    'hasCover',
  );
  @override
  late final GeneratedColumn<bool> hasCover = GeneratedColumn<bool>(
    'has_cover',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_cover" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMsMeta = const VerificationMeta(
    'addedAtMs',
  );
  @override
  late final GeneratedColumn<int> addedAtMs = GeneratedColumn<int>(
    'added_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    libraryId,
    mediaType,
    title,
    subtitle,
    authors,
    authorsJson,
    narrators,
    narratorsJson,
    seriesName,
    seriesSequence,
    seriesJson,
    genresJson,
    tagsJson,
    description,
    publisher,
    publishedYear,
    durationSec,
    numChapters,
    hasCover,
    addedAtMs,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(
        _libraryIdMeta,
        libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('authors')) {
      context.handle(
        _authorsMeta,
        authors.isAcceptableOrUnknown(data['authors']!, _authorsMeta),
      );
    }
    if (data.containsKey('authors_json')) {
      context.handle(
        _authorsJsonMeta,
        authorsJson.isAcceptableOrUnknown(
          data['authors_json']!,
          _authorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('narrators')) {
      context.handle(
        _narratorsMeta,
        narrators.isAcceptableOrUnknown(data['narrators']!, _narratorsMeta),
      );
    }
    if (data.containsKey('narrators_json')) {
      context.handle(
        _narratorsJsonMeta,
        narratorsJson.isAcceptableOrUnknown(
          data['narrators_json']!,
          _narratorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('series_name')) {
      context.handle(
        _seriesNameMeta,
        seriesName.isAcceptableOrUnknown(data['series_name']!, _seriesNameMeta),
      );
    }
    if (data.containsKey('series_sequence')) {
      context.handle(
        _seriesSequenceMeta,
        seriesSequence.isAcceptableOrUnknown(
          data['series_sequence']!,
          _seriesSequenceMeta,
        ),
      );
    }
    if (data.containsKey('series_json')) {
      context.handle(
        _seriesJsonMeta,
        seriesJson.isAcceptableOrUnknown(data['series_json']!, _seriesJsonMeta),
      );
    }
    if (data.containsKey('genres_json')) {
      context.handle(
        _genresJsonMeta,
        genresJson.isAcceptableOrUnknown(data['genres_json']!, _genresJsonMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('published_year')) {
      context.handle(
        _publishedYearMeta,
        publishedYear.isAcceptableOrUnknown(
          data['published_year']!,
          _publishedYearMeta,
        ),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('num_chapters')) {
      context.handle(
        _numChaptersMeta,
        numChapters.isAcceptableOrUnknown(
          data['num_chapters']!,
          _numChaptersMeta,
        ),
      );
    }
    if (data.containsKey('has_cover')) {
      context.handle(
        _hasCoverMeta,
        hasCover.isAcceptableOrUnknown(data['has_cover']!, _hasCoverMeta),
      );
    }
    if (data.containsKey('added_at_ms')) {
      context.handle(
        _addedAtMsMeta,
        addedAtMs.isAcceptableOrUnknown(data['added_at_ms']!, _addedAtMsMeta),
      );
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  LibraryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryItem(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_id'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      authors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors'],
      )!,
      authorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors_json'],
      )!,
      narrators: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrators'],
      )!,
      narratorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrators_json'],
      )!,
      seriesName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_name'],
      ),
      seriesSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_sequence'],
      ),
      seriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series_json'],
      )!,
      genresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres_json'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publishedYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}published_year'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration_sec'],
      )!,
      numChapters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_chapters'],
      )!,
      hasCover: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_cover'],
      )!,
      addedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at_ms'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $LibraryItemsTable createAlias(String alias) {
    return $LibraryItemsTable(attachedDatabase, alias);
  }
}

class LibraryItem extends DataClass implements Insertable<LibraryItem> {
  /// Owning server profile ID.
  final String serverId;

  /// Audiobookshelf library item ID.
  final String id;

  /// Owning library ID.
  final String libraryId;

  /// Media type discriminator (`book` in v1).
  final String mediaType;

  /// Book title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Display-formatted comma-separated author names.
  final String authors;

  /// JSON-encoded author names array for structured grouping.
  final String authorsJson;

  /// Display-formatted comma-separated narrator names.
  final String narrators;

  /// JSON-encoded narrator names array.
  final String narratorsJson;

  /// Primary series name, if any.
  final String? seriesName;

  /// Sequence string within the primary series (for example, `"1"` or `"2.5"`).
  final String? seriesSequence;

  /// JSON-encoded list of `{id, name, sequence}` series entries.
  final String seriesJson;

  /// JSON-encoded genres array.
  final String genresJson;

  /// JSON-encoded tags array.
  final String tagsJson;

  /// Synopsis/description text.
  final String? description;

  /// Publisher name, if available.
  final String? publisher;

  /// Published year string, if available.
  final String? publishedYear;

  /// Total audio duration in seconds.
  final double durationSec;

  /// Number of chapters reported on the item.
  final int numChapters;

  /// Whether the item has a cover image on the server.
  final bool hasCover;

  /// Epoch milliseconds when the item was added to Audiobookshelf.
  final int addedAtMs;

  /// Epoch milliseconds when the item metadata was last updated.
  final int updatedAtMs;
  const LibraryItem({
    required this.serverId,
    required this.id,
    required this.libraryId,
    required this.mediaType,
    required this.title,
    this.subtitle,
    required this.authors,
    required this.authorsJson,
    required this.narrators,
    required this.narratorsJson,
    this.seriesName,
    this.seriesSequence,
    required this.seriesJson,
    required this.genresJson,
    required this.tagsJson,
    this.description,
    this.publisher,
    this.publishedYear,
    required this.durationSec,
    required this.numChapters,
    required this.hasCover,
    required this.addedAtMs,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['library_id'] = Variable<String>(libraryId);
    map['media_type'] = Variable<String>(mediaType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['authors'] = Variable<String>(authors);
    map['authors_json'] = Variable<String>(authorsJson);
    map['narrators'] = Variable<String>(narrators);
    map['narrators_json'] = Variable<String>(narratorsJson);
    if (!nullToAbsent || seriesName != null) {
      map['series_name'] = Variable<String>(seriesName);
    }
    if (!nullToAbsent || seriesSequence != null) {
      map['series_sequence'] = Variable<String>(seriesSequence);
    }
    map['series_json'] = Variable<String>(seriesJson);
    map['genres_json'] = Variable<String>(genresJson);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publishedYear != null) {
      map['published_year'] = Variable<String>(publishedYear);
    }
    map['duration_sec'] = Variable<double>(durationSec);
    map['num_chapters'] = Variable<int>(numChapters);
    map['has_cover'] = Variable<bool>(hasCover);
    map['added_at_ms'] = Variable<int>(addedAtMs);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  LibraryItemsCompanion toCompanion(bool nullToAbsent) {
    return LibraryItemsCompanion(
      serverId: Value(serverId),
      id: Value(id),
      libraryId: Value(libraryId),
      mediaType: Value(mediaType),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      authors: Value(authors),
      authorsJson: Value(authorsJson),
      narrators: Value(narrators),
      narratorsJson: Value(narratorsJson),
      seriesName: seriesName == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesName),
      seriesSequence: seriesSequence == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesSequence),
      seriesJson: Value(seriesJson),
      genresJson: Value(genresJson),
      tagsJson: Value(tagsJson),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publishedYear: publishedYear == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedYear),
      durationSec: Value(durationSec),
      numChapters: Value(numChapters),
      hasCover: Value(hasCover),
      addedAtMs: Value(addedAtMs),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory LibraryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryItem(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      libraryId: serializer.fromJson<String>(json['libraryId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      authors: serializer.fromJson<String>(json['authors']),
      authorsJson: serializer.fromJson<String>(json['authorsJson']),
      narrators: serializer.fromJson<String>(json['narrators']),
      narratorsJson: serializer.fromJson<String>(json['narratorsJson']),
      seriesName: serializer.fromJson<String?>(json['seriesName']),
      seriesSequence: serializer.fromJson<String?>(json['seriesSequence']),
      seriesJson: serializer.fromJson<String>(json['seriesJson']),
      genresJson: serializer.fromJson<String>(json['genresJson']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      description: serializer.fromJson<String?>(json['description']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publishedYear: serializer.fromJson<String?>(json['publishedYear']),
      durationSec: serializer.fromJson<double>(json['durationSec']),
      numChapters: serializer.fromJson<int>(json['numChapters']),
      hasCover: serializer.fromJson<bool>(json['hasCover']),
      addedAtMs: serializer.fromJson<int>(json['addedAtMs']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'libraryId': serializer.toJson<String>(libraryId),
      'mediaType': serializer.toJson<String>(mediaType),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'authors': serializer.toJson<String>(authors),
      'authorsJson': serializer.toJson<String>(authorsJson),
      'narrators': serializer.toJson<String>(narrators),
      'narratorsJson': serializer.toJson<String>(narratorsJson),
      'seriesName': serializer.toJson<String?>(seriesName),
      'seriesSequence': serializer.toJson<String?>(seriesSequence),
      'seriesJson': serializer.toJson<String>(seriesJson),
      'genresJson': serializer.toJson<String>(genresJson),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'description': serializer.toJson<String?>(description),
      'publisher': serializer.toJson<String?>(publisher),
      'publishedYear': serializer.toJson<String?>(publishedYear),
      'durationSec': serializer.toJson<double>(durationSec),
      'numChapters': serializer.toJson<int>(numChapters),
      'hasCover': serializer.toJson<bool>(hasCover),
      'addedAtMs': serializer.toJson<int>(addedAtMs),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  LibraryItem copyWith({
    String? serverId,
    String? id,
    String? libraryId,
    String? mediaType,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    String? authors,
    String? authorsJson,
    String? narrators,
    String? narratorsJson,
    Value<String?> seriesName = const Value.absent(),
    Value<String?> seriesSequence = const Value.absent(),
    String? seriesJson,
    String? genresJson,
    String? tagsJson,
    Value<String?> description = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<String?> publishedYear = const Value.absent(),
    double? durationSec,
    int? numChapters,
    bool? hasCover,
    int? addedAtMs,
    int? updatedAtMs,
  }) => LibraryItem(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    libraryId: libraryId ?? this.libraryId,
    mediaType: mediaType ?? this.mediaType,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    authors: authors ?? this.authors,
    authorsJson: authorsJson ?? this.authorsJson,
    narrators: narrators ?? this.narrators,
    narratorsJson: narratorsJson ?? this.narratorsJson,
    seriesName: seriesName.present ? seriesName.value : this.seriesName,
    seriesSequence: seriesSequence.present
        ? seriesSequence.value
        : this.seriesSequence,
    seriesJson: seriesJson ?? this.seriesJson,
    genresJson: genresJson ?? this.genresJson,
    tagsJson: tagsJson ?? this.tagsJson,
    description: description.present ? description.value : this.description,
    publisher: publisher.present ? publisher.value : this.publisher,
    publishedYear: publishedYear.present
        ? publishedYear.value
        : this.publishedYear,
    durationSec: durationSec ?? this.durationSec,
    numChapters: numChapters ?? this.numChapters,
    hasCover: hasCover ?? this.hasCover,
    addedAtMs: addedAtMs ?? this.addedAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  LibraryItem copyWithCompanion(LibraryItemsCompanion data) {
    return LibraryItem(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      authors: data.authors.present ? data.authors.value : this.authors,
      authorsJson: data.authorsJson.present
          ? data.authorsJson.value
          : this.authorsJson,
      narrators: data.narrators.present ? data.narrators.value : this.narrators,
      narratorsJson: data.narratorsJson.present
          ? data.narratorsJson.value
          : this.narratorsJson,
      seriesName: data.seriesName.present
          ? data.seriesName.value
          : this.seriesName,
      seriesSequence: data.seriesSequence.present
          ? data.seriesSequence.value
          : this.seriesSequence,
      seriesJson: data.seriesJson.present
          ? data.seriesJson.value
          : this.seriesJson,
      genresJson: data.genresJson.present
          ? data.genresJson.value
          : this.genresJson,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      description: data.description.present
          ? data.description.value
          : this.description,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publishedYear: data.publishedYear.present
          ? data.publishedYear.value
          : this.publishedYear,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      numChapters: data.numChapters.present
          ? data.numChapters.value
          : this.numChapters,
      hasCover: data.hasCover.present ? data.hasCover.value : this.hasCover,
      addedAtMs: data.addedAtMs.present ? data.addedAtMs.value : this.addedAtMs,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItem(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('mediaType: $mediaType, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('authors: $authors, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('narrators: $narrators, ')
          ..write('narratorsJson: $narratorsJson, ')
          ..write('seriesName: $seriesName, ')
          ..write('seriesSequence: $seriesSequence, ')
          ..write('seriesJson: $seriesJson, ')
          ..write('genresJson: $genresJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('description: $description, ')
          ..write('publisher: $publisher, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('durationSec: $durationSec, ')
          ..write('numChapters: $numChapters, ')
          ..write('hasCover: $hasCover, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    serverId,
    id,
    libraryId,
    mediaType,
    title,
    subtitle,
    authors,
    authorsJson,
    narrators,
    narratorsJson,
    seriesName,
    seriesSequence,
    seriesJson,
    genresJson,
    tagsJson,
    description,
    publisher,
    publishedYear,
    durationSec,
    numChapters,
    hasCover,
    addedAtMs,
    updatedAtMs,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryItem &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.libraryId == this.libraryId &&
          other.mediaType == this.mediaType &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.authors == this.authors &&
          other.authorsJson == this.authorsJson &&
          other.narrators == this.narrators &&
          other.narratorsJson == this.narratorsJson &&
          other.seriesName == this.seriesName &&
          other.seriesSequence == this.seriesSequence &&
          other.seriesJson == this.seriesJson &&
          other.genresJson == this.genresJson &&
          other.tagsJson == this.tagsJson &&
          other.description == this.description &&
          other.publisher == this.publisher &&
          other.publishedYear == this.publishedYear &&
          other.durationSec == this.durationSec &&
          other.numChapters == this.numChapters &&
          other.hasCover == this.hasCover &&
          other.addedAtMs == this.addedAtMs &&
          other.updatedAtMs == this.updatedAtMs);
}

class LibraryItemsCompanion extends UpdateCompanion<LibraryItem> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> libraryId;
  final Value<String> mediaType;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String> authors;
  final Value<String> authorsJson;
  final Value<String> narrators;
  final Value<String> narratorsJson;
  final Value<String?> seriesName;
  final Value<String?> seriesSequence;
  final Value<String> seriesJson;
  final Value<String> genresJson;
  final Value<String> tagsJson;
  final Value<String?> description;
  final Value<String?> publisher;
  final Value<String?> publishedYear;
  final Value<double> durationSec;
  final Value<int> numChapters;
  final Value<bool> hasCover;
  final Value<int> addedAtMs;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const LibraryItemsCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.authors = const Value.absent(),
    this.authorsJson = const Value.absent(),
    this.narrators = const Value.absent(),
    this.narratorsJson = const Value.absent(),
    this.seriesName = const Value.absent(),
    this.seriesSequence = const Value.absent(),
    this.seriesJson = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.description = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.numChapters = const Value.absent(),
    this.hasCover = const Value.absent(),
    this.addedAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryItemsCompanion.insert({
    required String serverId,
    required String id,
    required String libraryId,
    this.mediaType = const Value.absent(),
    required String title,
    this.subtitle = const Value.absent(),
    this.authors = const Value.absent(),
    this.authorsJson = const Value.absent(),
    this.narrators = const Value.absent(),
    this.narratorsJson = const Value.absent(),
    this.seriesName = const Value.absent(),
    this.seriesSequence = const Value.absent(),
    this.seriesJson = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.description = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.numChapters = const Value.absent(),
    this.hasCover = const Value.absent(),
    this.addedAtMs = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       libraryId = Value(libraryId),
       title = Value(title);
  static Insertable<LibraryItem> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? libraryId,
    Expression<String>? mediaType,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? authors,
    Expression<String>? authorsJson,
    Expression<String>? narrators,
    Expression<String>? narratorsJson,
    Expression<String>? seriesName,
    Expression<String>? seriesSequence,
    Expression<String>? seriesJson,
    Expression<String>? genresJson,
    Expression<String>? tagsJson,
    Expression<String>? description,
    Expression<String>? publisher,
    Expression<String>? publishedYear,
    Expression<double>? durationSec,
    Expression<int>? numChapters,
    Expression<bool>? hasCover,
    Expression<int>? addedAtMs,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (libraryId != null) 'library_id': libraryId,
      if (mediaType != null) 'media_type': mediaType,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (authors != null) 'authors': authors,
      if (authorsJson != null) 'authors_json': authorsJson,
      if (narrators != null) 'narrators': narrators,
      if (narratorsJson != null) 'narrators_json': narratorsJson,
      if (seriesName != null) 'series_name': seriesName,
      if (seriesSequence != null) 'series_sequence': seriesSequence,
      if (seriesJson != null) 'series_json': seriesJson,
      if (genresJson != null) 'genres_json': genresJson,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (description != null) 'description': description,
      if (publisher != null) 'publisher': publisher,
      if (publishedYear != null) 'published_year': publishedYear,
      if (durationSec != null) 'duration_sec': durationSec,
      if (numChapters != null) 'num_chapters': numChapters,
      if (hasCover != null) 'has_cover': hasCover,
      if (addedAtMs != null) 'added_at_ms': addedAtMs,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryItemsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? libraryId,
    Value<String>? mediaType,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String>? authors,
    Value<String>? authorsJson,
    Value<String>? narrators,
    Value<String>? narratorsJson,
    Value<String?>? seriesName,
    Value<String?>? seriesSequence,
    Value<String>? seriesJson,
    Value<String>? genresJson,
    Value<String>? tagsJson,
    Value<String?>? description,
    Value<String?>? publisher,
    Value<String?>? publishedYear,
    Value<double>? durationSec,
    Value<int>? numChapters,
    Value<bool>? hasCover,
    Value<int>? addedAtMs,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return LibraryItemsCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      mediaType: mediaType ?? this.mediaType,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      authors: authors ?? this.authors,
      authorsJson: authorsJson ?? this.authorsJson,
      narrators: narrators ?? this.narrators,
      narratorsJson: narratorsJson ?? this.narratorsJson,
      seriesName: seriesName ?? this.seriesName,
      seriesSequence: seriesSequence ?? this.seriesSequence,
      seriesJson: seriesJson ?? this.seriesJson,
      genresJson: genresJson ?? this.genresJson,
      tagsJson: tagsJson ?? this.tagsJson,
      description: description ?? this.description,
      publisher: publisher ?? this.publisher,
      publishedYear: publishedYear ?? this.publishedYear,
      durationSec: durationSec ?? this.durationSec,
      numChapters: numChapters ?? this.numChapters,
      hasCover: hasCover ?? this.hasCover,
      addedAtMs: addedAtMs ?? this.addedAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (authors.present) {
      map['authors'] = Variable<String>(authors.value);
    }
    if (authorsJson.present) {
      map['authors_json'] = Variable<String>(authorsJson.value);
    }
    if (narrators.present) {
      map['narrators'] = Variable<String>(narrators.value);
    }
    if (narratorsJson.present) {
      map['narrators_json'] = Variable<String>(narratorsJson.value);
    }
    if (seriesName.present) {
      map['series_name'] = Variable<String>(seriesName.value);
    }
    if (seriesSequence.present) {
      map['series_sequence'] = Variable<String>(seriesSequence.value);
    }
    if (seriesJson.present) {
      map['series_json'] = Variable<String>(seriesJson.value);
    }
    if (genresJson.present) {
      map['genres_json'] = Variable<String>(genresJson.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publishedYear.present) {
      map['published_year'] = Variable<String>(publishedYear.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<double>(durationSec.value);
    }
    if (numChapters.present) {
      map['num_chapters'] = Variable<int>(numChapters.value);
    }
    if (hasCover.present) {
      map['has_cover'] = Variable<bool>(hasCover.value);
    }
    if (addedAtMs.present) {
      map['added_at_ms'] = Variable<int>(addedAtMs.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryItemsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('mediaType: $mediaType, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('authors: $authors, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('narrators: $narrators, ')
          ..write('narratorsJson: $narratorsJson, ')
          ..write('seriesName: $seriesName, ')
          ..write('seriesSequence: $seriesSequence, ')
          ..write('seriesJson: $seriesJson, ')
          ..write('genresJson: $genresJson, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('description: $description, ')
          ..write('publisher: $publisher, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('durationSec: $durationSec, ')
          ..write('numChapters: $numChapters, ')
          ..write('hasCover: $hasCover, ')
          ..write('addedAtMs: $addedAtMs, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryItemIdMeta = const VerificationMeta(
    'libraryItemId',
  );
  @override
  late final GeneratedColumn<String> libraryItemId = GeneratedColumn<String>(
    'library_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIndexMeta = const VerificationMeta(
    'chapterIndex',
  );
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
    'chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startSecMeta = const VerificationMeta(
    'startSec',
  );
  @override
  late final GeneratedColumn<double> startSec = GeneratedColumn<double>(
    'start_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endSecMeta = const VerificationMeta('endSec');
  @override
  late final GeneratedColumn<double> endSec = GeneratedColumn<double>(
    'end_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    libraryItemId,
    chapterIndex,
    title,
    startSec,
    endSec,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('library_item_id')) {
      context.handle(
        _libraryItemIdMeta,
        libraryItemId.isAcceptableOrUnknown(
          data['library_item_id']!,
          _libraryItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryItemIdMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
        _chapterIndexMeta,
        chapterIndex.isAcceptableOrUnknown(
          data['chapter_index']!,
          _chapterIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_sec')) {
      context.handle(
        _startSecMeta,
        startSec.isAcceptableOrUnknown(data['start_sec']!, _startSecMeta),
      );
    } else if (isInserting) {
      context.missing(_startSecMeta);
    }
    if (data.containsKey('end_sec')) {
      context.handle(
        _endSecMeta,
        endSec.isAcceptableOrUnknown(data['end_sec']!, _endSecMeta),
      );
    } else if (isInserting) {
      context.missing(_endSecMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    serverId,
    libraryItemId,
    chapterIndex,
  };
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      libraryItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_item_id'],
      )!,
      chapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_index'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_sec'],
      )!,
      endSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}end_sec'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  /// Owning server profile ID.
  final String serverId;

  /// Owning library item ID.
  final String libraryItemId;

  /// Zero-based chapter order index.
  final int chapterIndex;

  /// Chapter title.
  final String title;

  /// Chapter start timestamp in seconds.
  final double startSec;

  /// Chapter end timestamp in seconds.
  final double endSec;
  const Chapter({
    required this.serverId,
    required this.libraryItemId,
    required this.chapterIndex,
    required this.title,
    required this.startSec,
    required this.endSec,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['library_item_id'] = Variable<String>(libraryItemId);
    map['chapter_index'] = Variable<int>(chapterIndex);
    map['title'] = Variable<String>(title);
    map['start_sec'] = Variable<double>(startSec);
    map['end_sec'] = Variable<double>(endSec);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      serverId: Value(serverId),
      libraryItemId: Value(libraryItemId),
      chapterIndex: Value(chapterIndex),
      title: Value(title),
      startSec: Value(startSec),
      endSec: Value(endSec),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      serverId: serializer.fromJson<String>(json['serverId']),
      libraryItemId: serializer.fromJson<String>(json['libraryItemId']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      title: serializer.fromJson<String>(json['title']),
      startSec: serializer.fromJson<double>(json['startSec']),
      endSec: serializer.fromJson<double>(json['endSec']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'libraryItemId': serializer.toJson<String>(libraryItemId),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'title': serializer.toJson<String>(title),
      'startSec': serializer.toJson<double>(startSec),
      'endSec': serializer.toJson<double>(endSec),
    };
  }

  Chapter copyWith({
    String? serverId,
    String? libraryItemId,
    int? chapterIndex,
    String? title,
    double? startSec,
    double? endSec,
  }) => Chapter(
    serverId: serverId ?? this.serverId,
    libraryItemId: libraryItemId ?? this.libraryItemId,
    chapterIndex: chapterIndex ?? this.chapterIndex,
    title: title ?? this.title,
    startSec: startSec ?? this.startSec,
    endSec: endSec ?? this.endSec,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      libraryItemId: data.libraryItemId.present
          ? data.libraryItemId.value
          : this.libraryItemId,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      title: data.title.present ? data.title.value : this.title,
      startSec: data.startSec.present ? data.startSec.value : this.startSec,
      endSec: data.endSec.present ? data.endSec.value : this.endSec,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('startSec: $startSec, ')
          ..write('endSec: $endSec')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    libraryItemId,
    chapterIndex,
    title,
    startSec,
    endSec,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.serverId == this.serverId &&
          other.libraryItemId == this.libraryItemId &&
          other.chapterIndex == this.chapterIndex &&
          other.title == this.title &&
          other.startSec == this.startSec &&
          other.endSec == this.endSec);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> serverId;
  final Value<String> libraryItemId;
  final Value<int> chapterIndex;
  final Value<String> title;
  final Value<double> startSec;
  final Value<double> endSec;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.serverId = const Value.absent(),
    this.libraryItemId = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.startSec = const Value.absent(),
    this.endSec = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String serverId,
    required String libraryItemId,
    required int chapterIndex,
    required String title,
    required double startSec,
    required double endSec,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       libraryItemId = Value(libraryItemId),
       chapterIndex = Value(chapterIndex),
       title = Value(title),
       startSec = Value(startSec),
       endSec = Value(endSec);
  static Insertable<Chapter> custom({
    Expression<String>? serverId,
    Expression<String>? libraryItemId,
    Expression<int>? chapterIndex,
    Expression<String>? title,
    Expression<double>? startSec,
    Expression<double>? endSec,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (libraryItemId != null) 'library_item_id': libraryItemId,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (title != null) 'title': title,
      if (startSec != null) 'start_sec': startSec,
      if (endSec != null) 'end_sec': endSec,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? serverId,
    Value<String>? libraryItemId,
    Value<int>? chapterIndex,
    Value<String>? title,
    Value<double>? startSec,
    Value<double>? endSec,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      serverId: serverId ?? this.serverId,
      libraryItemId: libraryItemId ?? this.libraryItemId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      startSec: startSec ?? this.startSec,
      endSec: endSec ?? this.endSec,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (libraryItemId.present) {
      map['library_item_id'] = Variable<String>(libraryItemId.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startSec.present) {
      map['start_sec'] = Variable<double>(startSec.value);
    }
    if (endSec.present) {
      map['end_sec'] = Variable<double>(endSec.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('startSec: $startSec, ')
          ..write('endSec: $endSec, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaProgressEntriesTable extends MediaProgressEntries
    with TableInfo<$MediaProgressEntriesTable, MediaProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryItemIdMeta = const VerificationMeta(
    'libraryItemId',
  );
  @override
  late final GeneratedColumn<String> libraryItemId = GeneratedColumn<String>(
    'library_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<double> durationSec = GeneratedColumn<double>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _localPositionSecMeta = const VerificationMeta(
    'localPositionSec',
  );
  @override
  late final GeneratedColumn<double> localPositionSec = GeneratedColumn<double>(
    'local_position_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverPositionSecMeta = const VerificationMeta(
    'serverPositionSec',
  );
  @override
  late final GeneratedColumn<double> serverPositionSec =
      GeneratedColumn<double>(
        'server_position_sec',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _lastSyncedPositionSecMeta =
      const VerificationMeta('lastSyncedPositionSec');
  @override
  late final GeneratedColumn<double> lastSyncedPositionSec =
      GeneratedColumn<double>(
        'last_synced_position_sec',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFinishedMeta = const VerificationMeta(
    'isFinished',
  );
  @override
  late final GeneratedColumn<bool> isFinished = GeneratedColumn<bool>(
    'is_finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_finished" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hideFromContinueListeningMeta =
      const VerificationMeta('hideFromContinueListening');
  @override
  late final GeneratedColumn<bool> hideFromContinueListening =
      GeneratedColumn<bool>(
        'hide_from_continue_listening',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_from_continue_listening" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _localUpdatedAtMsMeta = const VerificationMeta(
    'localUpdatedAtMs',
  );
  @override
  late final GeneratedColumn<int> localUpdatedAtMs = GeneratedColumn<int>(
    'local_updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverUpdatedAtMsMeta = const VerificationMeta(
    'serverUpdatedAtMs',
  );
  @override
  late final GeneratedColumn<int> serverUpdatedAtMs = GeneratedColumn<int>(
    'server_updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    libraryItemId,
    durationSec,
    localPositionSec,
    serverPositionSec,
    lastSyncedPositionSec,
    progress,
    isFinished,
    hideFromContinueListening,
    localUpdatedAtMs,
    serverUpdatedAtMs,
    syncState,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('library_item_id')) {
      context.handle(
        _libraryItemIdMeta,
        libraryItemId.isAcceptableOrUnknown(
          data['library_item_id']!,
          _libraryItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryItemIdMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('local_position_sec')) {
      context.handle(
        _localPositionSecMeta,
        localPositionSec.isAcceptableOrUnknown(
          data['local_position_sec']!,
          _localPositionSecMeta,
        ),
      );
    }
    if (data.containsKey('server_position_sec')) {
      context.handle(
        _serverPositionSecMeta,
        serverPositionSec.isAcceptableOrUnknown(
          data['server_position_sec']!,
          _serverPositionSecMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_position_sec')) {
      context.handle(
        _lastSyncedPositionSecMeta,
        lastSyncedPositionSec.isAcceptableOrUnknown(
          data['last_synced_position_sec']!,
          _lastSyncedPositionSecMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('is_finished')) {
      context.handle(
        _isFinishedMeta,
        isFinished.isAcceptableOrUnknown(data['is_finished']!, _isFinishedMeta),
      );
    }
    if (data.containsKey('hide_from_continue_listening')) {
      context.handle(
        _hideFromContinueListeningMeta,
        hideFromContinueListening.isAcceptableOrUnknown(
          data['hide_from_continue_listening']!,
          _hideFromContinueListeningMeta,
        ),
      );
    }
    if (data.containsKey('local_updated_at_ms')) {
      context.handle(
        _localUpdatedAtMsMeta,
        localUpdatedAtMs.isAcceptableOrUnknown(
          data['local_updated_at_ms']!,
          _localUpdatedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at_ms')) {
      context.handle(
        _serverUpdatedAtMsMeta,
        serverUpdatedAtMs.isAcceptableOrUnknown(
          data['server_updated_at_ms']!,
          _serverUpdatedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, libraryItemId};
  @override
  MediaProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaProgressEntry(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      libraryItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_item_id'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration_sec'],
      )!,
      localPositionSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}local_position_sec'],
      )!,
      serverPositionSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}server_position_sec'],
      )!,
      lastSyncedPositionSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_synced_position_sec'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      isFinished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_finished'],
      )!,
      hideFromContinueListening: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hide_from_continue_listening'],
      )!,
      localUpdatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_updated_at_ms'],
      )!,
      serverUpdatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_updated_at_ms'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
    );
  }

  @override
  $MediaProgressEntriesTable createAlias(String alias) {
    return $MediaProgressEntriesTable(attachedDatabase, alias);
  }
}

class MediaProgressEntry extends DataClass
    implements Insertable<MediaProgressEntry> {
  /// Owning server profile ID.
  final String serverId;

  /// Owning library item ID.
  final String libraryItemId;

  /// Media duration in seconds.
  final double durationSec;

  /// Active local listening position in seconds.
  final double localPositionSec;

  /// Last known server listening position in seconds.
  final double serverPositionSec;

  /// Baseline position in seconds at the last clean sync.
  final double lastSyncedPositionSec;

  /// Normalized completion ratio in `[0.0, 1.0]`.
  final double progress;

  /// Whether the book is marked finished.
  final bool isFinished;

  /// Whether the item is hidden from Continue Listening.
  final bool hideFromContinueListening;

  /// UTC epoch milliseconds of the latest local listening change.
  final int localUpdatedAtMs;

  /// UTC epoch milliseconds reported by the server.
  final int serverUpdatedAtMs;

  /// Sync status (`synced`, `pendingPush`, or `conflict`).
  final String syncState;
  const MediaProgressEntry({
    required this.serverId,
    required this.libraryItemId,
    required this.durationSec,
    required this.localPositionSec,
    required this.serverPositionSec,
    required this.lastSyncedPositionSec,
    required this.progress,
    required this.isFinished,
    required this.hideFromContinueListening,
    required this.localUpdatedAtMs,
    required this.serverUpdatedAtMs,
    required this.syncState,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['library_item_id'] = Variable<String>(libraryItemId);
    map['duration_sec'] = Variable<double>(durationSec);
    map['local_position_sec'] = Variable<double>(localPositionSec);
    map['server_position_sec'] = Variable<double>(serverPositionSec);
    map['last_synced_position_sec'] = Variable<double>(lastSyncedPositionSec);
    map['progress'] = Variable<double>(progress);
    map['is_finished'] = Variable<bool>(isFinished);
    map['hide_from_continue_listening'] = Variable<bool>(
      hideFromContinueListening,
    );
    map['local_updated_at_ms'] = Variable<int>(localUpdatedAtMs);
    map['server_updated_at_ms'] = Variable<int>(serverUpdatedAtMs);
    map['sync_state'] = Variable<String>(syncState);
    return map;
  }

  MediaProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return MediaProgressEntriesCompanion(
      serverId: Value(serverId),
      libraryItemId: Value(libraryItemId),
      durationSec: Value(durationSec),
      localPositionSec: Value(localPositionSec),
      serverPositionSec: Value(serverPositionSec),
      lastSyncedPositionSec: Value(lastSyncedPositionSec),
      progress: Value(progress),
      isFinished: Value(isFinished),
      hideFromContinueListening: Value(hideFromContinueListening),
      localUpdatedAtMs: Value(localUpdatedAtMs),
      serverUpdatedAtMs: Value(serverUpdatedAtMs),
      syncState: Value(syncState),
    );
  }

  factory MediaProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaProgressEntry(
      serverId: serializer.fromJson<String>(json['serverId']),
      libraryItemId: serializer.fromJson<String>(json['libraryItemId']),
      durationSec: serializer.fromJson<double>(json['durationSec']),
      localPositionSec: serializer.fromJson<double>(json['localPositionSec']),
      serverPositionSec: serializer.fromJson<double>(json['serverPositionSec']),
      lastSyncedPositionSec: serializer.fromJson<double>(
        json['lastSyncedPositionSec'],
      ),
      progress: serializer.fromJson<double>(json['progress']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      hideFromContinueListening: serializer.fromJson<bool>(
        json['hideFromContinueListening'],
      ),
      localUpdatedAtMs: serializer.fromJson<int>(json['localUpdatedAtMs']),
      serverUpdatedAtMs: serializer.fromJson<int>(json['serverUpdatedAtMs']),
      syncState: serializer.fromJson<String>(json['syncState']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'libraryItemId': serializer.toJson<String>(libraryItemId),
      'durationSec': serializer.toJson<double>(durationSec),
      'localPositionSec': serializer.toJson<double>(localPositionSec),
      'serverPositionSec': serializer.toJson<double>(serverPositionSec),
      'lastSyncedPositionSec': serializer.toJson<double>(lastSyncedPositionSec),
      'progress': serializer.toJson<double>(progress),
      'isFinished': serializer.toJson<bool>(isFinished),
      'hideFromContinueListening': serializer.toJson<bool>(
        hideFromContinueListening,
      ),
      'localUpdatedAtMs': serializer.toJson<int>(localUpdatedAtMs),
      'serverUpdatedAtMs': serializer.toJson<int>(serverUpdatedAtMs),
      'syncState': serializer.toJson<String>(syncState),
    };
  }

  MediaProgressEntry copyWith({
    String? serverId,
    String? libraryItemId,
    double? durationSec,
    double? localPositionSec,
    double? serverPositionSec,
    double? lastSyncedPositionSec,
    double? progress,
    bool? isFinished,
    bool? hideFromContinueListening,
    int? localUpdatedAtMs,
    int? serverUpdatedAtMs,
    String? syncState,
  }) => MediaProgressEntry(
    serverId: serverId ?? this.serverId,
    libraryItemId: libraryItemId ?? this.libraryItemId,
    durationSec: durationSec ?? this.durationSec,
    localPositionSec: localPositionSec ?? this.localPositionSec,
    serverPositionSec: serverPositionSec ?? this.serverPositionSec,
    lastSyncedPositionSec: lastSyncedPositionSec ?? this.lastSyncedPositionSec,
    progress: progress ?? this.progress,
    isFinished: isFinished ?? this.isFinished,
    hideFromContinueListening:
        hideFromContinueListening ?? this.hideFromContinueListening,
    localUpdatedAtMs: localUpdatedAtMs ?? this.localUpdatedAtMs,
    serverUpdatedAtMs: serverUpdatedAtMs ?? this.serverUpdatedAtMs,
    syncState: syncState ?? this.syncState,
  );
  MediaProgressEntry copyWithCompanion(MediaProgressEntriesCompanion data) {
    return MediaProgressEntry(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      libraryItemId: data.libraryItemId.present
          ? data.libraryItemId.value
          : this.libraryItemId,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      localPositionSec: data.localPositionSec.present
          ? data.localPositionSec.value
          : this.localPositionSec,
      serverPositionSec: data.serverPositionSec.present
          ? data.serverPositionSec.value
          : this.serverPositionSec,
      lastSyncedPositionSec: data.lastSyncedPositionSec.present
          ? data.lastSyncedPositionSec.value
          : this.lastSyncedPositionSec,
      progress: data.progress.present ? data.progress.value : this.progress,
      isFinished: data.isFinished.present
          ? data.isFinished.value
          : this.isFinished,
      hideFromContinueListening: data.hideFromContinueListening.present
          ? data.hideFromContinueListening.value
          : this.hideFromContinueListening,
      localUpdatedAtMs: data.localUpdatedAtMs.present
          ? data.localUpdatedAtMs.value
          : this.localUpdatedAtMs,
      serverUpdatedAtMs: data.serverUpdatedAtMs.present
          ? data.serverUpdatedAtMs.value
          : this.serverUpdatedAtMs,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaProgressEntry(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('durationSec: $durationSec, ')
          ..write('localPositionSec: $localPositionSec, ')
          ..write('serverPositionSec: $serverPositionSec, ')
          ..write('lastSyncedPositionSec: $lastSyncedPositionSec, ')
          ..write('progress: $progress, ')
          ..write('isFinished: $isFinished, ')
          ..write('hideFromContinueListening: $hideFromContinueListening, ')
          ..write('localUpdatedAtMs: $localUpdatedAtMs, ')
          ..write('serverUpdatedAtMs: $serverUpdatedAtMs, ')
          ..write('syncState: $syncState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    libraryItemId,
    durationSec,
    localPositionSec,
    serverPositionSec,
    lastSyncedPositionSec,
    progress,
    isFinished,
    hideFromContinueListening,
    localUpdatedAtMs,
    serverUpdatedAtMs,
    syncState,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaProgressEntry &&
          other.serverId == this.serverId &&
          other.libraryItemId == this.libraryItemId &&
          other.durationSec == this.durationSec &&
          other.localPositionSec == this.localPositionSec &&
          other.serverPositionSec == this.serverPositionSec &&
          other.lastSyncedPositionSec == this.lastSyncedPositionSec &&
          other.progress == this.progress &&
          other.isFinished == this.isFinished &&
          other.hideFromContinueListening == this.hideFromContinueListening &&
          other.localUpdatedAtMs == this.localUpdatedAtMs &&
          other.serverUpdatedAtMs == this.serverUpdatedAtMs &&
          other.syncState == this.syncState);
}

class MediaProgressEntriesCompanion
    extends UpdateCompanion<MediaProgressEntry> {
  final Value<String> serverId;
  final Value<String> libraryItemId;
  final Value<double> durationSec;
  final Value<double> localPositionSec;
  final Value<double> serverPositionSec;
  final Value<double> lastSyncedPositionSec;
  final Value<double> progress;
  final Value<bool> isFinished;
  final Value<bool> hideFromContinueListening;
  final Value<int> localUpdatedAtMs;
  final Value<int> serverUpdatedAtMs;
  final Value<String> syncState;
  final Value<int> rowid;
  const MediaProgressEntriesCompanion({
    this.serverId = const Value.absent(),
    this.libraryItemId = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.localPositionSec = const Value.absent(),
    this.serverPositionSec = const Value.absent(),
    this.lastSyncedPositionSec = const Value.absent(),
    this.progress = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.hideFromContinueListening = const Value.absent(),
    this.localUpdatedAtMs = const Value.absent(),
    this.serverUpdatedAtMs = const Value.absent(),
    this.syncState = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaProgressEntriesCompanion.insert({
    required String serverId,
    required String libraryItemId,
    this.durationSec = const Value.absent(),
    this.localPositionSec = const Value.absent(),
    this.serverPositionSec = const Value.absent(),
    this.lastSyncedPositionSec = const Value.absent(),
    this.progress = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.hideFromContinueListening = const Value.absent(),
    this.localUpdatedAtMs = const Value.absent(),
    this.serverUpdatedAtMs = const Value.absent(),
    this.syncState = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       libraryItemId = Value(libraryItemId);
  static Insertable<MediaProgressEntry> custom({
    Expression<String>? serverId,
    Expression<String>? libraryItemId,
    Expression<double>? durationSec,
    Expression<double>? localPositionSec,
    Expression<double>? serverPositionSec,
    Expression<double>? lastSyncedPositionSec,
    Expression<double>? progress,
    Expression<bool>? isFinished,
    Expression<bool>? hideFromContinueListening,
    Expression<int>? localUpdatedAtMs,
    Expression<int>? serverUpdatedAtMs,
    Expression<String>? syncState,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (libraryItemId != null) 'library_item_id': libraryItemId,
      if (durationSec != null) 'duration_sec': durationSec,
      if (localPositionSec != null) 'local_position_sec': localPositionSec,
      if (serverPositionSec != null) 'server_position_sec': serverPositionSec,
      if (lastSyncedPositionSec != null)
        'last_synced_position_sec': lastSyncedPositionSec,
      if (progress != null) 'progress': progress,
      if (isFinished != null) 'is_finished': isFinished,
      if (hideFromContinueListening != null)
        'hide_from_continue_listening': hideFromContinueListening,
      if (localUpdatedAtMs != null) 'local_updated_at_ms': localUpdatedAtMs,
      if (serverUpdatedAtMs != null) 'server_updated_at_ms': serverUpdatedAtMs,
      if (syncState != null) 'sync_state': syncState,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaProgressEntriesCompanion copyWith({
    Value<String>? serverId,
    Value<String>? libraryItemId,
    Value<double>? durationSec,
    Value<double>? localPositionSec,
    Value<double>? serverPositionSec,
    Value<double>? lastSyncedPositionSec,
    Value<double>? progress,
    Value<bool>? isFinished,
    Value<bool>? hideFromContinueListening,
    Value<int>? localUpdatedAtMs,
    Value<int>? serverUpdatedAtMs,
    Value<String>? syncState,
    Value<int>? rowid,
  }) {
    return MediaProgressEntriesCompanion(
      serverId: serverId ?? this.serverId,
      libraryItemId: libraryItemId ?? this.libraryItemId,
      durationSec: durationSec ?? this.durationSec,
      localPositionSec: localPositionSec ?? this.localPositionSec,
      serverPositionSec: serverPositionSec ?? this.serverPositionSec,
      lastSyncedPositionSec:
          lastSyncedPositionSec ?? this.lastSyncedPositionSec,
      progress: progress ?? this.progress,
      isFinished: isFinished ?? this.isFinished,
      hideFromContinueListening:
          hideFromContinueListening ?? this.hideFromContinueListening,
      localUpdatedAtMs: localUpdatedAtMs ?? this.localUpdatedAtMs,
      serverUpdatedAtMs: serverUpdatedAtMs ?? this.serverUpdatedAtMs,
      syncState: syncState ?? this.syncState,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (libraryItemId.present) {
      map['library_item_id'] = Variable<String>(libraryItemId.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<double>(durationSec.value);
    }
    if (localPositionSec.present) {
      map['local_position_sec'] = Variable<double>(localPositionSec.value);
    }
    if (serverPositionSec.present) {
      map['server_position_sec'] = Variable<double>(serverPositionSec.value);
    }
    if (lastSyncedPositionSec.present) {
      map['last_synced_position_sec'] = Variable<double>(
        lastSyncedPositionSec.value,
      );
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (hideFromContinueListening.present) {
      map['hide_from_continue_listening'] = Variable<bool>(
        hideFromContinueListening.value,
      );
    }
    if (localUpdatedAtMs.present) {
      map['local_updated_at_ms'] = Variable<int>(localUpdatedAtMs.value);
    }
    if (serverUpdatedAtMs.present) {
      map['server_updated_at_ms'] = Variable<int>(serverUpdatedAtMs.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaProgressEntriesCompanion(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('durationSec: $durationSec, ')
          ..write('localPositionSec: $localPositionSec, ')
          ..write('serverPositionSec: $serverPositionSec, ')
          ..write('lastSyncedPositionSec: $lastSyncedPositionSec, ')
          ..write('progress: $progress, ')
          ..write('isFinished: $isFinished, ')
          ..write('hideFromContinueListening: $hideFromContinueListening, ')
          ..write('localUpdatedAtMs: $localUpdatedAtMs, ')
          ..write('serverUpdatedAtMs: $serverUpdatedAtMs, ')
          ..write('syncState: $syncState, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryItemIdMeta = const VerificationMeta(
    'libraryItemId',
  );
  @override
  late final GeneratedColumn<String> libraryItemId = GeneratedColumn<String>(
    'library_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSecMeta = const VerificationMeta(
    'timeSec',
  );
  @override
  late final GeneratedColumn<double> timeSec = GeneratedColumn<double>(
    'time_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    libraryItemId,
    timeSec,
    title,
    note,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('library_item_id')) {
      context.handle(
        _libraryItemIdMeta,
        libraryItemId.isAcceptableOrUnknown(
          data['library_item_id']!,
          _libraryItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryItemIdMeta);
    }
    if (data.containsKey('time_sec')) {
      context.handle(
        _timeSecMeta,
        timeSec.isAcceptableOrUnknown(data['time_sec']!, _timeSecMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSecMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, libraryItemId, timeSec};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      libraryItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_item_id'],
      )!,
      timeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}time_sec'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  /// Owning server profile ID.
  final String serverId;

  /// Owning library item ID.
  final String libraryItemId;

  /// Bookmark timestamp in seconds.
  final double timeSec;

  /// Bookmark title.
  final String title;

  /// Optional extended note added by the user.
  final String? note;

  /// Epoch milliseconds when the bookmark was created.
  final int createdAtMs;
  const Bookmark({
    required this.serverId,
    required this.libraryItemId,
    required this.timeSec,
    required this.title,
    this.note,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['library_item_id'] = Variable<String>(libraryItemId);
    map['time_sec'] = Variable<double>(timeSec);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      serverId: Value(serverId),
      libraryItemId: Value(libraryItemId),
      timeSec: Value(timeSec),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      serverId: serializer.fromJson<String>(json['serverId']),
      libraryItemId: serializer.fromJson<String>(json['libraryItemId']),
      timeSec: serializer.fromJson<double>(json['timeSec']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'libraryItemId': serializer.toJson<String>(libraryItemId),
      'timeSec': serializer.toJson<double>(timeSec),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  Bookmark copyWith({
    String? serverId,
    String? libraryItemId,
    double? timeSec,
    String? title,
    Value<String?> note = const Value.absent(),
    int? createdAtMs,
  }) => Bookmark(
    serverId: serverId ?? this.serverId,
    libraryItemId: libraryItemId ?? this.libraryItemId,
    timeSec: timeSec ?? this.timeSec,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      libraryItemId: data.libraryItemId.present
          ? data.libraryItemId.value
          : this.libraryItemId,
      timeSec: data.timeSec.present ? data.timeSec.value : this.timeSec,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('timeSec: $timeSec, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(serverId, libraryItemId, timeSec, title, note, createdAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.serverId == this.serverId &&
          other.libraryItemId == this.libraryItemId &&
          other.timeSec == this.timeSec &&
          other.title == this.title &&
          other.note == this.note &&
          other.createdAtMs == this.createdAtMs);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> serverId;
  final Value<String> libraryItemId;
  final Value<double> timeSec;
  final Value<String> title;
  final Value<String?> note;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.serverId = const Value.absent(),
    this.libraryItemId = const Value.absent(),
    this.timeSec = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String serverId,
    required String libraryItemId,
    required double timeSec,
    required String title,
    this.note = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       libraryItemId = Value(libraryItemId),
       timeSec = Value(timeSec),
       title = Value(title);
  static Insertable<Bookmark> custom({
    Expression<String>? serverId,
    Expression<String>? libraryItemId,
    Expression<double>? timeSec,
    Expression<String>? title,
    Expression<String>? note,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (libraryItemId != null) 'library_item_id': libraryItemId,
      if (timeSec != null) 'time_sec': timeSec,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<String>? serverId,
    Value<String>? libraryItemId,
    Value<double>? timeSec,
    Value<String>? title,
    Value<String?>? note,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      serverId: serverId ?? this.serverId,
      libraryItemId: libraryItemId ?? this.libraryItemId,
      timeSec: timeSec ?? this.timeSec,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (libraryItemId.present) {
      map['library_item_id'] = Variable<String>(libraryItemId.value);
    }
    if (timeSec.present) {
      map['time_sec'] = Variable<double>(timeSec.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('serverId: $serverId, ')
          ..write('libraryItemId: $libraryItemId, ')
          ..write('timeSec: $timeSec, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryIdMeta = const VerificationMeta(
    'libraryId',
  );
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookIdsJsonMeta = const VerificationMeta(
    'bookIdsJson',
  );
  @override
  late final GeneratedColumn<String> bookIdsJson = GeneratedColumn<String>(
    'book_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    serverId,
    id,
    libraryId,
    name,
    description,
    bookIdsJson,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(
        _libraryIdMeta,
        libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('book_ids_json')) {
      context.handle(
        _bookIdsJsonMeta,
        bookIdsJson.isAcceptableOrUnknown(
          data['book_ids_json']!,
          _bookIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  Collection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collection(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      bookIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_ids_json'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class Collection extends DataClass implements Insertable<Collection> {
  /// Owning server profile ID.
  final String serverId;

  /// Audiobookshelf collection ID.
  final String id;

  /// Owning library ID.
  final String libraryId;

  /// Collection name.
  final String name;

  /// Optional collection description.
  final String? description;

  /// JSON-encoded ordered list of library item IDs in this collection.
  final String bookIdsJson;

  /// Epoch milliseconds when the collection was updated.
  final int updatedAtMs;
  const Collection({
    required this.serverId,
    required this.id,
    required this.libraryId,
    required this.name,
    this.description,
    required this.bookIdsJson,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['id'] = Variable<String>(id);
    map['library_id'] = Variable<String>(libraryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['book_ids_json'] = Variable<String>(bookIdsJson);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      serverId: Value(serverId),
      id: Value(id),
      libraryId: Value(libraryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      bookIdsJson: Value(bookIdsJson),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory Collection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collection(
      serverId: serializer.fromJson<String>(json['serverId']),
      id: serializer.fromJson<String>(json['id']),
      libraryId: serializer.fromJson<String>(json['libraryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      bookIdsJson: serializer.fromJson<String>(json['bookIdsJson']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'id': serializer.toJson<String>(id),
      'libraryId': serializer.toJson<String>(libraryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'bookIdsJson': serializer.toJson<String>(bookIdsJson),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  Collection copyWith({
    String? serverId,
    String? id,
    String? libraryId,
    String? name,
    Value<String?> description = const Value.absent(),
    String? bookIdsJson,
    int? updatedAtMs,
  }) => Collection(
    serverId: serverId ?? this.serverId,
    id: id ?? this.id,
    libraryId: libraryId ?? this.libraryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    bookIdsJson: bookIdsJson ?? this.bookIdsJson,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  Collection copyWithCompanion(CollectionsCompanion data) {
    return Collection(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      id: data.id.present ? data.id.value : this.id,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      bookIdsJson: data.bookIdsJson.present
          ? data.bookIdsJson.value
          : this.bookIdsJson,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bookIdsJson: $bookIdsJson, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    serverId,
    id,
    libraryId,
    name,
    description,
    bookIdsJson,
    updatedAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collection &&
          other.serverId == this.serverId &&
          other.id == this.id &&
          other.libraryId == this.libraryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.bookIdsJson == this.bookIdsJson &&
          other.updatedAtMs == this.updatedAtMs);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<String> serverId;
  final Value<String> id;
  final Value<String> libraryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> bookIdsJson;
  final Value<int> updatedAtMs;
  final Value<int> rowid;
  const CollectionsCompanion({
    this.serverId = const Value.absent(),
    this.id = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.bookIdsJson = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsCompanion.insert({
    required String serverId,
    required String id,
    required String libraryId,
    required String name,
    this.description = const Value.absent(),
    this.bookIdsJson = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       id = Value(id),
       libraryId = Value(libraryId),
       name = Value(name);
  static Insertable<Collection> custom({
    Expression<String>? serverId,
    Expression<String>? id,
    Expression<String>? libraryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? bookIdsJson,
    Expression<int>? updatedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (id != null) 'id': id,
      if (libraryId != null) 'library_id': libraryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (bookIdsJson != null) 'book_ids_json': bookIdsJson,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? id,
    Value<String>? libraryId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? bookIdsJson,
    Value<int>? updatedAtMs,
    Value<int>? rowid,
  }) {
    return CollectionsCompanion(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      name: name ?? this.name,
      description: description ?? this.description,
      bookIdsJson: bookIdsJson ?? this.bookIdsJson,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bookIdsJson.present) {
      map['book_ids_json'] = Variable<String>(bookIdsJson.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('id: $id, ')
          ..write('libraryId: $libraryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bookIdsJson: $bookIdsJson, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServerProfilesTable serverProfiles = $ServerProfilesTable(this);
  late final $LibrariesTable libraries = $LibrariesTable(this);
  late final $LibraryItemsTable libraryItems = $LibraryItemsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $MediaProgressEntriesTable mediaProgressEntries =
      $MediaProgressEntriesTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serverProfiles,
    libraries,
    libraryItems,
    chapters,
    mediaProgressEntries,
    bookmarks,
    collections,
  ];
}

typedef $$ServerProfilesTableCreateCompanionBuilder =
    ServerProfilesCompanion Function({
      required String id,
      required String baseUrl,
      required String displayName,
      Value<String?> serverVersion,
      required String userId,
      required String username,
      Value<String?> userType,
      Value<String?> defaultLibraryId,
      Value<bool> supportsRefreshTokens,
      Value<bool> isActive,
      required DateTime lastConnectedAt,
      Value<int> rowid,
    });
typedef $$ServerProfilesTableUpdateCompanionBuilder =
    ServerProfilesCompanion Function({
      Value<String> id,
      Value<String> baseUrl,
      Value<String> displayName,
      Value<String?> serverVersion,
      Value<String> userId,
      Value<String> username,
      Value<String?> userType,
      Value<String?> defaultLibraryId,
      Value<bool> supportsRefreshTokens,
      Value<bool> isActive,
      Value<DateTime> lastConnectedAt,
      Value<int> rowid,
    });

class $$ServerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userType => $composableBuilder(
    column: $table.userType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultLibraryId => $composableBuilder(
    column: $table.defaultLibraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsRefreshTokens => $composableBuilder(
    column: $table.supportsRefreshTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userType => $composableBuilder(
    column: $table.userType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultLibraryId => $composableBuilder(
    column: $table.defaultLibraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsRefreshTokens => $composableBuilder(
    column: $table.supportsRefreshTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerProfilesTable> {
  $$ServerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get userType =>
      $composableBuilder(column: $table.userType, builder: (column) => column);

  GeneratedColumn<String> get defaultLibraryId => $composableBuilder(
    column: $table.defaultLibraryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsRefreshTokens => $composableBuilder(
    column: $table.supportsRefreshTokens,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => column,
  );
}

class $$ServerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServerProfilesTable,
          ServerProfile,
          $$ServerProfilesTableFilterComposer,
          $$ServerProfilesTableOrderingComposer,
          $$ServerProfilesTableAnnotationComposer,
          $$ServerProfilesTableCreateCompanionBuilder,
          $$ServerProfilesTableUpdateCompanionBuilder,
          (
            ServerProfile,
            BaseReferences<_$AppDatabase, $ServerProfilesTable, ServerProfile>,
          ),
          ServerProfile,
          PrefetchHooks Function()
        > {
  $$ServerProfilesTableTableManager(
    _$AppDatabase db,
    $ServerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> serverVersion = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> userType = const Value.absent(),
                Value<String?> defaultLibraryId = const Value.absent(),
                Value<bool> supportsRefreshTokens = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> lastConnectedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServerProfilesCompanion(
                id: id,
                baseUrl: baseUrl,
                displayName: displayName,
                serverVersion: serverVersion,
                userId: userId,
                username: username,
                userType: userType,
                defaultLibraryId: defaultLibraryId,
                supportsRefreshTokens: supportsRefreshTokens,
                isActive: isActive,
                lastConnectedAt: lastConnectedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseUrl,
                required String displayName,
                Value<String?> serverVersion = const Value.absent(),
                required String userId,
                required String username,
                Value<String?> userType = const Value.absent(),
                Value<String?> defaultLibraryId = const Value.absent(),
                Value<bool> supportsRefreshTokens = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime lastConnectedAt,
                Value<int> rowid = const Value.absent(),
              }) => ServerProfilesCompanion.insert(
                id: id,
                baseUrl: baseUrl,
                displayName: displayName,
                serverVersion: serverVersion,
                userId: userId,
                username: username,
                userType: userType,
                defaultLibraryId: defaultLibraryId,
                supportsRefreshTokens: supportsRefreshTokens,
                isActive: isActive,
                lastConnectedAt: lastConnectedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServerProfilesTable, ServerProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ServerProfilesTable,
                    ServerProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServerProfilesTable,
      ServerProfile,
      $$ServerProfilesTableFilterComposer,
      $$ServerProfilesTableOrderingComposer,
      $$ServerProfilesTableAnnotationComposer,
      $$ServerProfilesTableCreateCompanionBuilder,
      $$ServerProfilesTableUpdateCompanionBuilder,
      (
        ServerProfile,
        BaseReferences<_$AppDatabase, $ServerProfilesTable, ServerProfile>,
      ),
      ServerProfile,
      PrefetchHooks Function()
    >;
typedef $$LibrariesTableCreateCompanionBuilder = LibrariesCompanion Function({
  required String serverId,
  required String id,
  required String name,
  required String mediaType,
  Value<String> icon,
  Value<int> displayOrder,
  required int lastSyncedAtMs,
  Value<int> rowid,
});
typedef $$LibrariesTableUpdateCompanionBuilder = LibrariesCompanion Function({
  Value<String> serverId,
  Value<String> id,
  Value<String> name,
  Value<String> mediaType,
  Value<String> icon,
  Value<int> displayOrder,
  Value<int> lastSyncedAtMs,
  Value<int> rowid,
});

class $$LibrariesTableFilterComposer
    extends Composer<_$AppDatabase, $LibrariesTable> {
  $$LibrariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncedAtMs => $composableBuilder(
    column: $table.lastSyncedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibrariesTableOrderingComposer
    extends Composer<_$AppDatabase, $LibrariesTable> {
  $$LibrariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncedAtMs => $composableBuilder(
    column: $table.lastSyncedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibrariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibrariesTable> {
  $$LibrariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncedAtMs => $composableBuilder(
    column: $table.lastSyncedAtMs,
    builder: (column) => column,
  );
}

class $$LibrariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibrariesTable,
          Library,
          $$LibrariesTableFilterComposer,
          $$LibrariesTableOrderingComposer,
          $$LibrariesTableAnnotationComposer,
          $$LibrariesTableCreateCompanionBuilder,
          $$LibrariesTableUpdateCompanionBuilder,
          (Library, BaseReferences<_$AppDatabase, $LibrariesTable, Library>),
          Library,
          PrefetchHooks Function()
        > {
  $$LibrariesTableTableManager(_$AppDatabase db, $LibrariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibrariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibrariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibrariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<int> lastSyncedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibrariesCompanion(
                serverId: serverId,
                id: id,
                name: name,
                mediaType: mediaType,
                icon: icon,
                displayOrder: displayOrder,
                lastSyncedAtMs: lastSyncedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String name,
                required String mediaType,
                Value<String> icon = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                required int lastSyncedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => LibrariesCompanion.insert(
                serverId: serverId,
                id: id,
                name: name,
                mediaType: mediaType,
                icon: icon,
                displayOrder: displayOrder,
                lastSyncedAtMs: lastSyncedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibrariesTable, Library>(table),
                  BaseReferences<_$AppDatabase, $LibrariesTable, Library>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibrariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibrariesTable,
      Library,
      $$LibrariesTableFilterComposer,
      $$LibrariesTableOrderingComposer,
      $$LibrariesTableAnnotationComposer,
      $$LibrariesTableCreateCompanionBuilder,
      $$LibrariesTableUpdateCompanionBuilder,
      (Library, BaseReferences<_$AppDatabase, $LibrariesTable, Library>),
      Library,
      PrefetchHooks Function()
    >;
typedef $$LibraryItemsTableCreateCompanionBuilder =
    LibraryItemsCompanion Function({
      required String serverId,
      required String id,
      required String libraryId,
      Value<String> mediaType,
      required String title,
      Value<String?> subtitle,
      Value<String> authors,
      Value<String> authorsJson,
      Value<String> narrators,
      Value<String> narratorsJson,
      Value<String?> seriesName,
      Value<String?> seriesSequence,
      Value<String> seriesJson,
      Value<String> genresJson,
      Value<String> tagsJson,
      Value<String?> description,
      Value<String?> publisher,
      Value<String?> publishedYear,
      Value<double> durationSec,
      Value<int> numChapters,
      Value<bool> hasCover,
      Value<int> addedAtMs,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });
typedef $$LibraryItemsTableUpdateCompanionBuilder =
    LibraryItemsCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> libraryId,
      Value<String> mediaType,
      Value<String> title,
      Value<String?> subtitle,
      Value<String> authors,
      Value<String> authorsJson,
      Value<String> narrators,
      Value<String> narratorsJson,
      Value<String?> seriesName,
      Value<String?> seriesSequence,
      Value<String> seriesJson,
      Value<String> genresJson,
      Value<String> tagsJson,
      Value<String?> description,
      Value<String?> publisher,
      Value<String?> publishedYear,
      Value<double> durationSec,
      Value<int> numChapters,
      Value<bool> hasCover,
      Value<int> addedAtMs,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

class $$LibraryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narrators => $composableBuilder(
    column: $table.narrators,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narratorsJson => $composableBuilder(
    column: $table.narratorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesSequence => $composableBuilder(
    column: $table.seriesSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numChapters => $composableBuilder(
    column: $table.numChapters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCover => $composableBuilder(
    column: $table.hasCover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LibraryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narrators => $composableBuilder(
    column: $table.narrators,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narratorsJson => $composableBuilder(
    column: $table.narratorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesSequence => $composableBuilder(
    column: $table.seriesSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numChapters => $composableBuilder(
    column: $table.numChapters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCover => $composableBuilder(
    column: $table.hasCover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAtMs => $composableBuilder(
    column: $table.addedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryItemsTable> {
  $$LibraryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  GeneratedColumn<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get narrators =>
      $composableBuilder(column: $table.narrators, builder: (column) => column);

  GeneratedColumn<String> get narratorsJson => $composableBuilder(
    column: $table.narratorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seriesName => $composableBuilder(
    column: $table.seriesName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seriesSequence => $composableBuilder(
    column: $table.seriesSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seriesJson => $composableBuilder(
    column: $table.seriesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get publishedYear => $composableBuilder(
    column: $table.publishedYear,
    builder: (column) => column,
  );

  GeneratedColumn<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numChapters => $composableBuilder(
    column: $table.numChapters,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCover =>
      $composableBuilder(column: $table.hasCover, builder: (column) => column);

  GeneratedColumn<int> get addedAtMs =>
      $composableBuilder(column: $table.addedAtMs, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );
}

class $$LibraryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryItemsTable,
          LibraryItem,
          $$LibraryItemsTableFilterComposer,
          $$LibraryItemsTableOrderingComposer,
          $$LibraryItemsTableAnnotationComposer,
          $$LibraryItemsTableCreateCompanionBuilder,
          $$LibraryItemsTableUpdateCompanionBuilder,
          (
            LibraryItem,
            BaseReferences<_$AppDatabase, $LibraryItemsTable, LibraryItem>,
          ),
          LibraryItem,
          PrefetchHooks Function()
        > {
  $$LibraryItemsTableTableManager(_$AppDatabase db, $LibraryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> libraryId = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String> authors = const Value.absent(),
                Value<String> authorsJson = const Value.absent(),
                Value<String> narrators = const Value.absent(),
                Value<String> narratorsJson = const Value.absent(),
                Value<String?> seriesName = const Value.absent(),
                Value<String?> seriesSequence = const Value.absent(),
                Value<String> seriesJson = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publishedYear = const Value.absent(),
                Value<double> durationSec = const Value.absent(),
                Value<int> numChapters = const Value.absent(),
                Value<bool> hasCover = const Value.absent(),
                Value<int> addedAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion(
                serverId: serverId,
                id: id,
                libraryId: libraryId,
                mediaType: mediaType,
                title: title,
                subtitle: subtitle,
                authors: authors,
                authorsJson: authorsJson,
                narrators: narrators,
                narratorsJson: narratorsJson,
                seriesName: seriesName,
                seriesSequence: seriesSequence,
                seriesJson: seriesJson,
                genresJson: genresJson,
                tagsJson: tagsJson,
                description: description,
                publisher: publisher,
                publishedYear: publishedYear,
                durationSec: durationSec,
                numChapters: numChapters,
                hasCover: hasCover,
                addedAtMs: addedAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String libraryId,
                Value<String> mediaType = const Value.absent(),
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String> authors = const Value.absent(),
                Value<String> authorsJson = const Value.absent(),
                Value<String> narrators = const Value.absent(),
                Value<String> narratorsJson = const Value.absent(),
                Value<String?> seriesName = const Value.absent(),
                Value<String?> seriesSequence = const Value.absent(),
                Value<String> seriesJson = const Value.absent(),
                Value<String> genresJson = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<String?> publishedYear = const Value.absent(),
                Value<double> durationSec = const Value.absent(),
                Value<int> numChapters = const Value.absent(),
                Value<bool> hasCover = const Value.absent(),
                Value<int> addedAtMs = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryItemsCompanion.insert(
                serverId: serverId,
                id: id,
                libraryId: libraryId,
                mediaType: mediaType,
                title: title,
                subtitle: subtitle,
                authors: authors,
                authorsJson: authorsJson,
                narrators: narrators,
                narratorsJson: narratorsJson,
                seriesName: seriesName,
                seriesSequence: seriesSequence,
                seriesJson: seriesJson,
                genresJson: genresJson,
                tagsJson: tagsJson,
                description: description,
                publisher: publisher,
                publishedYear: publishedYear,
                durationSec: durationSec,
                numChapters: numChapters,
                hasCover: hasCover,
                addedAtMs: addedAtMs,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryItemsTable, LibraryItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LibraryItemsTable,
                    LibraryItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LibraryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryItemsTable,
      LibraryItem,
      $$LibraryItemsTableFilterComposer,
      $$LibraryItemsTableOrderingComposer,
      $$LibraryItemsTableAnnotationComposer,
      $$LibraryItemsTableCreateCompanionBuilder,
      $$LibraryItemsTableUpdateCompanionBuilder,
      (
        LibraryItem,
        BaseReferences<_$AppDatabase, $LibraryItemsTable, LibraryItem>,
      ),
      LibraryItem,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required String serverId,
  required String libraryItemId,
  required int chapterIndex,
  required String title,
  required double startSec,
  required double endSec,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<String> serverId,
  Value<String> libraryItemId,
  Value<int> chapterIndex,
  Value<String> title,
  Value<double> startSec,
  Value<double> endSec,
  Value<int> rowid,
});

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startSec => $composableBuilder(
    column: $table.startSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get endSec => $composableBuilder(
    column: $table.endSec,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startSec => $composableBuilder(
    column: $table.startSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get endSec => $composableBuilder(
    column: $table.endSec,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get startSec =>
      $composableBuilder(column: $table.startSec, builder: (column) => column);

  GeneratedColumn<double> get endSec =>
      $composableBuilder(column: $table.endSec, builder: (column) => column);
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
          Chapter,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> libraryItemId = const Value.absent(),
                Value<int> chapterIndex = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> startSec = const Value.absent(),
                Value<double> endSec = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                serverId: serverId,
                libraryItemId: libraryItemId,
                chapterIndex: chapterIndex,
                title: title,
                startSec: startSec,
                endSec: endSec,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String libraryItemId,
                required int chapterIndex,
                required String title,
                required double startSec,
                required double endSec,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                serverId: serverId,
                libraryItemId: libraryItemId,
                chapterIndex: chapterIndex,
                title: title,
                startSec: startSec,
                endSec: endSec,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, Chapter>(table),
                  BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, BaseReferences<_$AppDatabase, $ChaptersTable, Chapter>),
      Chapter,
      PrefetchHooks Function()
    >;
typedef $$MediaProgressEntriesTableCreateCompanionBuilder =
    MediaProgressEntriesCompanion Function({
      required String serverId,
      required String libraryItemId,
      Value<double> durationSec,
      Value<double> localPositionSec,
      Value<double> serverPositionSec,
      Value<double> lastSyncedPositionSec,
      Value<double> progress,
      Value<bool> isFinished,
      Value<bool> hideFromContinueListening,
      Value<int> localUpdatedAtMs,
      Value<int> serverUpdatedAtMs,
      Value<String> syncState,
      Value<int> rowid,
    });
typedef $$MediaProgressEntriesTableUpdateCompanionBuilder =
    MediaProgressEntriesCompanion Function({
      Value<String> serverId,
      Value<String> libraryItemId,
      Value<double> durationSec,
      Value<double> localPositionSec,
      Value<double> serverPositionSec,
      Value<double> lastSyncedPositionSec,
      Value<double> progress,
      Value<bool> isFinished,
      Value<bool> hideFromContinueListening,
      Value<int> localUpdatedAtMs,
      Value<int> serverUpdatedAtMs,
      Value<String> syncState,
      Value<int> rowid,
    });

class $$MediaProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaProgressEntriesTable> {
  $$MediaProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get localPositionSec => $composableBuilder(
    column: $table.localPositionSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get serverPositionSec => $composableBuilder(
    column: $table.serverPositionSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastSyncedPositionSec => $composableBuilder(
    column: $table.lastSyncedPositionSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hideFromContinueListening => $composableBuilder(
    column: $table.hideFromContinueListening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localUpdatedAtMs => $composableBuilder(
    column: $table.localUpdatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverUpdatedAtMs => $composableBuilder(
    column: $table.serverUpdatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaProgressEntriesTable> {
  $$MediaProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get localPositionSec => $composableBuilder(
    column: $table.localPositionSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get serverPositionSec => $composableBuilder(
    column: $table.serverPositionSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastSyncedPositionSec => $composableBuilder(
    column: $table.lastSyncedPositionSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hideFromContinueListening => $composableBuilder(
    column: $table.hideFromContinueListening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localUpdatedAtMs => $composableBuilder(
    column: $table.localUpdatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverUpdatedAtMs => $composableBuilder(
    column: $table.serverUpdatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaProgressEntriesTable> {
  $$MediaProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get localPositionSec => $composableBuilder(
    column: $table.localPositionSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get serverPositionSec => $composableBuilder(
    column: $table.serverPositionSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastSyncedPositionSec => $composableBuilder(
    column: $table.lastSyncedPositionSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get isFinished => $composableBuilder(
    column: $table.isFinished,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hideFromContinueListening => $composableBuilder(
    column: $table.hideFromContinueListening,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localUpdatedAtMs => $composableBuilder(
    column: $table.localUpdatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverUpdatedAtMs => $composableBuilder(
    column: $table.serverUpdatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);
}

class $$MediaProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaProgressEntriesTable,
          MediaProgressEntry,
          $$MediaProgressEntriesTableFilterComposer,
          $$MediaProgressEntriesTableOrderingComposer,
          $$MediaProgressEntriesTableAnnotationComposer,
          $$MediaProgressEntriesTableCreateCompanionBuilder,
          $$MediaProgressEntriesTableUpdateCompanionBuilder,
          (
            MediaProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $MediaProgressEntriesTable,
              MediaProgressEntry
            >,
          ),
          MediaProgressEntry,
          PrefetchHooks Function()
        > {
  $$MediaProgressEntriesTableTableManager(
    _$AppDatabase db,
    $MediaProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MediaProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> libraryItemId = const Value.absent(),
                Value<double> durationSec = const Value.absent(),
                Value<double> localPositionSec = const Value.absent(),
                Value<double> serverPositionSec = const Value.absent(),
                Value<double> lastSyncedPositionSec = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<bool> hideFromContinueListening = const Value.absent(),
                Value<int> localUpdatedAtMs = const Value.absent(),
                Value<int> serverUpdatedAtMs = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaProgressEntriesCompanion(
                serverId: serverId,
                libraryItemId: libraryItemId,
                durationSec: durationSec,
                localPositionSec: localPositionSec,
                serverPositionSec: serverPositionSec,
                lastSyncedPositionSec: lastSyncedPositionSec,
                progress: progress,
                isFinished: isFinished,
                hideFromContinueListening: hideFromContinueListening,
                localUpdatedAtMs: localUpdatedAtMs,
                serverUpdatedAtMs: serverUpdatedAtMs,
                syncState: syncState,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String libraryItemId,
                Value<double> durationSec = const Value.absent(),
                Value<double> localPositionSec = const Value.absent(),
                Value<double> serverPositionSec = const Value.absent(),
                Value<double> lastSyncedPositionSec = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<bool> isFinished = const Value.absent(),
                Value<bool> hideFromContinueListening = const Value.absent(),
                Value<int> localUpdatedAtMs = const Value.absent(),
                Value<int> serverUpdatedAtMs = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaProgressEntriesCompanion.insert(
                serverId: serverId,
                libraryItemId: libraryItemId,
                durationSec: durationSec,
                localPositionSec: localPositionSec,
                serverPositionSec: serverPositionSec,
                lastSyncedPositionSec: lastSyncedPositionSec,
                progress: progress,
                isFinished: isFinished,
                hideFromContinueListening: hideFromContinueListening,
                localUpdatedAtMs: localUpdatedAtMs,
                serverUpdatedAtMs: serverUpdatedAtMs,
                syncState: syncState,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaProgressEntriesTable, MediaProgressEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MediaProgressEntriesTable,
                    MediaProgressEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaProgressEntriesTable,
      MediaProgressEntry,
      $$MediaProgressEntriesTableFilterComposer,
      $$MediaProgressEntriesTableOrderingComposer,
      $$MediaProgressEntriesTableAnnotationComposer,
      $$MediaProgressEntriesTableCreateCompanionBuilder,
      $$MediaProgressEntriesTableUpdateCompanionBuilder,
      (
        MediaProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $MediaProgressEntriesTable,
          MediaProgressEntry
        >,
      ),
      MediaProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String serverId,
  required String libraryItemId,
  required double timeSec,
  required String title,
  Value<String?> note,
  Value<int> createdAtMs,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> serverId,
  Value<String> libraryItemId,
  Value<double> timeSec,
  Value<String> title,
  Value<String?> note,
  Value<int> createdAtMs,
  Value<int> rowid,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get timeSec => $composableBuilder(
    column: $table.timeSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get libraryItemId => $composableBuilder(
    column: $table.libraryItemId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get timeSec =>
      $composableBuilder(column: $table.timeSec, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> libraryItemId = const Value.absent(),
                Value<double> timeSec = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion(
                serverId: serverId,
                libraryItemId: libraryItemId,
                timeSec: timeSec,
                title: title,
                note: note,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String libraryItemId,
                required double timeSec,
                required String title,
                Value<String?> note = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                serverId: serverId,
                libraryItemId: libraryItemId,
                timeSec: timeSec,
                title: title,
                note: note,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, Bookmark>(table),
                  BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      required String serverId,
      required String id,
      required String libraryId,
      required String name,
      Value<String?> description,
      Value<String> bookIdsJson,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<String> serverId,
      Value<String> id,
      Value<String> libraryId,
      Value<String> name,
      Value<String?> description,
      Value<String> bookIdsJson,
      Value<int> updatedAtMs,
      Value<int> rowid,
    });

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookIdsJson => $composableBuilder(
    column: $table.bookIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookIdsJson => $composableBuilder(
    column: $table.bookIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookIdsJson => $composableBuilder(
    column: $table.bookIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          Collection,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (
            Collection,
            BaseReferences<_$AppDatabase, $CollectionsTable, Collection>,
          ),
          Collection,
          PrefetchHooks Function()
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> libraryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> bookIdsJson = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionsCompanion(
                serverId: serverId,
                id: id,
                libraryId: libraryId,
                name: name,
                description: description,
                bookIdsJson: bookIdsJson,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String id,
                required String libraryId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> bookIdsJson = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionsCompanion.insert(
                serverId: serverId,
                id: id,
                libraryId: libraryId,
                name: name,
                description: description,
                bookIdsJson: bookIdsJson,
                updatedAtMs: updatedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CollectionsTable, Collection>(table),
                  BaseReferences<_$AppDatabase, $CollectionsTable, Collection>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      Collection,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (
        Collection,
        BaseReferences<_$AppDatabase, $CollectionsTable, Collection>,
      ),
      Collection,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(_db, _db.serverProfiles);
  $$LibrariesTableTableManager get libraries =>
      $$LibrariesTableTableManager(_db, _db.libraries);
  $$LibraryItemsTableTableManager get libraryItems =>
      $$LibraryItemsTableTableManager(_db, _db.libraryItems);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$MediaProgressEntriesTableTableManager get mediaProgressEntries =>
      $$MediaProgressEntriesTableTableManager(_db, _db.mediaProgressEntries);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
}
