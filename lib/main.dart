import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await Permission.storage.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ammn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: WebViewAmmn(),
    );
  }
}

class WebViewAmmn extends StatefulWidget {
  const WebViewAmmn({Key? key}) : super(key: key);

  @override
  State<WebViewAmmn> createState() => _WebViewAmmnState();
}

class _WebViewAmmnState extends State<WebViewAmmn> {
  late InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppWebView Example'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse("https://ammn.com.sa/")
            ),
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    useOnDownloadStart: true
                )
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            onDownloadStartRequest: (controller, url) async {
              if (kDebugMode) {
                print("onDownloadStart $url");
              }
              final taskId = await FlutterDownloader.enqueue(
                url: '$url',
                savedDir: (await getExternalStorageDirectory())!.path,
                showNotification: true, // show download progress in status bar (for Android)
                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
              );
            },
          ),
        ),

      ]),
    );
  }
}