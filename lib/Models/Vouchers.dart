class ListVouchers {
  String? uuid;
  String? code;
  String? description;
  int? discountType;
  String? discountValue;
  String? minOrderValue;
  String? maxDiscountAmount;
  String? startDate;
  String? endDate;
  int? usageLimitPerVoucher;
  int? usageLimitPerUser;
  int? currentUsageCount;
  int? userUsageCount;
  String? status;

  ListVouchers({
    this.uuid,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.minOrderValue,
    this.maxDiscountAmount,
    this.startDate,
    this.endDate,
    this.usageLimitPerVoucher,
    this.usageLimitPerUser,
    this.currentUsageCount,
    this.userUsageCount,
    this.status,
  });

  ListVouchers.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    code = json['code'];
    description = json['description'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    minOrderValue = json['min_order_value'];
    maxDiscountAmount = json['max_discount_amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    usageLimitPerVoucher = json['usage_limit_per_voucher'];
    usageLimitPerUser = json['usage_limit_per_user'];
    currentUsageCount = json['current_usage_count'];
    userUsageCount = json['user_usage_count'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['code'] = code;
    data['description'] = description;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['min_order_value'] = minOrderValue;
    data['max_discount_amount'] = maxDiscountAmount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['usage_limit_per_voucher'] = usageLimitPerVoucher;
    data['usage_limit_per_user'] = usageLimitPerUser;
    data['current_usage_count'] = currentUsageCount;
    data['user_usage_count'] = userUsageCount;
    data['status'] = status;
    return data;
  }
}
