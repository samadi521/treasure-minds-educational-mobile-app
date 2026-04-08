import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';

class RewardsShopScreen extends StatefulWidget {
  const RewardsShopScreen({super.key});

  @override
  State<RewardsShopScreen> createState() => _RewardsShopScreenState();
}

class _RewardsShopScreenState extends State<RewardsShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  
  int _userCoins = 1250;
  int _userGems = 45;
  
  final List<ShopItem> _avatars = [
    ShopItem(
      id: 1,
      name: 'Space Explorer',
      description: 'Cosmic themed avatar',
      icon: Icons.rocket,
      price: 500,
      currency: 'coins',
      color: AppColors.neonBlue,
      isOwned: false,
      isEquipped: false,
      type: 'avatar',
      rarity: 'Rare',
    ),
    ShopItem(
      id: 2,
      name: 'Dragon Rider',
      description: 'Epic dragon avatar',
      icon: Icons.whatshot,
      price: 1000,
      currency: 'coins',
      color: AppColors.mathOrange,
      isOwned: false,
      isEquipped: false,
      type: 'avatar',
      rarity: 'Epic',
    ),
    ShopItem(
      id: 3,
      name: 'Mermaid',
      description: 'Underwater themed',
      icon: Icons.beach_access,
      price: 20,
      currency: 'gems',
      color: AppColors.neonCyan,
      isOwned: true,
      isEquipped: false,
      type: 'avatar',
      rarity: 'Rare',
    ),
  ];

  final List<ShopItem> _powerups = [
    ShopItem(
      id: 4,
      name: 'Double XP',
      description: '2x XP for 1 hour',
      icon: Icons.bolt,
      price: 150,
      currency: 'coins',
      color: AppColors.gold,
      isOwned: true,
      isEquipped: false,
      type: 'powerup',
      rarity: 'Common',
      quantity: 3,
    ),
    ShopItem(
      id: 5,
      name: 'Extra Life',
      description: '+1 life in games',
      icon: Icons.favorite,
      price: 100,
      currency: 'coins',
      color: AppColors.errorRed,
      isOwned: true,
      isEquipped: false,
      type: 'powerup',
      rarity: 'Common',
      quantity: 5,
    ),
    ShopItem(
      id: 6,
      name: 'Time Freeze',
      description: 'Stop timer for 10s',
      icon: Icons.timer,
      price: 200,
      currency: 'coins',
      color: AppColors.neonBlue,
      isOwned: false,
      isEquipped: false,
      type: 'powerup',
      rarity: 'Rare',
      quantity: 0,
    ),
    ShopItem(
      id: 7,
      name: 'Hint Potion',
      description: 'Reveals one answer',
      icon: Icons.lightbulb,
      price: 80,
      currency: 'coins',
      color: AppColors.gold,
      isOwned: false,
      isEquipped: false,
      type: 'powerup',
      rarity: 'Common',
      quantity: 0,
    ),
  ];

  final List<ShopItem> _themes = [
    ShopItem(
      id: 8,
      name: 'Dark Mode',
      description: 'Sleek dark theme',
      icon: Icons.dark_mode,
      price: 300,
      currency: 'coins',
      color: AppColors.neonPurple,
      isOwned: false,
      isEquipped: false,
      type: 'theme',
      rarity: 'Common',
    ),
    ShopItem(
      id: 9,
      name: 'Rainbow Theme',
      description: 'Colorful interface',
      icon: Icons.color_lens,
      price: 15,
      currency: 'gems',
      color: AppColors.gold,
      isOwned: true,
      isEquipped: true,
      type: 'theme',
      rarity: 'Epic',
    ),
    ShopItem(
      id: 10,
      name: 'Nature Theme',
      description: 'Forest inspired',
      icon: Icons.forest,
      price: 400,
      currency: 'coins',
      color: AppColors.mintGreen,
      isOwned: false,
      isEquipped: false,
      type: 'theme',
      rarity: 'Rare',
    ),
  ];

  final List<ShopItem> _specialItems = [
    ShopItem(
      id: 11,
      name: 'Mystery Box',
      description: 'Random surprise item',
      icon: Icons.card_giftcard,
      price: 300,
      currency: 'coins',
      color: AppColors.gold,
      isOwned: false,
      isEquipped: false,
      type: 'special',
      rarity: 'Random',
    ),
    ShopItem(
      id: 12,
      name: 'Golden Pass',
      description: '7 days premium access',
      icon: Icons.workspace_premium,
      price: 50,
      currency: 'gems',
      color: AppColors.gold,
      isOwned: false,
      isEquipped: false,
      type: 'special',
      rarity: 'Legendary',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Rewards Shop'),
        backgroundColor: AppColors.neonPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _buildCurrencyBar(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildCategoryTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildShopGrid('avatars'),
                  _buildShopGrid('powerups'),
                  _buildShopGrid('themes'),
                  _buildShopGrid('special'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCurrencyCard(Icons.monetization_on, '$_userCoins', 'Coins', AppColors.gold),
          _buildCurrencyCard(Icons.diamond, '$_userGems', 'Gems', AppColors.neonCyan),
          _buildCurrencyCard(Icons.add_shopping_cart, 'Shop', 'Store', AppColors.mintGreen),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(IconData icon, String amount, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['👤 Avatars', '⚡ Power-ups', '🎨 Themes', '✨ Special'];
    
    return Container(
      margin: const EdgeInsets.all(16),
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _tabController.index == index;
          return GestureDetector(
            onTap: () {
              _tabController.animateTo(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonPurple : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopGrid(String type) {
    List<ShopItem> items;
    switch (type) {
      case 'avatars':
        items = _avatars;
        break;
      case 'powerups':
        items = _powerups;
        break;
      case 'themes':
        items = _themes;
        break;
      default:
        items = _specialItems;
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildShopItemCard(item);
      },
    );
  }

  Widget _buildShopItemCard(ShopItem item) {
    final isOwned = item.isOwned;
    final isEquipped = item.isEquipped;
    final canAfford = item.currency == 'coins' 
        ? _userCoins >= item.price 
        : _userGems >= item.price;
    
    return Container(
      decoration: BoxDecoration(
        gradient: isOwned
            ? LinearGradient(
                colors: [item.color.withValues(alpha: 0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isOwned ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEquipped ? AppColors.gold : (isOwned ? item.color : Colors.grey.shade200),
          width: isEquipped ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Item Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [item.color, item.color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Item Name
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isOwned ? item.color : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Item Description
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Rarity Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRarityColor(item.rarity).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.rarity,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(item.rarity),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Price / Action Button
                if (!isOwned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: canAfford ? AppColors.mintGreen : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: canAfford ? () => _purchaseItem(item) : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.currency == 'coins' ? Icons.monetization_on : Icons.diamond,
                            size: 14,
                            color: canAfford ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.price}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: canAfford ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (isEquipped)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'EQUIPPED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.neonBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () => _equipItem(item),
                      child: const Text(
                        'EQUIP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (item.quantity !> 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (isEquipped)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _purchaseItem(ShopItem item) async {
    // Check if can afford
    if (item.currency == 'coins' && _userCoins < item.price) {
      _showInsufficientFundsDialog('Coins');
      return;
    }
    if (item.currency == 'gems' && _userGems < item.price) {
      _showInsufficientFundsDialog('Gems');
      return;
    }
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text('Purchase ${item.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 50, color: item.color),
            const SizedBox(height: 12),
            Text(
              '${item.price} ${item.currency}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(item.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mintGreen,
            ),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() {
        if (item.currency == 'coins') {
          _userCoins -= item.price;
        } else {
          _userGems -= item.price;
        }
        item.isOwned = true;
        if (item.type == 'powerup') {
          item.quantity = (item.quantity ?? 0) + 1;
        }
      });
      
      _confettiController.play();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text('Successfully purchased ${item.name}!'),
            ],
          ),
          backgroundColor: AppColors.mintGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _equipItem(ShopItem item) {
    // Unequip other items of same type
    List<ShopItem> items;
    switch (item.type) {
      case 'avatar':
        items = _avatars;
        break;
      case 'theme':
        items = _themes;
        break;
      default:
        items = [];
    }
    
    setState(() {
      for (var i in items) {
        i.isEquipped = false;
      }
      item.isEquipped = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} equipped!'),
        backgroundColor: AppColors.neonBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInsufficientFundsDialog(String currency) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text('Insufficient Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, size: 50, color: AppColors.warningOrange),
            const SizedBox(height: 12),
            Text(
              'You don\'t have enough $currency!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Play more games to earn rewards.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common': return Colors.grey;
      case 'Rare': return AppColors.neonBlue;
      case 'Epic': return AppColors.neonPurple;
      case 'Legendary': return AppColors.gold;
      default: return Colors.grey;
    }
  }
}

class ShopItem {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final int price;
  final String currency;
  final Color color;
  bool isOwned;
  bool isEquipped;
  final String type;
  final String rarity;
  int? quantity;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.price,
    required this.currency,
    required this.color,
    required this.isOwned,
    required this.isEquipped,
    required this.type,
    required this.rarity,
    this.quantity,
  });
}