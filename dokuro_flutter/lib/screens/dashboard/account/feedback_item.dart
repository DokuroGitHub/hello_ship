import 'package:dokuro_flutter/controllers/feedback_item_controller.dart';
import 'package:dokuro_flutter/models/feedback.dart' as fb;
import 'package:flutter/material.dart';


class FeedbackItem extends StatelessWidget {
  final fb.Feedback initialFeedback;
  final Function(fb.Feedback feedback)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  const FeedbackItem(
    this.initialFeedback, {
    Key? key,
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('FeedbackItem');
    final feedbackItemController = FeedbackItemController(
      initialFeedback,
      onUpdateCallBack: onUpdateCallBack,
      onDeleteCallBack: onDeleteCallBack,
      onRefetchCallBack: onRefetchCallBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedbackItemController.initPlz();
    });

    return const Text('FeedbackItem');
  }
}
