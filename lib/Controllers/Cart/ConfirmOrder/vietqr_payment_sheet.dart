// TẬP TIN: vietqr_payment_sheet.dart (Phiên bản đơn giản nhất)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utshop/Global/app_color.dart';
import 'package:utshop/Routes/app_page.dart';
import 'package:utshop/Utils/utils.dart';

class VietQRPaymentSheet extends StatelessWidget {
  final String orderCode;
  final double totalAmount;
  final String bankBin;
  final String bankAccount;
  final String accountName;

  late final String qrImageUrl;

  VietQRPaymentSheet({
    super.key,
    required this.orderCode,
    required this.totalAmount,
    required this.bankBin,
    required this.bankAccount,
    required this.accountName,
  }) {
    qrImageUrl = _getQRImageUrl();
  }

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  String _getQRImageUrl() {
    final memo = orderCode.replaceAll(" ", "");
    return "https://img.vietqr.io/image/$bankBin-$bankAccount-compact2.png?amount=${totalAmount.toInt()}&addInfo=$memo&accountName=$accountName";
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Utils.showSnackBar(
      title: "Đã sao chép",
      message: text,
      backgroundColor: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String amountString = _currencyFormatter.format(totalAmount);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Thanh toán VietQR",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300], height: 1),
          // Nội dung
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Quét mã QR hoặc sao chép thông tin",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  // Mã QR
                  Container(
                    width: 260,
                    height: 260,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      qrImageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Text(
                              "Lỗi tải mã QR. Vui lòng thử lại.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Thông tin chi tiết
                  _buildInfoRow(context, "Ngân hàng", accountName),
                  _buildInfoRow(
                    context,
                    "Số tài khoản",
                    bankAccount,
                    canCopy: true,
                  ),
                  _buildInfoRow(
                    context,
                    "Số tiền",
                    amountString,
                    canCopy: true,
                    isAmount: true,
                  ),
                  _buildInfoRow(
                    context,
                    "Nội dung",
                    orderCode,
                    canCopy: true,
                    isMemo: true,
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "QUAN TRỌNG: Vui lòng nhập ĐÚNG nội dung chuyển khoản là mã đơn hàng.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Nút "Tôi đã thanh toán"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(Routes.orderSuccess, arguments: orderCode);
                    Utils.showSnackBar(
                      title: "Thông báo",
                      message: "Admin sẽ xác nhận đơn hàng của bạn sớm nhất.",
                      backgroundColor: Colors.green,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Tôi đã thanh toán",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool canCopy = false,
    bool isAmount = false,
    bool isMemo = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    isAmount
                        ? Colors.red
                        : (isMemo ? AppColor.primary : Colors.black),
              ),
            ),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () => _copyToClipboard(context, value),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.copy, size: 18, color: AppColor.primary),
              ),
            ),
        ],
      ),
    );
  }
}
