import 'package:flutter_test/flutter_test.dart';
import 'package:quickbitex/domain/order_pricing.dart';

void main() {
  const pricing = OrderPricing();

  test('small order keeps a delivery fee and BITE5 discount', () {
    final quote = pricing.quote(
      [BasketLine(item: menu[2], qty: 2)],
      'bite5',
    );
    expect(quote.foodMinor, 700);
    expect(quote.discountMinor, 35);
    expect(quote.deliveryMinor, 299);
    expect(quote.totalMinor, 700 - 35 + 299);
  });

  test('orders at 25 dollars waive delivery', () {
    final quote = pricing.quote(
      [BasketLine(item: menu[1], qty: 2)],
      '',
    );
    expect(quote.foodMinor, 2900);
    expect(quote.deliveryMinor, 0);
  });
}
