import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './api/firebase_api.dart';
import './model/firebase_file.dart';
import './page/image_page.dart';
import 'package:flutter/material.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp();

//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // static final String title = 'Image';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();

    futureFiles =
        FirebaseApi.listAll("${FirebaseAuth.instance.currentUser!.uid}/images");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(
        //   title: Text(MyApp.title),
        //   centerTitle: true,
        // ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // buildHeader(files.length),
                      // const SizedBox(height: 12),
                      Expanded(
                        child: GridView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            if (file.name.contains("jpg") ||
                                file.name.contains("png") ||
                                file.name.contains("jpeg")) {
                              return buildFile(context, file);
                            } else {
                              return const Text("");
                            }
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      );

  Widget buildFile(BuildContext context, FirebaseFile file) {
    return
        // Container(
        //     margin: const EdgeInsets.only(top: 10),
        //     // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        //     height: 100,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(15),
        //         gradient: const LinearGradient(colors: [
        //           // Color.fromARGB(255, 24, 94, 224),
        //           Color(0xFF42A5F5),
        //           Color.fromARGB(15, 42, 197, 244),
        //         ])
        //         // color: Colors.amber,
        //         ),
        //     child: Padding(
        //         padding: const EdgeInsets.only(
        //           left: 15,
        //           top: 20,
        //           bottom: 5,
        //         ),
        // child:
        GestureDetector(
      // leading: ClipOval(
      child: Image.network(
        file.url,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImagePage(file: file),
      )),
    );
    // title: Text(
    //   file.name,
    //   style: const TextStyle(
    //     fontWeight: FontWeight.bold,
    //     decoration: TextDecoration.underline,
    //     color: Colors.blue,
    //   ),
    // ),

    // ));
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: const Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
}
