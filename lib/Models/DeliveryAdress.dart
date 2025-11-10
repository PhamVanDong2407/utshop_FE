class DeliveryAdd {
  String? uuid;
  String? recipientName;
  String? phone;
  String? province;
  String? district;
  String? address;
  int? isDefault;

  DeliveryAdd({
    this.uuid,
    this.recipientName,
    this.phone,
    this.province,
    this.district,
    this.address,
    this.isDefault,
  });

  DeliveryAdd.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    recipientName = json['recipient_name'];
    phone = json['phone'];
    province = json['province'];
    district = json['district'];
    address = json['address'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['recipient_name'] = recipientName;
    data['phone'] = phone;
    data['province'] = province;
    data['district'] = district;
    data['address'] = address;
    data['is_default'] = isDefault;
    return data;
  }
}
