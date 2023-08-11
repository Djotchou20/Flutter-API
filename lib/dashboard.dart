import 'package:flutter/material.dart';
import 'base_stations.dart';
import 'exercise_tile.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'camera.dart';

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
        items: const [
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
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Hi Admin!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(currentDateTime,
                              style: TextStyle(color: Colors.blue[200])),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //Notification
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: filterExercises,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // Engineering
                  const Row(
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
                  const SizedBox(
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
                                builder: (context) => const MyHomePage()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.place,
                                  size: 28,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
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
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.router,
                                  size: 28,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('BaseStations',
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
                              padding: const EdgeInsets.all(16),
                              child: const Icon(
                                Icons.build,
                                size: 28,
                                color: Colors.white,
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text('Installtions',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),

                      // Orders
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Camera()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 28,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Camera',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(25),
                  color: Colors.grey[200],
                  child: Center(
                      child: Column(children: [
                    //Reports
                    const Row(
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
                    const SizedBox(
                      height: 20,
                    ),

                    // listview of exercises
                    Expanded(
                      child: ListView(children: const [
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
