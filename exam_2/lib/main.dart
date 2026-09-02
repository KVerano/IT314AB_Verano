import 'package:flutter/material.dart';

class Profile {
  String name;
  String status;
  bool pc;
  bool playing;
  bool online;

  Profile({
    required this.name,
    required this.status,
    required this.pc,
    required this.online,
    required this.playing,
  });
}

List<Profile> profiles = [
  Profile(
    name: 'MissYouLikeKrazy',
    status: 'Online',
    pc: true,
    online: true,
    playing: false,
  ),
  Profile(
    name: 'bread',
    status: 'Playing',
    pc: true,
    online: true,
    playing: true,
  ),
  Profile(
    name: 'The14th',
    status: 'Playing',
    pc: true,
    online: true,
    playing: true,
  ),
];

List<Profile> online = [
  Profile(
    name: 'Carlvendish',
    status: 'Away',
    pc: false,
    online: false,
    playing: false,
  ),
  Profile(
    name: 'D1yah',
    status: 'Away',
    pc: false,
    online: false,
    playing: false,
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SocialPage());
  }
}

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 13, 14),

      body: ListView(
        padding: EdgeInsets.only(top: 50),

        children: [
          Padding(
            padding: EdgeInsets.only(left: 32),

            child: Text(
              'Social',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Messages',
                style: TextStyle(
                  color: Color.fromARGB(255, 130, 127, 128),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Requests',
                style: TextStyle(
                  color: Color.fromARGB(255, 130, 127, 128),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // SizedBox(width: 20),
            ],
          ),

          SizedBox(height: 25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),

            child: Card(
              color: Color.fromARGB(255, 36, 32, 33),
              elevation: 0,

              child: Padding(
                padding: EdgeInsets.all(15),

                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 190, 187, 188),
                      size: 30,
                    ),

                    SizedBox(width: 12),

                    Text(
                      'Search',
                      style: TextStyle(
                        color: Color.fromARGB(255, 190, 187, 188),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.only(left: 40),

            child: Row(
              children: [
                Text(
                  'VALORANT',
                  style: TextStyle(
                    color: Color.fromARGB(255, 190, 187, 188),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: 8),

                Text(
                  '3',
                  style: TextStyle(
                    color: Color.fromARGB(255, 190, 187, 188),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          profileCard(profiles[0]),
          profileCard(profiles[1]),
          profileCard(profiles[2]),

          SizedBox(height: 10),

          Padding(
            padding: EdgeInsets.only(left: 40),

            child: Text(
              'Online 4',
              style: TextStyle(
                color: Color.fromARGB(255, 190, 187, 188),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 15),

          profileCard(online[0]),
          profileCard(online[1]),
        ],
      ),
    );
  }

  Widget profileCard(Profile profile) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 25, bottom: 15),

      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,

            decoration: BoxDecoration(
              color: Color.fromARGB(255, 36, 33, 34),
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.person,
              color: profile.online
                  ? Color.fromARGB(255, 255, 70, 85)
                  : Colors.white,
              size: 38,
            ),
          ),

          SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 3),

              Row(
                children: [
                  Icon(
                    profile.pc ? Icons.monitor : Icons.mobile_friendly,
                    color: Color.fromARGB(255, 190, 187, 188),
                    size: 19,
                  ),

                  SizedBox(width: 5),

                  Text(
                    profile.pc
                        ? '${profile.status} - VALORANT'
                        : '${profile.status} - Riot Mobile',
                    style: TextStyle(
                      color: Color.fromARGB(255, 190, 187, 188),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
