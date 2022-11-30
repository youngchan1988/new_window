import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_window/new_window.dart';

void main(List<String> args) {
  runApp(StartApp(
    args: args,
  ));
}

class StartApp extends StatelessWidget {
  const StartApp({super.key, required this.args});
  final List<String> args;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewWindowApp(
        runArgs: args,
        home: const MyApp(),
        builder: (context, windowId, route, arguments) {
          return WindowWidget(
              windowId: windowId, route: route, arguments: arguments);
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          NewWindow.show(route: '/newcore/macos', arguments: {'User': 'Young'});
        },
        child: const Text('New Window'),
      )),
    );
  }
}

class WindowWidget extends StatelessWidget {
  const WindowWidget(
      {super.key, required this.windowId, required this.route, this.arguments});

  final int windowId;
  final String route;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Window')),
      body: Container(
        color: Colors.blueAccent,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Route: $route'),
            Text('Arguments: ${jsonEncode(arguments)}'),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  NewWindow.close(windowId);
                },
                child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}
