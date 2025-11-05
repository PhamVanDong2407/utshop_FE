class Banners {
  String? uuid;
  String? imageUrl;
  bool? isActive;

  Banners({this.uuid, this.imageUrl, this.isActive});

  Banners.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    imageUrl = json['imageUrl'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['imageUrl'] = imageUrl;
    data['isActive'] = isActive;
    return data;
  }
}
