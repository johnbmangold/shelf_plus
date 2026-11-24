import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shelf_plus/core/network/abs_api_models.dart';
import 'package:shelf_plus/core/theme/shelf_theme_tokens.dart';
import 'package:shelf_plus/features/auth/domain/auth_repository.dart';
import 'package:shelf_plus/features/auth/presentation/auth_controller.dart';
import 'package:shelf_plus/features/auth/presentation/server_setup_view_model.dart';
import 'package:shelf_plus/l10n/generated/app_localizations.dart';

/// Server setup and login screen supporting subpath URLs and reverse-proxy
/// custom HTTP headers.
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen].
  const new({
    required this.authRepository,
    required this.authController,
    required this.diagnosticsRoute,
    super.key,
  });

  /// Repository handling server probing and login.
  final AuthRepository authRepository;

  /// Global auth controller updated on successful sign-in.
  final AuthController authController;

  /// Route path opened when tapping "View diagnostic logs".
  final String diagnosticsRoute;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  late final ServerSetupViewModel _viewModel = ServerSetupViewModel(
    authRepository: widget.authRepository,
    authController: widget.authController,
  );
  bool _obscurePassword = true;

  @override
  void dispose() {
    _urlController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleTestConnection() async {
    final url = _urlController.text.trim();
    if (!_viewModel.isValidUrl(url)) {
      _formKey.currentState?.validate();
      return;
    }
    final ok = await _viewModel.testConnection();
    if (ok && mounted && _urlController.text != _viewModel.serverUrl) {
      _urlController.text = _viewModel.serverUrl;
    }
  }

  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await _viewModel.signIn();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Icon(
                        Icons.headphones_rounded,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.loginTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tokens.subtleMetaText,
                        ),
                      ),
                      if (widget
                          .authController
                          .sessionExpiredNotice) ...<Widget>[
                        const SizedBox(height: 16),
                        _NoticeBanner(
                          icon: Icons.lock_clock_outlined,
                          message: l10n.loginSessionExpiredNotice,
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          foregroundColor:
                              theme.colorScheme.onSecondaryContainer,
                        ),
                      ],
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              key: const Key('login_server_url_field'),
                              controller: _urlController,
                              enabled: !_viewModel.isBusy,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: l10n.loginServerUrlLabel,
                                hintText: l10n.loginServerUrlHint,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: _viewModel.updateServerUrl,
                              validator: (value) {
                                if (value == null ||
                                    !_viewModel.isValidUrl(value)) {
                                  return l10n.loginServerUrlRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                OutlinedButton.icon(
                                  key: const Key(
                                    'login_test_connection_button',
                                  ),
                                  onPressed: _viewModel.isBusy
                                      ? null
                                      : _handleTestConnection,
                                  icon: _viewModel.isProbing
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.wifi_tethering),
                                  label: Text(
                                    _viewModel.isProbing
                                        ? l10n.loginTestingConnection
                                        : l10n.loginTestConnection,
                                  ),
                                ),
                                if (_viewModel.probeResult != null) ...<Widget>[
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ProbeSuccessChip(
                                      result: _viewModel.probeResult!,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            _CustomHeadersCard(
                              viewModel: _viewModel,
                              enabled: !_viewModel.isBusy,
                            ),
                            const SizedBox(height: 16),
                            AutofillGroup(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    key: const Key('login_username_field'),
                                    enabled: !_viewModel.isBusy,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const <String>[
                                      AutofillHints.username,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: l10n.loginUsernameLabel,
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: _viewModel.updateUsername,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return l10n.loginUsernameRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    key: const Key('login_password_field'),
                                    enabled: !_viewModel.isBusy,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const <String>[
                                      AutofillHints.password,
                                    ],
                                    onFieldSubmitted: (_) =>
                                        unawaited(_handleSignIn()),
                                    decoration: InputDecoration(
                                      labelText: l10n.loginPasswordLabel,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        tooltip:
                                            l10n.loginTogglePasswordTooltip,
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                    ),
                                    onChanged: _viewModel.updatePassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.loginPasswordRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (_viewModel.error != null) ...<Widget>[
                              const SizedBox(height: 16),
                              _NoticeBanner(
                                icon: Icons.error_outline,
                                message: _localizeAuthError(
                                  l10n,
                                  _viewModel.error!,
                                ),
                                backgroundColor:
                                    theme.colorScheme.errorContainer,
                                foregroundColor:
                                    theme.colorScheme.onErrorContainer,
                              ),
                            ],
                            const SizedBox(height: 20),
                            FilledButton(
                              key: const Key('login_sign_in_button'),
                              onPressed: _viewModel.isBusy
                                  ? null
                                  : _handleSignIn,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                              ),
                              child: _viewModel.isSigningIn
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(l10n.loginSigningIn),
                                      ],
                                    )
                                  : Text(l10n.loginSignIn),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              key: const Key('login_view_diagnostics_button'),
                              onPressed: () => unawaited(
                                context.push(widget.diagnosticsRoute),
                              ),
                              icon: const Icon(
                                Icons.article_outlined,
                                size: 18,
                              ),
                              label: Text(l10n.loginViewDiagnostics),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _localizeAuthError(AppLocalizations l10n, AbsApiException error) {
    return switch (error.kind) {
      AbsApiErrorKind.invalidUrl => l10n.authErrorInvalidUrl,
      AbsApiErrorKind.unreachable => l10n.authErrorUnreachable,
      AbsApiErrorKind.timeout => l10n.authErrorTimeout,
      AbsApiErrorKind.tlsCertificate => l10n.authErrorTls,
      AbsApiErrorKind.proxyAuthRequired => l10n.authErrorProxyAuth,
      AbsApiErrorKind.invalidCredentials => l10n.authErrorCredentials,
      AbsApiErrorKind.invalidServerResponse => l10n.authErrorInvalidResponse,
      AbsApiErrorKind.sessionExpired => l10n.loginSessionExpiredNotice,
      AbsApiErrorKind.unknown => l10n.authErrorUnknown,
    };
  }
}

class _ProbeSuccessChip extends StatelessWidget {
  const new({required this.result});

  final ServerProbeResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final version = result.serverVersion;
    final label = (version != null && version.isNotEmpty)
        ? l10n.loginConnectedBadge(version)
        : l10n.loginConnectedNoVersion;

    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        avatar: Icon(
          Icons.check_circle_outline,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        label: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _CustomHeadersCard extends StatelessWidget {
  const new({required this.viewModel, required this.enabled});

  final ServerSetupViewModel viewModel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tokens = context.shelfTokens;

    return Card(
      child: ExpansionTile(
        key: const Key('login_custom_headers_tile'),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          l10n.loginCustomHeadersTitle,
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          l10n.loginCustomHeadersSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: tokens.subtleMetaText,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: <Widget>[
          for (var i = 0; i < viewModel.customHeaders.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      key: Key('custom_header_name_$i'),
                      enabled: enabled,
                      initialValue: viewModel.customHeaders[i].name,
                      decoration: InputDecoration(
                        labelText: l10n.loginHeaderNameLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) =>
                          viewModel.updateCustomHeader(i, name: val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      key: Key('custom_header_value_$i'),
                      enabled: enabled,
                      initialValue: viewModel.customHeaders[i].value,
                      decoration: InputDecoration(
                        labelText: l10n.loginHeaderValueLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) =>
                          viewModel.updateCustomHeader(i, value: val),
                    ),
                  ),
                  IconButton(
                    key: Key('remove_custom_header_$i'),
                    tooltip: l10n.loginRemoveHeaderTooltip,
                    onPressed: enabled
                        ? () => viewModel.removeCustomHeader(i)
                        : null,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('login_add_header_button'),
              onPressed: enabled ? viewModel.addCustomHeader : null,
              icon: const Icon(Icons.add),
              label: Text(l10n.loginAddHeader),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const new({
    required this.icon,
    required this.message,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: foregroundColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: foregroundColor),
            ),
          ),
        ],
      ),
    );
  }
}
