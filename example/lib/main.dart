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
        builder: (context, window, route, arguments) {
          return WindowWidget(
              window: window, route: route, arguments: arguments);
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
  NewWindow? _newWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NewWindow.show(
                  route: '/newcore/macos',
                  arguments: {'User': 'Young'},
                  closable: false,
                ).then((value) {
                  setState(() {
                    _newWindow = value;
                  });
                });
              },
              child: const Text('New Window'),
            ),
            if (_newWindow != null) ...[
              const SizedBox(
                height: 24,
              ),
              Text('A new window 【${_newWindow!.id}】 created!'),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  NewWindow.of(0).sendMessageTo(
                      toWindowId: _newWindow!.id,
                      message: 'Hello World To Window 【${_newWindow!.id}】');
                },
                child: const Text('Send Hello'),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class WindowWidget extends StatefulWidget {
  const WindowWidget(
      {super.key, required this.window, required this.route, this.arguments});

  final NewWindow window;
  final String route;
  final Map<String, dynamic>? arguments;

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  String? _receiveMessage;

  @override
  void initState() {
    widget.window.receiver(onClose: () {
      debugPrint('NewWindow State: onClose');
    }, shouldClose: () {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: const Text('Confirm to close?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.window.close();
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ));
      }
    }, onMessage: (message) {
      if (mounted) {
        setState(() {
          _receiveMessage = message.message;
        });
      }
    });
    super.initState();
  }

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
            Text('Route: ${widget.route}'),
            Text('Arguments: ${jsonEncode(widget.arguments)}'),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                widget.window.close();
              },
              child: const Text('Close'),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(_receiveMessage ?? ''),
          ],
        ),
      ),
    );
  }
}
