import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entities/proto.dart' as proto;
import '../tools/tools.dart';
import 'contact_invitation_item_widget.dart';

class ContactInvitationListWidget extends ConsumerStatefulWidget {
  ContactInvitationListWidget({
    required this.contactInvitationRecordList,
    super.key,
  });

  final IList<proto.ContactInvitationRecord> contactInvitationRecordList;

  @override
  ContactInvitationListWidgetState createState() =>
      ContactInvitationListWidgetState();
}

class ContactInvitationListWidgetState
    extends ConsumerState<ContactInvitationListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final textTheme = theme.textTheme;
    final scale = theme.extension<ScaleScheme>()!;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 64, maxHeight: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                  color: scale.grayScale.appBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.contactInvitationRecordList.length,
                itemBuilder: (context, index) {
                  if (index < 0 ||
                      index >= widget.contactInvitationRecordList.length) {
                    return null;
                  }
                  return ContactInvitationItemWidget(
                          contactInvitationRecord:
                              widget.contactInvitationRecordList[index],
                          key: ObjectKey(
                              widget.contactInvitationRecordList[index]))
                      .paddingAll(2);
                },
                findChildIndexCallback: (key) {
                  final index = widget.contactInvitationRecordList.indexOf(
                      (key as ObjectKey).value!
                          as proto.ContactInvitationRecord);
                  if (index == -1) {
                    return null;
                  }
                  return index;
                },
                shrinkWrap: true,
              )).paddingLTRB(8, 0, 8, 8).flexible()
        ],
      ),
    );
  }
}