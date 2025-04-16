// import 'package:chatbot/facility.dart';
// import 'package:chatbot/gallery.dart';
// import 'package:chatbot/staff.dart';
import 'package:flutter/material.dart';
// import '../../chat bot.dart';
import '../../user/sell pets and adopt.dart';
import '../../user/view groomimg and service request.dart';
import '../../user/view pets and buy.dart';
import '../../user/viewcart.dart';
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


                if (course[index].text == "View Pets") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>viewpetsandbuy (title: '')),
                  );
                } else if (course[index].text == "Sell and Adopt Pet") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sellpetsandadopt(title: '',)),
                  );
                } else if (course[index].text == "Grooming Service") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => viewgroomingandservicerequest(title: '')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>Viewcart(title: '')),
                  );
                }
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
