class DetailProduct {
  String? uuid;
  String? name;
  String? description;
  int? price;
  bool? isFavorite;
  int? totalStock;
  List<Images>? images;
  List<Variants>? variants;

  DetailProduct({
    this.uuid,
    this.name,
    this.description,
    this.price,
    this.isFavorite,
    this.totalStock,
    this.images,
    this.variants,
  });

  DetailProduct.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    isFavorite = json['is_favorite'];
    totalStock = json['total_stock'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['is_favorite'] = isFavorite;
    data['total_stock'] = totalStock;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? uuid;
  String? url;
  bool? isMain;

  Images({this.uuid, this.url, this.isMain});

  Images.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    url = json['url'];
    isMain = json['is_main'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['url'] = url;
    data['is_main'] = isMain;
    return data;
  }
}

class Variants {
  String? variantUuid;
  int? size;
  int? color;
  int? stock;

  Variants({this.variantUuid, this.size, this.color, this.stock});

  Variants.fromJson(Map<String, dynamic> json) {
    variantUuid = json['variant_uuid'];
    size = json['size'];
    color = json['color'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_uuid'] = variantUuid;
    data['size'] = size;
    data['color'] = color;
    data['stock'] = stock;
    return data;
  }
}
