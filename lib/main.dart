import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'domain/order_pricing.dart';
import 'order_controller.dart';

void main() {
  Get.put(OrderController());
  runApp(const QuickBiteXApp());
}

class QuickBiteXApp extends StatelessWidget {
  const QuickBiteXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QuickBiteX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE4572E),
          primary: const Color(0xFFE4572E),
          background: const Color(0xFFFFF8F1),
        ),
      ),
      home: const DinerGate(),
    );
  }
}

class DinerGate extends StatelessWidget {
  const DinerGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    return Obx(() =>
        controller.signedIn.value ? const MenuPage() : const SignInPage());
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController(text: 'rio@quickbitex.dev');
    final password = TextEditingController(text: 'demo1234');
    final controller = Get.find<OrderController>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            Text('QuickBiteX',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
                'Neighborhood food demo. Payment is simulated cash on delivery.'),
            const SizedBox(height: 20),
            TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            Obx(() => Text(controller.error.value ?? '')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => controller.signIn(email.text, password.text),
              child: const Text('Find dinner'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harbor Kitchen'),
        actions: [
          IconButton(
            tooltip: 'Basket',
            onPressed: () => Get.to(() => const BasketPage()),
            icon: const Icon(Icons.shopping_basket_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final item in menu)
            ListTile(
              title: Text(item.name),
              subtitle: Text(
                  '${item.cuisine} · \$${(item.priceMinor / 100).toStringAsFixed(2)}'),
              trailing: IconButton(
                tooltip: 'Add ${item.name}',
                onPressed: () => controller.add(item),
                icon: const Icon(Icons.add),
              ),
            ),
        ],
      ),
    );
  }
}

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    final coupon = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Basket')),
      body: Obx(() {
        final quote = controller.quote;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Deliver to ${controller.address.value}'),
            if (controller.lines.isEmpty) const Text('Basket is empty.'),
            for (final line in controller.lines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(line.item.name),
                subtitle: Text(
                    'Qty ${line.qty}${line.note.isEmpty ? '' : ' · ${line.note}'}'),
              ),
            TextField(
                controller: coupon,
                decoration: const InputDecoration(labelText: 'Coupon BITE5')),
            TextButton(
              onPressed: () => controller.applyCoupon(coupon.text),
              child: const Text('Apply coupon'),
            ),
            Text('Food \$${(quote.foodMinor / 100).toStringAsFixed(2)}'),
            Text(
                'Discount \$${(quote.discountMinor / 100).toStringAsFixed(2)}'),
            Text(
                'Delivery \$${(quote.deliveryMinor / 100).toStringAsFixed(2)}'),
            Text('Total \$${(quote.totalMinor / 100).toStringAsFixed(2)}'),
            Text(controller.error.value ?? ''),
            FilledButton(
              onPressed: () {
                controller.place();
                if (controller.status.value == 'Preparing') {
                  Get.to(() => const TrackingPage());
                }
              },
              child: const Text('Place simulated order'),
            ),
          ],
        );
      }),
    );
  }
}

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Live map is simulated. No GPS permission is requested.'),
              const SizedBox(height: 12),
              Text(controller.status.value,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: controller.advance,
                child: const Text('Advance sample status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
