import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard/posts/post_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/account_role.dart';
import 'package:dokuro_flutter/models/constants/emote_code.dart';
import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:dokuro_flutter/models/post_emote.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/shipment/shipment_attachments_widget.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/shipment/shipment_offer_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/rating_widget.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/screens/dashboard/shipments/shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'post_attachments_widget.dart';

class PostItem extends StatefulWidget {
  final Post initialPost;
  final Function? onDeleteCallback;
  final Function? onRefreshCallBack;
  const PostItem(
    this.initialPost, {
    Key? initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
  }) : super(key: initialKey);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late final postItemController = PostItemController(
    widget.initialPost,
    initialKey: widget.key,
    onDeleteCallback: widget.onDeleteCallback,
    onRefreshCallBack: widget.onRefreshCallBack,
  );

  @override
  void initState() {
    postItemController.initPlz();
    super.initState();
  }

  @override
  void dispose() {
    postItemController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'PostItem, id: ${postItemController.post.value.id}, key: ${postItemController.initialKey}');
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => postItemController.status.value == Status.ready
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Column(children: [
                      _photoNameDate3Dots(),
                      _postContent(),
                      Obx(() => _shipmentContent()),
                      const SizedBox(height: 5.0),
                      _emoteCommentCounts(context),
                      const Divider(thickness: 1.5),
                    ]),
                    if (postItemController.showEmotesPicker.value)
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: _emotesRow(),
                      ),
                  ]),
                  _likeCommentShareRow(),
                  _commentsContent(),
                ],
              )
            : const CircularProgressIndicator()),
      ),
    );
  }

  Widget _emotesRow() {
    return InkWell(
      onTapDown: (x) {
        debugPrint('onTapDown');
      },
      onLongPress: () async {
        debugPrint('onLongPress');
        postItemController.hoverTrueAt.value = DateTime.now();
        await Future.delayed(const Duration(seconds: 1));
        if (!postItemController.hoverTrueAt.value
            .compareTo(postItemController.hoverFalseAt.value)
            .isNegative) {
          postItemController.showEmotesPicker.value = true;
        }
      },
      onHover: (val) async {
        debugPrint('onHover: $val');
        if (val) {
          postItemController.hoverTrueAt.value = DateTime.now();
          await Future.delayed(const Duration(seconds: 1));
          if (!postItemController.hoverTrueAt.value
              .compareTo(postItemController.hoverFalseAt.value)
              .isNegative) {
            postItemController.showEmotesPicker.value = true;
          }
        } else {
          postItemController.hoverFalseAt.value = DateTime.now();
          await Future.delayed(const Duration(seconds: 3));
          if (postItemController.hoverTrueAt.value
              .compareTo(postItemController.hoverFalseAt.value)
              .isNegative) {
            postItemController.showEmotesPicker.value = false;
          }
        }
      },
      onTap: () {},
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        // like
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController
                .onEmoteTap(PostEmote(code: EmoteCode.like));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/like-48x48-1991059.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        // love
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController
                .onEmoteTap(PostEmote(code: EmoteCode.love));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/love-48x48-1991064.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        // care
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController
                .onEmoteTap(PostEmote(code: EmoteCode.care));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/care-48x48-1991058.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        // haha
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController
                .onEmoteTap(PostEmote(code: EmoteCode.haha));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/haha-48x48-1991060.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        // wow
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController.onEmoteTap(PostEmote(code: EmoteCode.wow));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/wow-48x48-1991062.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        // sad
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController.onEmoteTap(PostEmote(code: EmoteCode.sad));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/sad-48x48-1991063.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
        //angry
        InkWell(
          onTap: () async {
            postItemController.showEmotesPicker.value = false;
            postItemController.hoverFalseAt.value = DateTime.now();
            await postItemController
                .onEmoteTap(PostEmote(code: EmoteCode.angry));
          },
          child: Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/facebook-reactions-emoticons/png-48/angry-48x48-1991061.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _photoNameDate3Dots() {
    return Row(
      children: [
        //  img
        UserAvatar(
          avatarUrl: postItemController.post.value.userByCreatedBy?.avatarUrl,
          lastSeen: postItemController.post.value.userByCreatedBy?.lastSeen,
        ),
        const SizedBox(width: 10.0),
        //  name+rating+date
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name + rating
              Row(children: [
                //  name
                Flexible(
                  child: UserName(
                    name: postItemController.post.value.userByCreatedBy?.name,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 15.0),
                //  rating
                const RatingWidget(),
              ]),
              const SizedBox(height: 5.0),
              //  date + location + edited
              Row(children: [
                Flexible(
                  child: Tooltip(
                    message: stringHelper.dateTimeToStringV4(
                        postItemController.post.value.editedAt ??
                            postItemController.post.value.createdAt),
                    child: Text(
                      stringHelper.dateTimeToStringV1(
                          postItemController.post.value.editedAt ??
                              postItemController.post.value.createdAt),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                // address
                if (postItemController.post.value.postAddress != null)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Tooltip(
                        message: stringHelper.addressToStringV3(
                            postAddress:
                                postItemController.post.value.postAddress),
                        child: Text(
                          '${AppLocalizations.of(Get.context!).atPlace} ${stringHelper.addressToStringV1(postAddress: postItemController.post.value.postAddress)}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                // edited?
                if (postItemController.post.value.editedAt != null)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                        child: Tooltip(
                          message: stringHelper.dateTimeToStringV4(
                              postItemController.post.value.editedAt),
                          child: const Text(
                            'edited',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ]),
            ],
          ),
        ),
        // 3 dots
        _actions(),
      ],
    );
  }

  Widget _postContent() {
    if (postItemController.post.value.text.isEmpty &&
        (postItemController.post.value.postAttachments?.nodes.isEmpty ??
            false)) {
      return const SizedBox();
    }
    return Column(children: [
      //  text
      Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(postItemController.post.value.text,
                style: const TextStyle(fontSize: 16.0)),
          ),
        ),
      ]),
      //  attachments
      PostAttachmentsWidget(
          attachments: postItemController.post.value.postAttachments),
    ]);
  }

  Widget _shipmentContent() {
    if (postItemController.shipment.value.id == 0) {
      return const SizedBox();
    }
    if (postItemController.shipment.value.deletedAt != null) {
      return Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Text('Shipment deleted'));
    }
    return Column(children: [
      const Divider(
        thickness: .5,
        color: Colors.grey,
        indent: 100,
        endIndent: 100,
      ),
      Row(children: [
        const Expanded(child: Text('+ Tìm Shipper:')),
        _shipmentActions(),
      ]),
      _shipmentAddressFrom(),
      _shipmentAddressTo(),
      _shipmentPrice(),
      _shipmentNotes(),
      _shipmentPhone(),
      _shipmentAttachments(),
      const Divider(thickness: 1),
      Obx(() => _shipmentOffers()),
    ]);
  }

  Widget _commentsContent() {
    if (postItemController.isShowComments.value == false) {
      return const SizedBox();
    }
    return Column(children: [
      const Divider(thickness: 1.5),
      _postComments(),
    ]);
  }

  Widget _shipmentAddressFrom() {
    String address = '';
    var details =
        postItemController.post.value.shipment?.shipmentAddressFrom?.details ??
            '';
    var street =
        postItemController.post.value.shipment?.shipmentAddressFrom?.street ??
            '';
    var district =
        postItemController.post.value.shipment?.shipmentAddressFrom?.district ??
            '';
    var city =
        postItemController.post.value.shipment?.shipmentAddressFrom?.city ?? '';
    if (details.isNotEmpty) {
      address = details;
    } else {
      if (street.isNotEmpty) {
        address += '$street, ';
      }
      if (district.isNotEmpty) {
        address += '$district, ';
      }
      if (city.isNotEmpty) {
        address += '$city.';
      }
    }
    return Row(children: [Expanded(child: Text('AddressFrom: $address'))]);
  }

  Widget _shipmentAddressTo() {
    var address = '';
    var details =
        postItemController.post.value.shipment?.shipmentAddressTo?.details ??
            '';
    var street =
        postItemController.post.value.shipment?.shipmentAddressTo?.street ?? '';
    var district =
        postItemController.post.value.shipment?.shipmentAddressTo?.district ??
            '';
    var city =
        postItemController.post.value.shipment?.shipmentAddressTo?.city ?? '';
    if (details.isNotEmpty) {
      address = details;
    } else {
      if (street.isNotEmpty) {
        address += '$street, ';
      }
      if (district.isNotEmpty) {
        address += '$district, ';
      }
      if (city.isNotEmpty) {
        address += '$city.';
      }
    }
    return Row(children: [Expanded(child: Text('AddressTo: $address'))]);
  }

  Widget _shipmentNotes() {
    if (postItemController.post.value.shipment?.notes.isEmpty ?? true) {
      return const SizedBox();
    }
    return Row(children: [
      Expanded(
          child:
              Text('Notes: ${postItemController.post.value.shipment!.notes}'))
    ]);
  }

  Widget _shipmentPhone() {
    return Row(children: [
      Expanded(
          child:
              Text('Phone: ${postItemController.post.value.shipment!.phone}'))
    ]);
  }

  Widget _shipmentPrice() {
    return Row(children: [
      Expanded(
          child:
              Text('Price: ${postItemController.post.value.shipment?.cod} vnđ'))
    ]);
  }

  Widget _shipmentAttachments() {
    if (postItemController
            .post.value.shipment?.shipmentAttachments?.nodes.isEmpty ??
        true) {
      return const SizedBox();
    }
    return Row(
      children: [
        Expanded(
          child: ShipmentAttachmentsWidget(
              attachments:
                  postItemController.post.value.shipment!.shipmentAttachments!),
        ),
      ],
    );
  }

  Widget _shipmentOffers() {
    var items = postItemController.shipmentOffers.value.nodes;
    if (postItemController.cbCreatedByMe.value) {
      items = items
          .where((element) =>
              element.createdBy == postItemController.currentUser.id)
          .toList();
    }
    if (postItemController.cbAcceptedAt.value) {
      items = items.where((element) => element.acceptedAt != null).toList();
    }
    if (postItemController.cbRejectedAt.value) {
      items = items
          .where((element) =>
              element.rejectedAt != null && element.acceptedAt == null)
          .toList();
    }
    if (postItemController.cbAcceptedAtRejectedAtNull.value) {
      items = items
          .where((element) =>
              element.acceptedAt == null && element.rejectedAt == null)
          .toList();
    }
    final search = postItemController.searchOfferTEC.value.text.toLowerCase();
    if (search.isNotEmpty) {
      items = items
          .where((element) =>
              element.price.toString().contains(search) ||
              element.notes.toLowerCase().contains(search) ||
              (element.userByCreatedBy?.uid.toLowerCase().contains(search) ??
                  false) ||
              (element.userByCreatedBy?.name.toLowerCase().contains(search) ??
                  false))
          .toList();
    }

    return Column(children: [
      _searchOfferRow(),
      const SizedBox(height: 5),
      // list offers
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height / 4),
        child: ListView(
          shrinkWrap: true,
          children: [
            //for (var i = 0; i < 5; i++)
            ...items.map((e) => ShipmentOfferItem(
                  e,
                  initialShipment: postItemController.shipment.value,
                  onUpdateCallBack: (shipmentOffer) {
                    postItemController.sortShipmentOffers();
                  },
                  onDeleteCallBack: () {
                    postItemController.shipmentOffers.update((val) {
                      val?.nodes.remove(e);
                      val?.totalCount--;
                    });
                  },
                  onRefetchCallBack: () async {
                    await postItemController.fetchShipmentById();
                    if (postItemController.shipment.value.shipmentOffers !=
                        null) {
                      postItemController.shipmentOffers.value =
                          postItemController.shipment.value.shipmentOffers!;
                    }
                    postItemController.sortShipmentOffers();
                  },
                )),
          ],
        ),
      ),
      // buttons // acceptedOffer
      postItemController.shipment.value.acceptedOffer != null
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Winner:'),
              ShipmentOfferItem(
                postItemController.shipment.value.acceptedOffer!,
              ),
            ])
          : postItemController.currentUser.role == AccountRole.roleShipper
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Expanded(
                        child: TextButton(
                          onPressed: postItemController.onOfferTap,
                          child: const Text('Offer'),
                        ),
                      ),
                    ])
              : const SizedBox(),

      const Divider(thickness: 1.5),
    ]);
  }

  Widget _likeCommentShareRow() {
    return Row(
      children: [
        const SizedBox(width: 10),
        //  like button
        Expanded(child: _btnLike()),
        //  comment button
        Expanded(
          child: TextButton.icon(
            onPressed: postItemController.onCommentTap,
            icon: Icon(Icons.comment,
                color: Theme.of(Get.context!).textTheme.button?.color),
            label: Text(AppLocalizations.of(Get.context!).commentCap,
                style: Theme.of(Get.context!).textTheme.button),
          ),
        ),
        //  share button
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              var uid = '';
              if (postItemController
                      .post.value.userByCreatedBy?.uid.isNotEmpty ??
                  false) {
                uid = postItemController.post.value.userByCreatedBy!.uid;
              } else {
                uid = postItemController.post.value.createdBy;
              }
              final message = 'uid: $uid';
              Clipboard.setData(ClipboardData(text: uid));
              Get.showSnackbar(GetSnackBar(
                title: 'Copied',
                message: message,
                duration: const Duration(seconds: 1),
              ));
            },
            icon: Icon(Icons.share,
                color: Theme.of(Get.context!).textTheme.button?.color),
            label: Text(AppLocalizations.of(Get.context!).copyCap,
                style: Theme.of(Get.context!).textTheme.button),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _btnLike() {
    final myEmote = postItemController.emotesByCurrentUserId.value;
    return TextButton.icon(
      onLongPress: () async {
        debugPrint('onLongPress');
        postItemController.hoverTrueAt.value = DateTime.now();
        await Future.delayed(const Duration(seconds: 1));
        if (!postItemController.hoverTrueAt.value
            .compareTo(postItemController.hoverFalseAt.value)
            .isNegative) {
          postItemController.showEmotesPicker.value = true;
        }
      },
      onHover: (val) async {
        debugPrint('onHover: $val');
        if (val) {
          postItemController.hoverTrueAt.value = DateTime.now();
          await Future.delayed(const Duration(seconds: 1));
          if (!postItemController.hoverTrueAt.value
              .compareTo(postItemController.hoverFalseAt.value)
              .isNegative) {
            postItemController.showEmotesPicker.value = true;
          }
        } else {
          postItemController.hoverFalseAt.value = DateTime.now();
          await Future.delayed(const Duration(seconds: 3));
          if (postItemController.hoverTrueAt.value
              .compareTo(postItemController.hoverFalseAt.value)
              .isNegative) {
            postItemController.showEmotesPicker.value = false;
          }
        }
      },
      onPressed: () async => await postItemController.onLikeTap(),
      icon: myEmote?.code == EmoteCode.like
          ? SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                'assets/images/facebook-reactions-emoticons/png-24/like-24x24-1991059.png',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.thumb_up),
              ),
            )
          : myEmote?.code == EmoteCode.love
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset(
                    'assets/images/facebook-reactions-emoticons/png-24/love-24x24-1991064.png',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.thumb_up),
                  ),
                )
              : myEmote?.code == EmoteCode.care
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        'assets/images/facebook-reactions-emoticons/png-24/care-24x24-1991058.png',
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.thumb_up),
                      ),
                    )
                  : myEmote?.code == EmoteCode.haha
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'assets/images/facebook-reactions-emoticons/png-24/haha-24x24-1991060.png',
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.thumb_up),
                          ),
                        )
                      : myEmote?.code == EmoteCode.wow
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                'assets/images/facebook-reactions-emoticons/png-24/wow-24x24-1991062.png',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.thumb_up),
                              ),
                            )
                          : myEmote?.code == EmoteCode.sad
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    'assets/images/facebook-reactions-emoticons/png-24/sad-24x24-1991063.png',
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.thumb_up),
                                  ),
                                )
                              : myEmote?.code == EmoteCode.angry
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        'assets/images/facebook-reactions-emoticons/png-24/angry-24x24-1991061.png',
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.thumb_up),
                                      ),
                                    )
                                  : Icon(Icons.thumb_up_alt_outlined,
                                      color: Theme.of(Get.context!)
                                          .textTheme
                                          .button
                                          ?.color),
      label: myEmote?.code == EmoteCode.like
          ? Text(AppLocalizations.of(Get.context!).likeCap,
              style: const TextStyle(color: Colors.blue))
          : myEmote?.code == EmoteCode.love
              ? Text(AppLocalizations.of(Get.context!).loveCap,
                  style: const TextStyle(color: Colors.red))
              : myEmote?.code == EmoteCode.care
                  ? Text(AppLocalizations.of(Get.context!).careCap,
                      style: const TextStyle(color: Colors.yellow))
                  : myEmote?.code == EmoteCode.haha
                      ? Text(AppLocalizations.of(Get.context!).hahaCap,
                          style: const TextStyle(color: Colors.yellow))
                      : myEmote?.code == EmoteCode.wow
                          ? Text(AppLocalizations.of(Get.context!).wowCap,
                              style: const TextStyle(color: Colors.yellow))
                          : myEmote?.code == EmoteCode.sad
                              ? Text(AppLocalizations.of(Get.context!).sadCap,
                                  style: const TextStyle(color: Colors.yellow))
                              : myEmote?.code == EmoteCode.angry
                                  ? Text(
                                      AppLocalizations.of(Get.context!)
                                          .angryCap,
                                      style:
                                          const TextStyle(color: Colors.orange))
                                  : Text(
                                      AppLocalizations.of(Get.context!).likeCap,
                                      style: Theme.of(Get.context!)
                                          .textTheme
                                          .button),
    );
  }

  Widget _emoteCommentCounts(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // emote count
      Flexible(child: Obx(() => _postEmotesCount(context))),
      // comment count
      Flexible(child: _postCommentsCount(context)),
    ]);
  }

  Widget _postEmotesCount(BuildContext context) {
    final like = postItemController.likeTotalCount.value;
    final love = postItemController.loveTotalCount.value;
    final care = postItemController.careTotalCount.value;
    final wow = postItemController.wowTotalCount.value;
    final haha = postItemController.hahaTotalCount.value;
    final sad = postItemController.sadTotalCount.value;
    final angry = postItemController.angryTotalCount.value;
    final totalCount = like + love + care + wow + haha + sad + angry;
    var emotes = [
      {'like': like},
      {'love': love},
      {'care': care},
      {'wow': wow},
      {'haha': haha},
      {'sad': sad},
      {'angry': angry}
    ];
    if (1 == 2) {
      debugPrint('emotes: $emotes');
      debugPrint('likeNameItems: ${postItemController.likeNameItems}');
      debugPrint('loveNameItems: ${postItemController.loveNameItems}');
      debugPrint('careNameItems: ${postItemController.careNameItems}');
      debugPrint('hahaNameItems: ${postItemController.hahaNameItems}');
      debugPrint('wowNameItems: ${postItemController.wowNameItems}');
      debugPrint('sadNameItems: ${postItemController.sadNameItems}');
      debugPrint('angryNameItems: ${postItemController.angryNameItems}');
    }
    if (totalCount < 1) {
      return const SizedBox();
    }
    // remove 0 values
    emotes.removeWhere((e) => e.values.first == 0);
    emotes.sort((a, b) => b[b.keys.first]!.compareTo(a[a.keys.first]!));
    var postEmoteLabel = '';
    // set postEmoteLabel
    if (totalCount > 0) {
      int flag = 0;
      if (like > 0) {
        flag++;
        if (like == 1) {
          postEmoteLabel = postItemController.likeNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).like}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).likes}';
        }
      }
      if (love > 0) {
        flag++;
        if (love == 1) {
          postEmoteLabel = postItemController.loveNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).love}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).loves}';
        }
      }
      if (care > 0) {
        flag++;
        if (care == 1) {
          postEmoteLabel = postItemController.careNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).care}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).cares}';
        }
      }
      if (haha > 0) {
        flag++;
        if (haha == 1) {
          postEmoteLabel = postItemController.hahaNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).haha}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).hahas}';
        }
      }
      if (wow > 0) {
        flag++;
        if (wow == 1) {
          postEmoteLabel = postItemController.wowNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).wow}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).wows}';
        }
      }
      if (sad > 0) {
        flag++;
        if (sad == 1) {
          postEmoteLabel = postItemController.sadNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).sad}';
        } else {
          postEmoteLabel = '$totalCount ${AppLocalizations.of(context).sads}';
        }
      }
      if (angry > 0) {
        flag++;
        if (angry == 1) {
          postEmoteLabel = postItemController.angryNameItems
                  .firstWhereOrNull((element) => true)
                  ?.data ??
              '1 ${AppLocalizations.of(context).angry}';
        } else {
          postEmoteLabel =
              '$totalCount ${AppLocalizations.of(context).angries}';
        }
      }
      if (flag > 1) {
        postEmoteLabel = '$totalCount';
      }
    }

    return TextButton.icon(
      onPressed: () {},
      icon: Row(children: [
        ...emotes.map((e) {
          WidgetSpan richMessage = const WidgetSpan(child: SizedBox());
          Widget child = const SizedBox();
          if (e.keys.first == EmoteCode.like) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).likeCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.likeNameItems[index];
                      },
                      itemCount: postItemController.likeNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/like-16x16-1991059.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.love) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).loveCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.loveNameItems[index];
                      },
                      itemCount: postItemController.loveNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/love-16x16-1991064.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.care) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).careCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.careNameItems[index];
                      },
                      itemCount: postItemController.careNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/care-16x16-1991058.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.haha) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).hahaCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.hahaNameItems[index];
                      },
                      itemCount: postItemController.hahaNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/haha-16x16-1991060.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.wow) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).wowCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.wowNameItems[index];
                      },
                      itemCount: postItemController.wowNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/wow-16x16-1991062.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.sad) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).sadCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.sadNameItems[index];
                      },
                      itemCount: postItemController.sadNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/sad-16x16-1991063.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          } else if (e.keys.first == EmoteCode.angry) {
            richMessage = WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(
                width: Get.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(Get.context!).angryCap,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return postItemController.angryNameItems[index];
                      },
                      itemCount: postItemController.angryNameItems.length,
                    ),
                  ],
                ),
              ),
            );
            child = Image.asset(
              'assets/images/facebook-reactions-emoticons/png-16/angry-16x16-1991061.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.thumb_up),
            );
          }
          return Tooltip(
            richMessage: richMessage,
            child: child,
          );
        }),
      ]),
      label: Text(postEmoteLabel),
    );
  }

  Widget _postCommentsCount(BuildContext context) {
    final postCommentsTotalCount =
        postItemController.initialPost.postComments?.totalCount ?? 0;
    if (postCommentsTotalCount == 0) {
      return const SizedBox();
    }
    var label = '';
    if (postCommentsTotalCount == 1) {
      label = '$postCommentsTotalCount ${AppLocalizations.of(context).comment}';
    } else {
      label =
          '$postCommentsTotalCount ${AppLocalizations.of(context).comments}';
    }
    return Text(label);
  }

  Widget _postComments() {
    switch (postItemController.commentsOrderBy.value) {
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
                onPressed: postItemController.showFilters,
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Tất cả bình luận '),
                  Icon(Icons.arrow_drop_down_outlined),
                ]),
              ),
            ]),
            // list comments with filter
            _listCommentsWithFilter(),
            // input row
            _commentInputRow(),
          ],
        );
      case CommentsOrderBy.idDesc:
        return Column(
          children: [
            // Gần đây nhất ▼
            Row(children: [
              const Spacer(),
              TextButton(
                onPressed: postItemController.showFilters,
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Gần đây nhất'),
                  Icon(Icons.arrow_drop_down_outlined),
                ]),
              ),
            ]),
            // input row
            _commentInputRow(),
            // list comments with filter
            _listCommentsWithFilter(),
            // Xem thêm bình luận/Xem thêm 6 bình luận - 3/28
            _viewMoreCommentsWidget(),
            // Ai đó đang nhập bình luận...
            if (1 == 2)
              Row(children: const [
                Text('··· Ai đó đang nhập bình luận...'),
                Spacer(),
              ]),
            // Viết bình luận...
            Row(children: [
              TextButton(
                  onPressed: () => postItemController.commentFC.requestFocus(),
                  child: const Text('Viết bình luận...')),
              const Spacer(),
            ]),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _listCommentsWithFilter() {
    if (postItemController.postCommentItems.isEmpty) {
      return const SizedBox();
    }

    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          reverse:
              postItemController.commentsOrderBy.value == CommentsOrderBy.idAsc,
          itemBuilder: (context, index) {
            return postItemController.postCommentItems[index];
          },
          itemCount: postItemController.postCommentItems.length,
        ));
  }

  Widget _viewMoreCommentsWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      postItemController.postCommentItems.length !=
              postItemController.postCommentsTotalCount.value
          ? TextButton(
              onPressed: () {
                postItemController
                    .fetchPostCommentsByPostIdFirstAfterCurrentUserId();
              },
              child: const Text('Xem thêm bình luận'),
            )
          : const SizedBox(),
      Text(
          '${postItemController.postCommentItems.length}/${postItemController.postCommentsTotalCount.value}'),
    ]);
  }

  Widget _commentInputRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          // UserAvatar
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
            child: UserAvatar(
              avatarUrl: postItemController.currentUser.avatarUrl,
              lastSeen: postItemController.post.value.userByCreatedBy?.lastSeen,
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
                  await postItemController.onCommentSendTap();
                }
              },
              child: TextField(
                focusNode: postItemController.commentFC,
                controller: postItemController.commentTEC,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 15, right: 0, bottom: 15),
                  hintText: 'Viết bình luận công khai',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: 1 == 2
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(
                            Icons.tag_faces_outlined,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.24),
                          ),
                          const SizedBox(width: 5.0),
                          Icon(
                            Icons.photo_camera_outlined,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.24),
                          ),
                          const SizedBox(width: 5.0),
                          Icon(
                            Icons.attach_file,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.24),
                          ),
                          const SizedBox(width: 5.0),
                        ])
                      : null,
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
            onPressed: postItemController.onCommentSendTap,
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _searchOfferRow() {
    return Row(
      children: [
        const Text('+ Offers: '),
        // searchTF
        Expanded(
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              // phim enter => send
              if (event.runtimeType == RawKeyDownEvent &&
                  (event.logicalKey.keyId == 4294967309) &&
                  (!event.isShiftPressed)) {
                postItemController.onOfferSearchTap();
              }
            },
            child: TextField(
              controller: postItemController.searchOfferTEC,
              minLines: 1,
              maxLines: 1,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 35),
                contentPadding: const EdgeInsets.only(
                    left: 10.0, top: 10, right: 0, bottom: 10),
                hintText: 'Tìm kiếm',
                filled: true,
                fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    // send button => send
                    onPressed: postItemController.onOfferSearchTap,
                  ),
                ]),
              ),
            ),
          ),
        ),
        // filter
        IconButton(
          onPressed: () {
            Get.dialog(SimpleDialog(
              title: const Text('Lọc'),
              children: [
                // cbCreatedByMe
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        postItemController.cbCreatedByMe.value =
                            !postItemController.cbCreatedByMe.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: postItemController.cbCreatedByMe.value,
                              onChanged: null)),
                        ),
                        const Text('Của tôi'),
                      ]),
                    ),
                  ),
                ]),
                // cbAcceptedAt
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        postItemController.cbAcceptedAt.value =
                            !postItemController.cbAcceptedAt.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: postItemController.cbAcceptedAt.value,
                              onChanged: null)),
                        ),
                        const Text('Accepted'),
                      ]),
                    ),
                  ),
                ]),
                // cbRejectedAt
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        postItemController.cbRejectedAt.value =
                            !postItemController.cbRejectedAt.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: postItemController.cbRejectedAt.value,
                              onChanged: null)),
                        ),
                        const Text('Rejected'),
                      ]),
                    ),
                  ),
                ]),
                // cbAcceptedAtRejectedAtNull
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        postItemController.cbAcceptedAtRejectedAtNull.value =
                            !postItemController
                                .cbAcceptedAtRejectedAtNull.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: postItemController
                                  .cbAcceptedAtRejectedAtNull.value,
                              onChanged: null)),
                        ),
                        const Text('Not decided'),
                      ]),
                    ),
                  ),
                ]),
              ],
            ));
          },
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
        ),
        // sort
        PopupMenuButton<ShipmentOffersOrderBy>(
          tooltip: 'Xếp theo',
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
          onSelected: (selected) {
            postItemController.shipmentOffersOrderBy.value = selected;
            postItemController.sortShipmentOffers();
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.oldest,
                child: Text('Cũ nhất',
                    style: TextStyle(
                        color: postItemController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.oldest
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.newest,
                child: Text('Mới nhất',
                    style: TextStyle(
                        color: postItemController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.newest
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.priceDesc,
                child: Text('Giá cao nhất',
                    style: TextStyle(
                        color: postItemController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.priceDesc
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.priceAsc,
                child: Text('Giá thấp nhất',
                    style: TextStyle(
                        color: postItemController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.priceAsc
                            ? Colors.red
                            : Colors.blue)),
              ),
            ];
          },
        ),
      ],
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
        if (selected == 'view') {
          postItemController.onPostViewTap();
        }
        if (selected == 'report') {
          postItemController.onPostReportTap();
        }
        if (selected == 'edit') {
          postItemController.onPostEditTap();
        }
        if (selected == 'delete') {
          postItemController.onPostDeleteTap();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'view',
            child: Text('View'),
          ),
          if (postItemController.post.value.createdBy !=
              postItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'report',
              child: Text('Report'),
            ),
          if (postItemController.post.value.createdBy ==
              postItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
          if (postItemController.post.value.createdBy ==
              postItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
        ];
      },
    );
  }

  Widget _shipmentActions() {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'view') {
          postItemController.onShipmentViewTap();
        }
        if (selected == 'shipment_screen') {
          Get.to(() => ShipmentScreen(
                postItemController.shipment.value,
                onDeleteCallback: () {
                  postItemController.post.value.deletedAt = DateTime.now();
                },
              ));
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'view',
            child: Text('View'),
          ),
          const PopupMenuItem<String>(
            value: 'shipment_screen',
            child: Text('Go to shipment screen'),
          ),
        ];
      },
    );
  }
}
