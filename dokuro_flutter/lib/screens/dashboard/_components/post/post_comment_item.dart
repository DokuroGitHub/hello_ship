import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard/posts/post_comment_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/comment_emote.dart';
import 'package:dokuro_flutter/models/constants/emote_code.dart';
import 'package:dokuro_flutter/models/emotes_count.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/rating_widget.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'comment_attachments_widget.dart';

class PostCommentItem extends StatefulWidget {
  final PostComment initialPostComment;
  final Function(Key? deletedKey)? onDeleteCallback;
  final Function? onRefreshCallBack;
  final Function(dynamic)? onFocusCallBack;
  const PostCommentItem(
    this.initialPostComment, {
    Key? initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
    this.onFocusCallBack,
  }) : super(key: initialKey);

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  late final postCommentItemController = PostCommentItemController(
    widget.initialPostComment,
    initialKey: widget.key,
    onRefreshCallBack: widget.onRefreshCallBack,
    onFocusCallBack: widget.onFocusCallBack,
  );

  @override
  void initState() {
    postCommentItemController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    postCommentItemController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'PostCommentItem, id: ${postCommentItemController.postComment.value.id}, key: ${postCommentItemController.initialKey}}');
    return Obx(() => postCommentItemController.status.value == Status.ready
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // avatar
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
                child: _userAvatar(),
              ),
              const SizedBox(width: 5),
              // name + rating / text + attachments / emotes + reply + time / replies
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // comment content || edit content
                    postCommentItemController.isEdit.value
                        ? _editContent()
                        : _commentContent(),
                    // _postCommentsByReplyToContent
                    _postCommentsByReplyToContent(),
                  ],
                ),
              ),
            ],
          )
        : const CircularProgressIndicator());
  }

  Widget _commentContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ( ( name + rating ) / text ) + 3dots
      Row(
        children: [
          // (name + rating) / text
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(Get.context!).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name + rating
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                        child: UserName(
                      name: postCommentItemController
                          .initialPostComment.userByCreatedBy?.name,
                      onTap: () {},
                    )),
                    const SizedBox(width: 15.0),
                    // rating
                    const RatingWidget(rating: 4.69, length: 69),
                  ]),
                  // text
                  Text(postCommentItemController.initialPostComment.text),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // 3 dots: edit, delete / hide, report
          _actions(),
        ],
      ),
      //  attachments
      CommentAttachmentsWidget(
          attachments: postCommentItemController
              .initialPostComment.commentAttachmentsByCommentId),
      // like + reply + copy + date
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // _btnLike    //const Text('·'),
          Flexible(child: _btnLike()),
          // reply button
          Flexible(
            child: TextButton(
              onPressed: postCommentItemController.onReplyTap,
              child: Text(AppLocalizations.of(Get.context!).replyCap,
                  style: Theme.of(Get.context!).textTheme.button),
            ),
          ),
          // copy uid button
          Flexible(
            child: TextButton(
              onPressed: () {
                var uid = '';
                if (widget.initialPostComment.userByCreatedBy?.uid.isNotEmpty ??
                    false) {
                  uid = widget.initialPostComment.userByCreatedBy!.uid;
                } else {
                  uid = widget.initialPostComment.createdBy;
                }
                final message = 'uid: $uid';
                Clipboard.setData(ClipboardData(text: uid));
                Get.showSnackbar(GetSnackBar(
                  title: 'Copied',
                  message: message,
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Text(AppLocalizations.of(Get.context!).copyCap,
                  style: Theme.of(Get.context!).textTheme.button),
            ),
          ),
          // date
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: Text(
                  stringHelper.dateTimeToDurationStringShort(
                      postCommentItemController.initialPostComment.createdAt),
                  style: Theme.of(Get.context!).textTheme.button),
            ),
          ),
          //  _commentEmotesCount
          _commentEmotesCount(),
        ],
      ),
    ]);
  }

  Widget _editContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ( ( name + rating ) / text ) + 3dots
      _editTF(),
      //  attachments
      CommentAttachmentsWidget(
          attachments: postCommentItemController
              .initialPostComment.commentAttachmentsByCommentId),
      // Nhan Esc de huy.
      Row(children: [
        const Flexible(child: Text('Nhấn Esc để ')),
        // cancel button
        Flexible(
          child: TextButton(
            onPressed: postCommentItemController.onCancelEditTap,
            child: Text(
              AppLocalizations.of(Get.context!).cancel,
            ),
          ),
        ),
        const Flexible(child: Text('.')),
      ]),
    ]);
  }

  Widget _userAvatar() {
    return UserAvatar(
      avatarUrl: postCommentItemController
          .initialPostComment.userByCreatedBy?.avatarUrl,
      lastSeen: postCommentItemController
          .initialPostComment.userByCreatedBy?.lastSeen,
    );
  }

  Widget _postCommentsByReplyToContent() {
    if (postCommentItemController.isShowPostCommentsByReplyTo.value == false) {
      return _repliesCountWidget();
    }
    return _postCommentsByReplyTo();
  }

  Widget _repliesCountWidget() {
    if (postCommentItemController.postCommentsTotalCount.value.isEqual(0)) {
      return const SizedBox();
    }
    var label = '';
    var totalCount = postCommentItemController.postCommentsTotalCount.value;
    if (totalCount > 1) {
      label = '$totalCount ${AppLocalizations.of(Get.context!).replies}';
    } else {
      label = '$totalCount ${AppLocalizations.of(Get.context!).reply}';
    }
    return TextButton.icon(
      onPressed: () async {
        await postCommentItemController
            .fetchPostCommentsByReplyToFirstAfterCurrentUserId();
        postCommentItemController.isShowPostCommentsByReplyTo.value = true;
      },
      icon: const Icon(Icons.subdirectory_arrow_right),
      label: Text(label),
    );
  }

  Widget _postCommentsByReplyTo() {
    switch (postCommentItemController.commentsOrderBy.value) {
      case CommentsOrderBy.idAsc:
        return Column(
          children: [
            // Xem các bình luận trước/Xem thêm 3 bình luận - Tất cả bình luận ▼
            Row(children: [
              // Xem các bình luận trước/Xem thêm 3 bình luận
              _viewMoreCommentsWidget(),
              const Spacer(),
              // Tất cả bình luận ▼
              TextButton(
                onPressed: postCommentItemController.showFilters,
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Tất cả bình luận '),
                  Icon(Icons.arrow_drop_down_outlined),
                ]),
              ),
            ]),
            // list comments with filter
            _listCommentsWithFilter(),
            // input row
            _inputRow(),
          ],
        );
      case CommentsOrderBy.idDesc:
        return Column(
          children: [
            // Gần đây nhất ▼
            Row(children: [
              const Spacer(),
              TextButton(
                onPressed: postCommentItemController.showFilters,
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Gần đây nhất'),
                  Icon(Icons.arrow_drop_down_outlined),
                ]),
              ),
            ]),
            // input row
            _inputRow(),
            // list comments with filter
            _listCommentsWithFilter(),
            // Xem thêm bình luận/Xem thêm 6 bình luận - 3/28
            _viewMoreCommentsWidget(),
            // Ai đó đang nhập bình luận...
            Row(children: const [
              Flexible(child: Text('··· Ai đó đang nhập bình luận...')),
            ]),
            // Viết bình luận...
            Row(children: [
              Flexible(
                child: TextButton(
                    onPressed: () =>
                        postCommentItemController.commentNode.requestFocus(),
                    child: const Text('Viết bình luận...')),
              ),
            ]),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _viewMoreCommentsWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      postCommentItemController.postCommentItems.length !=
              postCommentItemController.postCommentsTotalCount.value
          ? TextButton(
              onPressed: () {
                postCommentItemController
                    .fetchPostCommentsByReplyToFirstAfterCurrentUserId();
              },
              child: const Text('Xem thêm bình luận'),
            )
          : const SizedBox(),
      Text(
          '${postCommentItemController.postCommentItems.length}/${postCommentItemController.postCommentsTotalCount.value}'),
    ]);
  }

  Widget _btnLike() {
    if (postCommentItemController.emotesByCurrentUserId.value != null) {
      return TextButton(
        onPressed: () async => await postCommentItemController
            .onLikeTap(CommentEmote(code: EmoteCode.like)),
        child: Text(AppLocalizations.of(Get.context!).likeCap,
            style: const TextStyle(color: Colors.blue)),
      );
    }
    return TextButton(
      onPressed: () async => await postCommentItemController
          .onLikeTap(CommentEmote(code: EmoteCode.like)),
      child: Text(AppLocalizations.of(Get.context!).likeCap,
          style: Theme.of(Get.context!).textTheme.button),
    );
  }

  Widget _commentEmotesCount() {
    final totalCount = postCommentItemController.likeTotalCount.value +
        postCommentItemController.loveTotalCount.value +
        postCommentItemController.careTotalCount.value +
        postCommentItemController.hahaTotalCount.value +
        postCommentItemController.wowTotalCount.value +
        postCommentItemController.sadTotalCount.value +
        postCommentItemController.angryTotalCount.value;
    if (totalCount.isEqual(0)) {
      return const SizedBox();
    }
    var commentEmoteLabel = '';
    if (totalCount > 1) {
      commentEmoteLabel =
          '$totalCount ${AppLocalizations.of(Get.context!).likes}';
    } else {
      commentEmoteLabel =
          '$totalCount ${AppLocalizations.of(Get.context!).like}';
    }

    //int like, love, care, haha, wow, sad, angry = 0;
    List<EmoteValue> counts = [];
    counts.addAll([
      EmoteValue(
        code: EmoteCode.like,
        value: postCommentItemController.likeTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.love,
        value: postCommentItemController.loveTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.care,
        value: postCommentItemController.careTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.haha,
        value: postCommentItemController.hahaTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.wow,
        value: postCommentItemController.wowTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.sad,
        value: postCommentItemController.sadTotalCount.value,
      ),
      EmoteValue(
        code: EmoteCode.angry,
        value: postCommentItemController.angryTotalCount.value,
      ),
    ]);
    counts.removeWhere((element) => element.value == 0);
    counts.sort(((a, b) => b.value.compareTo(a.value)));

    return Tooltip(
      richMessage: WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...counts.map(
              (e) => Text(
                '${e.value} ${e.code}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/facebook-reactions-emoticons/png-16/like-16x16-1991059.png',
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.thumb_up),
        ),
        label: Text(commentEmoteLabel),
      ),
    );
  }

  Widget _listCommentsWithFilter() {
    if (postCommentItemController.postCommentItems.isEmpty) {
      return const SizedBox();
    }
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          reverse: postCommentItemController.commentsOrderBy.value ==
              CommentsOrderBy.idAsc,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return postCommentItemController.postCommentItems[index];
          },
          itemCount: postCommentItemController.postCommentItems.length,
        ));
  }

  Widget _inputRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
            child: UserAvatar(
              avatarUrl: postCommentItemController.currentUser.avatarUrl,
              lastSeen: postCommentItemController
                  .initialPostComment.userByCreatedBy?.lastSeen,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) async {
                // phim enter => send
                if (event.runtimeType == RawKeyDownEvent &&
                    (event.logicalKey.keyId == 4294967309) &&
                    (!event.isShiftPressed)) {
                  await postCommentItemController.onSendTap();
                }
              },
              child: TextField(
                focusNode: postCommentItemController.commentNode,
                controller: postCommentItemController.textController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 15, right: 0, bottom: 15),
                  hintText: 'Viết phản hồi...',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      Icons.tag_faces_outlined,
                      color: Theme.of(Get.context!)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.64),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.photo_camera_outlined,
                      color: Theme.of(Get.context!)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.64),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(Get.context!)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.64),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.blue,
            ),
            // send button => send
            onPressed: postCommentItemController.onSendTap,
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _actions() {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'edit') {
          postCommentItemController.onEditTap();
        }
        if (selected == 'delete') {
          postCommentItemController.onDeleteTap();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  Widget _editTF() {
    postCommentItemController.editTEC.text =
        postCommentItemController.initialPostComment.text;
    return Row(
      children: [
        const SizedBox(width: 10.0),
        Expanded(
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) async {
              // phim enter => onConfirmEditTap
              if (event.runtimeType == RawKeyDownEvent &&
                  (event.logicalKey.keyId == 4294967309) &&
                  (!event.isShiftPressed)) {
                await postCommentItemController.onConfirmEditTap();
              }
            },
            child: TextField(
              focusNode: postCommentItemController.editFC,
              controller: postCommentItemController.editTEC,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 10.0, top: 15, right: 0, bottom: 15),
                hintText: 'Viết bình luận...',
                filled: true,
                fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    Icons.tag_faces_outlined,
                    color: Theme.of(Get.context!)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.64),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.photo_camera_outlined,
                    color: Theme.of(Get.context!)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.64),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Theme.of(Get.context!)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.64),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                ]),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
            color: Colors.blue,
          ),
          // send button => send
          onPressed: postCommentItemController.onConfirmEditTap,
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
