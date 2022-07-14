import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/feedback.dart' as fb;
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackItemController {
  final fb.Feedback initialFeedback;
  final Function(fb.Feedback feedback)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  FeedbackItemController(
    this.initialFeedback, {
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  });

  //final _client = Get.find<PostgraphileService>().client;
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final FocusNode offerPriceFC = FocusNode();
  final FocusNode offerNotesFC = FocusNode();

  Rx<TextEditingController> offerPriceTEC = TextEditingController().obs;
  Rx<TextEditingController> offerNotesTEC = TextEditingController().obs;
  Rx<Status> status = Status.ready.obs;

  initPlz() {
    debugPrint('FeedbackItemController, id: ${initialFeedback.id}');

    ever(status, (_) {
      debugPrint('status: $status');
    });
  }

  disposePlz() {
    debugPrint('ShipmentOfferItemController dispose');
    offerPriceFC.dispose();
    offerNotesFC.dispose();
    offerPriceTEC.update((val) {
      val?.dispose();
    });
    offerNotesTEC.update((val) {
      val?.dispose();
    });
  }
}
