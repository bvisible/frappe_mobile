import 'dart:isolate';
import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'utils/helpers.dart';
import 'utils/http.dart';

import 'app/locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  await initDb();
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(downloadCallback);
  await initApiConfig();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => FrappeApp(),
    ),
  );
}

void downloadCallback(String id, int status, int progress) {
  final SendPort? send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
  if(send != null) {
    send.send([id, status, progress]);
  }
}
