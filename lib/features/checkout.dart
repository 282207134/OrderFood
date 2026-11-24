import 'package:flutter/material.dart';

import '../core/order_state.dart';
import '../core/ui.dart';
import '../data/catalog.dart';
import 'auth.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);
    return _CheckoutLayout(
      title: 'Add To Cart',
      subtitle: 'Add to food list',
      action: BottomAction(
        'CHECKOUT',
        onPressed: order.itemCount == 0
            ? null
            : () => openPage(context, const CheckoutScreen()),
      ),
      children: [
        if (order.itemCount == 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 52,
                  color: Palette.muted,
                ),
                SizedBox(height: 12),
                Text('Your basket is empty', style: TextStyle(fontSize: 19)),
                SizedBox(height: 6),
                Caption('Choose a dish to start an order.'),
              ],
            ),
          ),
        for (final entry in order.basket.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _BasketItem(entry.key, entry.value, order),
          ),
        if (order.itemCount != 0) ...[
          const SizedBox(height: 15),
          _Totals(order),
        ],
      ],
    );
  }
}

class _BasketItem extends StatelessWidget {
  const _BasketItem(this.food, this.quantity, this.order);
  final Food food;
  final int quantity;
  final OrderState order;

  @override
  Widget build(BuildContext context) => Panel(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(9, 9, 4, 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: ColoredBox(
              color: const Color(0xFFFFF4E6),
              child: FoodImage(
                food.image,
                width: 92,
                height: 96,
                fit: food.photo ? BoxFit.cover : BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Caption(food.description, size: 11, lines: 2),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      money(food.price * quantity),
                      style: const TextStyle(color: Palette.orange),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuantityButton(
                          Icons.remove,
                          'Fewer ${food.name}',
                          () => order.changeQuantity(food, -1),
                        ),
                        Text('$quantity'),
                        _QuantityButton(
                          Icons.add,
                          'More ${food.name}',
                          () => order.changeQuantity(food, 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => order.removeFood(food),
            tooltip: 'Remove ${food.name}',
            icon: const Icon(Icons.close, size: 18, color: Palette.muted),
          ),
        ],
      ),
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton(this.icon, this.label, this.onPressed);
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    width: 36,
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 17, color: Palette.ink),
    ),
  );
}

class _Totals extends StatelessWidget {
  const _Totals(this.order);
  final OrderState order;

  @override
  Widget build(BuildContext context) => Panel(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          line('Subtotal', order.subtotal),
          const SizedBox(height: 5),
          line('Delivery charges', order.deliveryFee),
          const Divider(height: 20),
          line('Total amount', order.total, total: true),
        ],
      ),
    ),
  );

  Widget line(String label, int price, {bool total = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: total ? Palette.ink : Palette.muted,
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        money(price),
        style: TextStyle(
          color: total ? Palette.orange : Palette.muted,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);
    return _CheckoutLayout(
      title: 'Payment Process',
      subtitle: 'Submit your order',
      action: BottomAction(
        'SUBMIT ORDER',
        onPressed: order.itemCount == 0
            ? null
            : () {
                if (!order.submitOrder()) return;
                final navigator = Navigator.of(context);
                navigator.pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => SuccessScreen(
                      message: 'Your demo order has been placed. Thanks for ordering with Tasty Food!',
                      button: 'BACK TO HOME',
                      onContinue: () =>
                          navigator.popUntil((route) => route.isFirst),
                    ),
                  ),
                );
              },
      ),
      children: [
        _CheckoutPanel(
          title: 'Shipping address',
          change: () => openPage(context, const ShippingScreen()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.address.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Caption(order.address.summary, size: 14),
            ],
          ),
        ),
        const SizedBox(height: 23),
        _CheckoutPanel(
          title: 'Payment',
          change: () => openPage(context, const PaymentMethodsScreen()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _PaymentLogo(order.method),
                  const SizedBox(width: 8),
                  Expanded(child: Text(order.method.label)),
                  if (order.lastDigits.isNotEmpty)
                    Caption('•••• ${order.lastDigits}'),
                ],
              ),
              if (order.expiry case final expiry?) ...[
                const SizedBox(height: 9),
                Caption('Expiry on $expiry'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 23),
        _Totals(order),
        const SizedBox(height: 13),
        const Caption(
          'Demo checkout · No payment will be collected.',
          size: 12,
        ),
      ],
    );
  }
}

class _CheckoutPanel extends StatelessWidget {
  const _CheckoutPanel({
    required this.title,
    required this.change,
    required this.child,
  });
  final String title;
  final VoidCallback change;
  final Widget child;

  @override
  Widget build(BuildContext context) => Panel(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: change,
                child: Semantics(
                  label: 'Change $title',
                  excludeSemantics: true,
                  child: const Text('Change'),
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  static const labels = [
    'Full name',
    'Address 1',
    'Address 2',
    'City',
    'State',
    'Zip code',
  ];
  final form = GlobalKey<FormState>();
  late final fields = OrderScope.read(context).address.fields
      .map((value) => TextEditingController(text: value))
      .toList();

  @override
  void dispose() {
    for (final field in fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    final values = fields.map((controller) => controller.text.trim()).toList();
    OrderScope.read(context).setAddress(
      ShippingAddress(
        values[0],
        values[1],
        values[2],
        values[3],
        values[4],
        values[5],
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await openPage<bool>(
      context,
      const PaymentMethodsScreen(),
    );
    if (mounted && selected == true) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => _CheckoutLayout(
    title: 'Shipping Address',
    subtitle: 'New Shipping address',
    action: BottomAction('PAYMENT METHOD', onPressed: save),
    children: [
      Form(
        key: form,
        child: Column(
          children: [
            for (var i = 0; i < labels.length; i++)
              AppField(
                label: labels[i],
                controller: fields[i],
                keyboard: i == 5 ? TextInputType.streetAddress : null,
                validator: i == 2 ? null : requiredField,
              ),
          ],
        ),
      ),
    ],
  );
}

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  Future<void> select(BuildContext context, PaymentMethod method) async {
    if (method.demoDigits.isEmpty) {
      OrderScope.read(context).selectPayment(method);
      Navigator.pop(context, true);
      return;
    }
    final saved = await openPage<bool>(context, CardScreen(method));
    if (saved == true && context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final current = OrderScope.of(context).method;
    return _CheckoutLayout(
      title: 'Payment Method',
      subtitle: 'Select your payment method',
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a demo card',
        backgroundColor: Palette.orange,
        foregroundColor: Colors.white,
        onPressed: () => select(context, PaymentMethod.mastercard),
        child: const Icon(Icons.add_rounded, size: 29),
      ),
      children: [
        for (final method in PaymentMethod.values)
          Column(
            children: [
              ListTile(
                tileColor: method == current
                    ? const Color(0xFFF2F2F4)
                    : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                leading: _PaymentLogo(method),
                title: Text(method.label),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Palette.muted,
                  size: 20,
                ),
                onTap: () => select(context, method),
              ),
              const Divider(height: 1),
            ],
          ),
      ],
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  const _PaymentLogo(this.method);
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) => Container(
    width: 49,
    height: 31,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Palette.line),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
      child: switch (method) {
        PaymentMethod.visa => const Text(
          'VISA',
          style: TextStyle(
            color: Color(0xFF11457B),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
        PaymentMethod.mastercard => SizedBox(
          width: 33,
          height: 18,
          child: Stack(
            children: [
              circle(0, const Color(0xFFEB001B)),
              circle(13, const Color(0xD9FF9B00)),
            ],
          ),
        ),
        PaymentMethod.paypal => const Text(
          'P',
          style: TextStyle(
            color: Color(0xFF1777BA),
            fontStyle: FontStyle.italic,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        PaymentMethod.rupay => const FoodImage(
          'rupay',
          width: 40,
          fit: BoxFit.contain,
        ),
        PaymentMethod.paytm => const FoodImage(
          'paytm',
          width: 40,
          fit: BoxFit.contain,
        ),
      },
    ),
  );

  Positioned circle(double left, Color color) => Positioned(
    left: left,
    child: SizedBox.square(
      dimension: 18,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

class CardScreen extends StatefulWidget {
  const CardScreen(this.method, {super.key});
  final PaymentMethod method;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: 'Dylan Flores');
  late final number = TextEditingController(
    text: '4111 1111 1111 ${widget.method.demoDigits}',
  );
  final expiry = TextEditingController(text: '06 / 30');
  final cvv = TextEditingController(text: '123');
  late bool saveCard = OrderScope.read(context).saveCard;

  @override
  void dispose() {
    name.dispose();
    number.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  String digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  void save() {
    if (!form.currentState!.validate()) return;
    final cardNumber = digits(number.text);
    final expires = digits(expiry.text);
    OrderScope.read(context).useCard(
      widget.method,
      cardNumber.substring(cardNumber.length - 4),
      '${expires.substring(0, 2)}/${expires.substring(2)}',
      saveCard,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => _CheckoutLayout(
    title: 'My Card',
    subtitle: 'Your payment method',
    action: BottomAction('PAY NOW', onPressed: save),
    children: [
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: AspectRatio(
            aspectRatio: 260 / 164,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: const FoodImage('card_preview'),
            ),
          ),
        ),
      ),
      const SizedBox(height: 17),
      const Caption(
        'Demo card details are prefilled for local checkout.',
        size: 12,
      ),
      const SizedBox(height: 6),
      Form(
        key: form,
        child: Column(
          children: [
            AppField(
              label: 'Card holder name',
              controller: name,
              validator: requiredField,
            ),
            AppField(
              label: 'Card number',
              controller: number,
              keyboard: TextInputType.number,
              validator: (value) => digits(value ?? '').length == 16
                  ? null
                  : 'Enter 16 demo digits',
            ),
            Row(
              children: [
                Expanded(
                  child: AppField(
                    label: 'Expiry date',
                    controller: expiry,
                    keyboard: TextInputType.datetime,
                    validator: (value) =>
                        RegExp(r'^(0[1-9]|1[0-2])\d{2}$')
                            .hasMatch(digits(value ?? ''))
                        ? null
                        : 'Use MM / YY',
                  ),
                ),
                const SizedBox(width: 19),
                Expanded(
                  child: AppField(
                    label: 'CVV',
                    controller: cvv,
                    secret: true,
                    maxLength: 4,
                    keyboard: TextInputType.number,
                    validator: (value) =>
                        RegExp(r'^\d{3,4}$').hasMatch(value ?? '')
                        ? null
                        : 'Enter 3 or 4 digits',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Save this card'),
        activeThumbColor: Colors.white,
        activeTrackColor: Palette.green,
        value: saveCard,
        onChanged: (value) => setState(() => saveCard = value),
      ),
    ],
  );
}

String? requiredField(String? value) =>
    (value ?? '').trim().isEmpty ? 'Required' : null;

class _CheckoutLayout extends StatelessWidget {
  const _CheckoutLayout({
    required this.title,
    required this.subtitle,
    required this.children,
    this.action,
    this.floatingActionButton,
  });

  final String title, subtitle;
  final List<Widget> children;
  final Widget? action, floatingActionButton;

  @override
  Widget build(BuildContext context) => FoodScaffold(
    bottom: MediaQuery.viewInsetsOf(context).bottom == 0 ? action : null,
    floatingActionButton: floatingActionButton,
    body: Column(
      children: [
        PageHeader(title),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SectionTitle(subtitle),
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        ),
      ],
    ),
  );
}
