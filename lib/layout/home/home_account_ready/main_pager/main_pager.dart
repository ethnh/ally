import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:provider/provider.dart';

import '../../../../blogpost/blog_post_list.dart';
import '../../../../chat/chat.dart';
import '../../../../contact_invitation/contact_invitation.dart';
import '../../../../graphview/awesome.dart';
import '../../../../theme/theme.dart';
import '../../../layout.dart';
import 'account_page.dart';
import 'bottom_sheet_action_button.dart';
import 'chats_page.dart';
import 'page_cubit.dart';

List<BlogPost> getSampleBlogPosts() {
  return [
    BlogPost(
      title: "The Future of Technology",
      content: "# Exploring upcoming trends in AI, robotics, and quantum computing. The future is closer than you think, with technology rapidly evolving.",
      author: "aaa",
    ),
    BlogPost(
      title: "Sustainable Energy for the Next Century",
            author: "aaa",
      content: "## Renewable energy sources such as solar, wind, and hydroelectric power are paving the way for a cleaner, more sustainable future."
    ),
    BlogPost(
      title: "The Impact of Global Warming",
            author: "abc",
      content: "Global warming remains one of the most significant challenges of our time, affecting wildlife, weather patterns, and global sea levels."
    ),
    BlogPost(
      title: "Revolutionizing Education Through Online Learning",
            author: "name123",
      content: "### The rise of online education offers unprecedented access to learning resources, expanding opportunities worldwide."
    ),
    BlogPost(
      title: "The Art of Culinary Innovations",
            author: "ME!!!",
      content: "Culinary art is not just about cooking; **it's about combining flavors and techniques** to create new dishes that amaze and delight.",
      owned: true,
    ),
    BlogPost(
      title: "Exploring the Depths: Oceanography",
            author: "Ally",
      content: "*Oceanography helps us understand the complexity and breadth of ocean ecosystems and their* `importance` ```to global health```."
    ),
  ];
}

List<MapLocation> getSampleMapLocations() {
  return [
    MapLocation(
      name: "Central Park",
      coordinates: "40.7829° N, 73.9654° W",
    ),
    MapLocation(
      name: "Eiffel Tower",
      coordinates: "48.8584° N, 2.2945° E",
    ),
    MapLocation(
      name: "Great Pyramid of Giza",
      coordinates: "29.9792° N, 31.1342° E",
    ),
    MapLocation(
      name: "Sydney Opera House",
      coordinates: "33.8568° S, 151.2153° E",
    ),
    MapLocation(
      name: "Machu Picchu",
      coordinates: "13.1631° S, 72.5450° W",
    ),
    MapLocation(
      name: "Taj Mahal",
      coordinates: "27.1751° N, 78.0421° E",
    ),
  ];
}

List<User> getSampleUsers() {
  return [
    User(
      name: "Alice",
      pubkey: "1A2B3C4D5E6F7G8H9I0J",
    ),
    User(
      name: "Bob",
      pubkey: "0J9I8H7G6F5E4D3C2B1A",
    ),
    User(
      name: "Charlie",
      pubkey: "A1B2C3D4E5F6G7H8I9J0",
    ),
    User(
      name: "David",
      pubkey: "0I9H8G7F6E5D4C3B2A1J",
    ),
    User(
      name: "Eve",
      pubkey: "J1A2B3C4D5E6F7G8H9I0",
    ),
    User(
      name: "Frank",
      pubkey: "0A1B2C3D4E5F6G7H8I9J",
    ),
  ];
}


class MainPager extends StatefulWidget {
  const MainPager({super.key});

  @override
  MainPagerState createState() => MainPagerState();

  static MainPagerState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainPagerState>();
}

class MainPagerState extends State<MainPager> with TickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////

  var _currentPage = 0;
  final pageController = PreloadPageController();

  final _selectedIconList = <IconData>[Icons.person, Icons.chat, Icons.map, Icons.description, Icons.diversity_1];
  // final _unselectedIconList = <IconData>[
  //   Icons.chat_outlined,
  //   Icons.person_outlined
  // ];
  final _fabIconList = <IconData>[
    Icons.person_add_sharp,
    Icons.add_comment_sharp,
    Icons.map, Icons.description, Icons.diversity_1
  ];
  final _bottomLabelList = <String>[
    translate('pager.contacts'),
    translate('pager.chats'),
    translate('pager.map'), translate('pager.description'), translate('pager.diversity_1')
  ];

  //////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          // _hideBottomBarAnimationController.reverse();
          // _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          // _hideBottomBarAnimationController.forward();
          // _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  BottomBarItem buildBottomBarItem(int index) {
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;
    return BottomBarItem(
      title: Text(_bottomLabelList[index]),
      icon:
          Icon(_selectedIconList[index], color: scale.primaryScale.borderText),
      selectedIcon:
          Icon(_selectedIconList[index], color: scale.primaryScale.borderText),
      backgroundColor: scale.primaryScale.borderText,
      //badge: const Text('9+'),
      //showBadge: true,
    );
  }

  List<BottomBarItem> _buildBottomBarItems() {
    final bottomBarItems = List<BottomBarItem>.empty(growable: true);
    for (var index = 0; index < _bottomLabelList.length; index++) {
      final item = buildBottomBarItem(index);
      bottomBarItems.add(item);
    }
    return bottomBarItems;
  }

  Future<void> scanContactInvitationDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        // ignore: prefer_expression_function_bodies
        builder: (context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10,
              ),
              title: const Text(
                'Scan Contact Invite',
                style: TextStyle(fontSize: 24),
              ),
              content: ScanInvitationDialog(
                modalContext: context,
              ));
        });
  }

  Widget _bottomSheetBuilder(BuildContext sheetContext, BuildContext context) {
    if (_currentPage == 0) {
      // New contact invitation
      return newContactBottomSheetBuilder(sheetContext, context);
    } else if (_currentPage == 1) {
      // New chat
      return newChatBottomSheetBuilder(sheetContext, context);
    } else {
      // Unknown error
      return debugPage('TBD - Undesigned');
    }
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;

    return Scaffold(
      //extendBody: true,
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
          onNotification: onScrollNotification,
          child: PreloadPageView(
              controller: pageController,
              preloadPagesCount: 2,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                context.read<PageCubit>().setPage(index);
              },
              children: [
                AccountPage(),
                ChatsPage(),
                SearchableMapLocationListWidget(locations: getSampleMapLocations()),
                SearchableBlogPostListWidget(blogPosts: getSampleBlogPosts()),
                SearchableUserListWidget(users: getSampleUsers()),
                
              ])),
      // appBar: AppBar(
      //   toolbarHeight: 24,
      //   title: Text(
      //     'C',
      //     style: Theme.of(context).textTheme.headlineSmall,
      //   ),
      // ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: scale.primaryScale.hoverBorder,
        option: AnimatedBarOptions(
          inkEffect: true,
          inkColor: scale.primaryScale.hoverPrimary,
          opacity: 0.3,
        ),
        items: _buildBottomBarItems(),
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: _currentPage,
        onTap: (index) async {
          await pageController.animateToPage(index,
              duration: 250.ms, curve: Curves.easeInOut);
        },
      ),

      floatingActionButton: BottomSheetActionButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          foregroundColor: scale.secondaryScale.borderText,
          backgroundColor: scale.secondaryScale.hoverBorder,
          builder: (context) => Icon(
                _fabIconList[_currentPage],
                color: scale.secondaryScale.borderText,
              ),
          bottomSheetBuilder: (sheetContext) =>
              _bottomSheetBuilder(sheetContext, context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PreloadPageController>(
        'pageController', pageController));
  }
}
