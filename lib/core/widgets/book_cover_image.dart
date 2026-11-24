import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';

/// Editorial rounded audiobook cover widget with authenticated disk caching and
/// warm monogram fallback when offline or cover art is absent.
class BookCoverImage extends StatelessWidget {
  /// Creates a [BookCoverImage].
  const new({
    required this.title,
    required this.size,
    this.coverUrl,
    this.headers = const <String, String>{},
    this.enableNetworkImage = true,
    this.borderRadius = 12,
    super.key,
  });

  /// Book title used for fallback initials and semantics.
  final String title;

  /// Square width/height dimension.
  final double size;

  /// Optional authenticated cover URL.
  final String? coverUrl;

  /// Auth + custom proxy HTTP headers attached to image fetches.
  final Map<String, String> headers;

  /// Whether network image loading is enabled (set `false` in widget tests).
  final bool enableNetworkImage;

  /// Corner radius for the cover frame.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shelfTokens;
    final theme = Theme.of(context);
    final url = coverUrl;

    Widget content;
    if (enableNetworkImage && url != null && url.isNotEmpty) {
      content = CachedNetworkImage(
        imageUrl: url,
        httpHeaders: headers.isEmpty ? null : headers,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (context, _) => _CoverPlaceholder(
          title: title,
          size: size,
          colorScheme: theme.colorScheme,
          tokens: tokens,
        ),
        errorWidget: (context, _, _) => _CoverPlaceholder(
          title: title,
          size: size,
          colorScheme: theme.colorScheme,
          tokens: tokens,
        ),
      );
    } else {
      content = _CoverPlaceholder(
        title: title,
        size: size,
        colorScheme: theme.colorScheme,
        tokens: tokens,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: tokens.hairlineBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const new({
    required this.title,
    required this.size,
    required this.colorScheme,
    required this.tokens,
  });

  final String title;
  final double size;
  final ColorScheme colorScheme;
  final ShelfThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final initial = title.trim().isNotEmpty
        ? title.trim().substring(0, 1).toUpperCase()
        : '?';

    return ColoredBox(
      color: colorScheme.surfaceContainerHigh,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              initial,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: colorScheme.primary),
            ),
            if (size >= 88) ...<Widget>[
              const SizedBox(height: 4),
              Icon(
                Icons.menu_book_outlined,
                size: 16,
                color: tokens.subtleMetaText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
