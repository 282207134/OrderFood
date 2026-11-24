class Food {
  const Food(
    this.name,
    this.image,
    this.price,
    this.category,
    this.description, {
    this.photo = false,
    this.rating = 4.6,
  });

  final String name;
  final String image;
  final int price;
  final String category;
  final String description;
  final bool photo;
  final double rating;
}

class Restaurant {
  const Restaurant(
    this.name,
    this.image,
    this.address,
    this.category,
    this.distance,
    this.rating,
    this.description,
  );

  final String name;
  final String image;
  final String address;
  final String category;
  final String distance;
  final double rating;
  final String description;
}

class FoodCategory {
  const FoodCategory(
    this.name,
    this.image,
    this.tint,
    this.description,
    this.rating,
  );

  final String name;
  final String image;
  final int tint;
  final String description;
  final double rating;
}

const categories = [
  FoodCategory(
    'Asian',
    'asian',
    0xFFF0794A,
    'Rice bowls, noodles and street-food favorites.',
    4.6,
  ),
  FoodCategory(
    'Chinese',
    'chinese',
    0xFF8C46C4,
    'Wok-fried favorites with fragrant sauces.',
    3.5,
  ),
  FoodCategory(
    'Pizza',
    'pizza',
    0xFF2955CF,
    'Freshly baked crusts with generous toppings.',
    5.0,
  ),
  FoodCategory(
    'Vegan',
    'asian',
    0xFFE26463,
    'Fresh vegetables, grains and plant-based mains.',
    4.6,
  ),
];

const restaurants = [
  Restaurant(
    'Lucky Sweets',
    'salmon',
    '169, Sakhale Road, Kherwadi, Abohar',
    'Asian',
    '2.2 km',
    4.0,
    'A neighborhood kitchen for freshly cooked rice, noodles and generous plates to share. Order your favorites from the menu below.',
  ),
  Restaurant(
    'Spice Kitchen',
    'steak',
    '42, Station Road, Abohar',
    'Asian',
    '3.1 km',
    4.5,
    'Grilled mains and seasonal sides, prepared to order with the kitchen’s spice blends.',
  ),
  Restaurant(
    'Green Table',
    'salad',
    '18, Garden Road, Abohar',
    'Vegan',
    '3.8 km',
    4.7,
    'Colorful bowls and fresh greens, with bright dressings and a rotating selection of sides.',
  ),
];

const trendingFoods = [
  Food(
    'Manchurian Noodles',
    'noodles',
    12,
    'Chinese',
    'Wok-tossed noodles with vegetables and Manchurian sauce.',
  ),
  Food(
    'Chicken Fried Rice',
    'rice',
    10,
    'Asian',
    'Golden fried rice tossed with chicken, fresh vegetables and house seasoning.',
  ),
  Food(
    'Crispy Chicken Plate',
    'chicken',
    15,
    'Asian',
    'Crispy chicken, seasoned potatoes and a side of greens.',
  ),
  Food(
    'Garden Salad',
    'greens',
    5,
    'Vegan',
    'Crunchy greens, vegetables and a bright house dressing.',
  ),
  Food(
    'Barbecue Wings',
    'barbecue',
    20,
    'Asian',
    'Smoky glazed wings with a creamy dipping sauce.',
  ),
  Food(
    'Roast Sandwich',
    'roast',
    16,
    'Asian',
    'Roasted filling, crisp lettuce and a toasted roll.',
  ),
  Food(
    'Chili Noodles',
    'noodles',
    12,
    'Chinese',
    'Noodles tossed with red chili and crunchy vegetables.',
  ),
  Food(
    'Vegetable Fried Rice',
    'rice',
    10,
    'Chinese',
    'Fried rice with crisp seasonal vegetables and spring onion.',
  ),
];

const readyFoods = [
  Food(
    'Salmon & Greens',
    'salmon',
    15,
    'Asian',
    'Salmon served with fresh greens and a house dressing.',
    photo: true,
  ),
  Food(
    'Avocado Bowl',
    'salad',
    15,
    'Vegan',
    'Creamy avocado, herbs and fresh vegetables.',
    photo: true,
  ),
  Food(
    'Garden Pizza',
    'pizza_full',
    14,
    'Pizza',
    'Stone-baked pizza with vegetables and cheese.',
    photo: true,
  ),
  Food(
    'Lunch Bowl',
    'sandwich',
    15,
    'Asian',
    'A lunch bowl of grilled chicken, fries and vegetables.',
    photo: true,
  ),
  Food(
    'Fruit & Oat Bowl',
    'dessert',
    9,
    'Vegan',
    'Fresh fruit, oat clusters and yogurt.',
    photo: true,
  ),
  Food(
    'Peach Parfait',
    'dumplings',
    8,
    'Vegan',
    'Sliced peach, yogurt and toasted granola.',
    photo: true,
  ),
];

const restaurantStories = [
  ('Sushi Place', 'sushi', 3.4),
  ('NomNom', 'bar', 3.8),
  ('Sushi Place', 'sushi', 4.6),
];
