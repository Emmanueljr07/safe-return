import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karu/routing/go_routing.dart';

class DeepLinksConfig {
  StreamSubscription? _linkSubscription;
  Future<void> initDeepLinks(AppLinks applinks) async {
    // Handle link if app was opened from cold start (closed state)
    final initialLink = await applinks.getInitialLink();
    if (initialLink != null) {
      // Defer until after first frame so router is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleDeepLink(initialLink);
      });
    }

    // Handle link if app was already running (background state)
    _linkSubscription = applinks.uriLinkStream.listen(
      (uri) {
        handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('Failed to receive deep link: $err');
      },
    );
  }

  void handleDeepLink(Uri uri) {
    // uri = myapp://items/abc123
    // uri.pathSegments = ['items', 'abc123']
    debugPrint('Received deep link: $uri');
    debugPrint('Segments: ${uri.pathSegments}');

    if (uri.scheme == 'myreturnapp' && uri.host == 'items') {
      if (uri.pathSegments.isEmpty) {
        debugPrint('No item ID found in deep link');
        return;
      }
      final itemId = uri.pathSegments.first; // 'abc123'

      // Navigate to the item screen
      router.go('/livestatus/$itemId');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
