import 'package:share_plus/share_plus.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class InviteService {
  // Static shared list ID
  static const String sharedListId = 'shared_list';

  // Generate simple invite link
  static String generateInviteLink() {
    return 'https://yourapp.com/invite'; // No parameters needed
  }

  // Share the invite link using share_plus
  static void shareInviteLink(BuildContext context) {
    String link = generateInviteLink();
    Share.share('Join our shared grocery list: $link');
  }

  // Initialize link handling
  static late AppLinks _appLinks;

  static Future<StreamSubscription<Uri>> initLinkHandling(
      BuildContext context) async {
    _appLinks = AppLinks();

    final subscription = _appLinks.uriLinkStream.listen((Uri uri) {
      if (uri.path == '/invite') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to the shared grocery list!')),
        );
      }
    });

    return subscription;
  }
}
