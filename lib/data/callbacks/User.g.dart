part of 'User.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
    userid: json['userid'] as String,
    firstname: json['firstname'] as String,
    lastname: json['lastname'] as String,
    country: json['country'] as String,
    mobile: json['mobile'] as String,
    gender: json['gender'] as String,
    city: json['cityname'] as String,
    church: json['churchname'] as String,
    email: json['email'] as String,
    level: json['level'] as String,
    handle: json['handle'] as String,
    created: json['created'] as String,
    signedin: json['signedin'] as String,
    avatarblobid: json['avatarblobid'] as String,
    points: json['points'] as String,
    wallposts: json['wallposts'] as String);

abstract class _$UserSerializerMixin {
  String get userid;
  String get firstname;
  String get lastname;
  String get country;
  String get mobile;
  String get gender;
  String get city;
  String get church;
  String get email;
  String get level;
  String get handle;
  String get created;
  String get signedin;
  String get avatarblobid;
  String get avatarwidth;
  String get avatarheight;
  String get points;
  String get wallposts;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userid' : userid, 
				'firstname' : firstname,
				'lastname' : lastname,
				'country' : country,
				'mobile' : mobile,
				'gender' : gender,
				'city' : city,
				'church' : church,
				'email' : email,
				'level' : level,
				'handle' : handle,
				'created' : created,
				'signedin' : signedin,
				'avatarblobid' : avatarblobid,
				'points' : points,
				'wallposts' : wallposts
      };
}
