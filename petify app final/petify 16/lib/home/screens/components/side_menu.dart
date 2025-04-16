import 'package:flutter/material.dart';
import 'package:petify/user/view%20groomimg%20and%20service%20request.dart';
import 'package:petify/user/view%20payement.dart';
import '../../../disease prediction.dart';
import '../../../reg/loginPage.dart';
import '../../../user/change password.dart';
import '../../../user/ChatBot.dart';
import '../../../user/send rating.dart';
import '../../../user/user view profile.dart';
import '../../../user/user view rating.dart';
import '../../../user/view groomimg.dart';
import '../../../user/view my pets.dart';
import '../../../user/view pet order.dart';
import '../../../user/view veterinary.dart';
import '../../../user/viewproduct.dart';
import '../../../user/viewproductcart.dart';
import '../../constant.dart';
import '../../main.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          DrawerListTile(
            icon: Icons.home,
            title: "Home",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewProfile(title: 'Profile'),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.lock,
            title: "Change password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => changepassword(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.pets,
            title: "My pets",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMyPets(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.payment,
            title: "Payments",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => viewpayement(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.star_rate,
            title: "Send rating",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => sendrating(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.reviews,
            title: "View rating",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => userviewrating(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.shopping_bag,
            title: "View pet product",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => viewproduct(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.shopping_cart,
            title: "View pet product cart",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => viewproductcart(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.health_and_safety,
            title: "Disease Prediction",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PredictionsList(),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.cleaning_services,
            title: "View Grooming Package",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewgrooming(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.medical_services,
            title: "View Nearby Vets",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewveterinary(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.shopping_basket,
            title: "View Pet Order",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewpetorder(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.design_services,
            title: "Grooming Request & Service",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => viewgroomingandservicerequest(title: ''),
                ),
              );
            },
          ),
          DrawerListTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(title: ''),
                ),
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
                const Text(
                  "See you soon",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("LOGOUT", style: TextStyle(color: kDarkBlue)),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(title: ''),
                          ),
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
                    ),
                  ],
                ),
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
      horizontalTitleGap: 10,
      leading: Icon(
        icon,
        color: Colors.grey,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
