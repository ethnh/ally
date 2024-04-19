import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

import '../../../account_manager/account_manager.dart';
import '../../../apiglobalmapview/map.dart';
import '../../../blogpost/blog_post_list.dart';
import '../../../chat/chat.dart';
import '../../../graphview/graph_page.dart';
import '../../../theme/theme.dart';
import '../../../tools/tools.dart';
import 'main_pager/main_pager.dart';
import 'main_pager/page_cubit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
class HomeAccountReadyMain extends StatefulWidget {
  const HomeAccountReadyMain({super.key});

  @override
  State<HomeAccountReadyMain> createState() => _HomeAccountReadyMainState();
}

class _HomeAccountReadyMainState extends State<HomeAccountReadyMain> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await changeWindowSetup(
          TitleBarStyle.normal, OrientationCapability.normal);
    });
  }

  Widget buildUserPanel() => Builder(builder: (context) {
        final account = context.watch<AccountRecordCubit>().state;
        final theme = Theme.of(context);
        final scale = theme.extension<ScaleScheme>()!;

        return Column(children: <Widget>[
          Row(children: [
            IconButton(
                icon: const Icon(Icons.settings),
                color: scale.secondaryScale.borderText,
                constraints: const BoxConstraints.expand(height: 64, width: 64),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        scale.primaryScale.hoverBorder),
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))))),
                tooltip: translate('app_bar.settings_tooltip'),
                onPressed: () async {
                  await GoRouterHelper(context).push('/settings');
                }).paddingLTRB(0, 0, 8, 0),
            asyncValueBuilder(account,
                    (_, account) => ProfileWidget(profile: account.profile))
                .expanded(),
          ]).paddingAll(8),
          const MainPager().expanded()
        ]);
      });

  Widget buildPhone(BuildContext context) =>
      Material(color: Colors.transparent, child: buildUserPanel());

  Widget buildTabletLeftPane(BuildContext context) => Builder(
      builder: (context) =>
          Material(color: Colors.transparent, child: buildUserPanel()));

Widget buildTabletRightPane(BuildContext context) {
  final currentPage = context.watch<PageCubit>().state;
  if (currentPage < 2) {
    final activeChatRemoteConversationKey = context.watch<ActiveChatCubit>().state;
    if (activeChatRemoteConversationKey == null) {
      return const EmptyChatWidget();
    }
    return ChatComponent.builder(
      remoteConversationRecordKey: activeChatRemoteConversationKey,
    );
  } else if (currentPage == 2) {
    return InteractiveCityMapPage();
  } else if (currentPage == 3) {
    return BlocBuilder<BlogCubit, BlogPost?>(
      builder: (context, activeBlog) {
        if (activeBlog != null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeBlog.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'By ${activeBlog.author}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Markdown(data: activeBlog.content),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.article, size: 48),
                SizedBox(height: 16),
                Text(
                  'No blog post selected',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }
      },
    );
  } else if (currentPage == 4) {
    return const GraphExamplePage();
  } else {
    return const Text("Not Sure How You Ended Up Here..");
  }
}

  // ignore: prefer_expression_function_bodies
  Widget buildTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final scale = theme.extension<ScaleScheme>()!;

    final children = [
      ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: w / 2),
              child: buildTabletLeftPane(context))),
      SizedBox(
          width: 2,
          height: double.infinity,
          child: ColoredBox(color: scale.primaryScale.hoverBorder)),
      Expanded(child: buildTabletRightPane(context)),
    ];

    return Row(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) => responsiveVisibility(
        context: context,
        phone: false,
      )
          ? buildTablet(context)
          : buildPhone(context);
}
