import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:html/parser.dart' as html show parse;
// import 'package:html/dom.dart' as dom;

void main() {
  runApp(const StartApp());
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textCaptchaController = TextEditingController();
  WebViewController webViewController = WebViewController();
  FocusNode focusNodeWallet = FocusNode();
  FocusNode focusNodeCaptcha = FocusNode();
  bool uploadedData = false;
  bool openUp = false;
  bool loading = false;
  bool openUpPopUp = false;
  bool authorizationStatus = false;

  @override
  void initState() {
    super.initState();

    textEditingController.addListener(() {
      String text = textEditingController.text;
      webViewController.runJavaScript('''
               document.querySelector("#loginform-num").value = "$text";
              ''');
    });

    textCaptchaController.addListener(() {
      String captcha = textCaptchaController.text;
      webViewController.runJavaScript('''
               document.querySelector("#loginform-captcha").value = "$captcha";
              ''');
    });

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.red)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (kDebugMode) {
              print(progress);
            }

            print(authorizationStatus);
            if(progress == 100 && authorizationStatus) {
              setState(() {
                loading = false;
                openUpPopUp = false;
                uploadedData = true;
              });
            } else if(progress > 100 && authorizationStatus) {
              setState(() {
                loading = true;
                openUpPopUp = false;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            webViewController.runJavaScript('\$("body *").not(\$("#loginform-captcha-image").parents().addBack()).css({visibility: "hidden"})');
            webViewController.runJavaScript('\$("#loginform-captcha-image").width(290)');
            webViewController.runJavaScript('window.scrollTo({top: 465, behavior: "smooth"})');
            // Object htmlString = await webViewController.runJavaScriptReturningResult("window.document.getElementsByTagName('html')[0].outerHTML;");
            // var document = html.parse(htmlString);
            // print(document.getElementById('loginform-captcha-image')!);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://lktk.tk-barn.ru/'));

    Future.delayed(
      const Duration(milliseconds: 500), () {
        setState(() {
          openUp = true;
          loading = true;
        });
      }
    );

    Future.delayed(
        const Duration(milliseconds: 4000), () {
      setState(() {
        loading = false;
        openUpPopUp = true;
      });
    }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            backgroundColor: const Color(0xFF0080FF),
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                height: height * 1.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      top: !openUp ? height / 2.7 : 100,
                      curve: Curves.easeInOutBack,
                      duration: const Duration(seconds: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 30,),
                          AnimatedContainer(
                            width: !openUp ? width * 1.5: 140,
                            height: !openUp ? width * 1.5 : 140,
                            duration: const Duration(seconds: 1),
                            child: SvgPicture.asset(
                              'asset/icon/city.svg',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedPositioned(
                        top: !authorizationStatus ? height : 0,
                        curve: Curves.easeInOutCubic,
                        duration: const Duration(seconds: 1),
                        child: Container(
                          width: width,
                          height: height,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0080FF),
                          ),
                        )
                    ),
                    AnimatedPositioned(
                      top: !openUpPopUp ? height: 300,
                      curve: Curves.easeInOutCubic,
                      duration: const Duration(seconds: 2),
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(58),
                          color: Colors.white.withOpacity(0.95),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              "Авторизация",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blueAccent,
                                  fontFamily: "SF Text"
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              "введите данные вашего проездного",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueAccent,
                                  fontFamily: "SF Text"
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                focusNode: focusNodeWallet,
                                textInputAction: TextInputAction.next,
                                controller: textEditingController,
                                onEditingComplete: () {    //ADDED
                                  focusNodeCaptcha.requestFocus();
                                },
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  labelText: '000 123 456',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onHorizontalDragUpdate: (updateDetails) {},
                              onVerticalDragUpdate: (updateDetails) {},
                              child: SizedBox(
                                width: width / 1.2,
                                height: 100,
                                child: WebViewWidget(
                                  controller: webViewController,
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  webViewController.clearCache();
                                  webViewController.reload();
                                },
                                child: const Text(
                                  'Перезагрузить капчу'
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextField(
                                focusNode: focusNodeCaptcha,
                                textInputAction: TextInputAction.done,
                                controller: textCaptchaController,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  labelText: 'Введите капчу с картинки',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white
                                ),
                                onPressed: () {
                                  authorizationStatus = true;
                                  webViewController.runJavaScript("\$('.btn-primary').trigger('click')");
                                },
                                child: const Text('Добавить карту'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    AnimatedOpacity(
                      opacity: loading ? 1.0 : 0.0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOutCubic,
                      child: Container(
                        margin: EdgeInsets.only(top: height / 1.5),
                        child: OverflowBox(
                          minHeight: 70,
                          maxHeight: 70,
                          child: Lottie.asset(
                            'asset/a.json',
                            fit: BoxFit.scaleDown
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}


