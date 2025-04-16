// import 'package:chatbot/facility.dart';
// import 'package:chatbot/gallery.dart';
// import 'package:chatbot/staff.dart';
import 'package:flutter/material.dart';
import 'package:petify/deliveryboy/viewprofilenew.dart';
// import '../../chat bot.dart';
import '../../deliveryboy/update work status.dart';
import '../../deliveryboy/view assigned work.dart';
import '../../deliveryboy/view profile.dart';
import '../../deliveryboy/view rating.dart';
import '../data/data.dart';

class CourseGrid extends StatelessWidget {
  const CourseGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: course.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 16 / 7, // Adjust this ratio based on your UI design
        crossAxisCount: 1,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(course[index].backImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {


                if (course[index].text == "Profile") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>ViewProfilePage (title: '')),
                  );
                } else if (course[index].text == "Assigned Work") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAssignedWork(title: '')),
                  );
                }
                else if (course[index].text == "Rating") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReviewpage(title: '')),
                  );
                }

                // else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) =>updateworkstatus(title: '')),
                //   );
                // }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Column with course text and lessons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        course[index].text,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   course[index].lessons,
                      //   style: const TextStyle(color: Colors.white),
                      // ),
                    ],
                  ),
                  // Right Column with course image
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        course[index].imageUrl,
                        height: 110,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
