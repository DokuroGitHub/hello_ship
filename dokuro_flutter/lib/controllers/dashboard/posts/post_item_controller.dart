import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/constants/emote_code.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/constants/report_type.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/post_emote.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/post/post_comment_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/screens/dashboard/posts/post_screen.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostItemController {
  final Post initialPost;
  final Key? initialKey;
  final Function? onDeleteCallback;
  final Function? onRefreshCallBack;

  PostItemController(
    this.initialPost, {
    this.initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
  });

  final dbService = Get.find<DbService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final FocusNode commentFC = FocusNode();
  final int _limit = 2;

  final TextEditingController commentTEC = TextEditingController();
  final TextEditingController searchOfferTEC = TextEditingController();
  Rx<TextEditingController> postTextTEC = TextEditingController().obs;
  Rx<TextEditingController> offerPriceTEC = TextEditingController().obs;
  Rx<TextEditingController> offerNotesTEC = TextEditingController().obs;

  Rx<Status> status = Status.ready.obs;

  // post
  late Rx<Post> post = initialPost.obs;
  // shipment
  Rx<Shipment> shipment = Shipment().obs;
  Rx<ShipmentOffers> shipmentOffers = ShipmentOffers().obs;
  // emotes
  Rxn<PostEmote> emotesByCurrentUserId = Rxn();
  RxList<Text> likeNameItems = RxList();
  RxInt likeTotalCount = 0.obs;
  RxList<Text> loveNameItems = RxList();
  RxInt loveTotalCount = 0.obs;
  RxList<Text> careNameItems = RxList();
  RxInt careTotalCount = 0.obs;
  RxList<Text> hahaNameItems = RxList();
  RxInt hahaTotalCount = 0.obs;
  RxList<Text> wowNameItems = RxList();
  RxInt wowTotalCount = 0.obs;
  RxList<Text> sadNameItems = RxList();
  RxInt sadTotalCount = 0.obs;
  RxList<Text> angryNameItems = RxList();
  RxInt angryTotalCount = 0.obs;
  // postCommentItems
  RxList<PostCommentItem> postCommentItems = RxList();
  Rx<PageInfo> postCommentsPageInfo = PageInfo().obs;
  RxInt postCommentsTotalCount = 0.obs;

  // shipmentOffers conditions
  RxBool cbCreatedByMe = false.obs;
  RxBool cbRejectedAt = false.obs;
  RxBool cbAcceptedAt = false.obs;
  RxBool cbAcceptedAtRejectedAtNull = false.obs;
  Rx<ShipmentOffersOrderBy> shipmentOffersOrderBy =
      ShipmentOffersOrderBy.newest.obs;
  // comments conditions
  Rx<bool> isShowComments = false.obs;
  Rx<CommentsOrderBy> commentsOrderBy = CommentsOrderBy.idDesc.obs;
  // emotesPicker
  RxBool showEmotesPicker = false.obs;
  Rx<DateTime> hoverTrueAt = DateTime.now().obs;
  Rx<DateTime> hoverFalseAt = DateTime.now().obs;

  // report
  RxString reportType = ReportType.undefined.obs;
  final TextEditingController reportTEC = TextEditingController();

  void _reset() {
    // post
    post.value = Post();
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

  Text _emoteToItem(PostEmote e) {
    return Text(
      e.userByCreatedBy?.name ?? '',
      key: Key('${e.id}'),
      style: const TextStyle(color: Colors.black),
    );
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
        fetchPostCommentsByPostIdFirstAfterCurrentUserId();
      },
    );
  }

  void sortPostCommentItems() {
    if (postCommentItems.isEmpty) {
      return;
    }
    var items = postCommentItems.toList();
    // default newest
    if (commentsOrderBy.value == CommentsOrderBy.idDesc) {
      items.sort((a, b) => b.initialPostComment.createdAt!
          .compareTo(a.initialPostComment.createdAt!));
    } else if (shipmentOffersOrderBy.value == CommentsOrderBy.idAsc) {
      items.sort((a, b) => a.initialPostComment.createdAt!
          .compareTo(b.initialPostComment.createdAt!));
    }
    postCommentItems.value = items;
  }

  void sortShipmentOffers() {
    if (shipmentOffers.value.nodes.isEmpty) {
      return;
    }
    var items = shipmentOffers.value.nodes;
    // default newest
    if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.newest) {
      items.sort((a, b) =>
          (b.editedAt ?? b.createdAt)!.compareTo((a.editedAt ?? a.createdAt)!));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.oldest) {
      items.sort((a, b) =>
          (a.editedAt ?? a.createdAt)!.compareTo((b.editedAt ?? b.createdAt)!));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.priceAsc) {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.priceDesc) {
      items.sort((a, b) => b.price.compareTo(a.price));
    }
    shipmentOffers.update((val) {
      val?.nodes = items;
    });
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

  Future<void> fetchPostCommentsByPostIdFirstAfterCurrentUserId() async {
    try {
      var moreItems =
          await dbService.postCommentsByPostIdFirstAfterCurrentUserId(
        initialPost.id,
        _limit,
        postCommentsPageInfo.value.endCursor,
        currentUser.id,
      );
      if (moreItems != null) {
        postCommentsTotalCount.value = moreItems.totalCount;
        postCommentsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        postCommentItems.addAll(moreItems.nodes.map((e) => _toItem(e)));
      } else {
        debugPrint('fetchPostCommentsByPostIdFirstAfterCurrentUserId failed');
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    debugPrint('postCommentItems: ${postCommentItems.length}');
  }

  Future<void> fetchShipmentById() async {
    debugPrint('fetchShipmentById');
    try {
      var shipmentDesu = await dbService.shipmentById(
        shipment.value.id,
      );
      if (shipmentDesu != null) {
        shipment.value = shipmentDesu;
      } else {
        debugPrint('fetchShipmentById failed');
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    debugPrint('shipment: ${shipment.value.id}');
  }

  Future<void> fetchShipmentOffersByShipmentId() async {
    try {
      var shipmentOffersDesu =
          await dbService.shipmentOffersByShipmentId(shipment.value.id);
      if (shipmentOffersDesu != null) {
        debugPrint('fetchShipmentOffersByShipmentId successfully ');
        shipmentOffers.value = shipmentOffersDesu;
      } else {
        debugPrint('fetchShipmentOffersByShipmentId failed');
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    debugPrint(
        'fetchShipmentOffersByShipmentId: ${shipmentOffers.value.totalCount}');
  }

  Future<void> onLikeTap() async {
    debugPrint('onLikeTap');
    try {
      // exist?
      //var existed = emotesByCurrentUserId.value;
      var existed = await dbService.postEmoteByPostIdAndCreatedBy(
        initialPost.id,
        currentUser.id,
      );
      if (existed != null) {
        // delete
        var deleted = await dbService.deletePostEmoteById(existed.id);
        if (deleted == null) {
          debugPrint('deleted failed');
        } else {
          debugPrint('deleted successfully');
          emotesByCurrentUserId.value = null;
          if (deleted.code == EmoteCode.like) {
            likeNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            likeTotalCount--;
          } else if (deleted.code == EmoteCode.love) {
            loveNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            loveTotalCount--;
          } else if (deleted.code == EmoteCode.care) {
            careNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            careTotalCount--;
          } else if (deleted.code == EmoteCode.haha) {
            hahaNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            hahaTotalCount--;
          } else if (deleted.code == EmoteCode.wow) {
            wowNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            wowTotalCount--;
          } else if (deleted.code == EmoteCode.sad) {
            sadNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            sadTotalCount--;
          } else if (deleted.code == EmoteCode.angry) {
            angryNameItems.removeWhere((e) => e.key == Key('${deleted.id}'));
            angryTotalCount--;
          }
        }
        return;
      }
      // create
      var created = await dbService.createPostEmoteByPostIdCreatedByCode(
        initialPost.id,
        currentUser.id,
        EmoteCode.like,
      );
      if (created == null) {
        debugPrint('created failed');
      } else {
        debugPrint('created successfully');
        created.userByCreatedBy = currentUser;
        emotesByCurrentUserId.value = created;
        likeNameItems.add(_emoteToItem(created));
        likeTotalCount++;
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> onEmoteTap(PostEmote? emote) async {
    if (emote == null) {
      return;
    }
    debugPrint('onEmoteTap');
    try {
      // exist?
      //var existed = emotesByCurrentUserId.value;
      var existed = await dbService.postEmoteByPostIdAndCreatedBy(
        initialPost.id,
        currentUser.id,
      );
      if (existed != null) {
        final PostEmote old = PostEmote(
          id: existed.id,
          createdBy: existed.createdBy,
          createdAt: existed.createdAt,
          code: existed.code,
          userByCreatedBy: existed.userByCreatedBy,
        );
        // update
        existed.editedAt = DateTime.now();
        existed.code = emote.code;
        var updated = await dbService.updatePostEmoteByIdEditedAtCode(
          existed.id,
          existed.code,
        );
        if (updated == null) {
          debugPrint('updated failed');
        } else {
          debugPrint('updated successfully');
          // emotesByCurrentUserId
          updated.userByCreatedBy = currentUser;
          emotesByCurrentUserId.value = updated;
          // remove _old
          if (old.code == EmoteCode.like) {
            likeNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            likeTotalCount--;
          } else if (old.code == EmoteCode.love) {
            loveNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            loveTotalCount--;
          } else if (old.code == EmoteCode.care) {
            careNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            careTotalCount--;
          } else if (old.code == EmoteCode.haha) {
            hahaNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            hahaTotalCount--;
          } else if (old.code == EmoteCode.wow) {
            wowNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            wowTotalCount--;
          } else if (old.code == EmoteCode.sad) {
            sadNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            sadTotalCount--;
          } else if (old.code == EmoteCode.angry) {
            angryNameItems.removeWhere((e) => e.key == Key('${old.id}'));
            angryTotalCount--;
          }
          // add updated
          if (updated.code == EmoteCode.like) {
            likeNameItems.add(_emoteToItem(updated));
            likeTotalCount++;
          } else if (updated.code == EmoteCode.love) {
            loveNameItems.add(_emoteToItem(updated));
            loveTotalCount++;
          } else if (updated.code == EmoteCode.care) {
            careNameItems.add(_emoteToItem(updated));
            careTotalCount++;
          } else if (updated.code == EmoteCode.haha) {
            hahaNameItems.add(_emoteToItem(updated));
            hahaTotalCount++;
          } else if (updated.code == EmoteCode.wow) {
            wowNameItems.add(_emoteToItem(updated));
            wowTotalCount++;
          } else if (updated.code == EmoteCode.sad) {
            sadNameItems.add(_emoteToItem(updated));
            sadTotalCount++;
          } else if (updated.code == EmoteCode.angry) {
            angryNameItems.add(_emoteToItem(updated));
            angryTotalCount++;
          }
        }
        return;
      }
      // create
      var created = await dbService.createPostEmoteByPostIdCreatedByCode(
        initialPost.id,
        currentUser.id,
        emote.code,
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

  Future<void> onCommentTap() async {
    await fetchPostCommentsByPostIdFirstAfterCurrentUserId();
    isShowComments.value = true;
    commentFC.requestFocus();
  }

  Future<void> onCommentSendTap() async {
    var created = await dbService.createPostCommentByPostIdCreatedByTextReplyTo(
      initialPost.id,
      currentUser.id,
      commentTEC.value.text.isNotEmpty ? commentTEC.value.text : null,
      null,
    );
    if (created != null) {
      commentTEC.clear();
      commentFC.unfocus();
      // chua lam
      await _createCommentAttachments();
      created.userByCreatedBy = currentUser;
      postCommentItems.insert(0, _toItem(created));
      postCommentsTotalCount.value++;
    } else {
      debugPrint('createPostComment failed');
    }
  }

  Future<void> onOfferSearchTap() async {
    final items = await dbService.shipmentOffersByShipmentIdSearch(
      initialPost.shipmentId,
      searchOfferTEC.value.text,
    );
    if (items == null) {
      Get.snackbar(
        'Failed:',
        'Could not search offers',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipmentOffers.value = items;
      sortShipmentOffers();
      searchOfferTEC.clear();
      Get.snackbar(
        'Success:',
        'fetched offers',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onOfferSubmitTap() async {
    final created =
        await dbService.createShipmentOfferByShipmentIdCreatedByPriceNotes(
      initialPost.shipmentId,
      currentUser.id,
      int.tryParse(offerPriceTEC.value.text),
      offerNotesTEC.value.text.isNotEmpty ? offerNotesTEC.value.text : null,
    );
    if (created == null) {
      Get.snackbar(
        'Failed:',
        'Could not send offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipmentOffers.update((val) {
        val?.nodes.add(created);
        val?.totalCount++;
      });
      sortShipmentOffers();
      offerPriceTEC.update((val) {
        val?.clear();
      });
      offerNotesTEC.update((val) {
        val?.clear();
      });
      Get.back();
      Get.snackbar(
        'Success:',
        'Sent offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onOfferTap() async {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Flexible(child: Text('Offer:')),
          const SizedBox(width: 10),
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
              child: UserAvatar(
                avatarUrl: currentUser.avatarUrl,
                isOnline: true,
              )),
          const SizedBox(width: 5),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // price
                  Row(children: [
                    Expanded(
                      child: Text(
                        'Price: ${int.tryParse(offerPriceTEC.value.text) ?? 0} vnđ',
                        style: const TextStyle(
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ]),
                  // notes
                  Row(children: [
                    Expanded(
                      child: Text(
                        'Notes: ${offerNotesTEC.value.text}',
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ]),
        children: [
          // price
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Price: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: offerPriceTEC.value,
                onChanged: (s) {
                  offerPriceTEC.update((val) {});
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 35),
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 0, bottom: 10),
                  hintText: '50000',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Flexible(child: Text('vnđ')),
          ]),
          const SizedBox(height: 5),
          // notes
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Notes: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: offerNotesTEC.value,
                onChanged: (e) {
                  offerNotesTEC.update((val) {});
                },
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 10, bottom: 10),
                  hintText: 'Leave some notes here',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onEditingComplete: onOfferSubmitTap,
              ),
            ),
            const SizedBox(width: 5),
          ]),
          const SizedBox(height: 5),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: TextButton(
                  onPressed: () {
                    offerPriceTEC.value.clear();
                    offerNotesTEC.value.clear();
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              // ok
              Flexible(
                child: ElevatedButton(
                  onPressed: onOfferSubmitTap,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onPostViewTap() async {
    Get.to(() => PostScreen(
          post.value,
          initialKey: initialKey,
          onDeleteCallback: onDeleteCallback,
          onRefreshCallBack: onRefreshCallBack,
        ));
  }

  Future<void> onPostReportTap() async {
    postTextTEC.value.text = initialPost.text;
    Get.dialog(
      Obx(() {
        if (reportType.value == ReportType.content18) {
          return SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          reportType.value = ReportType.undefined;
                        },
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Tiêu chuẩn cộng đồng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.close),
                        onPressed: Get.back,
                      ),
                    ),
                  ]),
              children: [
                const Divider(thickness: 1.0),
                Row(children: const [Icon(Icons.error, color: Colors.red)]),
                const Text(
                  'Nội dung 18+',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                    'Chúng tôi chỉ gỡ những nội dung vi phạm Tiêu chuẩn cộng đồng của mình, chẳng hạn như:'),
                const SizedBox(height: 10),
                const Text('. Hoạt động tình dục'),
                const Text('. Bán hoặc mua dâm'),
                const Text(
                    '. Nhũ hoa (trừ trường hợp đang cho con bú, liên quan đến sức khỏe và hành động phản đối)'),
                const Text('. Ảnh khỏa thân hiển thị bộ phận sinh dục'),
                const Text('. Ngôn ngữ khiêu dâm'),
                const SizedBox(height: 10),
                const Text('Ghi chú:'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: reportTEC,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onPostReportSendTap,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ))),
                  child: const Text('Gửi'),
                ),
              ]);
        } else if (reportType.value == ReportType.violence) {
          return SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          reportType.value = ReportType.undefined;
                        },
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Tiêu chuẩn cộng đồng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.close),
                        onPressed: Get.back,
                      ),
                    ),
                  ]),
              children: [
                const Divider(thickness: 1.0),
                Row(children: const [Icon(Icons.error, color: Colors.red)]),
                const Text(
                  'Bạo lực',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Chúng tôi chỉ gỡ những nội dung vi phạm Tiêu chuẩn cộng đồng của mình, chẳng hạn như:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  '• Mối đe dọa gây ra bạo lực đáng tin',
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                    '   Ví dụ: nhắm mục tiêu một người và nhắc đến vũ khí cụ thể'),
                const Text(
                  '• Người hoặc tổ chức nguy hiểm',
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                    '   Ví dụ: chủ nghĩa khủng bố hoặc một tổ chức tội phạm'),
                const Text(
                  '• Hình ảnh cực kỳ bạo lực',
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                    '   Ví dụ: tôn vinh bạo lực hoặc tán dương sự đau khổ'),
                const Text(
                  '• Một loại bạo lực khác',
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                    '   Ví dụ: hình ảnh hoặc nội dung khác gây khó chịu'),
                const SizedBox(height: 10),
                const Text('Ghi chú:'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: reportTEC,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onPostReportSendTap,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ))),
                  child: const Text('Gửi'),
                ),
              ]);
        } else if (reportType.value == ReportType.nationalSecret) {
          return SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          reportType.value = ReportType.undefined;
                        },
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Tiêu chuẩn cộng đồng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.close),
                        onPressed: Get.back,
                      ),
                    ),
                  ]),
              children: [
                const Divider(thickness: 1.0),
                Row(children: const [Icon(Icons.error, color: Colors.red)]),
                const Text(
                  'Bí mật quốc gia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Chúng tôi chỉ gỡ những nội dung vi phạm Tiêu chuẩn cộng đồng của mình, chẳng hạn như:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Chúng tôi gỡ nội dung về mọi cá nhân hoặc nhóm phi chính phủ tham gia hay ủng hộ các hành vi bạo lực có kế hoạch phục vụ mục đích chính trị, tôn giáo hoặc lý tưởng.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text('Ghi chú:'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: reportTEC,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onPostReportSendTap,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ))),
                  child: const Text('Gửi'),
                ),
              ]);
        } else if (reportType.value == ReportType.others) {
          return SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          reportType.value = ReportType.undefined;
                        },
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        'Báo cáo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Ink(
                      decoration: ShapeDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.close),
                        onPressed: Get.back,
                      ),
                    ),
                  ]),
              children: [
                const Divider(thickness: 1.0),
                const Text(
                  'Nội dung này có vi phạm Tiêu chuẩn cộng đồng của chúng tôi không?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Các tiêu chuẩn của chúng tôi giải thích về những gì chúng tôi cho phép và không cho phép hiển thị trên Facebook. Với sự hỗ trợ của các chuyên gia, chúng tôi thường xuyên xem xét và cập nhật các tiêu chuẩn mình đề ra.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text('Ghi chú:'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: reportTEC,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onPostReportSendTap,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ))),
                  child: const Text('Gửi'),
                ),
              ]);
        }
        return SimpleDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          title: Row(children: [
            Expanded(
              child: Stack(alignment: AlignmentDirectional.center, children: [
                const Text(
                  'Báo cáo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.close),
                      onPressed: _onPostEditCloseTap,
                    ),
                  ),
                ),
              ]),
            )
          ]),
          children: [
            const Divider(thickness: 1.0),
            const Text(
              'Hãy chọn vấn đề',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
                'Nếu bạn nhận thấy ai đó đang gặp nguy hiểm, đừng chần chừ mà hãy tìm ngay sự giúp đỡ trước khi báo cáo với chúng tôi.'),
            const SizedBox(height: 10),
            // content18
            InkWell(
              onTap: () {
                reportType.value = ReportType.content18;
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(ReportType.content18),
                      Icon(Icons.keyboard_arrow_right),
                    ]),
              ),
            ),
            // nationalSecret
            InkWell(
              onTap: () {
                reportType.value = ReportType.violence;
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(ReportType.violence),
                      Icon(Icons.keyboard_arrow_right),
                    ]),
              ),
            ),
            // nationalSecret
            InkWell(
              onTap: () {
                reportType.value = ReportType.nationalSecret;
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(ReportType.nationalSecret),
                      Icon(Icons.keyboard_arrow_right),
                    ]),
              ),
            ),
            // others
            InkWell(
              onTap: () {
                reportType.value = ReportType.others;
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(ReportType.others),
                      Icon(Icons.keyboard_arrow_right),
                    ]),
              ),
            ),
          ],
        );
      }),
      barrierDismissible: true,
    );
  }

  Future<void> onPostEditTap() async {
    postTextTEC.value.text = initialPost.text;
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.center, children: [
              const Text('Chỉnh sửa bài viết'),
              Positioned(
                right: 0,
                top: 0,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.close),
                    onPressed: _onPostEditCloseTap,
                  ),
                ),
              ),
            ]),
          )
        ]),
        children: [
          const Divider(thickness: 1.0),
          // avatar + (name / location) + actions
          Row(children: [
            // avatar
            SizedBox(
              width: 40,
              height: 40,
              child: UserAvatar(
                avatarUrl: currentUser.avatarUrl,
                lastSeen: currentUser.lastSeen,
              ),
            ),
            const SizedBox(width: 5),
            // name + location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: currentUser.name),
                  TextButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                    ),
                    icon: const Icon(Icons.location_pin),
                    label: const Text('location'),
                  ),
                ],
              ),
            ),
          ]),
          // postTextTF
          TextField(
            controller: postTextTEC.value,
            onChanged: (_) {
              postTextTEC.update((val) {});
            },
            decoration: InputDecoration(
              hintText: '${currentUser.name} ơi, Bạn đang nghĩ gì thế?',
              border: InputBorder.none,
            ),
            maxLines: 5,
          ),
          // save btn
          Row(children: [
            Expanded(
              child: Obx(() => ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))))),
                    onPressed: postTextTEC.value.text != initialPost.text
                        ? _onPostEditSubmitTap
                        : null,
                    child: const Text('Lưu'),
                  )),
            ),
          ]),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> onPostDeleteTap() async {
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
                    _onPostDeleteSubmitTap();
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

  void onShipmentViewTap() {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Shipment'),
              Positioned(
                right: 0,
                top: 0,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ]),
          ),
        ]),
        children: [
          const Divider(thickness: 1.0),
          // avatar + name + uid
          Row(children: [
            // avatar
            SizedBox(
              width: 40,
              height: 40,
              child: UserAvatar(
                avatarUrl: post.value.userByCreatedBy?.avatarUrl,
                lastSeen: post.value.userByCreatedBy?.lastSeen,
              ),
            ),
            const SizedBox(width: 5),
            // name + uid
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: post.value.userByCreatedBy?.name),
                  TextButton.icon(
                    onPressed: () {
                      var uid = '';
                      if (post.value.userByCreatedBy?.uid.isNotEmpty ?? false) {
                        uid = post.value.userByCreatedBy!.uid;
                      } else {
                        uid = post.value.createdBy;
                      }
                      final message = 'uid: $uid';
                      Clipboard.setData(ClipboardData(text: uid));
                      Get.showSnackbar(GetSnackBar(
                        title: 'Copied',
                        message: message,
                        duration: const Duration(seconds: 1),
                      ));
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                    ),
                    icon: const Icon(Icons.person),
                    label: Obx(() => Text(
                        'uid: ${(post.value.userByCreatedBy?.uid.isNotEmpty ?? false) ? post.value.userByCreatedBy?.uid : post.value.createdBy}')),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // type
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.delivery_dining),
            Flexible(child: Text('Type: ${shipment.value.type}')),
          ]),
          const SizedBox(height: 5),
          // service
          Row(children: [
            const Icon(Icons.category),
            const Flexible(child: Text('Service: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.service),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // cod
          Row(children: [
            const Icon(Icons.attach_money),
            const Flexible(child: Text('Price: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text('${shipment.value.cod} vnđ'),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // phone
          Row(children: [
            const Icon(Icons.phone),
            Flexible(
                child: Text('${AppLocalizations.of(Get.context!).phoneCap}: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.phone.isNotEmpty
                    ? shipment.value.phone
                    : AppLocalizations.of(Get.context!).phoneNot),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // status
          Row(children: [
            const Icon(Icons.timer),
            const Flexible(child: Text('Status: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.status),
              ),
            ),
          ]),

          const Divider(thickness: 1.0),
          // action buttons
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Đóng'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _onPostEditCloseTap() async {
    if (postTextTEC.value.text == initialPost.text) {
      Get.back();
    } else {
      Get.dialog(SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child:
                Stack(alignment: AlignmentDirectional.centerStart, children: [
              const Text('Thay đổi chưa lưu'),
              Positioned(
                right: 0,
                top: 0,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.close),
                    onPressed: Get.back,
                  ),
                ),
              ),
            ]),
          )
        ]),
        children: [
          const Divider(thickness: 1.0),
          // avatar + (name / location) + actions
          const Text('Hệ thống sẽ không lưu các thay đổi của bạn'),
          const SizedBox(height: 10),
          // actions
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Flexible(
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                onPressed: () => Get.close(1),
                child: const Text('Tiếp tục chỉnh sửa'),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                onPressed: () => Get.close(2),
                child: const Text('Bỏ'),
              ),
            ),
          ]),
        ],
      ));
    }
  }

  Future<void> _onPostEditSubmitTap() async {
    final updated = await dbService.updatePostByIdEditedAtText(
      initialPost.id,
      postTextTEC.value.text.isNotEmpty ? postTextTEC.value.text : null,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update post',
        duration: const Duration(seconds: 2),
      );
    } else {
      //onRefreshCallBack?.call();
      post.update((val) {
        val?.editedAt = updated.editedAt;
        val?.text = updated.text;
      });
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated post',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onPostDeleteSubmitTap() async {
    final updated = await dbService.updatePostByIdDeletedByDeletedAt(
      initialPost.id,
      currentUser.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not delete post',
        duration: const Duration(seconds: 2),
      );
    } else {
      //onRefreshCallBack?.call();
      onDeleteCallback?.call();
      Get.back();
      Get.snackbar(
        'Success:',
        'Deleted post',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onPostReportSendTap() async {
    final created = await dbService
        .createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus(
      post.value.createdBy,
      currentUser.id,
      reportTEC.text.isNotEmpty ? reportTEC.text : null,
      post.value.id,
      reportType.value,
      ReportStatus.unchecked,
    );
    if (created == null) {
      Get.back();
      Get.snackbar(
        'Failure:',
        'Could not send report',
        duration: const Duration(seconds: 2),
      );
    } else {
      reportType.value = ReportType.undefined;
      reportTEC.clear();
      Get.back();
      Get.dialog(
        SimpleDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            titlePadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            title: Column(children: const [
              SizedBox(height: 10),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              Text(
                'Cảm ơn bạn! Chúng tôi đã nhận được báo cáo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
            children: [
              // reportType
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    margin: const EdgeInsets.all(10),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.check, color: Colors.blue),
                      Text(
                        reportType.value,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ]),
                  ),
                ],
              ),
              // stages
              IntrinsicHeight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              height: 10,
                              width: 10,
                            ),
                            const Expanded(
                                child: VerticalDivider(thickness: 2)),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withOpacity(0.4)),
                              child: Align(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                            const Expanded(
                                child: VerticalDivider(thickness: 2)),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              height: 10,
                              width: 10,
                            ),
                            const SizedBox(height: 30),
                          ]),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Báo cáo nhận được',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'Báo cáo của bạn hỗ trợ chúng tôi cải thiện quy trình và giữ Facebook an toàn cho mọi người.'),
                              Text(
                                'Đang chờ xét duyệt',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'Chúng tôi dùng công nghệ và đội ngũ xét duyệt để loại bỏ mọi nội dung không tuân thủ tiêu chuẩn cộng đồng của mình nhanh nhất có thể.'),
                              Text(
                                'Quyết định đã đưa ra',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'Chúng tôi sẽ gửi thông báo để bạn xem kết quả trong Hộp thư hỗ trợ trong thời gian sớm nhất có thể.'),
                            ]),
                      ),
                    ]),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.0),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(onPressed: Get.back, child: const Text('Đóng')),
              ]),
            ]),
        barrierDismissible: true,
      );
    }
  }

  Future<PostComment?> _createCommentAttachments() async {
    try {} catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  // subscriptionPostEmotesByPostId() {
  //   debugPrint('subscriptionPostEmotesByPostId');
  //   try {
  //     var subscription = _client.subscribe(
  //       SubscriptionOptions(
  //         document: gql(PostQuery.subscriptionPostEmotesByPostId),
  //         variables: {
  //           "postId": post.value.id,
  //         },
  //       ),
  //     );
  //     subscription.listen((result) {
  //       if (result.hasException) {
  //         debugPrint(result.exception.toString());
  //         return;
  //       }
  //       if (result.isfetching) {
  //         debugPrint('awaiting results');
  //         return;
  //       }
  //       final List? maps =
  //           result.data?['postEmotesByPostId']?['nodes'] as List?;
  //       debugPrint('data: ${result.data}');
  //       if (maps != null) {
  //         post.value.postEmotes =
  //             convertMapToPostEmotes(result.data?['postEmotesByPostId']);
  //         //postEmotes.clear();
  //         //postEmotes.addAll(maps.map((e) => PostEmote.fromJson(e)).toList());
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint('e: $e');
  //   }
  // }

  // subscriptionPostCommentsByPostId() {
  //   try {
  //     var subscription = _client.subscribe(
  //       SubscriptionOptions(
  //         document: gql(PostQuery.subscriptionPostCommentsByPostId),
  //         variables: {"postId": post.value.id},
  //       ),
  //     );
  //     subscription.listen((result) {
  //       if (result.hasException) {
  //         debugPrint(result.exception.toString());
  //         return;
  //       }
  //       if (result.isfetching) {
  //         debugPrint('awaiting results');
  //         return;
  //       }
  //       final List? maps =
  //           result.data?['postCommentsByPostId']?['nodes'] as List?;
  //       debugPrint('data: ${result.data}');
  //       if (maps != null) {
  //         post.value.postComments =
  //             convertMapToPostComments(result.data?['postCommentsByPostId']);
  //         post.value.postComments?.nodes =
  //             maps.map((e) => PostComment.fromJson(e)).toList();
  //         //comments.clear();
  //         //comments.addAll(maps.map((e) => PostComment.fromJson(e)).toList());
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint('e: $e');
  //   }
  // }

  initPlz() {
    debugPrint('PosItemController, initPlz, id: ${initialPost.id}');
    post.value = initialPost;
    // emoteByCurrentUserId
    final emoteByCurrentUserId = initialPost.emoteByCurrentUserId;
    if (emoteByCurrentUserId?.nodes.isNotEmpty ?? false) {
      emotesByCurrentUserId.value = emoteByCurrentUserId?.nodes.first;
    }
    // emotesByLike
    final emotesByLike = initialPost.emotesByLike;
    if (emotesByLike != null) {
      likeNameItems.addAll(emotesByLike.nodes.map((e) => _emoteToItem(e)));
      likeTotalCount.value = emotesByLike.totalCount;
    }
    // emotesByLove
    final emotesByLove = initialPost.emotesByLove;
    if (emotesByLove != null) {
      loveNameItems.addAll(emotesByLove.nodes.map((e) => _emoteToItem(e)));
      loveTotalCount.value = emotesByLove.totalCount;
    }
    // emotesByCare
    final emotesByCare = initialPost.emotesByCare;
    if (emotesByCare != null) {
      careNameItems.addAll(emotesByCare.nodes.map((e) => _emoteToItem(e)));
      careTotalCount.value = emotesByCare.totalCount;
    }
    // emotesByHaha
    final emotesByHaha = initialPost.emotesByHaha;
    if (emotesByHaha != null) {
      hahaNameItems.addAll(emotesByHaha.nodes.map((e) => _emoteToItem(e)));
      hahaTotalCount.value = emotesByHaha.totalCount;
    }
    // emotesByWow
    final emotesByWow = initialPost.emotesByWow;
    if (emotesByWow != null) {
      wowNameItems.addAll(emotesByWow.nodes.map((e) => _emoteToItem(e)));
      wowTotalCount.value = emotesByWow.totalCount;
    }
    // emotesBySad
    final emotesBySad = initialPost.emotesBySad;
    if (emotesBySad != null) {
      sadNameItems.addAll(emotesBySad.nodes.map((e) => _emoteToItem(e)));
      sadTotalCount.value = emotesBySad.totalCount;
    }
    // emotesByAngry
    final emotesByAngry = initialPost.emotesByAngry;
    if (emotesByAngry != null) {
      angryNameItems.addAll(emotesByAngry.nodes.map((e) => _emoteToItem(e)));
      angryTotalCount.value = emotesByAngry.totalCount;
    }
    // postComments
    final postComments = initialPost.postComments;
    if (postComments != null) {
      postCommentItems.addAll(postComments.nodes.map((e) => _toItem(e)));
      postCommentsTotalCount.value = postComments.totalCount;
    }
    // shipment
    final shipmentDesu = initialPost.shipment;
    if (shipmentDesu != null) {
      shipment.value = shipmentDesu;
    }
    if (initialPost.shipment?.shipmentOffers != null) {
      shipmentOffers.value = initialPost.shipment!.shipmentOffers!;
      sortShipmentOffers();
    }
  }

  disposePlz() {
    debugPrint('PosItemController, disposePlz, id: ${initialPost.id}');
    commentFC.dispose();
    commentTEC.dispose();
    offerPriceTEC.value.dispose();
    offerNotesTEC.value.dispose();
  }
}
