import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final button = PopupMenuButton(
        key: _menuKey,
        itemBuilder: (_) => const <PopupMenuItem<String>>[
              PopupMenuItem<String>(child: Text('Doge'), value: 'Doge'),
              PopupMenuItem<String>(child: Text('Lion'), value: 'Lion'),
            ],
        onSelected: (_) {});

    final tile = ListTile(
        title: Text('Doge or lion?'),
        trailing: button,
        onTap: () {
          // This is a hack because _PopupMenuButtonState is private.
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });
    return Scaffold(
      body: Center(
        child: button,
      ),
    );
  }
}
