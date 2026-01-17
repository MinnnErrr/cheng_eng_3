import 'package:cheng_eng_3/ui/cart/screens/cart_screen.dart';
import 'package:cheng_eng_3/ui/chat/screens/customer_chat_screen.dart';
import 'package:cheng_eng_3/ui/home/screens/customer_home.dart';
import 'package:cheng_eng_3/ui/profile/screens/profile_screen.dart';
import 'package:cheng_eng_3/ui/core/widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerMainWrapper extends ConsumerStatefulWidget {
  const CustomerMainWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerMainWrapperState();
}

class _CustomerMainWrapperState extends ConsumerState<CustomerMainWrapper> {
  int _index = 0;

  final _screens = [
    const CustomerHome(),
    const CustomerChatScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() {
          _index = value;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(
            icon: CartIconBadge(
              icon: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
