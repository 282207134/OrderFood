import 'package:flutter/material.dart';

import '../core/order_state.dart';
import '../core/ui.dart';
import 'discover.dart';

enum AccountFlow {
  login(
    'Welcome Back!',
    'Sign in to discover restaurants and order your favorites.',
    'LOGIN',
  ),
  register(
    'Welcome',
    'Create an account to start ordering from Tasty Food.',
    'SIGN UP',
  ),
  forgot(
    'Forgot Password',
    'Enter your email address to request a reset code.',
    'SEND',
  ),
  reset(
    'Reset Password',
    'Enter the reset code and choose a new password.',
    'CHANGE PASSWORD',
  );

  const AccountFlow(this.title, this.description, this.action);

  final String title, description, action;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  var page = 0;

  void next() {
    if (page == 2) {
      openPage(context, const AccountScreen(AccountFlow.login));
      return;
    }
    controller.nextPage(
      duration: const Duration(milliseconds: 290),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FoodScaffold(
    lightStatus: page != 0,
    body: PageView.builder(
      controller: controller,
      itemCount: 3,
      onPageChanged: (value) => setState(() => page = value),
      itemBuilder: (context, index) => _Walkthrough(
        index: index,
        onNext: next,
        onLogin: () =>
            openPage(context, const AccountScreen(AccountFlow.login)),
        onDot: (value) => controller.animateToPage(
          value,
          duration: const Duration(milliseconds: 270),
          curve: Curves.easeOut,
        ),
      ),
    ),
  );
}

class _Walkthrough extends StatelessWidget {
  const _Walkthrough({
    required this.index,
    required this.onNext,
    required this.onLogin,
    required this.onDot,
  });

  final int index;
  final VoidCallback onNext, onLogin;
  final ValueChanged<int> onDot;

  @override
  Widget build(BuildContext context) {
    final dark = index == 1;
    final color = dark ? Colors.white : const Color(0xFF202127);
    return LayoutBuilder(
      builder: (context, viewport) {
        final width = viewport.maxWidth;
        return Stack(
          children: [
            if (index != 0) ...[
              const Positioned.fill(child: FoodImage('auth_photo')),
              const Positioned.fill(
                child: ColoredBox(color: Color(0x600E171F)),
              ),
            ],
            if (index == 2)
              Positioned.fill(
                top: viewport.maxHeight * .35,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(34),
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        viewport.maxHeight -
                        MediaQuery.paddingOf(context).vertical,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height:
                            (viewport.maxHeight * (index == 2 ? .34 : .045)),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height:
                            viewport.maxHeight *
                            (index == 0
                                ? .48
                                : index == 1
                                ? .43
                                : .23),
                        child: index == 0
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: -width * .34,
                                    width: width * .45,
                                    top: 28,
                                    bottom: 20,
                                    child: const FoodImage('onboard_left'),
                                  ),
                                  Positioned(
                                    right: -width * .34,
                                    width: width * .45,
                                    top: 28,
                                    bottom: 20,
                                    child: const FoodImage('onboard_side'),
                                  ),
                                  Container(
                                    width: width * .79,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: Palette.shadow,
                                    ),
                                    child: const Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        FoodImage(
                                          'food_pattern',
                                          alignment: Alignment.topCenter,
                                        ),
                                        Align(
                                          alignment: Alignment(0, -.27),
                                          child: _Logo(
                                            circled: true,
                                            size: 132,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: _Logo(
                                  circled: dark,
                                  size: dark ? 128 : 161,
                                ),
                              ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            Text(
                              'Get started',
                              style: TextStyle(
                                fontSize: 32,
                                color: color,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Discover Restaurants Delivering\nto your doorstep',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color,
                                fontSize: 17,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 29),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0; i < 3; i++)
                                  Semantics(
                                    label: 'Walkthrough ${i + 1} of 3',
                                    button: true,
                                    selected: i == index,
                                    child: InkWell(
                                      onTap: () => onDot(i),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Container(
                                          width: 39,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: i == index
                                                ? Palette.orange
                                                : (dark
                                                      ? Colors.white60
                                                      : Palette.line),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GradientButton(
                              index == 2 ? 'LOGIN' : 'NEXT',
                              onPressed: onNext,
                            ),
                            if (index < 2)
                              TextButton(
                                onPressed: onLogin,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: dark ? Colors.white : Palette.orange,
                                  ),
                                ),
                              ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: dark
                                    ? Colors.white70
                                    : Palette.muted,
                              ),
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Terms & Conditions'),
                                  content: const Text(
                                    'Tasty Food is a local demo. Restaurant listings and checkout use sample data.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.circled, required this.size});
  final bool circled;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(size * .115),
    decoration: circled
        ? const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.white24, spreadRadius: 14, blurRadius: 5),
            ],
          )
        : null,
    child: const FoodImage('onboard_logo', fit: BoxFit.contain),
  );
}

class AccountScreen extends StatefulWidget {
  const AccountScreen(this.flow, {super.key});
  final AccountFlow flow;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final form = GlobalKey<FormState>();
  final fields = List.generate(4, (_) => TextEditingController());
  AccountFlow get flow => widget.flow;

  @override
  void dispose() {
    for (final field in fields) {
      field.dispose();
    }
    super.dispose();
  }

  void goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final order = OrderScope.read(context);
    switch (flow) {
      case AccountFlow.login:
        order.signIn(fields[0].text);
        goHome();
      case AccountFlow.register:
        order.signIn(fields[0].text, email: fields[1].text.trim());
        openPage(
          context,
          SuccessScreen(
            message: 'Your Tasty Food account is ready. Explore restaurants and choose your first meal.',
            button: 'EXPLORE FOOD',
            onContinue: goHome,
          ),
        );
      case AccountFlow.forgot:
        openPage(context, const AccountScreen(AccountFlow.reset));
      case AccountFlow.reset:
        openPage(
          context,
          SuccessScreen(
            message: 'You have successfully changed your demo password. Return to login to continue.',
            button: 'BACK TO LOGIN',
            onContinue: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => const AccountScreen(AccountFlow.login),
              ),
              (route) => route.isFirst,
            ),
          ),
        );
    }
  }

  Widget field(
    int index,
    String label, {
    bool secret = false,
    TextInputType? keyboard,
    String? Function(String)? check,
  }) => AppField(
    key: ValueKey('account-${flow.name}-$index'),
    label: label,
    controller: fields[index],
    keyboard: keyboard,
    secret: secret,
    validator: (value) {
      final text = (value ?? '').trim();
      if (text.isEmpty) return 'Enter ${label.toLowerCase()}';
      return check?.call(text);
    },
  );

  String? email(String text) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)
      ? null
      : 'Enter a valid email address';

  String? password(String text) =>
      text.length >= 6 ? null : 'Use at least 6 characters';

  String? confirm(String text) =>
      text == fields[2 - (flow == AccountFlow.reset ? 1 : 0)].text.trim()
      ? null
      : 'Passwords must match';

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    return _AccountFrame(
      child: LayoutBuilder(
        builder: (context, box) {
          final double top = keyboard
              ? 20
              : (flow == AccountFlow.register
                    ? 30
                    : (box.maxHeight * .19).clamp(25, 120).toDouble());
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(30, top, 30, 18),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (box.maxHeight - top - 18).clamp(0, double.infinity),
              ),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          flow.title,
                          style: const TextStyle(
                            color: Color(0xFF202127),
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Caption(flow.description, size: 15),
                        const SizedBox(height: 17),
                        ...switch (flow) {
                          AccountFlow.login => [
                            field(0, 'Username'),
                            field(1, 'Password', secret: true, check: password),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => openPage(
                                  context,
                                  const AccountScreen(AccountFlow.forgot),
                                ),
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          ],
                          AccountFlow.register => [
                            field(0, 'Username'),
                            field(
                              1,
                              'Email address',
                              keyboard: TextInputType.emailAddress,
                              check: email,
                            ),
                            field(2, 'Password', secret: true, check: password),
                            field(
                              3,
                              'Confirm password',
                              secret: true,
                              check: confirm,
                            ),
                          ],
                          AccountFlow.forgot => [
                            field(
                              0,
                              'Email address',
                              keyboard: TextInputType.emailAddress,
                              check: email,
                            ),
                          ],
                          AccountFlow.reset => [
                            const Caption('Demo reset code: 236545'),
                            field(
                              0,
                              'Reset code',
                              keyboard: TextInputType.number,
                              check: (value) => value == '236545'
                                  ? null
                                  : 'Enter the demo reset code',
                            ),
                            field(
                              1,
                              'New password',
                              secret: true,
                              check: password,
                            ),
                            field(
                              2,
                              'Confirm password',
                              secret: true,
                              check: confirm,
                            ),
                          ],
                        },
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 22),
                        GradientButton(flow.action, onPressed: submit),
                        if (flow == AccountFlow.register) ...[
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Palette.ink,
                              side: const BorderSide(color: Palette.line),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            onPressed: () => showNotice(
                              context,
                              'Google sign-up is unavailable in this local demo.',
                            ),
                            icon: const Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            label: const Text('Sign up with Google'),
                          ),
                        ],
                        if (flow == AccountFlow.login ||
                            flow == AccountFlow.register)
                          TextButton(
                            onPressed: () {
                              if (flow == AccountFlow.register) {
                                Navigator.pop(context);
                              } else {
                                openPage(
                                  context,
                                  const AccountScreen(AccountFlow.register),
                                );
                              }
                            },
                            child: Text(
                              flow == AccountFlow.login
                                  ? 'Don’t have an account? Sign Up'
                                  : 'Already have an account? Sign In',
                            ),
                          )
                        else
                          const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppField extends StatefulWidget {
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboard,
    this.secret = false,
    this.validator,
    this.maxLength,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final bool secret;
  final String? Function(String?)? validator;
  final int? maxLength;

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  bool reveal = false;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboard,
      obscureText: widget.secret && !reveal,
      enableSuggestions: !widget.secret,
      autocorrect: !widget.secret,
      validator: widget.validator,
      maxLength: widget.maxLength,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.label,
        counterText: '',
        suffixIcon: widget.secret
            ? IconButton(
                tooltip: reveal ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => reveal = !reveal),
                icon: Icon(
                  reveal
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 19,
                ),
              )
            : null,
      ),
    ),
  );
}

class _AccountFrame extends StatelessWidget {
  const _AccountFrame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    final headerHeight = keyboard ? 100.0 : 133.0;
    return FoodScaffold(
      body: Stack(
        children: [
          Positioned(
            height: headerHeight + 40,
            left: 0,
            right: 0,
            top: 0,
            child: const Stack(
              fit: StackFit.expand,
              children: [
                FoodImage('auth_photo', alignment: Alignment.topCenter),
                ColoredBox(color: Color(0x55101620)),
              ],
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: HeaderRow('')),
          Positioned.fill(
            top: headerHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(33)),
              ),
              child: SafeArea(top: false, child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.message,
    required this.button,
    required this.onContinue,
  });
  final String message, button;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _AccountFrame(
    child: LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 35, 30, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (box.maxHeight - 59).clamp(0, double.infinity),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const FoodImage(
                'success_illustration',
                width: 180,
                height: 216,
                fit: BoxFit.contain,
              ),
              Column(
                children: [
                  const SizedBox(height: 38),
                  const Text(
                    'Successfully!',
                    style: TextStyle(fontSize: 31, color: Color(0xFF202127)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(button, onPressed: onContinue),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
