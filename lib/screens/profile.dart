import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/controller/auth_controller.dart';
import 'package:today/widgets/change_password.dart';
import 'package:today/widgets/change_profile.dart';
// import '../providers/user_provider.dart';
// import '../widgets/password_change.dart';

// import '../widgets/change_phone.dart';
// import '../widgets/change_profile.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // late UserBloc user;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // user.loadData(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // user = Provider.of<UserBloc>(context);
    return GetBuilder<AuthController>(
      builder:((auth) =>  Scaffold(
          appBar: AppBar(
            title: const Text("الملف الشخصي"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _getHeader(),
                      const Divider(),
                      _myOrder('تغيير صورة البروفايل', Icons.person_outline,
                          () async {
                        setState(() {
                          uploading = true;
                        });
                        await auth.updateProfile();
                        setState(() {
                          uploading = false;
                        });
                      }),
                      _myOrder(
                        'تعديل اسم المستخدم',
                        Icons.edit,
                        () => showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          backgroundColor: Colors.white,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: const ChangeProfileWidget(),
                          ),
                        ),
                      ),
                      // _myOrder(
                      //   'تعديل الرقم الهاتف',
                      //   Icons.phone,
                      //   () => showModalBottomSheet(
                      //     context: context,
                      //     useRootNavigator: true,
                      //     isScrollControlled: true,
                      //     shape: const RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(30),
                      //           topRight: Radius.circular(30)),
                      //     ),
                      //     backgroundColor: Colors.white,
                      //     builder: (context) => Padding(
                      //       padding: MediaQuery.of(context).viewInsets,
                      //       child: Text("") //const ChangePhoneWidget(),
                      //     ),
                      //   ),
                      // ),
                      _myOrder(
                        'تغيير الرمز السري',
                        Icons.password_outlined,
                        () => showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          backgroundColor: Colors.white,
                          builder: (context) => Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: const ChangePasswordWidget(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _myOrder('تسجيل خروج', Icons.exit_to_app,
                 () async {
                  // var auth = AuthController();
                  auth.signOut();
                  // final sh = await SharedPreferences.getInstance();
                  // sh.remove("token");
                  // Navigator.pushReplacementNamed(context, 'login');
                }),
              )
            ],
          )))
    );
  }

  Widget _getHeader() {
    var auth = Get.find<AuthController>();
    return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 10.0, top: 10),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Padding(
                //     padding: const EdgeInsetsDirectional.only(start: 10),
                //     child: Container(
                //       margin: const EdgeInsetsDirectional.only(bottom: 17),
                //       height: 64,
                //       width: 64,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(width: 1.0, color: Colors.white)),
                //       child: GestureDetector(
                //         onTap: () async {
                //           setState(() {
                //             uploading = true;
                //           });
                //           // await user.uploadImages(context);
                //           setState(() {
                //             uploading = false;
                //           });
                //         },
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(30),
                //           child: uploading
                //               ? const CircularProgressIndicator()
                //               : Image.network(
                //                   // 'https://yoo2.smart-node.net${user.user?.avatar}',
                //                   auth.profileurl!,
                //                   errorBuilder: (context, error, stackTrace) =>
                //                       const Icon(
                //                     Icons.person,
                //                     size: 55,
                //                   ),
                //                 ),
                //         ),
                //       ),
                //     )),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً, ${FirebaseAuth.instance.currentUser!.displayName}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    // Text(
                    //   '${FirebaseAuth.instance.currentUser!.displayName}',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .subtitle2!
                    //       .copyWith(color: Colors.black),
                    // )
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  _myOrder(String text, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: ListTile(
          dense: true,
          title: Text(
            text,
            // style: GoogleFonts.cairo().copyWith(fontSize: 15),
          ),
          leading: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(
                icon,
              )),
          trailing: const Icon(
            Icons.keyboard_arrow_left,
          ),
          onTap: () => onPressed(),
        ),
      ),
    );
  }
}
