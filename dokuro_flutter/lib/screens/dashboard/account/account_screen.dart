import 'package:dokuro_flutter/constants/strings.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/account_role.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/notification_service.dart';
import 'package:dokuro_flutter/screens/dashboard/account/feedback_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/locale/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/controllers/dashboard/account/account_controller.dart';
import 'package:dokuro_flutter/services/theme/theme_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  final User? initialUser;
  const AccountScreen({Key? key, this.initialUser}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final accountController = AccountController(widget.initialUser);

  @override
  void initState() {
    accountController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    accountController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(),
      body: Obx(
        () => SingleChildScrollView(
          controller: accountController.scrollController,
          reverse: false,
          child: Column(
            children: [
              _coverAvatar(),
              const SizedBox(height: 10),
              _editBtn(),
              const SizedBox(height: 10),
              _address(),
              const SizedBox(height: 10),
              _birthDate(),
              const SizedBox(height: 10),
              _createdAt(),
              const SizedBox(height: 10),
              _email(),
              const SizedBox(height: 10),
              _lastSeen(),
              const SizedBox(height: 10),
              _blockedUntil(),
              const SizedBox(height: 10),
              _name(),
              const SizedBox(height: 10),
              _phoneNumber(),
              const SizedBox(height: 10),
              _role(),
              const SizedBox(height: 10),
              _bios(),
              const SizedBox(height: 10),
              _shipperInfo(),
              const SizedBox(height: 10),
              _feedback(),
              const SizedBox(height: 10),
              _postsFilter(),
              const SizedBox(height: 10),
              _posts(),
              Obx(() => _more()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(Strings.accountPage),
      actions: [
        if (accountController.user.value.role == AccountRole.roleAdmin)
          IconButton(
              onPressed: () {
                Get.to(() => const TestScreen());
              },
              icon: const Icon(Icons.nature_outlined)),
        if (accountController.user.value.id ==
            accountController.currentUser.id) ...[
          // switchTheme
          Tooltip(
            message: 'Giao diện sáng/tối',
            child: IconButton(
              icon: const Icon(Icons.lightbulb),
              color: Colors.grey,
              onPressed: themeService.switchTheme,
            ),
          ),
          // changeLocale
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onSelected: localeService.changeLocale,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'vi',
                  child: Text('Tiếng Việt',
                      style: TextStyle(
                          color: LocaleService().languageCode == 'vi'
                              ? Colors.red
                              : Colors.blue)),
                ),
                PopupMenuItem<String>(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: LocaleService().languageCode == 'en'
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
                if (1 == 2)
                  PopupMenuItem<String>(
                    value: 'es',
                    child: Text(
                      'Espanol',
                      style: TextStyle(
                        color: LocaleService().languageCode == 'es'
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ),
              ];
            },
          ),
          const SizedBox(width: 10),
          // confirmSignOut
          Flexible(
            child: TextButton(
              clipBehavior: Clip.antiAlias,
              onPressed: accountController.confirmSignOut,
              child: Text(
                AppLocalizations.of(Get.context!).logout,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
      bottom:
          accountController.user.value.id != accountController.currentUser.id
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(0.0),
                  child: _callSMSChat(),
                )
              : null,
    );
  }

  Widget _callSMSChat() {
    if (accountController.user.value.id == accountController.currentUser.id) {
      //return const SizedBox();
    }
    return Row(children: [
      Expanded(
        child: Row(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call),
              label: const Text('Gọi điện'),
            ),
          ),
        ]),
      ),
      Expanded(
        child: Row(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sms),
              label: const Text('Gửi SMS'),
            ),
          ),
        ]),
      ),
      Expanded(
        child: Row(children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat),
              label: const Text('Chat'),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _editBtn() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(children: const []),
      TextButton.icon(
        onPressed: accountController.onUserEditTap,
        icon: const Icon(Icons.edit),
        label: Text(AppLocalizations.of(Get.context!).editProfileCap),
      ),
    ]);
  }

  Widget _coverAvatar() {
    return Stack(children: [
      Column(children: [
        Row(children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.width * .4 > Get.height * .5
                    ? Get.height * .5
                    : Get.width * .4,
              ),
              child: Obx(() => Image(
                    image: NetworkImage(
                      accountController.user.value.coverUrl,
                    ),
                    errorBuilder: (_, __, ___) =>
                        Image.asset('assets/images/welcome_image.png'),
                  )),
            ),
          ),
        ]),
        const SizedBox(height: 45),
        Row(),
      ]),
      Positioned(
        left: 10,
        bottom: 0,
        child: Row(children: [
          UserAvatar(
            avatarUrl: accountController.user.value.avatarUrl,
            lastSeen: accountController.user.value.lastSeen,
          ),
          const SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            UserName(name: accountController.user.value.name),
            Text('uid: ${accountController.user.value.uid}'),
          ]),
        ]),
      ),
    ]);
  }

  Widget _address() {
    if (accountController.user.value.userAddress == null) {
      return const SizedBox();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(AppLocalizations.of(Get.context!).addressCap),
      ),
      const SizedBox(height: 5),
      Row(children: [
        const SizedBox(width: 20),
        const Icon(Icons.location_pin),
        const SizedBox(width: 10),
        Expanded(
          child: Text(stringHelper
              .addressToStringV3(
                  userAddress: accountController.user.value.userAddress)
              .replaceAll(',,', ',')),
        ),
      ]),
    ]);
  }

  Widget _birthDate() {
    if (accountController.user.value.birthdate == null) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
            '${AppLocalizations.of(Get.context!).birthdateCap}: ${stringHelper.dateTimeToStringV2(accountController.user.value.birthdate)}'),
      ),
    ]);
  }

  Widget _createdAt() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
            '${AppLocalizations.of(Get.context!).joinedSinceCap}: ${stringHelper.dateTimeToStringV5(accountController.user.value.createdAt)}'),
      ),
    ]);
  }

  Widget _email() {
    if (accountController.user.value.email.isEmpty) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.mail_outline_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              '${AppLocalizations.of(Get.context!).emailCap}: ${accountController.user.value.email}')),
    ]);
  }

  Widget _lastSeen() {
    if (accountController.user.value.lastSeen
            ?.compareTo(DateTime.now().subtract(const Duration(seconds: 30)))
            .isGreaterThan(0) ??
        false) {
      return Row(children: [
        const SizedBox(width: 10),
        const Icon(Icons.online_prediction_outlined),
        const SizedBox(width: 10),
        Flexible(
            child: Text(
                '${AppLocalizations.of(Get.context!).onlineCap}: ${AppLocalizations.of(Get.context!).online}')),
      ]);
    }
    String text =
        '${AppLocalizations.of(Get.context!).onlineCap}: ${stringHelper.dateTimeToDurationString(accountController.user.value.lastSeen)}';
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.online_prediction_outlined),
      const SizedBox(width: 10),
      Flexible(child: Text(text)),
    ]);
  }

  Widget _blockedUntil() {
    if (accountController.user.value.blockedUntil != null) {
      return Row(children: [
        const SizedBox(width: 10),
        const Icon(Icons.block_outlined),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
              '${AppLocalizations.of(Get.context!).blockCap}: ${AppLocalizations.of(Get.context!).block} ${stringHelper.dateTimeToStringV5(accountController.user.value.blockedUntil)}'),
        ),
      ]);
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.block_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              '${AppLocalizations.of(Get.context!).blockCap}: ${AppLocalizations.of(Get.context!).blockNot}')),
    ]);
  }

  Widget _name() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.tag_faces_outlined),
      const SizedBox(width: 10),
      Flexible(
          child: Text(
              '${AppLocalizations.of(Get.context!).nameCap}: ${accountController.user.value.name}')),
    ]);
  }

  Widget _phoneNumber() {
    return Flex(direction: Axis.horizontal, children: [
      const SizedBox(width: 10),
      const Icon(Icons.phone),
      const SizedBox(width: 10),
      Flexible(child: Text('${AppLocalizations.of(Get.context!).phoneCap}: ')),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(accountController.user.value.phone.isNotEmpty
              ? accountController.user.value.phone
              : AppLocalizations.of(Get.context!).phoneNot),
        ),
      ),
    ]);
  }

  Widget _role() {
    String role = '';
    if (accountController.user.value.role == AccountRole.roleAdmin) {
      role = AppLocalizations.of(Get.context!).adminCap;
    } else if (accountController.user.value.role == AccountRole.roleShipper) {
      role = AppLocalizations.of(Get.context!).shipperCap;
    } else if (accountController.user.value.role == AccountRole.roleUser) {
      role = AppLocalizations.of(Get.context!).userCap;
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.people_alt_outlined),
      const SizedBox(width: 10),
      Flexible(child: Text('${AppLocalizations.of(Get.context!).roleCap}: ')),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(role),
        ),
      ),
    ]);
  }

  Widget _bios() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const SizedBox(width: 10),
        const Icon(Icons.event_note_outlined),
        const SizedBox(width: 10),
        Flexible(child: Text('${AppLocalizations.of(Get.context!).biosCap}: ')),
      ]),
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * .6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(accountController.user.value.bios),
        ),
      ),
    ]);
  }

  Widget _shipperInfo() {
    if (accountController.user.value.userShipper == null) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Row(children: const [
            Icon(Icons.local_shipping_outlined),
            SizedBox(width: 10),
            Text('Thông tin shipper: '),
          ]),
          onTap: () {
            accountController.showShipperInfo.value =
                !accountController.showShipperInfo.value;
          },
        ),
        const SizedBox(height: 10),
        accountController.showShipperInfo.value
            ? Container(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.handyman_outlined),
                            const SizedBox(width: 10),
                            const Text('Loại phương tiện: '),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(accountController
                                      .user.value.userShipper?.vehicleType ??
                                  ''),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.event_note_outlined),
                            const SizedBox(width: 10),
                            const Text('Miêu tả: '),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(Get.context!).size.width *
                                          .6),
                              decoration: const BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(
                                  'Miêu tả: ${accountController.user.value.userShipper?.vehicleDescription ?? ''}'),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.loop),
                            const SizedBox(width: 10),
                            const Text('Trạng thái: '),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(accountController
                                      .user.value.userShipper?.status ??
                                  ''),
                            ),
                          ]),
                    ]),
              )
            : Row(children: const [SizedBox(width: 50), Icon(Icons.expand)]),
      ],
    );
  }

  Widget _feedback() {
    if (accountController.user.value.userShipper == null) {
      return const SizedBox();
    }
    return Column(children: [
      Row(children: [
        Text(AppLocalizations.of(Get.context!).rateAndFeedBacks),
        const Spacer(),
        TextButton(
          child: Text(AppLocalizations.of(Get.context!).viewAll),
          onPressed: () {
            //_showFeedBacksPage(context, widget.myUser, widget.myUser2.id!);
          },
        ),
      ]),
      //Summary(feedBacks: feedBacks),
      const SizedBox(height: 10),
      if (accountController.feedbacks.value.nodes.isNotEmpty)
        FeedbackItem(accountController.feedbacks.value.nodes.first),
    ]);
  }

  Widget _postsFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Flexible(
              child: Text(
                'Bài viết',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (1 == 2)
              Flexible(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.view_quilt),
                      Flexible(child: Text('Bộ lọc')),
                      SizedBox(width: 10),
                    ]),
                  ),
                ),
              ),
          ]),
          const Divider(),
        ]),
      ),
    );
  }

  Widget _posts() {
    debugPrint('_posts');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return accountController.postItems[index];
          },
          itemCount: accountController.postItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      accountController.postItems.length !=
              accountController.postsTotalCount.value
          ? TextButton(
              onPressed: () {
                accountController.fetchPostsByUserIdCurrentUserIdFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${accountController.postItems.length}/${accountController.postsTotalCount.value}'),
    ]);
  }
}
