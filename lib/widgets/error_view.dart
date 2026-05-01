import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/tmdb_error.dart';

/// Full-screen-ish error state. Reads any [TmdbError] for a friendly message
/// and only shows a retry button when [TmdbError.isRetryable] is true.
/// For [TmdbMissingKeyError] / [TmdbInvalidKeyError] it offers a Settings
/// shortcut instead.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final Object? error;
  final VoidCallback? onRetry;

  /// Use a tighter layout (icon + message on one row, no big spacing).
  /// Useful for sub-sections of a screen.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tmdbError = error is TmdbError ? error as TmdbError : null;
    final message = tmdbError?.userMessage ?? _genericMessage(error);
    final retryable = tmdbError?.isRetryable ?? true;
    final isKeyProblem =
        tmdbError is TmdbMissingKeyError || tmdbError is TmdbInvalidKeyError;

    final color = Theme.of(context).colorScheme.error;
    final icon = isKeyProblem
        ? Icons.key_off_outlined
        : tmdbError is TmdbNoNetworkError
            ? Icons.wifi_off
            : Icons.error_outline;

    if (compact) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (isKeyProblem)
              FilledButton.icon(
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
                onPressed: () => context.push('/settings'),
              )
            else if (retryable && onRetry != null)
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                onPressed: onRetry,
              ),
          ],
        ),
      ),
    );
  }

  String _genericMessage(Object? error) {
    if (error == null) return 'Something went wrong.';
    return 'Something went wrong. ($error)';
  }
}
