import 'package:flutter/material.dart';

class Profile {
  String image;
  String name;
  int score;
  int kills;
  int deaths;
  int assists;
  bool matchMvp;
  bool teamMvp;

  Profile({
    required this.image,
    required this.name,
    required this.score,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.matchMvp,
    required this.teamMvp,
  });
}

List<Profile> profiles = [
  Profile(
    image: 'assets/phoenix.webp',
    name: 'Scyn4pse',
    score: 261,
    kills: 23,
    deaths: 21,
    assists: 6,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/sova.webp',
    name: 'Sova Chinese',
    score: 190,
    kills: 17,
    deaths: 21,
    assists: 8,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/chamber.webp',
    name: 'Dabid',
    score: 89,
    kills: 9,
    deaths: 8,
    assists: 1,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/clove.webp',
    name: 'Clove Chinese',
    score: 298,
    kills: 28,
    deaths: 23,
    assists: 6,
    matchMvp: true,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/reyna.webp',
    name: 'noobsaur',
    score: 259,
    kills: 21,
    deaths: 21,
    assists: 10,
    matchMvp: false,
    teamMvp: false,
  ),
];

List<Profile> opponents = [
  Profile(
    image: 'assets/sova.webp',
    name: 'tlbvay',
    score: 219,
    kills: 20,
    deaths: 18,
    assists: 5,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/reyna.webp',
    name: 'Kreiz',
    score: 191,
    kills: 18,
    deaths: 21,
    assists: 2,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/raze.webp',
    name: 'TranHoang17',
    score: 203,
    kills: 19,
    deaths: 19,
    assists: 4,
    matchMvp: false,
    teamMvp: false,
  ),
  Profile(
    image: 'assets/cypher.webp',
    name: 'Neithl',
    score: 246,
    kills: 23,
    deaths: 21,
    assists: 5,
    matchMvp: false,
    teamMvp: true,
  ),
  Profile(
    image: 'assets/brimstone.webp',
    name: 'clutch bus cuk',
    score: 159,
    kills: 13,
    deaths: 19,
    assists: 9,
    matchMvp: false,
    teamMvp: false,
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // give ang widget sa iyang ID

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MatchPage());
  }
}

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 27, 28),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 27, 28),
        foregroundColor: Colors.white,
        title: Text(
          '< Match Details', // huehue maam wako ka icon, na gg na ang oks gi mano2 nalang haha
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text(
            'My Team',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          // profile cards sa mga profiles sa "My Team" kemeru huehue (ka remember ko ani ka sir mark maam)
          profileCard(profiles[0]),
          profileCard(profiles[1]),
          profileCard(profiles[2]),
          profileCard(profiles[3]),
          profileCard(profiles[4]),

          SizedBox(height: 25),

          Text(
            'Opponents',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          // profile cards sa mga profiles sa "Opponents"
          profileCard(opponents[0]),
          profileCard(opponents[1]),
          profileCard(opponents[2]),
          profileCard(opponents[3]),
          profileCard(opponents[4]),
        ],
      ),
    );
  }

  Widget profileCard(Profile profile) {
    return Card(
      color: Color.fromARGB(255, 26, 27, 28),
      margin: EdgeInsets.only(bottom: 8),

      child: Padding(
        padding: EdgeInsets.all(10),

        child: Row(
          // profile, score, & kda
          children: [
            Image.asset(profile.image, width: 55, height: 55),

            SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                if (profile.matchMvp)
                  Text(
                    'MATCH MVP',
                    style: TextStyle(color: Colors.amber, fontSize: 11),
                  ),

                if (profile.teamMvp)
                  Text(
                    'TEAM MVP',
                    style: TextStyle(color: Colors.amber, fontSize: 11),
                  ),
              ],
            ),

            Text(
              '${profile.score}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(width: 18),

            Text(
              '${profile.kills} / ${profile.deaths} / ${profile.assists}',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
