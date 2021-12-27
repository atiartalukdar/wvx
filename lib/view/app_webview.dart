import 'dart:developer';

import 'package:weview/utils/export.util.dart';
import 'package:weview/view/take_image.dart';

class AppWebView extends StatelessWidget {
  AppWebView({Key? key}) : super(key: key);

  final AppController _ctrl = Get.put<AppController>(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewX(
          key: const ValueKey(ksWebViewKey),
          javascriptMode: JavascriptMode.unrestricted,
          initialContent: ksURL,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          onWebViewCreated: (controller) async {
            _ctrl.webviewController = controller;
          },
          onPageFinished: (value) async {
            await _ctrl.setIPandUI();
          },
          dartCallBacks: {
            DartCallback(
              name: ksScanCallBack,
              callBack: (msg) {
                log('scan');
                Get.to(
                  () => BarcodeScanner(
                    appController: Get.put<AppController>(AppController()),
                    iawvctrl: Get.put<AppController>(AppController()).webviewController,
                  ),
                );
              },
            ),
            DartCallback(
              name: ksTakeImageCallBack,
              callBack: (msg) async {
                Get.to(() => TakeImage());
                log('take image');
              },
            ),
            DartCallback(
              name: ksUpdateIPCallBack,
              callBack: (msg) async {
                log('update ip');
                _ctrl.updateIP();
              },
            )
          },
        ),
      ),
    );
  }
}
