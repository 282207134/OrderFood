import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class Palette {
  static const paper = Color(0xFFFCFCFD);
  static const ink = Color(0xFF3E3F68);
  static const muted = Color(0xFF687695);
  static const line = Color(0xFFEDEDF2);
  static const orange = Color(0xFFF47B35);
  static const gold = Color(0xFFFBB231);
  static const green = Color(0xFF27A35B);
  static const gradient = LinearGradient(
    colors: [orange, gold],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const shadow = [
    BoxShadow(color: Color(0x101F2035), blurRadius: 22, offset: Offset(0, 7)),
  ];
}

String money(int value) => '\$$value';

Future<T?> openPage<T>(BuildContext context, Widget child) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => child));

void showNotice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class FoodImage extends StatelessWidget {
  const FoodImage(
    this.name, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
  });

  final String name;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/$name.webp',
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    excludeFromSemantics: true,
  );
}

class OrangeBackdrop extends StatelessWidget {
  const OrangeBackdrop({super.key});

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(gradient: Palette.gradient),
    child: Opacity(opacity: .14, child: FoodImage('header')),
  );
}

class FoodScaffold extends StatefulWidget {
  const FoodScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.drawer,
    this.floatingActionButton,
    this.lightStatus = true,
    this.protectStatusOnScroll = false,
  });

  final Widget body;
  final Widget? bottom, drawer, floatingActionButton;
  final bool lightStatus, protectStatusOnScroll;

  @override
  State<FoodScaffold> createState() => _FoodScaffoldState();
}

class _FoodScaffoldState extends State<FoodScaffold> {
  var scrolled = false;

  bool updateStatus(ScrollUpdateNotification event) {
    if (event.depth == 0 && event.metrics.axis == Axis.vertical) {
      final next = event.metrics.pixels > 45;
      if (next != scrolled) setState(() => scrolled = next);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value:
        (widget.lightStatus && !scrolled
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark)
            .copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarContrastEnforced: false,
            ),
    child: Scaffold(
      body: widget.protectStatusOnScroll
          ? NotificationListener<ScrollUpdateNotification>(
              onNotification: updateStatus,
              child: Stack(
                children: [
                  CenteredContent(child: widget.body),
                  if (scrolled)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.paddingOf(context).top,
                      child: const ColoredBox(color: Palette.paper),
                    ),
                ],
              ),
            )
          : CenteredContent(child: widget.body),
      bottomNavigationBar: widget.bottom,
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
    ),
  );
}

class CenteredContent extends StatelessWidget {
  const CenteredContent({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: child,
    ),
  );
}

class HeaderRow extends StatelessWidget {
  const HeaderRow(
    this.title, {
    super.key,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 61,
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child:
                  leading ??
                  IconButton(
                    tooltip: 'Back',
                    color: Colors.white,
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: actions.length > 1 ? 84 : 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader(this.title, {super.key, this.actions = const []});
  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned.fill(child: OrangeBackdrop()),
      Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: HeaderRow(title, actions: actions),
      ),
    ],
  );
}

class GradientButton extends StatelessWidget {
  const GradientButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.height = 50,
    this.radius = 7,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height, radius;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(radius);
    return Opacity(
      opacity: onPressed == null ? .55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Palette.gradient,
          borderRadius: border,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: border,
            onTap: onPressed,
            child: Semantics(
              button: true,
              enabled: onPressed != null,
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: .25,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomAction extends StatelessWidget {
  const BottomAction(this.label, {super.key, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: SafeArea(
      top: false,
      child: CenteredContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
          child: GradientButton(label, onPressed: onPressed),
        ),
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 9,
    this.color = Colors.white,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: border,
        boxShadow: Palette.shadow,
      ),
      child: Material(
        color: color,
        borderRadius: border,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class Caption extends StatelessWidget {
  const Caption(this.text, {super.key, this.size = 13, this.lines});
  final String text;
  final double size;
  final int? lines;

  @override
  Widget build(BuildContext context) => Text(
    text,
    maxLines: lines,
    overflow: lines == null ? null : TextOverflow.ellipsis,
    style: TextStyle(color: Palette.muted, fontSize: size, height: 1.4),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      if (onSeeAll != null)
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(foregroundColor: Palette.orange),
          child: const Text('See all'),
        ),
    ],
  );
}

class Rating extends StatelessWidget {
  const Rating(this.value, {super.key, this.light = false});
  final double value;
  final bool light;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$value out of 5 stars',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12,
            color: light ? Colors.white : Palette.ink,
          ),
        ),
        const SizedBox(width: 3),
        for (var i = 1; i <= 5; i++)
          Icon(
            value >= i
                ? Icons.star_rounded
                : value > i - 1
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            color: Palette.orange,
            size: 13,
          ),
      ],
    ),
  );
}
