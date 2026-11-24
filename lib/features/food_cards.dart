import 'package:flutter/material.dart';

import '../core/ui.dart';
import '../data/catalog.dart';
import 'discover.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard(this.restaurant, {super.key});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) => Panel(
    onTap: () => openPage(context, RestaurantScreen(restaurant)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              FoodImage(restaurant.image),
              const Positioned(left: 10, top: 10, child: _OpenBadge()),
              Positioned(
                right: 10,
                top: 10,
                child: _Pill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Palette.gold,
                      ),
                      Text(
                        ' ${restaurant.rating.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RestaurantTag(restaurant.category),
                  const SizedBox(width: 4),
                  RestaurantTag(restaurant.distance),
                  const SizedBox(width: 8),
                  const _AvatarStack(),
                ],
              ),
              const SizedBox(height: 5),
              Caption(restaurant.address, size: 12, lines: 1),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      child: child,
    ),
  );
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge();

  @override
  Widget build(BuildContext context) => const _Pill(
    child: Text(
      'OPEN',
      style: TextStyle(
        color: Palette.green,
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class RestaurantTag extends StatelessWidget {
  const RestaurantTag(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFFF5472), Palette.gold]),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 9),
      ),
    ),
  );
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();
  static const names = [
    'avatar_one',
    'avatar_two',
    'avatar_three',
    'avatar_four',
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 50,
    height: 19,
    child: Stack(
      children: [
        for (var i = 0; i < names.length; i++)
          Positioned(
            left: i * 11.0,
            child: Container(
              width: 17,
              height: 17,
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(child: FoodImage(names[i])),
            ),
          ),
      ],
    ),
  );
}

class CategoryTile extends StatelessWidget {
  const CategoryTile(this.category, {super.key, this.onTap});
  final FoodCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Panel(
    radius: 7,
    onTap: onTap,
    child: Stack(
      fit: StackFit.expand,
      children: [
        FoodImage(category.image),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(category.tint).withValues(alpha: .44),
                Color(category.tint).withValues(alpha: .86),
              ],
            ),
          ),
        ),
        Center(
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class TrendingFoodCard extends StatelessWidget {
  const TrendingFoodCard(this.food, {super.key});
  final Food food;

  @override
  Widget build(BuildContext context) => Panel(
    onTap: () => openPage(context, FoodDetailScreen(food)),
    child: Stack(
      children: [
        Positioned(
          right: 0,
          bottom: 0,
          width: 104,
          height: 89,
          child: Opacity(
            opacity: .8,
            child: FoodImage(
              'brush',
              fit: BoxFit.contain,
              alignment: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 13, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                money(food.price),
                style: const TextStyle(color: Palette.orange, fontSize: 16),
              ),
            ],
          ),
        ),
        Positioned(
          left: 25,
          right: 1,
          bottom: 1,
          height: 83,
          child: FoodImage(
            food.image,
            fit: food.photo ? BoxFit.cover : BoxFit.contain,
            alignment: Alignment.bottomRight,
          ),
        ),
      ],
    ),
  );
}

class ReadyFoodCard extends StatelessWidget {
  const ReadyFoodCard(this.food, {super.key});
  final Food food;

  @override
  Widget build(BuildContext context) => Panel(
    onTap: () => openPage(context, FoodDetailScreen(food)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              FoodImage(food.image),
              const Positioned(left: 9, top: 9, child: _OpenBadge()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Rating(food.rating),
            ],
          ),
        ),
      ],
    ),
  );
}

class RestaurantStory extends StatelessWidget {
  const RestaurantStory(this.name, this.image, this.rating, {super.key});
  final String name, image;
  final double rating;

  @override
  Widget build(BuildContext context) => Panel(
    radius: 12,
    onTap: () => openPage(
      context,
      RestaurantScreen(
        Restaurant(
          name,
          image,
          'Station Road, Abohar',
          'Asian',
          '2.5 km',
          rating,
          'Explore seasonal plates and house favorites on this restaurant’s menu.',
        ),
      ),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        FoodImage(image),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xE300121D)],
            ),
          ),
        ),
        Positioned(
          left: 13,
          bottom: 13,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Rating(rating, light: true),
            ],
          ),
        ),
      ],
    ),
  );
}
