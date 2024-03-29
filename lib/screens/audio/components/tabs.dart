import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final List<TabData> tabs;

  const Tabs({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelColor: Colors.black,
              tabs: tabs
                  .map(
                    (tData) => Tab(
                      key: tData.key != null ? Key(tData.key!) : null,
                      text: tData.label,
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) => tab.content).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabData {
  final String? key;
  final String label;
  final Widget content;

  TabData({this.key, required this.label, required this.content});
}
