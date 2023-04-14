import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/widgets/theme/theme_model.dart';

class more extends StatefulWidget {
  const more({super.key});

  @override
  State<more> createState() => _moreState();
}

class _moreState extends State<more> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeModel>(builder: ((controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${FirebaseAuth.instance.currentUser!.displayName}',
              style: TextStyle(
                fontSize: 21,
                color: controller.isDark? Colors.white:Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }));
  }
}
