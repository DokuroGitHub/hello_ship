import 'package:dokuro_flutter/models/comment_attachment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentAttachmentsWidget extends StatelessWidget {
  const CommentAttachmentsWidget({Key? key, this.attachments})
      : super(key: key);
  final CommentAttachments? attachments;

  final String defaultURL =
      'https://i0.wp.com/media.discordapp.net/attachments/781870041862897684/784806733431701514/EIB7R00XUAAwQ6a.png';

  @override
  Widget build(BuildContext context) {
    if (attachments?.nodes.isEmpty ?? true) {
      return const SizedBox();
    }
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // maxRow = 4, maxColumn = 3, maxHeight = 800, maxWidth = Get.width-24
          _itemsRow(attachments!.nodes.skip(0).take(3).toList()),
          attachments!.nodes.length > 6
              ? SizedBox(
                  height: Get.width * 1.8 / 4 / 2,
                  width: Get.width,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    ...attachments!.nodes
                        .skip(3)
                        .take(6)
                        .map((e) => _item(e))
                        .toList(),
                  ]),
                )
              : _itemsRow(attachments!.nodes.skip(3).take(3).toList()),
          if (attachments!.totalCount > 9)
            Row(
              children: [
                const Spacer(),
                Text(
                    '+${attachments!.totalCount - 12} ${attachments!.totalCount - 12 > 1 ? 'items' : 'item'}'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _itemsRow(List<CommentAttachment> items) {
    if (items.isEmpty) {
      return const SizedBox();
    }
    final maxWidth = Get.width - 24.0;
    final maxHeight = maxWidth * 1.8;
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items
                .map((e) => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxHeight / 4,
                        maxWidth: maxWidth / items.length,
                      ),
                      child: _item(e),
                    ))
                .toList(),
          ],
        ));
  }

  Widget _item(CommentAttachment a) {
    // phan loai type r return
    return _imageItem(a.thumbUrl.isNotEmpty ? a.thumbUrl : a.fileUrl);
  }

  Widget _imageItem(String? url, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: FadeInImage.assetNetwork(
          alignment: Alignment.topCenter,
          placeholder: 'assets/images/video_place_here.png',
          image: url ?? defaultURL,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
