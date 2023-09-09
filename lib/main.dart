import 'dart:async';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:reskinner_new/Theme/theme.dart';
import 'package:sqflite/sqflite.dart';

import 'Screen/Widget/Sidebar.dart';
import 'Screen/bottomBar.dart';
import 'UIGenerator/mainUi.dart';
import 'Utils/selectDevicesButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isHovering = false;
  bool isCodeGenerated = false;
  double horizontalPosition = 200.0;
  MouseCursor cursor = MouseCursor.defer;
  double bottomScale = 60;

  @override
  void initState() {
    var asd = getDatabasesPath();
    setMinScreenSize();
    DeviceSelector.getFlutterDeviceList();
    Timer.periodic(const Duration(seconds: 25), (timer) {
      DeviceSelector.getFlutterDeviceList();
    });

    super.initState();
  }

  setMinScreenSize() async {
    try {
      Size size = await DesktopWindow.getWindowSize();
      final double width = size.width * 0.8;
      final double height = size.height * 0.9;
      await DesktopWindow.setMinWindowSize(Size(width, height));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.resizeRow,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                bottomScale = MediaQuery.of(context).size.height -
                    details.globalPosition.dy;

                ///For snap
                if (bottomScale > 65 && bottomScale <= 200) {
                  bottomScale = 200;
                }
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                color: AppTheme.teretoryColor,
                height: 1.5,
              ),
            ),
          ),
          BottomBar(bottomScale: bottomScale, isCodegenerated: isCodeGenerated),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          Container(
            width: horizontalPosition.clamp(
              100,
              MediaQuery.of(context).size.width * 0.8,
            ),
            // color: Colors.red,
            color: AppTheme.secondaryColor,
            height: double.infinity,
            child: SideBar(
              onConfigGenerated: (String path) {},
              onCodegenerationInProgress: () {
                isCodeGenerated = false;
                setState(() {});
              },
              onCodeGenerated: (path) {
                isCodeGenerated = true;
                setState(() {});
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  double dx = details.globalPosition.dx;
                  horizontalPosition = dx;

                  setState(() {});
                },
                child: SizedBox(
                  height: double.infinity,
                  width: 1.5,
                  child: Container(
                    color: AppTheme.teretoryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: AppTheme.backgroundColor,
              child: BuilderUI(),
            ),
          )
        ],
      ),
    );
  }
}

class CenterText extends StatelessWidget {
  const CenterText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, overflow: TextOverflow.ellipsis));
  }
}
