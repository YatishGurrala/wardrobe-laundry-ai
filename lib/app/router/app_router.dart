import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../features/add/presentation/screens/add_clothing_screen.dart';
import '../../features/detail/presentation/screens/clothing_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/laundry/presentation/screens/laundry_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/wardrobe/presentation/screens/wardrobe_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(
            currentIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(index);
            },
            child: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wardrobe',
                builder: (context, state) => const WardrobeScreen(),
                routes: [
                  GoRoute(
                    path: 'item/:id',
                    builder: (context, state) => ClothingDetailScreen(
                      itemId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add',
                builder: (context, state) => const AddClothingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/laundry',
                builder: (context, state) => const LaundryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
