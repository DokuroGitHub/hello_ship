import 'package:dokuro_flutter/controllers/dashboard/posts/posts_controller.dart';
import 'package:dokuro_flutter/models/constants/shipment_service.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/constants/shipment_type.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final postsController = PostsController();

  @override
  void initState() {
    postsController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    postsController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PostsScreen build');
    return Scaffold(
      appBar: _appBar(context),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          if (direction == ScrollDirection.idle) {
          } else if (direction == ScrollDirection.forward) {
            postsController.showFAB.value = true;
          } else if (direction == ScrollDirection.reverse) {
            postsController.showFAB.value = false;
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: postsController.scrollController,
          child: Column(
            children: [
              _postEditor(context),
              _chips(),
              _posts(),
              _more(),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() => _fab()),
    );
  }

  Widget _fab() {
    return postsController.showFAB.value
        ? Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: IconButton(
              onPressed: () {
                if (postsController.scrollController.hasClients) {
                  postsController.scrollController.animateTo(
                    postsController.scrollController.position.minScrollExtent,
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeOut,
                  );
                }
              },
              icon: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.4),
                ),
                child: const Icon(Icons.arrow_upward, size: 30),
              ),
              iconSize: 40,
              tooltip: 'Tap to scroll to top',
            ),
          )
        : const SizedBox();
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        'Bài viết',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
      ],
    );
  }

  Widget _postEditor(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Column(
          children: [
            // avatar + postTextTF
            Row(
              children: [
                // avatar
                SizedBox(
                  height: 40,
                  width: 40,
                  child: UserAvatar(
                    avatarUrl: postsController.currentUser.avatarUrl,
                    lastSeen: postsController.currentUser.lastSeen,
                  ),
                ),
                const SizedBox(width: 10.0),
                // postTextTF
                Expanded(
                  child: GestureDetector(
                    onTap: postsController.onPostCreateTap,
                    child: TextField(
                      controller: postsController.postTextTEC,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 25.0),
                        hintText: "Bạn đang nghĩ gì?",
                        filled: true,
                        enabled: false,
                        fillColor:
                            Theme.of(context).bannerTheme.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            if (1 == 2) const Divider(thickness: 1.5),
            // buttons
            if (1 == 2)
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Color(0xFF58C472),
                      ),
                      label: Text(
                        'Picture',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _chips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              const Text(
                'Tag:',
                style: TextStyle(color: Colors.blue),
              ),
              // chipShipment
              Obx(
                () => GestureDetector(
                  onTap: () {
                    postsController.chipShipment.value =
                        !postsController.chipShipment.value;
                  },
                  child: postsController.chipShipment.value
                      ? const Chip(
                          backgroundColor: Colors.blue,
                          avatar: CircleAvatar(
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          ),
                          label: Text('shipment'),
                        )
                      : const Chip(
                          backgroundColor: Colors.grey,
                          avatar: CircleAvatar(
                            child: Icon(Icons.radio_button_unchecked),
                          ),
                          label: Text('shipment'),
                        ),
                ),
              ),
              // chipTransport
              Obx(
                () => postsController.chipShipment.value
                    ? GestureDetector(
                        onTap: () {
                          postsController.chipTransport.value =
                              !postsController.chipTransport.value;
                          if (postsController.chipDelivery.value) {
                            postsController.chipDelivery.value = false;
                          }
                        },
                        child: postsController.chipTransport.value
                            ? const Chip(
                                backgroundColor: Colors.blue,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                ),
                                label: Text(ShipmentType.transport),
                              )
                            : const Chip(
                                backgroundColor: Colors.grey,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.radio_button_unchecked),
                                ),
                                label: Text(ShipmentType.transport),
                              ),
                      )
                    : const SizedBox(),
              ),
              // chipDelivery
              Obx(
                () => postsController.chipShipment.value
                    ? GestureDetector(
                        onTap: () {
                          postsController.chipDelivery.value =
                              !postsController.chipDelivery.value;
                          if (postsController.chipTransport.value) {
                            postsController.chipTransport.value = false;
                          }
                        },
                        child: postsController.chipDelivery.value
                            ? const Chip(
                                backgroundColor: Colors.blue,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                ),
                                label: Text(ShipmentType.delivery),
                              )
                            : const Chip(
                                backgroundColor: Colors.grey,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.radio_button_unchecked),
                                ),
                                label: Text(ShipmentType.delivery),
                              ),
                      )
                    : const SizedBox(),
              ),
              // chipFinding
              Obx(
                () => postsController.chipShipment.value
                    ? GestureDetector(
                        onTap: () {
                          postsController.chipFinding.value =
                              !postsController.chipFinding.value;
                        },
                        child: postsController.chipFinding.value
                            ? const Chip(
                                backgroundColor: Colors.blue,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                ),
                                label: Text(ShipmentStatus.finding),
                              )
                            : const Chip(
                                backgroundColor: Colors.grey,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.radio_button_unchecked),
                                ),
                                label: Text(ShipmentStatus.finding),
                              ),
                      )
                    : const SizedBox(),
              ),
              // chipSaving
              Obx(
                () => postsController.chipShipment.value
                    ? GestureDetector(
                        onTap: () {
                          postsController.chipSaving.value =
                              !postsController.chipSaving.value;
                          if (postsController.chipFast.value) {
                            postsController.chipFast.value = false;
                          }
                        },
                        child: postsController.chipSaving.value
                            ? const Chip(
                                backgroundColor: Colors.blue,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                ),
                                label: Text(ShipmentService.saving),
                              )
                            : const Chip(
                                backgroundColor: Colors.grey,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.radio_button_unchecked),
                                ),
                                label: Text(ShipmentService.saving),
                              ),
                      )
                    : const SizedBox(),
              ),
              // chipFast
              Obx(
                () => postsController.chipShipment.value
                    ? GestureDetector(
                        onTap: () {
                          postsController.chipFast.value =
                              !postsController.chipFast.value;
                          if (postsController.chipSaving.value) {
                            postsController.chipSaving.value = false;
                          }
                        },
                        child: postsController.chipFast.value
                            ? const Chip(
                                backgroundColor: Colors.blue,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.check_circle_outline,
                                      color: Colors.green),
                                ),
                                label: Text(ShipmentService.fast),
                              )
                            : const Chip(
                                backgroundColor: Colors.grey,
                                avatar: CircleAvatar(
                                  child: Icon(Icons.radio_button_unchecked),
                                ),
                                label: Text(ShipmentService.fast),
                              ),
                      )
                    : const SizedBox(),
              ),
            ]),
          ),
        ),
        IconButton(
          onPressed: () {
            postsController.reset();
            postsController
                .fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
          },
          tooltip: 'Search',
          icon: const Icon(
            Icons.search,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _posts() {
    debugPrint('_posts');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return postsController.postItems[index];
          },
          itemCount: postsController.postItems.length,
        ));
  }

  Widget _more() {
    return Obx(
        () => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              postsController.postItems.length !=
                      postsController.postsTotalCount.value
                  ? TextButton(
                      onPressed: () {
                        postsController
                            .fetchPostsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter();
                      },
                      child: const Text('Xem thêm'),
                    )
                  : const SizedBox(),
              Text(
                  '${postsController.postItems.length}/${postsController.postsTotalCount.value}'),
            ]));
  }
}
