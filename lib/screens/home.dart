import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/screens/audio/main.dart';
import 'package:today/screens/document.dart';

import 'package:today/screens/new_video.dart';
import 'package:today/screens/photo/home.dart';

import 'package:today/screens/settings.dart';
import 'package:today/screens/video_hero_animation.dart';

import 'package:today/widgets/App_bar.dart';
import 'package:today/widgets/file_upload.dart';
import 'package:today/widgets/file_upload.dart' as upload;

import 'user_name.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  final int _currentPage = 0;
  final _pageController = PageController();
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var menu = SafeArea(
      child: PopupMenuButton(
          itemBuilder: (_) => const <PopupMenuItem<String>>[
                PopupMenuItem<String>(child: Text('Doge'), value: 'Doge'),
                PopupMenuItem<String>(child: Text('Lion'), value: 'Lion'),
              ],
          onSelected: (_) {}),
    );
    List<Widget> _generate = [
      const home(),
      const UploadToFirebase(),
      const MyProfile()
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.04,
              ),
              const App_bar(),
              SizedBox(height: size.height * 0.014),
              const more(),
              SizedBox(height: size.height * 0.01),
              tabbar(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: "ADD"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_suggest_sharp), label: "Settings"),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (value) => Get.to(() => _generate[value]),
      ),
    );
  }

  Widget tabbar() {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 4,
      child: Container(
        height: size.height * 0.71,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _controller,
                labelColor: Colors.grey.shade700,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: const Color(0xffF35383),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(
                    text: 'Photos',
                  ),
                  Tab(
                    text: 'Videos',
                  ),
                  Tab(
                    text: 'Music',
                  ),
                  Tab(
                    text: 'Docoment',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  Container(
                    color: Colors.white,
                    child: MainPage(),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const VideoPlayersList(), //ChewieDemo(),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const Center(
                      child: ExampleApp(),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Document(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
