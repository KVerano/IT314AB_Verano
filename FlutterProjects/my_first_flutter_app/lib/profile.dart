class Profile {
  String image;
  String name;
  String course;
  String yearLevel;
  int age;
  String hobby;
  String studentId;
  String email;
  String favoriteSubject;
  bool isScholar = false;
  bool isFavorite = false;
  bool active = true;

  Profile({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    this.active = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'course': course,
      'yearLevel': yearLevel,
      'age': age,
      'hobby': hobby,
      'studentId': studentId,
      'email': email,
      'favoriteSubject': favoriteSubject,
      'isScholar': isScholar,
      'isFavorite': isFavorite,
      'active': active,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    Profile student = Profile(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      course: json['course'] ?? '',
      yearLevel: json['yearLevel'] ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      hobby: json['hobby'] ?? 'Not provided',
      studentId: json['studentId'] ?? '',
      email: json['email'] ?? '',
      favoriteSubject: json['favoriteSubject'] ?? 'Not provided',
      active: json['active'] ?? true,
    );

    student.isScholar = json['isScholar'] ?? false;
    student.isFavorite = json['isFavorite'] ?? false;

    return student;
  }
}

List<Profile> profiles = [
  Profile(
    image: 'assets/kierstien.jpeg',
    name: 'Verano, Kierstien S.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Sleeping',
    studentId: '11111',
    email: 'kierstien.verano@dbtc-cebu.edu.ph',
    favoriteSubject: 'Break Time',
    active: true,
  ),

  Profile(
    image: 'assets/kyla.jpeg',
    name: 'Caballero, Kyla Marie S.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Drawing',
    studentId: '22222',
    email: 'kyla.caballero@dbtc-cebu.edu.ph',
    favoriteSubject: 'Break Time',
    active: true,
  ),

  Profile(
    image: 'assets/zelon.jpeg',
    name: 'Estimo, Zelon Matthew C.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 21,
    hobby: 'Dancing',
    studentId: '33333',
    email: 'zelon.estimo@dbtc-cebu.edu.ph',
    favoriteSubject: 'Dismissal Time',
    active: true,
  ),

  Profile(
    image: 'assets/leila.jpeg',
    name: 'Bangoy, Leila G.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Watching Movies',
    studentId: '44444',
    email: 'leila.bangoy@dbtc-cebu.edu.ph',
    favoriteSubject: 'Application Development and Emerging Technologies',
    active: true,
  ),

  Profile(
    image: 'assets/cassy.jpeg',
    name: 'Oraiz, Cassandra Gayle R.',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 20,
    hobby: 'Gaming',
    studentId: '55555',
    email: 'cassandra.oraiz@dbtc-cebu.edu.ph',
    favoriteSubject: 'Internet of Things',
    active: true,
  ),

  Profile(
    image: 'assets/taylor.webp',
    name: 'Swift, Taylor Alison',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 23,
    hobby: 'Singing',
    studentId: '66666',
    email: 'taylor.swift@dbtc-cebu.edu.ph',
    favoriteSubject: 'Fundamentals of Databased System',
    active: false,
  ),
];
