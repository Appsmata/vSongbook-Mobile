import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  String userid;
  String firstname;
  String lastname;
  String country;
  String mobile;
  String gender;
  String city;
  String church;
  String email;
  String level;
  String handle;
  String created;
  String signedin;
  String avatarblobid;
  String avatarwidth;
  String avatarheight;
  String points;
  String wallposts;
  
  User
    (
      {
        this.userid,
        this.firstname,
        this.lastname,
        this.country,
        this.mobile,
        this.gender,
        this.city,
        this.church,
        this.email,
        this.level,
        this.handle,
        this.created,
        this.signedin,
        this.avatarblobid,
        this.avatarwidth,
        this.avatarheight,
        this.points,
        this.wallposts
    }
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
