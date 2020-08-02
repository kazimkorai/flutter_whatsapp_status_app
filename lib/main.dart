import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whatsapp_status_app/ui/homepage_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

// import 'package:flutter_html/flutter_html.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;

  Future<int> checkStoragePermission() async {
    // bool result = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    var result = await Permission.storage.status;
    print("Checking Storage Permission " + result.toString());
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.isDenied) {
      return 0;
    } else if (result.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> requestStoragePermission() async {
    // PermissionStatus result = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    Map<Permission, PermissionStatus> result =
        await [Permission.storage].request();
    if (result[Permission.storage].isDenied) {
      return 1;
    } else if (result[Permission.storage].isGranted) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      print("Initial Values of $_storagePermissionCheck");
      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          // accentColor: Colors.amber,
        ),
        dark: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          // accentColor: Colors.amber,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Savvy',
              theme: theme,
              darkTheme: darkTheme,
              home: DefaultTabController(
                length: 2,
                child: FutureBuilder(
                  future: _storagePermissionChecker,
                  builder: (context, status) {
                    if (status.connectionState == ConnectionState.done) {
                      if (status.hasData) {
                        if (status.data == 1) {
                          return MyHome();
                        } else {
                          return Scaffold(
                            body: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Colors.lightBlue[100],
                                  Colors.lightBlue[200],
                                  Colors.lightBlue[300],
                                  Colors.lightBlue[200],
                                  Colors.lightBlue[100],
                                ],
                              )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Storage Permission Required",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "Allow Storage Permission",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    color: Colors.indigo,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _storagePermissionChecker =
                                            requestStoragePermission();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return Scaffold(
                          body: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.lightBlue[100],
                                Colors.lightBlue[200],
                                Colors.lightBlue[300],
                                Colors.lightBlue[200],
                                Colors.lightBlue[100],
                              ],
                            )),
                            child: Center(
                              child: Text(
                                "Something went wrong.. Please uninstall and Install Again.",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ));
  }
}
