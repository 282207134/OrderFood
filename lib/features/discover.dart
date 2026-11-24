import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/order_state.dart';
import '../core/ui.dart';
import '../data/catalog.dart';
import 'auth.dart';
import 'checkout.dart';
import 'food_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FoodScaffold(
      protectStatusOnScroll: true,
      drawer: const _FoodMenu(),
      bottom: _HomeNavigation(
        onHome: () {
          if (scroll.hasClients) {
            scroll.animateTo(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        },
      ),
      body: ListView(
        controller: scroll,
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 225,
                child: OrangeBackdrop(),
              ),
              Column(
                children: [
                  Builder(
                    builder: (context) => HeaderRow(
                      'Welcome to Tasty Food',
                      leading: IconButton(
                        tooltip: 'Open menu',
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        color: Colors.white,
                        icon: const Icon(Icons.menu_rounded, size: 28),
                      ),
                      actions: const [_SearchAction()],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 12, 2),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Trending Restaurants',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => openPage(
                            context,
                            const CatalogScreen(CatalogKind.restaurants),
                          ),
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  ),
                  _HorizontalRail(
                    height: 249,
                    width: 300,
                    children: [
                      for (final restaurant in restaurants)
                        RestaurantCard(restaurant),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _HomeSection(
            'Category',
            CatalogKind.categories,
            child: _HorizontalRail(
              height: 78,
              width: 72,
              children: [
                for (final category in categories)
                  CategoryTile(
                    category,
                    onTap: () => openPage(
                      context,
                      CatalogScreen(
                        CatalogKind.categoryFoods,
                        category: category,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _HomeSection(
            'Trending Food',
            CatalogKind.trending,
            child: _HorizontalRail(
              height: 164,
              width: 155,
              children: [
                for (final food in trendingFoods.take(4))
                  TrendingFoodCard(food),
              ],
            ),
          ),
          _HomeSection(
            'Latest item',
            CatalogKind.restaurants,
            child: _HorizontalRail(
              height: 205,
              width: 152,
              children: [
                for (final (name, image, rating) in restaurantStories)
                  RestaurantStory(name, image, rating),
              ],
            ),
          ),
          _HomeSection(
            'All Foods',
            CatalogKind.ready,
            child: _HorizontalRail(
              height: 193,
              width: 175,
              children: [for (final food in readyFoods) ReadyFoodCard(food)],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection(this.title, this.kind, {required this.child});
  final String title;
  final CatalogKind kind;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 13),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title,
            onSeeAll: () => openPage(context, CatalogScreen(kind)),
          ),
        ),
        child,
      ],
    ),
  );
}

class _HorizontalRail extends StatelessWidget {
  const _HorizontalRail({
    required this.height,
    required this.width,
    required this.children,
  });
  final double height, width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) =>
          SizedBox(width: width, child: children[index]),
    ),
  );
}

class _HomeNavigation extends StatelessWidget {
  const _HomeNavigation({required this.onHome});
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final count = OrderScope.of(context).itemCount;
    return Material(
      color: Colors.white,
      elevation: 5,
      child: SafeArea(
        top: false,
        child: CenteredContent(
          child: SizedBox(
            height: 63,
            child: Row(
              children: [
                _NavButton(
                  'Home',
                  Icons.home_outlined,
                  selected: true,
                  onPressed: onHome,
                ),
                _NavButton(
                  'Categories',
                  Icons.restaurant_menu_rounded,
                  onPressed: () => openPage(
                    context,
                    const CatalogScreen(CatalogKind.categories),
                  ),
                ),
                _NavButton(
                  'Basket',
                  Icons.shopping_basket_outlined,
                  count: count,
                  onPressed: () => openPage(context, const BasketScreen()),
                ),
                _NavButton(
                  'Profile',
                  Icons.person_outline_rounded,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton(
    this.label,
    this.icon, {
    this.selected = false,
    this.count = 0,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          tooltip: label,
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: Icon(
              icon,
              color: selected ? Palette.orange : Palette.ink,
              size: 23,
            ),
          ),
          onPressed: onPressed,
        ),
        if (selected)
          const Positioned(
            bottom: 3,
            child: SizedBox(
              width: 45,
              height: 3,
              child: ColoredBox(color: Palette.orange),
            ),
          ),
      ],
    ),
  );
}

enum CatalogKind {
  restaurants('Trending Restaurants', ''),
  categories('Food Category', 'Select your food category'),
  trending('Trending Food', 'Now trending'),
  ready('All Ready Foods', 'Ready to order'),
  categoryFoods('', 'Ready to order');

  const CatalogKind(this.title, this.subtitle);
  final String title, subtitle;
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen(this.kind, {super.key, this.category});
  final CatalogKind kind;
  final FoodCategory? category;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  var sorted = false;

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final isRestaurants = kind == CatalogKind.restaurants;
    final isCategories = kind == CatalogKind.categories;
    final foods = switch (kind) {
      CatalogKind.trending => [...trendingFoods],
      CatalogKind.ready => [...readyFoods],
      CatalogKind.categoryFoods => [
        ...trendingFoods,
        ...readyFoods,
      ].where((food) => food.category == widget.category?.name).toList(),
      _ => <Food>[],
    };
    if (sorted) foods.sort((a, b) => a.price.compareTo(b.price));
    final restaurantList = [...restaurants];
    if (sorted) restaurantList.sort((a, b) => b.rating.compareTo(a.rating));
    final categoryList = [...categories];
    if (sorted) categoryList.sort((a, b) => a.name.compareTo(b.name));

    return FoodScaffold(
      body: Column(
        children: [
          PageHeader(
            widget.category?.name ?? kind.title,
            actions: [
              const _SearchAction(compact: true),
              SizedBox(
                width: 40,
                child: IconButton(
                  color: Colors.white,
                  tooltip: sorted
                      ? 'Restore original order'
                      : isRestaurants
                      ? 'Sort by rating'
                      : isCategories
                      ? 'Sort by name'
                      : 'Sort by price',
                  onPressed: () {
                    setState(() => sorted = !sorted);
                    showNotice(
                      context,
                      sorted
                          ? isRestaurants
                                ? 'Sorted by rating'
                                : isCategories
                                ? 'Sorted by name'
                                : 'Sorted by lowest price'
                          : 'Original order restored',
                    );
                  },
                  icon: Icon(
                    sorted ? Icons.filter_list_off : Icons.tune_rounded,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 32),
              children: [
                if (kind.subtitle.isNotEmpty) ...[
                  SectionTitle(kind.subtitle),
                  const SizedBox(height: 18),
                ],
                if (isRestaurants)
                  for (final restaurant in restaurantList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 21),
                      child: SizedBox(
                        height: 242,
                        child: RestaurantCard(restaurant),
                      ),
                    ),
                if (isCategories)
                  for (final category in categoryList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CategoryRow(category),
                    ),
                if (!isRestaurants && !isCategories)
                  _FoodGrid(
                    foods: foods,
                    readyStyle: kind == CatalogKind.ready,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.category);
  final FoodCategory category;

  @override
  Widget build(BuildContext context) {
    void open() => openPage(
      context,
      CatalogScreen(CatalogKind.categoryFoods, category: category),
    );
    return Panel(
      onTap: open,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
        child: Row(
          children: [
            SizedBox(width: 72, height: 72, child: CategoryTile(category)),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name == 'Pizza'
                        ? 'Pizza'
                        : '${category.name} food',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Caption(category.description, size: 12, lines: 2),
                  const SizedBox(height: 5),
                  Rating(category.rating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodGrid extends StatelessWidget {
  const _FoodGrid({required this.foods, this.readyStyle = false});
  final List<Food> foods;
  final bool readyStyle;

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    primary: false,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 16,
      mainAxisExtent: readyStyle ? 192 : 153,
    ),
    itemCount: foods.length,
    itemBuilder: (_, index) => readyStyle
        ? ReadyFoodCard(foods[index])
        : TrendingFoodCard(foods[index]),
  );
}

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen(this.restaurant, {super.key});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) => FoodScaffold(
    protectStatusOnScroll: true,
    body: ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 228,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FoodImage(restaurant.image),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x82000000),
                      Colors.transparent,
                      Color(0x33000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: HeaderRow(
                  '',
                  actions: [
                    IconButton(
                      tooltip: 'Copy restaurant address',
                      color: Colors.white,
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: '${restaurant.name}\n${restaurant.address}',
                          ),
                        );
                        if (context.mounted) {
                          showNotice(context, 'Restaurant address copied');
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 14,
                right: 18,
                child: FilledButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(restaurant.name),
                      content: Text(restaurant.address),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Palette.ink,
                  ),
                  icon: const Icon(Icons.location_on_outlined, size: 17),
                  label: const Text('Find Locations'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RestaurantTag(restaurant.category),
                  RestaurantTag(restaurant.distance),
                ],
              ),
              const SizedBox(height: 5),
              Caption(restaurant.address),
              const SizedBox(height: 8),
              Rating(restaurant.rating),
              const SizedBox(height: 23),
              const SectionTitle('Description'),
              const SizedBox(height: 8),
              Caption(restaurant.description, size: 15),
            ],
          ),
        ),
        _HomeSection(
          'Trending food',
          CatalogKind.trending,
          child: _HorizontalRail(
            height: 164,
            width: 155,
            children: [
              for (final food in trendingFoods.take(4)) TrendingFoodCard(food),
            ],
          ),
        ),
        _HomeSection(
          'Menu listing',
          CatalogKind.ready,
          child: _HorizontalRail(
            height: 193,
            width: 175,
            children: [for (final food in readyFoods) ReadyFoodCard(food)],
          ),
        ),
        const SizedBox(height: 25),
      ],
    ),
  );
}

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen(this.food, {super.key});
  final Food food;

  @override
  Widget build(BuildContext context) {
    void add() {
      OrderScope.read(context).changeQuantity(food, 1);
      showNotice(context, '${food.name} added to your basket');
    }

    return FoodScaffold(
      protectStatusOnScroll: true,
      bottom: Material(
        color: Colors.white,
        elevation: 5,
        child: SafeArea(
          top: false,
          child: CenteredContent(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Palette.ink,
                      minimumSize: const Size.fromHeight(58),
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: add,
                    child: const Text('Add to Cart'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GradientButton(
                    'Buy Now ${money(food.price)}',
                    height: 58,
                    radius: 0,
                    onPressed: () {
                      OrderScope.read(context).changeQuantity(food, 1);
                      openPage(context, const BasketScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 334,
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 19,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(84),
                    ),
                    child: food.photo
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              FoodImage(food.image),
                              const ColoredBox(color: Color(0x55000000)),
                            ],
                          )
                        : const OrangeBackdrop(),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: HeaderRow('', actions: const [_SearchAction()]),
                ),
                Positioned(
                  top: 99,
                  left: 21,
                  right: 30,
                  child: Text(
                    food.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.05,
                    ),
                  ),
                ),
                if (!food.photo)
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 5,
                    height: 185,
                    child: FoodImage(food.image, fit: BoxFit.contain),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      money(food.price),
                      style: const TextStyle(
                        color: Palette.orange,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Caption('${food.category} • Tasty Food'),
                const SizedBox(height: 7),
                Rating(food.rating),
                const SizedBox(height: 25),
                const SectionTitle('Description'),
                const SizedBox(height: 8),
                Caption(food.description, size: 15),
              ],
            ),
          ),
          _HomeSection(
            'Related Food',
            CatalogKind.trending,
            child: _HorizontalRail(
              height: 164,
              width: 155,
              children: [
                for (final item
                    in trendingFoods.where((item) => item != food).take(4))
                  TrendingFoodCard(item),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: compact ? 40 : 48,
    child: IconButton(
      tooltip: 'Search',
      onPressed: () =>
          showSearch<void>(context: context, delegate: _FoodSearch()),
      color: Colors.white,
      icon: const Icon(Icons.search_rounded, size: 25),
    ),
  );
}

class _FoodSearch extends SearchDelegate<void> {
  _FoodSearch() : super(searchFieldLabel: 'Search food or restaurants');

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      tooltip: 'Clear search',
      onPressed: () => query = '',
      icon: const Icon(Icons.clear),
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _matches(context);

  @override
  Widget buildSuggestions(BuildContext context) => _matches(context);

  Widget _matches(BuildContext context) {
    final term = query.trim().toLowerCase();
    final foods = [...trendingFoods, ...readyFoods].where(
      (food) => '${food.name} ${food.category}'.toLowerCase().contains(term),
    );
    final places = restaurants.where(
      (restaurant) => restaurant.name.toLowerCase().contains(term),
    );
    if (foods.isEmpty && places.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView(
      children: [
        for (final restaurant in places)
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(restaurant.name),
            subtitle: Text(restaurant.address),
            onTap: () => openPage(context, RestaurantScreen(restaurant)),
          ),
        for (final food in foods)
          ListTile(
            leading: FoodImage(
              food.image,
              width: 50,
              height: 42,
              fit: BoxFit.contain,
            ),
            title: Text(food.name),
            subtitle: Text(food.category),
            trailing: Text(money(food.price)),
            onTap: () => openPage(context, FoodDetailScreen(food)),
          ),
      ],
    );
  }
}

class _FoodMenu extends StatelessWidget {
  const _FoodMenu();

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);
    final navigator = Navigator.of(context);
    void closeThen(Widget child) {
      navigator.pop();
      navigator.push(MaterialPageRoute<void>(builder: (_) => child));
    }

    void info(String title, String message) => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        width: 263,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 35, 14, 12),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const FoodImage(
                    'profile',
                    width: 62,
                    height: 62,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(order.name, style: const TextStyle(fontSize: 22)),
              Caption(order.handle),
              const SizedBox(height: 14),
              const Divider(),
              for (final (icon, label, action)
                  in <(IconData, String, VoidCallback)>[
                    (Icons.home_outlined, 'Home', navigator.pop),
                    (
                      Icons.search,
                      'Search',
                      () {
                        navigator.pop();
                        showSearch<void>(
                          context: navigator.context,
                          delegate: _FoodSearch(),
                        );
                      },
                    ),
                    (
                      Icons.shopping_basket_outlined,
                      'Basket',
                      () => closeThen(const BasketScreen()),
                    ),
                    (
                      Icons.percent_rounded,
                      'Discounts',
                      () => info(
                        'Discounts',
                        'No active discounts in this demo.',
                      ),
                    ),
                    (
                      Icons.confirmation_number_outlined,
                      'Promo-code',
                      () => info(
                        'Promo-code',
                        'Promo codes are unavailable in the local demo.',
                      ),
                    ),
                    (
                      Icons.settings_outlined,
                      'Settings',
                      () => showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Settings'),
                          content: ListenableBuilder(
                            listenable: order,
                            builder: (context, _) => SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Order updates'),
                              value: order.orderUpdates,
                              onChanged: order.setOrderUpdates,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (
                      Icons.support_agent_outlined,
                      'Support',
                      () => info(
                        'Support',
                        'Check your basket and shipping address before placing a demo order.',
                      ),
                    ),
                    (
                      Icons.logout,
                      'Logout',
                      () {
                        order.signOut();
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const OnboardingScreen(),
                          ),
                          (_) => false,
                        );
                      },
                    ),
                  ])
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 11,
                  leading: Icon(icon, color: Palette.ink, size: 22),
                  title: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: action,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
