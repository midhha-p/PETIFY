import 'package:flutter/material.dart';
import '../../user/sell pets and adopt.dart';
import '../../user/view groomimg and service request.dart';
import '../../user/view pets and buy.dart';
import '../../user/viewcart.dart';
import '../dhome/constant.dart';
import '../dhome/data/data.dart';
import '../dhome/model/course_model.dart';

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
        return Card(
          elevation: 8,  // Adds shadow to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),  // Rounded corners for the card
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(course[index].backImage),
                fit: BoxFit.cover,  // Ensures the background image covers the entire card
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken), // Darkens the background
              ),
              borderRadius: BorderRadius.circular(12),  // Same border radius as the card
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  if (course[index].text == "View Pets") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          viewpetsandbuy(title: '')),
                    );
                  }
                  else if (course[index].text == "Sell and Adopt Pet") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          sellpetsandadopt(title: '',)),
                    );
                  }

                  child:
                  Row(
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
                  );
                }
                ),
            ),
          ),
        );
      },
    );
  }
}
