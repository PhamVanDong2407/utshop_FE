class User {
  String? uuid;
  String? name;
  String? avatar;
  int? gender;
  String? birthDay;
  String? phone;
  String? email;
  String? province;
  String? district;
  String? address;
  String? createdAt;
  String? updatedAt;
  int? status;
  Permission? permission;

  User({
    this.uuid,
    this.name,
    this.avatar,
    this.gender,
    this.birthDay,
    this.phone,
    this.email,
    this.province,
    this.district,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.permission,
  });

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    avatar = json['avatar'];
    gender = json['gender'];
    birthDay = json['birth_day'];
    phone = json['phone'];
    email = json['email'];
    province = json['province'];
    district = json['district'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    permission =
        json['permission'] != null
            ? Permission.fromJson(json['permission'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['avatar'] = avatar;
    data['gender'] = gender;
    data['birth_day'] = birthDay;
    data['phone'] = phone;
    data['email'] = email;
    data['province'] = province;
    data['district'] = district;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    if (permission != null) {
      data['permission'] = permission!.toJson();
    }
    return data;
  }
}

class Permission {
  int? uuid;
  String? name;

  Permission({this.uuid, this.name});

  Permission.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    return data;
  }
}
