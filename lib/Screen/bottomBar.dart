import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reskinner_new/Listeners/CodeGenerationProcess.dart';
import 'package:reskinner_new/Listeners/appRunListener.dart';
import 'package:reskinner_new/Listeners/errorListener.dart';
import 'package:reskinner_new/Utils/appRunner.dart';

import '../Theme/theme.dart';
import '../Utils/lables.dart';
import '../Utils/selectDevicesButton.dart';

class BottomBar extends StatefulWidget {
  final double bottomScale;
  final bool isCodegenerated;
  const BottomBar(
      {super.key, required this.bottomScale, required this.isCodegenerated});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late double scale = widget.bottomScale;
  int selectedTerminalOption = 0;
  late bool codeGenerated = widget.isCodegenerated;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    scale = widget.bottomScale;
    codeGenerated = widget.isCodegenerated;
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  final ScrollController _controller = ScrollController();
  Map? selectedDevice;
  @override
  Widget build(BuildContext context) {
    log("SELELEELl ${selectedDevice}");
    return BottomAppBar(
      color: AppTheme.secondaryColor,
      height: scale.clamp(60, MediaQuery.of(context).size.height - 20),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                    valueListenable: AppRunListener.get(),
                    builder: (context, AppRunStatus value, widget) {
                      getIcon(AppRunStatus status) {
                        if (status == AppRunStatus.initial) {
                          return Icons.play_arrow_outlined;
                        }

                        if (status == AppRunStatus.starting) {
                          return Icons.run_circle;
                        }

                        if (status == AppRunStatus.started) {
                          return Icons.pause;
                        }
                        if (status == AppRunStatus.failed) {
                          return Icons.error;
                        }
                      }

                      getText(AppRunStatus status) {
                        if (status == AppRunStatus.initial) {
                          return Lable.runApp;
                        }

                        if (status == AppRunStatus.starting) {
                          return Lable.startingApp;
                        }

                        if (status == AppRunStatus.started) {
                          return Lable.startedApp;
                        }
                        if (status == AppRunStatus.failed) {
                          return Lable.failedAppRun;
                        }
                      }

                      return BottomBarItem(
                        icon: getIcon(value)!,
                        title: getText(value)!,
                        isDisabled:
                            selectedDevice == null && codeGenerated == false,
                        disabledToolTipMessage:
                            "Generate code first & Select device",
                        onTap: () async {
                          if (value == AppRunStatus.starting ||
                              value == AppRunStatus.started) {
                            AppRunner.killApp();
                            AppRunListener.setStatus(AppRunStatus.initial);
                            return;
                          }

                          if (value == AppRunStatus.starting) {
                            return;
                          }

                          try {
                            TerminalProcess.setProcessStatus("PROGRESS");
                            TerminalProcess.setProcessType(
                                ConsoleProcessType.appRun);
                            await AppRunner.generationFolder();
                            await AppRunner.pubGet();
                            await AppRunner.runApp();
                          } catch (e) {
                            Errors.error(e.toString());
                          }
                        },
                      );
                    }),
                BottomBarItem(
                  title: selectedDevice?['title'] ?? Lable.selectDevice,
                  icon: Icons.device_unknown,
                  onTap: () {
                    log("selecting");
                    DeviceSelector deviceSelector = DeviceSelector(
                      context,
                      "Select Device",
                      selectedDevice?['value'] ?? "",
                      onSelect: (selected) {
                        selectedDevice = selected;
                        AppRunner.selectedDeviceId = selected['value'];
                        setState(() {});
                        log("SELECTED $selected");
                      },
                    );
                    deviceSelector.select();
                  },
                ),
                const SizedBox(
                  width: 2,
                ),
                BottomBarItem(
                  title: Lable.console,
                  icon: Icons.terminal,
                  onTap: () {
                    if (scale >= 200) {
                      scale = 0;
                    } else {
                      scale = 200;
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            terminal()
          ],
        ),
      ),
    );
  }

  Widget terminal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomBarItem(
                    backgroundColor: selectedTerminalOption == 0
                        ? AppTheme.teretoryColor
                        : Colors.transparent,
                    onTap: () {
                      selectedTerminalOption = 0;
                      setState(() {});
                    },
                    title: "Process",
                    iconColor:
                        selectedTerminalOption == 0 ? Colors.white : null,
                    textColor:
                        selectedTerminalOption == 0 ? Colors.white : null,
                    icon: Icons.adb_rounded),
                ValueListenableBuilder<List>(
                    valueListenable: Errors.listen,
                    builder: (context, value, c) {
                      return BottomBarItem(
                          // backgroundColor: Colors.transparent,
                          onTap: () {
                            selectedTerminalOption = 1;
                            setState(() {});
                          },
                          backgroundColor: selectedTerminalOption == 1
                              ? AppTheme.teretoryColor
                              : Colors.transparent,
                          iconColor: value.isNotEmpty
                              ? Colors.red
                              : (selectedTerminalOption == 1
                                  ? Colors.white
                                  : null),
                          textColor:
                              selectedTerminalOption == 1 ? Colors.white : null,
                          title: value.length > 0
                              ? "Errors(${value.length})"
                              : "Errors",
                          icon: Icons.error);
                    }),
                SizedBox(
                  width: 5,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Errors.clear();
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                              color: AppTheme.lightTextColor,
                              decorationColor: AppTheme.lightTextColor,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )),
              ],
            ),
            if (selectedTerminalOption == 0) ...[
              ValueListenableBuilder(
                  valueListenable: TerminalProcess.listen(),
                  builder: (context, value, widegt) {
                    var type = value['type'];
                    if (type == ConsoleProcessType.codeGeneration) {
                      num current = value['process']['outOf']['current'];
                      num total = value['process']['outOf']['total'];
                      String status = value['status'] ?? "";
                      var process = "$current / $total";

                      // log("current / total ${current / total} $current $total");
                      double progressValue = current / total;
                      return SizedBox(
                        // width: 150,
                        // height: 20,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: LinearProgressIndicator(
                                value: progressValue.isNaN ? 0 : progressValue,
                                valueColor: status == "DONE"
                                    ? const AlwaysStoppedAnimation(Colors.green)
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(status == "DONE" ? "Success" : process),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
              const SizedBox(
                height: 10,
              ),
            ]
          ],
        ),
        if (selectedTerminalOption == 0)
          Container(
            // color: Colors.yellow,
            height: scale - 90,
            child: ValueListenableBuilder<Map>(
                valueListenable: TerminalProcess.listen(),
                builder: (context, value, w) {
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: value['process']['files'].length,
                      // reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var logs = "";
                        var isCodegen =
                            value['type'] == ConsoleProcessType.codeGeneration;
                        if (isCodegen) {
                          logs = value['process']['files']
                              .reversed
                              .toList()[index];
                        } else {
                          logs = value['process']['logs'][index];
                        }

                        if (logs == "") return const SizedBox.shrink();

                        return SelectableText(
                          " ${isCodegen ? 'Current : ' : ''}$logs",
                          style: const TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  );
                }),
          ),
        if (selectedTerminalOption == 1)
          Container(
            // color: Colors.yellow,
            height: scale - 75,
            child: ValueListenableBuilder<List<Map>>(
                valueListenable: Errors.listen,
                builder: (context, value, w) {
                  return ListView.builder(
                    controller: _controller,
                    itemCount: value.length,
                    // reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // _controller.jumpTo(_controller.position.maxScrollExtent + 50);
                      var list = value.reversed.toList()[index]['error'];
                      return Text(
                        "-> $list",
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  );
                }),
          ),
      ],
    );

    return Column(
      children: [
        BottomBarItem(
          icon: Icons.error,
          title: "",
          onTap: () {},
        ),
        BottomBarItem(
          icon: Icons.warning,
          title: "",
          onTap: () {},
        ),
        BottomBarItem(
          icon: Icons.account_tree_sharp,
          title: "",
          onTap: () {},
        )
      ],
    );
  }

  Widget BottomBarItem(
      {required IconData icon,
      required String title,
      bool? isDisabled,
      Color? textColor,
      Color? backgroundColor,
      Color? iconColor,
      String? disabledToolTipMessage,
      required void Function()? onTap}) {
    bool isHovering = false;
    conditionalToolTip(
      Widget child,
    ) {
      if (isDisabled == true) {
        return Tooltip(
          message: disabledToolTipMessage ?? title,
          child: child,
        );
      } else {
        return child;
      }
    }

    return conditionalToolTip(Material(
      color: isHovering
          ? Colors.red.shade400
          : (isDisabled == true
              ? Colors.grey.shade200
              : backgroundColor ?? AppTheme.primaryColor),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isDisabled == true ? null : onTap,
        onHover: (bool value) {
          isHovering = value;
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderColor, width: 1.5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? AppTheme.teretoryColor.withOpacity(0.5),
                  ),
                  Text(
                    title,
                    style: TextStyle(color: textColor),
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
