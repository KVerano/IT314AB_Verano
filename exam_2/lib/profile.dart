class Profile {
  String? name;
  String? status;
  bool? pc;
  bool? playing;
  bool? online;

  Profile({
    required this.name,
    required this.status,
    required this.pc,
    required this.online,
    required this.playing,
  });
}

class Convo {
  String? name;
  String? message;
  bool? online;

  Convo({required this.name, required this.message, required this.online});
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
