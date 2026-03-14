import 'package:flutter/material.dart';
import 'package:prototype/services/portal_session_manager.dart';

enum _SessionAction { refresh, login }

class PortalSessionIndicator extends StatelessWidget {
  const PortalSessionIndicator({
    super.key,
    required this.sessionManager,
    required this.onRefresh,
    required this.onOpenLogin,
  });

  final PortalSessionManager sessionManager;
  final VoidCallback onRefresh;
  final VoidCallback onOpenLogin;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sessionManager,
      builder: (context, _) {
        final status = sessionManager.status;
        final colorScheme = Theme.of(context).colorScheme;

        final (icon, color, tooltip) = switch (status) {
          PortalSessionStatus.authenticated => (
            Icons.verified_user,
            colorScheme.primary,
            'Portal 已登入'
          ),
          PortalSessionStatus.checking => (
            Icons.sync,
            colorScheme.secondary,
            '檢查登入狀態中'
          ),
          PortalSessionStatus.expired => (
            Icons.warning_amber_rounded,
            colorScheme.error,
            'Portal 可能已登出'
          ),
          PortalSessionStatus.error => (
            Icons.error_outline,
            colorScheme.error,
            'Portal 狀態檢查失敗'
          ),
          PortalSessionStatus.unknown => (
            Icons.help_outline,
            colorScheme.onSurfaceVariant,
            'Portal 狀態未知'
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
            PopupMenuItem(
              value: _SessionAction.refresh,
              child: Text('重新檢查登入狀態'),
            ),
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
