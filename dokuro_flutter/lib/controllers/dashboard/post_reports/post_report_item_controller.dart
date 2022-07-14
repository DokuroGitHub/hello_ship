import 'package:dokuro_flutter/models/reported_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportedUserItemController {
  final ReportedUser initialReportedUser;
  final Key? initialKey;

  ReportedUserItemController(
    this.initialReportedUser, {
    this.initialKey,
  });

  // reportedUser
  Rx<ReportedUser> reportedUser = ReportedUser().obs;

  void initPlz() {
    reportedUser.value = initialReportedUser;
  }
}
