import 'dart:isolate';
import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/app/app.locator.dart';
import 'package:frappe_app/app/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

import 'utils/helpers.dart';
import 'utils/http.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
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
  if (send != null) {
    send.send([id, status, progress]);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme.apply(
            // fontSizeFactor: 0.7,
            ),
      ),
    );

    return Portal(
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Frappe',
        theme: theme,
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
        initialRoute: Routes.startupView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [
          StackedService.routeObserver,
        ],
      ),
    );
  }
}
