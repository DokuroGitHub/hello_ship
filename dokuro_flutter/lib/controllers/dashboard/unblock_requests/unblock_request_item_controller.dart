import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnblockRequestItemController {
  final UnblockRequest initialUnblockRequest;
  final Key? initialKey;

  UnblockRequestItemController(
    this.initialUnblockRequest, {
    this.initialKey,
  });

  // reportedUser
  Rx<UnblockRequest> unblockRequest = UnblockRequest().obs;

  void initPlz() {
    unblockRequest.value = initialUnblockRequest;
  }


}
