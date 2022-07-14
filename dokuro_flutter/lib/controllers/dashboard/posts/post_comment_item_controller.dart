import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/comment_emote.dart';
import 'package:dokuro_flutter/models/constants/emote_code.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_comment_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:get/get.dart';

class PostCommentItemController {
  final PostComment initialPostComment;
  final Key? initialKey;
  final Function(Key? deletedKey)? onDeleteCallback;
  final Function? onRefreshCallBack;
  final Function(dynamic)? onFocusCallBack;
  PostCommentItemController(
    this.initialPostComment, {
    this.initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
    this.onFocusCallBack,
  });

  final dbService = Get.find<DbService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final int _limit = 2;
  final FocusNode commentNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  final FocusNode editFC = FocusNode();
  final TextEditingController editTEC = TextEditingController();

  Rx<Status> status = Status.ready.obs;
  Rx<bool> isEdit = false.obs;
  Rx<bool> isShowPostCommentsByReplyTo = false.obs;
  Rx<CommentsOrderBy> commentsOrderBy = CommentsOrderBy.idAsc.obs;

  // postComment
  late Rx<PostComment> postComment = initialPostComment.obs;
  // postCommentItems
  RxList<PostCommentItem> postCommentItems = RxList();
  Rx<PageInfo> postCommentsPageInfo = PageInfo().obs;
  RxInt postCommentsTotalCount = 0.obs;
  // emotes
  Rxn<CommentEmote> emotesByCurrentUserId = Rxn();
  RxList<Widget> likeNameItems = RxList();
  RxInt likeTotalCount = 0.obs;
  RxList<Widget> loveNameItems = RxList();
  RxInt loveTotalCount = 0.obs;
  RxList<Widget> careNameItems = RxList();
  RxInt careTotalCount = 0.obs;
  RxList<Widget> hahaNameItems = RxList();
  RxInt hahaTotalCount = 0.obs;
  RxList<Widget> wowNameItems = RxList();
  RxInt wowTotalCount = 0.obs;
  RxList<Widget> sadNameItems = RxList();
  RxInt sadTotalCount = 0.obs;
  RxList<Widget> angryNameItems = RxList();
  RxInt angryTotalCount = 0.obs;

  void _reset() {
    // postComment
    postComment.value = PostComment();
    // postComments
    postCommentItems.value = [];
    postCommentsPageInfo.value = PageInfo();
    postCommentsTotalCount.value = 0;
    // emotes
    emotesByCurrentUserId.value = null;
    likeNameItems.value = [];
    likeTotalCount.value = 0;
    loveNameItems.value = [];
    loveTotalCount.value = 0;
    careNameItems.value = [];
    careTotalCount.value = 0;
    hahaNameItems.value = [];
    hahaTotalCount.value = 0;
    wowNameItems.value = [];
    wowTotalCount.value = 0;
    sadNameItems.value = [];
    sadTotalCount.value = 0;
    angryNameItems.value = [];
    angryTotalCount.value = 0;
  }

  Widget _emoteToItem(CommentEmote e) {
    return Text(e.userByCreatedBy?.name ?? '');
  }

  PostCommentItem _toItem(PostComment postComment) {
    return PostCommentItem(
      postComment,
      initialKey: Key('${postComment.id}'),
      onDeleteCallback: (deletedKey) {
        postCommentItems.removeWhere((e) => e.key == deletedKey);
        postCommentsTotalCount.value--;
      },
      onRefreshCallBack: () {
        _reset();
        fetchPostCommentsByReplyToFirstAfterCurrentUserId();
      },
      onFocusCallBack: (s) {
        textController.text = s.toString();
        commentNode.requestFocus();
      },
    );
  }

  Future<void> showFilters() async {
    await showDialog<String>(
        context: Get.context!,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Sắp xếp theo'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  commentsOrderBy.value = CommentsOrderBy.idDesc;
                  Navigator.pop(context);
                },
                child: const Text('Gần đây nhất'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  commentsOrderBy.value = CommentsOrderBy.idAsc;
                  Navigator.pop(context);
                },
                child: const Text('Tất cả bình luận'),
              ),
            ],
          );
        });
  }

  Future<void> onLikeTap(CommentEmote? emote) async {
    debugPrint('onLikeTap');
    if (emote == null) {
      return;
    }
    try {
      final existed = emotesByCurrentUserId.value;
      if (existed != null) {
        // delete
        debugPrint('existed: $existed');
        var deleted = await dbService.deleteCommentEmoteById(existed.id);
        if (deleted == null) {
          debugPrint('deleted failed');
        } else {
          debugPrint('deleted successfully');
          emotesByCurrentUserId.value = null;
          if (deleted.code == EmoteCode.like) {
            likeNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            likeTotalCount--;
          } else if (deleted.code == EmoteCode.love) {
            loveNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            loveTotalCount--;
          } else if (deleted.code == EmoteCode.care) {
            careNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            careTotalCount--;
          } else if (deleted.code == EmoteCode.haha) {
            hahaNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            hahaTotalCount--;
          } else if (deleted.code == EmoteCode.wow) {
            wowNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            wowTotalCount--;
          } else if (deleted.code == EmoteCode.sad) {
            sadNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            sadTotalCount--;
          } else if (deleted.code == EmoteCode.angry) {
            angryNameItems.removeWhere((e) => e.key == Key(currentUser.id));
            angryTotalCount--;
          }
        }
        return;
      }
      // create
      var created = await dbService.createCommentEmote(
        initialPostComment.id,
        currentUser.id,
        emote,
      );
      if (created == null) {
        debugPrint('created failed');
      } else {
        debugPrint('created successfully');
        created.userByCreatedBy = currentUser;
        emotesByCurrentUserId.value = created;
        if (created.code == EmoteCode.like) {
          likeNameItems.add(_emoteToItem(created));
          likeTotalCount++;
        } else if (created.code == EmoteCode.love) {
          loveNameItems.add(_emoteToItem(created));
          loveTotalCount++;
        } else if (created.code == EmoteCode.care) {
          careNameItems.add(_emoteToItem(created));
          careTotalCount++;
        } else if (created.code == EmoteCode.haha) {
          hahaNameItems.add(_emoteToItem(created));
          hahaTotalCount++;
        } else if (created.code == EmoteCode.wow) {
          wowNameItems.add(_emoteToItem(created));
          wowTotalCount++;
        } else if (created.code == EmoteCode.sad) {
          sadNameItems.add(_emoteToItem(created));
          sadTotalCount++;
        } else if (created.code == EmoteCode.angry) {
          angryNameItems.add(_emoteToItem(created));
          angryTotalCount++;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  void onReplyTap() {
    if (onFocusCallBack == null) {
      // comment này có thể phản hồi
      isShowPostCommentsByReplyTo.value = true;
      //await _setNameTag(widget.comment.createdBy);
      commentNode.requestFocus();
    } else {
      // setNameTag bằng createdBy của comment này
      // focus vào _replyNode của comment mà comment này đang reply
      onFocusCallBack!(initialPostComment.userByCreatedBy?.name ??
          initialPostComment.userByCreatedBy?.uid ??
          initialPostComment.createdBy);
    }
  }

  Future<void> onSendTap() async {
    var created = await dbService.createPostCommentByPostIdCreatedByTextReplyTo(
      initialPostComment.postId,
      currentUser.id,
      textController.text.isNotEmpty ? textController.text : null,
      initialPostComment.id,
    );
    if (created != null) {
      textController.clear();
      commentNode.unfocus();
      // chua lam
      await _createCommentAttachments();
      created.userByCreatedBy = currentUser;
      postCommentItems.insert(0, _toItem(created));
    } else {
      debugPrint('createPostComment failed');
    }
  }

  Future<void> onConfirmDeleteTap() async {
    final patch = {
      'deletedAt': DateTime.now().toIso8601String(),
    };
    final updated = await dbService.updatePostCommentByIdPatch(
      initialPostComment.id,
      patch,
    );
    if (updated != null) {
      debugPrint('updatePostComment, deletedAt: ${updated.deletedAt}');
      onRefreshCallBack?.call();
      Get.snackbar(
        'Success:',
        'Deleted successfully',
        duration: const Duration(seconds: 2),
      );
    } else {
      debugPrint('updatePostComment failed');
      Get.snackbar(
        'Failed:',
        'Could not delete',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onDeleteTap() async {
    debugPrint('PostCommentItemController, onDeleteTap');
    await Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Confirm:'),
          ],
        ),
        children: [
          // r u sure
          Row(children: const [
            SizedBox(width: 5),
            Flexible(child: Text('Are you sure to delete this?')),
          ]),
          const SizedBox(height: 10),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ok
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    onConfirmDeleteTap();
                  },
                  child: const Text('Yes, delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onConfirmEditTap() async {
    final patch = {
      'editedAt': DateTime.now().toIso8601String(),
      'text': editTEC.text.isNotEmpty ? editTEC.text : null,
    };
    final updated = await dbService.updatePostCommentByIdPatch(
      initialPostComment.id,
      patch,
    );
    if (updated != null) {
      debugPrint('updatePostComment, editedAt: ${updated.editedAt}');
      onRefreshCallBack?.call();
    } else {
      debugPrint('updatePostComment failed');
    }
  }

  void onEditTap() {
    isEdit.value = true;
  }

  void onCancelEditTap() {
    isEdit.value = false;
  }

  Future<void> fetchPostCommentsByReplyToFirstAfterCurrentUserId() async {
    try {
      var moreItems =
          await dbService.postCommentsByReplyToFirstAfterCurrentUserId(
        initialPostComment.id,
        _limit,
        postCommentsPageInfo.value.endCursor,
        currentUser.id,
      );
      if (moreItems != null) {
        postCommentsTotalCount.value = moreItems.totalCount;
        postCommentsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        postCommentItems.addAll(moreItems.nodes.map((e) => _toItem(e)));
      } else {
        debugPrint('fetchPostCommentsByReplyTo failed');
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    debugPrint('fetchPostCommentsByReplyTo: ${postCommentItems.length}');
  }

  Future<PostComment?> _createCommentAttachments() async {
    try {} catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  initPlz() {
    debugPrint(
        'PostCommentItemController, initPlz, id: ${initialPostComment.id}');
    final postCommentsByReplyTo = initialPostComment.postCommentsByReplyTo;
    if (postCommentsByReplyTo != null) {
      postCommentsTotalCount.value = postCommentsByReplyTo.totalCount;
    }
    // emoteByCurrentUserId
    final emoteByCurrentUserId = initialPostComment.emoteByCurrentUserId;
    if (emoteByCurrentUserId?.nodes.isNotEmpty ?? false) {
      emotesByCurrentUserId.value = emoteByCurrentUserId?.nodes.first;
    }
    // emotesByLike
    final emotesByLike = initialPostComment.emotesByLike;
    if (emotesByLike != null) {
      likeNameItems.addAll(emotesByLike.nodes.map((e) => _emoteToItem(e)));
      likeTotalCount.value = emotesByLike.totalCount;
    }
    // emotesByLove
    final emotesByLove = initialPostComment.emotesByLove;
    if (emotesByLove != null) {
      loveNameItems.addAll(emotesByLove.nodes.map((e) => _emoteToItem(e)));
      loveTotalCount.value = emotesByLove.totalCount;
    }
    // emotesByCare
    final emotesByCare = initialPostComment.emotesByCare;
    if (emotesByCare != null) {
      careNameItems.addAll(emotesByCare.nodes.map((e) => _emoteToItem(e)));
      careTotalCount.value = emotesByCare.totalCount;
    }
    // emotesByHaha
    final emotesByHaha = initialPostComment.emotesByHaha;
    if (emotesByHaha != null) {
      hahaNameItems.addAll(emotesByHaha.nodes.map((e) => _emoteToItem(e)));
      hahaTotalCount.value = emotesByHaha.totalCount;
    }
    // emotesByWow
    final emotesByWow = initialPostComment.emotesByWow;
    if (emotesByWow != null) {
      wowNameItems.addAll(emotesByWow.nodes.map((e) => _emoteToItem(e)));
      wowTotalCount.value = emotesByWow.totalCount;
    }
    // emotesBySad
    final emotesBySad = initialPostComment.emotesBySad;
    if (emotesBySad != null) {
      sadNameItems.addAll(emotesBySad.nodes.map((e) => _emoteToItem(e)));
      sadTotalCount.value = emotesBySad.totalCount;
    }
    // emotesByAngry
    final emotesByAngry = initialPostComment.emotesByAngry;
    if (emotesByAngry != null) {
      angryNameItems.addAll(emotesByAngry.nodes.map((e) => _emoteToItem(e)));
      angryTotalCount.value = emotesByAngry.totalCount;
    }

    ever(status, (_) {
      debugPrint('status: $status');
    });
  }

  disposePlz() {
    debugPrint(
        'PostCommentItemController, disposePlz, id: ${initialPostComment.id}');
    commentNode.dispose();
    textController.dispose();
  }
}
