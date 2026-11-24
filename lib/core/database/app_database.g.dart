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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServerProfilesTable serverProfiles = $ServerProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [serverProfiles];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(_db, _db.serverProfiles);
}
