import 'package:flutter/material.dart';
import 'base_stations.dart';
import 'exercise_tile.dart';
import 'main.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class Exercise {
  final IconData icon;
  final String exerciseName;
  final int numberOfExercises;
  final Color color;

  Exercise(this.icon, this.exerciseName, this.numberOfExercises, this.color);
}

class _DashboardState extends State<Dashboard> {
  List<Exercise> allExercises = [
    Exercise(Icons.place, 'My Survey', 16, Colors.orange),
    Exercise(Icons.person, 'My Installations', 8, Colors.green),
    Exercise(Icons.build, 'Installation Report', 10, Colors.pink),
  ];

  List<Exercise> filteredExercises = [];
  String searchQuery = '';
  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd MMM, yyyy   hh:mm a').format(now);
    return formattedDateTime;
  }

  void filterExercises(String query) {
    setState(() {
      searchQuery = query;
      filteredExercises = allExercises
          .where((exercise) =>
              exercise.exerciseName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentDateTime = getCurrentDateTime();
    return Scaffold(
      backgroundColor: Colors.blue[800],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Greetings Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // User's Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Hi Admin!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(currentDateTime,
                              style: TextStyle(color: Colors.blue[200])),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //Notification
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: filterExercises,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // Engineering
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ENGINEERING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Icon(
                      //   Icons.more_horiz,
                      //   color: Colors.white,
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),

                  // 4 different
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Site Survey
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.place,
                                  size: 28,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Site Survey',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Base Stations
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BaseStation()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.router,
                                  size: 28,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            Text('BaseStations',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),

                      // Installations
                      Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.build,
                                size: 28,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Installtions',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),

                      // Orders
                      Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.shopping_cart,
                                size: 28,
                                color: Colors.white,
                              )),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Orders',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(25),
                  color: Colors.grey[200],
                  child: Center(
                      child: Column(children: [
                    //Reports
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('REPORTS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        // Icon(Icons.more_horiz),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // listview of exercises
                    Expanded(
                      child: ListView(children: [
                        ExerciseTile(
                          icon: Icons.place,
                          exerciseName: 'My Survey',
                          numberOfExercises: 16,
                          color: Colors.orange,
                        ),
                        ExerciseTile(
                          icon: Icons.person,
                          exerciseName: 'My Installations',
                          numberOfExercises: 8,
                          color: Colors.green,
                        ),
                        ExerciseTile(
                          icon: Icons.build,
                          exerciseName: 'Installation Report',
                          numberOfExercises: 10,
                          color: Colors.pink,
                        ),
                      ]),
                    ),
                  ]))),
            ),
          ],
        ),
      ),
    );
  }
}
