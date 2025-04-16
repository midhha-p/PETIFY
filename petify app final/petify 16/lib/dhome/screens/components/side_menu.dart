import 'package:flutter/material.dart';
import 'package:petify/deliveryboy/viewprofilenew.dart';
import '../../../deliveryboy/changepass.dart';
import '../../../deliveryboy/update work status.dart';
import '../../../deliveryboy/view assigned work.dart';
import '../../../deliveryboy/view profile.dart';
import '../../../deliveryboy/view rating.dart';
import '../../../reg/loginPage.dart';
import '../../constant.dart';
import '../../main.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 30),

          // You can also add a user avatar or branding/logo here if needed.

          DrawerListTile(
            icon: Icons.home, // ✅ Updated
            title: "Home",
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),

          DrawerListTile(
            icon: Icons.account_circle, // ✅ Updated
            title: "Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewProfilePage(title: '')),
              );
            },
          ),

          DrawerListTile(
            icon: Icons.lock_outline, // ✅ Updated
            title: "Change Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(title: '')),
              );
            },
          ),

          DrawerListTile(
            icon: Icons.assignment, // ✅ Updated
            title: "Assigned Work",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAssignedWork(title: '')),
              );
            },
          ),

          DrawerListTile(
            icon: Icons.star_rate, // ✅ Updated
            title: "Rating",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewReviewpage(title: '')),
              );
            },
          ),

          DrawerListTile(
            icon: Icons.logout, // Optional logout entry
            title: "Logout",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(title: '')),
              );
            },
          ),

          const SizedBox(height: 10),
          Image.asset(
            "images/dogss.png",
            height: 150,
          ),
          const SizedBox(height: 10),

          Container(
            height: 100,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("See you soon",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("LOGOUT", style: TextStyle(color: kDarkBlue)),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(title: '')),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: kDarkBlue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: kDarkBlue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        color: Colors.grey[700],
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
