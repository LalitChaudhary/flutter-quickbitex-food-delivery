import 'package:get/get.dart';

import 'domain/order_pricing.dart';

class OrderController extends GetxController {
  final signedIn = false.obs;
  final error = RxnString();
  final lines = <BasketLine>[].obs;
  final coupon = ''.obs;
  final status = 'Draft'.obs;
  final address = '14 Cedar Lane, Harbor District'.obs;

  OrderQuote get quote => const OrderPricing().quote(lines, coupon.value);

  void signIn(String email, String password) {
    if (email.trim() == 'rio@quickbitex.dev' && password == 'demo1234') {
      signedIn.value = true;
      error.value = null;
    } else {
      error.value = 'Use the demo diner on this screen.';
    }
  }

  void add(MenuItem item) {
    final index = lines.indexWhere((line) => line.item.id == item.id);
    if (index >= 0) {
      lines[index].qty += 1;
      lines.refresh();
    } else {
      lines.add(BasketLine(item: item));
    }
  }

  void applyCoupon(String code) {
    coupon.value = code;
  }

  void place() {
    if (lines.isEmpty) {
      error.value = 'Add a dish first.';
      return;
    }
    status.value = 'Preparing';
    error.value = null;
  }

  void advance() {
    const steps = ['Preparing', 'Courier assigned', 'Nearby', 'Delivered'];
    final index = steps.indexOf(status.value);
    if (index >= 0 && index < steps.length - 1) {
      status.value = steps[index + 1];
    }
  }
}
