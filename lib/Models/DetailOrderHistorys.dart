class DetailOrderHis {
  String? orderCode;
  String? totalAmount;
  String? subtotal;
  String? shippingFee;
  String? discount;
  String? status;
  String? paymentMethod;
  String? createdAt;
  String? voucherCode;
  String? recipientName;
  String? phone;
  String? province;
  String? district;
  String? address;
  List<Items>? items;

  DetailOrderHis({
    this.orderCode,
    this.totalAmount,
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.status,
    this.paymentMethod,
    this.createdAt,
    this.voucherCode,
    this.recipientName,
    this.phone,
    this.province,
    this.district,
    this.address,
    this.items,
  });

  DetailOrderHis.fromJson(Map<String, dynamic> json) {
    orderCode = json['order_code'];
    totalAmount = json['total_amount'];
    subtotal = json['subtotal'];
    shippingFee = json['shipping_fee'];
    discount = json['discount'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    voucherCode = json['voucher_code'];
    recipientName = json['recipient_name'];
    phone = json['phone'];
    province = json['province'];
    district = json['district'];
    address = json['address'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_code'] = orderCode;
    data['total_amount'] = totalAmount;
    data['subtotal'] = subtotal;
    data['shipping_fee'] = shippingFee;
    data['discount'] = discount;
    data['status'] = status;
    data['payment_method'] = paymentMethod;
    data['created_at'] = createdAt;
    data['voucher_code'] = voucherCode;
    data['recipient_name'] = recipientName;
    data['phone'] = phone;
    data['province'] = province;
    data['district'] = district;
    data['address'] = address;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? quantity;
  String? price;
  String? productName;
  String? mainImageUrl;
  int? size;
  int? color;

  Items({
    this.quantity,
    this.price,
    this.productName,
    this.mainImageUrl,
    this.size,
    this.color,
  });

  Items.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    productName = json['product_name'];
    mainImageUrl = json['main_image_url'];
    size = json['size'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['price'] = price;
    data['product_name'] = productName;
    data['main_image_url'] = mainImageUrl;
    data['size'] = size;
    data['color'] = color;
    return data;
  }
}
