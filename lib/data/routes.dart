import 'package:fluent_picacg/data/states.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluent_picacg/data/constants.dart';
import 'package:fluent_picacg/pages/categories_page.dart';
import 'package:fluent_picacg/pages/favourites_page.dart';
import 'package:fluent_picacg/pages/home_page.dart';
import 'package:fluent_picacg/pages/leaderboard_page.dart';
import 'package:fluent_picacg/pages/user_page.dart';
import 'package:fluent_picacg/pages/settings_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final GoRouter globalRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/homepage',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          name: 'homepage',
          path: '/homepage',
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
          routes: [
            GoRoute(
              name: 'homepage.details',
              path: 'details',
              builder: (BuildContext context, GoRouterState state) {
                return Center(
                  child: Column(
                    children: [
                      Text('详情'),
                      Button(
                        child: Text('查看评论'),
                        onPressed: () {
                          GoRouter.of(context).pushNamed('homepage.comments');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            GoRoute(
              name: 'homepage.comments',
              path: 'comments',
              builder: (BuildContext context, GoRouterState state) {
                return Center(child: Text('评论'));
              },
            ),
          ],
        ),
        GoRoute(
          name: 'leaderboard',
          path: '/leaderboard',
          builder: (BuildContext context, GoRouterState state) {
            return const LeaderboardPage();
          },
        ),
        GoRoute(
          name: 'categories',
          path: '/categories',
          builder: (BuildContext context, GoRouterState state) {
            return const CategoriesPage();
          },
        ),
        GoRoute(
          name: 'favourites',
          path: '/favourites',
          builder: (BuildContext context, GoRouterState state) {
            return const FavouritesPage();
          },
        ),
        GoRoute(
          name: 'user',
          path: '/user',
          builder: (BuildContext context, GoRouterState state) {
            return const UserPage();
          },
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return SettingsPage();
          },
        ),
      ],
    ),
  ],
);

List<NavigationPaneItem> getPaneItems({required Widget child}) => [
  PaneItem(
    icon: const Icon(FluentIcons.home),
    title: const Text('主页'),
    body: child,
  ),
  PaneItem(
    icon: const Icon(FluentIcons.line_chart),
    title: const Text('排行'),
    body: child,
  ),
  PaneItem(
    icon: const Icon(FluentIcons.category_classification),
    title: const Text('分类'),
    body: child,
  ),
];

List<NavigationPaneItem> getPaneFooterItems({required Widget child}) => [
  PaneItem(
    icon: const Icon(FluentIcons.favorite_list),
    title: const Text('收藏'),
    body: child,
  ),
  PaneItem(
    icon: const Icon(FluentIcons.user_clapper),
    title: const Text('用户'),
    body: child,
  ),
  PaneItem(
    icon: const Icon(FluentIcons.settings),
    title: const Text('设置'),
    body: child,
  ),
];

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      // header: SizedBox(
      //   height: kWindowCaptionHeight,
      //   child: WindowCaption(
      //     title: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 8.0),
      //       child: AppConstants.appIcon,
      //     ),
      //     brightness:
      //         context.watch<AppSettingsState>().theme == ThemeMode.dark
      //             ? Brightness.dark
      //             : Brightness.light,
      //   ),
      // ),
      content: NavigationView(
        appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: _buildLeadingButton(context),
        ),
        pane: NavigationPane(
          size: NavigationPaneSize(openWidth: 160),
          selected: _calculateSelectedIndex(context),
          onChanged: (int index) => _onItemTapped(index, context),
          displayMode: PaneDisplayMode.compact,
          items: getPaneItems(child: child),
          footerItems: getPaneFooterItems(child: child),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/homepage')) {
      return 0;
    } else if (location.startsWith('/leaderboard')) {
      return 1;
    } else if (location.startsWith('/categories')) {
      return 2;
    } else if (location.startsWith('/favourites')) {
      return 3;
    } else if (location.startsWith('/user')) {
      return 4;
    } else if (location.startsWith('/settings')) {
      return 5;
    }

    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    debugPrint('Selected index: $index');
    switch (index) {
      case 0:
        GoRouter.of(context).pushNamed('homepage');
        break;
      case 1:
        GoRouter.of(context).pushNamed('leaderboard');
        break;
      case 2:
        GoRouter.of(context).pushNamed('categories');
        break;
      case 3:
        GoRouter.of(context).pushNamed('favourites');
        break;
      case 4:
        GoRouter.of(context).pushNamed('user');
        break;
      case 5:
        GoRouter.of(context).pushNamed('settings');
        break;
      default:
        GoRouter.of(context).pushNamed('homepage');
        break;
    }
  }
}

Widget? _buildLeadingButton(BuildContext context) {
  final RouteMatchList currentConfiguration =
      GoRouter.of(context).routerDelegate.currentConfiguration;
  final RouteMatch lastMatch = currentConfiguration.last;
  final Uri location =
      lastMatch is ImperativeRouteMatch
          ? lastMatch.matches.uri
          : currentConfiguration.uri;
  final bool canPop = location.pathSegments.length > 1;

  return canPop
      ? NavigationPaneTheme(
        data: NavigationPaneThemeData(),
        child: Builder(
          builder:
              (context) => PaneItem(
                icon: const Center(child: Icon(FluentIcons.back)),
                title: Text('返回'),
                body: const SizedBox.shrink(),
              ).build(context, false, () {
                GoRouter.of(context).pop();
              }, displayMode: PaneDisplayMode.compact),
        ),
      )
      : null;
}
