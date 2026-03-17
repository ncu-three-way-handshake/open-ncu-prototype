import 'package:flutter/material.dart';
import 'package:prototype/services/portal_authenticator.dart';

enum _SessionAction { refresh, login }

class PortalSessionIndicator extends StatelessWidget {
  const PortalSessionIndicator({
    super.key,
    required this.authenticator,
    required this.onRefresh,
    required this.onOpenLogin,
  });

  final PortalAuthenticator authenticator;
  final VoidCallback onRefresh;
  final VoidCallback onOpenLogin;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        authenticator.status,
        authenticator.portalToken,
      ]),
      builder: (context, _) {
        final status = authenticator.status.value;
        final colorScheme = Theme.of(context).colorScheme;

        final (icon, color, tooltip) = switch (status) {
          PortalSessionStatus.authenticated => (
            Icons.verified_user,
            colorScheme.primary,
            'Portal 已登入',
          ),
          PortalSessionStatus.authenticating => (
            Icons.sync,
            colorScheme.secondary,
            '驗證 Portal 中',
          ),
          PortalSessionStatus.requireReauthentication => (
            Icons.warning_amber_rounded,
            colorScheme.error,
            'Portal 需要重新登入',
          ),
          PortalSessionStatus.expired => (
            Icons.schedule,
            colorScheme.error,
            'Portal 已過期',
          ),
          PortalSessionStatus.error => (
            Icons.error_outline,
            colorScheme.error,
            'Portal 驗證失敗',
          ),
        };

        return PopupMenuButton<_SessionAction>(
          tooltip: tooltip,
          onSelected: (value) {
            switch (value) {
              case _SessionAction.refresh:
                onRefresh();
              case _SessionAction.login:
                onOpenLogin();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: _SessionAction.refresh, child: Text('重新驗證')),
            PopupMenuItem(
              value: _SessionAction.login,
              child: Text('前往 Portal 登入'),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(icon, color: color),
          ),
        );
      },
    );
  }
}
