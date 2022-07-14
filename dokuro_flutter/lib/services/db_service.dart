import 'dart:io';

import 'package:dokuro_flutter/config.dart';
import 'package:dokuro_flutter/data/conversation_query.dart';
import 'package:dokuro_flutter/data/post_query.dart';
import 'package:dokuro_flutter/data/shipment_query.dart';
import 'package:dokuro_flutter/data/user_query.dart';
import 'package:dokuro_flutter/models/comment_emote.dart';
import 'package:dokuro_flutter/models/constants/participant_role.dart';
import 'package:dokuro_flutter/models/constants/report_status.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/models/message.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/participant.dart';
import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:dokuro_flutter/models/post_emote.dart';
import 'package:dokuro_flutter/models/reported_user.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_address_from.dart';
import 'package:dokuro_flutter/models/shipment_address_to.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/models/user_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class DbService extends GetxService {
  GraphQLClient? client;
  Future<DbService> initPlz([String? token]) async {
    debugPrint('$runtimeType delays 2 sec');
    //await 2.delay();
    resetClient(token);
    debugPrint('$runtimeType ready!');
    return this;
  }

  void resetClient([String? token]) {
    if (token == null) {
      client = null;
      return;
    }
    final HttpLink httpLink = HttpLink(
      'http://$serverDomain:$portHttp/graphql',
      defaultHeaders: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final WebSocketLink websocketLink = WebSocketLink(
      "ws://$serverDomain/graphql",
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        headers: {
          "Authorization": "Bearer $token",
          "Sec-WebSocket-Protocol": "graphql-ws",
        },
        initialPayload: "",
      ),
    );
    final Link link = Link.split(
        (request) => request.isSubscription, websocketLink, httpLink);

    client = GraphQLClient(cache: GraphQLCache(), link: link);
  }

  //// Users

  Future<User?> getCurrentUser() async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.currentUser),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      );
      if (result.hasException) {
        debugPrint('getUserFromToken: ${result.exception}');
        return null;
      }
      debugPrint('getUserFromToken: ${result.data!['currentUser']}');
      return convertMapToUser(result.data?['currentUser']);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdPatch(String id,
      [Map<String, dynamic> patch = const {}]) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdUserPatch),
          variables: {
            "id": id,
            "patch": patch,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdAvatarUrl: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdAvatarUrl, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdLastSeen(String id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserLastSeen),
          variables: {
            'id': id,
            'lastSeen': DateTime.now().toUtc().toIso8601String(),
          },
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdAvatarUrl: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdAvatarUrl, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> userByIdForAccountScreen(String id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.userByIdForAccountScreen),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdAvatarUrl: ${result.exception}');
        return null;
      }
      final map = result.data?['user'];
      debugPrint('_userByIdForAccountScreen, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdBios(String id, String? bios) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdBios),
          variables: {
            "id": id,
            "bios": bios,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('updateUserByIdBios: ${result.exception}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('updateUserByIdBios, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdNameBirthdate(
      String id, String? name, DateTime? birthdate) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdNameBirthdate),
          variables: {
            "id": id,
            "name": name,
            "birthdate": birthdate?.toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateUserByIdNameBirthdate: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdNameBirthdate, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdAvatarUrl(String id, String? avatarUrl) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdAvatarUrl),
          variables: {
            "id": id,
            "avatarUrl": avatarUrl,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdAvatarUrl: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdAvatarUrl, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdCoverUrl(String id, String? coverUrl) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdCoverUrl),
          variables: {
            "id": id,
            "coverUrl": coverUrl,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdCoverUrl: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdCoverUrl, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<UserAddress?> updateUserAddressByUserId(
      UserAddress userAddress) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document:
              gql(UserQuery.updateUserAddressByUserIdDetailsStreetDistrictCity),
          variables: {
            "userId": userAddress.userId.isNotEmpty ? userAddress.userId : null,
            "details":
                userAddress.details.isNotEmpty ? userAddress.userId : null,
            "street": userAddress.street.isNotEmpty ? userAddress.userId : null,
            "district":
                userAddress.district.isNotEmpty ? userAddress.userId : null,
            "city": userAddress.city.isNotEmpty ? userAddress.userId : null,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateUserAddressByUserId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateUserAddress']?['userAddress'];
      debugPrint('_updateUserAddressByUserId, map: $map');
      return convertMapToUserAddress(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<UnblockRequests?> unblockRequestsByCreatedByStatus(
      String createdBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.unblockRequestsByCreatedByStatus),
          variables: {
            'createdBy': createdBy,
            'status': ReportStatus.unchecked,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_unblockRequestsByCreatedByStatus: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['unblockRequests'];
      debugPrint('_unblockRequestsByCreatedByStatus, map: $map');
      return convertMapToUnblockRequests(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<UnblockRequest?> createUnblockRequestByText(String? text) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.createUnblockRequestByText),
          variables: {
            'text': text,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createUnblockRequestByText: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createUnblockRequest']?['unblockRequest'];
      debugPrint('_createUnblockRequestByText, map: $map');
      return convertMapToUnblockRequest(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<UnblockRequest?> updateUnblockRequestByIdTextEditedAt(
      int id, String? text) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUnblockRequestByIdTextEditedAt),
          variables: {
            'id': id,
            'text': text,
            'editedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateUnblockRequestByIdTextEditedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateUnblockRequest']?['unblockRequest'];
      debugPrint('_updateUnblockRequestByIdTextEditedAt, map: $map');
      return convertMapToUnblockRequest(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUserRoles() async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.userRoles),
          variables: const {},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('fetchUserRoles: ${result.exception}');
        return null;
      }
      debugPrint('fetchUserRoles, result.data: ${result.data}');
      return result.data;
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUsersByCreatedAtTimeFromTimeToRole({
    required DateTime time0,
    required DateTime time1,
    required DateTime time2,
    required DateTime time3,
    required DateTime time4,
    required DateTime time5,
    required DateTime time6,
    required DateTime time7,
    required DateTime time8,
    required DateTime time9,
    required DateTime time10,
    required DateTime time11,
    required DateTime time12,
  }) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.usersByCreatedAtTimeFromTimeToRole),
          variables: {
            'time0': time0.toIso8601String(),
            'time1': time1.toIso8601String(),
            'time2': time2.toIso8601String(),
            'time3': time3.toIso8601String(),
            'time4': time4.toIso8601String(),
            'time5': time5.toIso8601String(),
            'time6': time6.toIso8601String(),
            'time7': time7.toIso8601String(),
            'time8': time8.toIso8601String(),
            'time9': time9.toIso8601String(),
            'time10': time10.toIso8601String(),
            'time11': time11.toIso8601String(),
            'time12': time12.toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            'fetchUsersByCreatedAtTimeFromTimeToRole: ${result.exception}');
        return null;
      }
      debugPrint(
          'fetchUsersByCreatedAtTimeFromTimeToRole, result.data: ${result.data}');
      return result.data;
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Users?> usersBySearch(String search) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.usersBySearch),
          variables: {
            'search': search,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_usersBySearch: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['searchUsers'];
      debugPrint('_usersBySearch, map, $map');

      if (map != null) {
        return convertMapToUsers(map);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Users?> usersByFirstAfter(int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.usersByFirstAfter),
          variables: {
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_usersByFirstAfter: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['users'];
      debugPrint('_usersByFirstAfter, map, $map');
      return convertMapToUsers(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ReportedUsers?> reportedUsersByConditionFirstAfter(
      Map<String, dynamic> condition, int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var condition = {};
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.reportedUsersByConditionFirstAfter),
          variables: {
            'condition': condition,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_reportedUsersByConditionFirstAfter: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['reportedUsers'];
      debugPrint('_reportedUsersByConditionFirstAfter, map, $map');
      return convertMapToReportedUsers(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ReportedUser?> reportedUserById(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(UserQuery.reportedUserById),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_reportedUserById: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['reportedUser'];
      debugPrint('_reportedUserById, map: $map');
      return convertMapToReportedUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ReportedUser?> updateReportedUserByIdStatus(int id,
      [String status = ReportStatus.checked]) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateReportedUserByIdStatus),
          variables: {
            'id': id,
            'status': status,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateReportedUserByIdStatus: ${result.exception}');
        return null;
      }
      final map = result.data?['updateReportedUser']?['reportedUser'];
      debugPrint('_updateReportedUserByIdStatus, map: $map');
      return convertMapToReportedUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<User?> updateUserByIdBlockedUntil(
      String id, DateTime? blockedUntil) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery.updateUserByIdBlockedUntil),
          variables: {
            'id': id,
            'blockedUntil': blockedUntil?.toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateUserByIdBlockedUntil: ${result.exception}');
        return null;
      }
      final map = result.data?['updateUser']?['user'];
      debugPrint('_updateUserByIdBlockedUntil, map: $map');
      return convertMapToUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ReportedUser?>
      createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus(
          String userId,
          String createdBy,
          String? text,
          int? postId,
          String type,
          [String status = ReportStatus.unchecked]) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(UserQuery
              .createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus),
          variables: {
            'userId': userId,
            'createdBy': createdBy,
            'text': text,
            'postId': postId,
            'type': type,
            'status': status,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus: ${result.exception}');
        return null;
      }
      final map = result.data?['createReportedUser']?['reportedUser'];
      debugPrint(
          '_createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus, map: $map');
      return convertMapToReportedUser(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  //// Posts

  Future<Posts?> postsByUserIdCurrentUserIdFirstAfter(
      String userId, String currentUserId, int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery.postsByUserIdCurrentUserIdFirstAfter),
          variables: {
            'userId': userId,
            'currentUserId': currentUserId,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_postsByUserIdCurrentUserIdFirstAfter: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['postsByUserId'];
      debugPrint('_postsByUserIdCurrentUserIdFirstAfter, postsMap: $map');
      return convertMapToPosts(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> postByIdCurrentUserId(int id, String currentUserId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery.postByIdCurrentUserId),
          variables: {
            'id': id,
            'currentUserId': currentUserId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_postByIdCurrentUserId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['post'];
      debugPrint('_postByIdCurrentUserId, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> updatPostByIdDeletedByDelete(int id, String deletedBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.updatePostByIdDeletedByDeleteAt),
          variables: {
            'id': id,
            'deletedBy': deletedBy,
            'deletedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateReportedUserByIdStatus: ${result.exception}');
        return null;
      }
      final map = result.data?['updatePost']?['post'];
      debugPrint('_updateReportedUserByIdStatus, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostComments?> postCommentsByReplyToFirstAfterCurrentUserId(
      int replyTo, int first, String? after, String currentUserId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery.postCommentsByReplyToFirstAfterCurrentUserId),
          variables: {
            'replyTo': replyTo,
            'first': first,
            'after': after,
            'currentUserId': currentUserId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_postCommentsByReplyToFirstAfterCurrentUserId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['postComments'];
      debugPrint('_postCommentsByReplyToFirstAfterCurrentUserId, map, $map');
      return convertMapToPostComments(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<CommentEmote?> createCommentEmote(
      int commentId, String createdBy, CommentEmote? emote) async {
    if (emote == null || client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.createCommentEmote),
          variables: {
            "commentId": commentId,
            "createdBy": createdBy,
            "code": emote.code,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('createCommentEmote: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createCommentEmote']?['commentEmote'];
      debugPrint('createCommentEmote, map: $map');
      return convertMapToCommentEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<CommentEmote?> deleteCommentEmoteById(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.deleteCommentEmote),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('deleteCommentEmote: ${result.exception.toString()}');
      }
      final map = result.data?['deleteCommentEmote']?['commentEmote'];
      debugPrint('deleteCommentEmote, map: $map');
      return convertMapToCommentEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostComment?> createPostCommentByPostIdCreatedByTextReplyTo(
      int postId, String createdBy, String? text, int? replyTo) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.createPostComment),
          variables: {
            "postId": postId,
            "createdBy": createdBy,
            "text": text,
            "replyTo": replyTo,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('createPostComment: ${result.exception}');
        return null;
      }
      final map = result.data?['createPostComment']?['postComment'];
      debugPrint('createPostComment, map: $map');
      return convertMapToPostComment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostComment?> updatePostCommentByIdPatch(
      int id, Map<String, dynamic> patch) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.updatePostCommentByIdPatch),
          variables: {
            "id": id,
            "patch": patch,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('updatePostComment: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updatePostComment']?['postComment'];
      debugPrint('updatePostComment, map: $map');
      return convertMapToPostComment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostEmote?> postEmoteByPostIdAndCreatedBy(
      int postId, String createdBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery.postEmoteByPostIdAndCreatedBy),
          variables: {
            'postId': postId,
            'createdBy': createdBy,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            'postEmoteByPostIdAndCreatedBy: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['postEmoteByPostIdAndCreatedBy'];
      debugPrint('postEmoteByPostIdAndCreatedBy, map: $map');
      return convertMapToPostEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostComments?> postCommentsByPostIdFirstAfterCurrentUserId(
      int postId, int first, String? after, String currentUserId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery.postCommentsByPostIdFirstAfterCurrentUserId),
          variables: {
            'postId': postId,
            'first': first,
            'after': after,
            'currentUserId': currentUserId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            'postCommentsByPostIdFirstAfterCurrentUserId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['postComments'];
      debugPrint('postCommentsByPostIdFirstAfterCurrentUserId, map, $map');
      return convertMapToPostComments(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostEmote?> createPostEmoteByPostIdCreatedByCode(
      int postId, String createdBy, String code) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.createPostEmoteByPostIdCreatedByCode),
          variables: {
            "postId": postId,
            "createdBy": createdBy,
            "code": code,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createPostEmoteByPostIdCreatedByCode: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createPostEmote']?['postEmote'];
      debugPrint('_createPostEmoteByPostIdCreatedByCode, map: $map');
      return convertMapToPostEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostEmote?> updatePostEmoteByIdEditedAtCode(
      int id, String code) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.updatePostEmoteByIdEditedAtCode),
          variables: {
            "id": id,
            "editedAt": DateTime.now().toIso8601String(),
            "code": code,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updatePostEmoteByIdEditedAtCode: ${result.exception}');
        return null;
      }
      final map = result.data?['updatePostEmote']?['postEmote'];
      debugPrint('_updatePostEmoteByIdEditedAtCode, map: $map');
      return convertMapToPostEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<PostEmote?> deletePostEmoteById(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.deletePostEmote),
          variables: {
            "id": id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('deletePostEmote: ${result.exception}');
        return null;
      }
      final map = result.data?['deletePostEmote']?['postEmote'];
      debugPrint('deletePostEmote, map: $map');
      return convertMapToPostEmote(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> updatePostByIdDeletedByDeletedAt(
      int id, String deletedBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.updatePostByIdDeletedByDeleteAt),
          variables: {
            'id': id,
            'deletedBy': deletedBy,
            'deletedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updatePostByIdDeletedByDeletedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updatePost']?['post'];
      debugPrint('_updatePostByIdDeletedByDeletedAt, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> updatePostByIdEditedAtText(int id, String? text) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.updatePostByIdEditedAtText),
          variables: {
            "id": id,
            "editedAt": DateTime.now().toIso8601String(),
            "text": text,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updatePostByIdEditedAtText: ${result.exception}');
      }
      final map = result.data?['updatePost']?['post'];
      debugPrint('_updatePostByIdEditedAtText, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> createPostByCreatedByText(
      String createdBy, String? text) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.createPostByCreatedByText),
          variables: {
            "createdBy": createdBy,
            "text": text,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_createPostByCreatedByText: ${result.exception}');
        return null;
      }
      final map = result.data?['createPost']?['post'];
      debugPrint('_createPostByCreatedByText, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  //// Conversations

  Future<List<Conversation>> conversationsByCurrentUser() async {
    if (client == null) {
      return [];
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ConversationQuery.conversationsByCurrentUser),
          variables: const {},
          fetchPolicy: FetchPolicy.networkOnly,
          cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_conversationsByCurrentUser, hasException: ${result.exception}');
        return [];
      }
      final maps = result.data?['currentUser']?['participants']?['nodes']
          ?.map((e) => e['conversation'])
          ?.toList();
      debugPrint('_conversationsByCurrentUser, maps, $maps');
      if (maps != null) {
        return convertMapsToConversations(maps);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return [];
  }

  Future<Conversations?> conversationsByCurrentUserFirstAfter(
      int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ConversationQuery.conversationsByCurrentUserFirstAfter),
          variables: {
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
          cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_conversationsByCurrentUserFirstAfter: ${result.exception}');
        return null;
      }
      final map = result.data?['currentUser']?['participants'];
      debugPrint('_conversationsByFirstAfter, map, $map');
      final nodes =
          map?['nodes']?.map((e) => e['conversation'])?.toList() ?? [];
      final totalCount = map?['totalCount'];
      final pageInfo = map?['pageInfo'];
      return Conversations(
        nodes: convertMapsToConversations(nodes),
        totalCount: totalCount ?? 0,
        pageInfo: pageInfo != null ? PageInfo.fromJson(pageInfo) : null,
      );
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Conversation?> conversationById(String id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ConversationQuery.conversationById),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_conversationById: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['conversation'];
      debugPrint('_conversationById, map, $map');

      if (map != null) {
        return convertMapToConversation(map);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Conversation?> createdConversationByIdCreatedBy(
      String id, String createdBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ConversationQuery.createConversationByIdCreatedBy),
          variables: {
            'id': id,
            'createdBy': createdBy,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createdConversationByIdCreatedBy: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createConversation']?['conversation'];
      debugPrint('_createdConversationByIdCreatedBy, map: $map');
      return convertMapToConversation(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Conversation?> createConversationByCreatedBy(String createdBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ConversationQuery.createConversationByCreatedBy),
          variables: {
            "createdBy": createdBy,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createConversationByCreatedBy: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createConversation']?['conversation'];
      debugPrint('_createConversationByCreatedBy, map, $map');
      if (map != null) {
        return convertMapToConversation(map);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Message?> createMessageByConversationIdCreatedByText(
      String conversationId, String createdBy,
      [String? text, int? replyTo]) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ConversationQuery.addMessageToConversation),
          variables: {
            "conversationId": conversationId,
            "createdBy": createdBy,
            "text": text,
            "replyTo": replyTo,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createMessageByConversationId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createMessage']?['message'];
      if (map != null) {
        return convertMapToMessage(map);
      }
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Participant?> createParticipantByConversationIdUserIdCreatedByRole(
      String conversationId, String userId, String createdBy,
      {String role = ParticipantRole.roleMember}) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ConversationQuery
              .createParticipantByConversationIdUserIdCreatedByRole),
          variables: {
            'conversationId': conversationId,
            'userId': userId,
            'createdBy': createdBy,
            'role': role,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createParticipantByConversationIdUserIdCreatedByRole: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createParticipant']?['participant'];
      debugPrint(
          '_createParticipantByConversationIdUserIdCreatedByRole, map: $map');
      return convertMapToParticipant(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Messages?> messagesByConversationId(String conversationId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ConversationQuery.messagesByConversationId),
          variables: {
            'conversationId': conversationId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_messagesByConversationId: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['messages'];
      debugPrint('_messagesByConversationId, map, $map');
      return convertMapToMessages(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Conversation?> updateConversationByIdDeletedByDeletedAt(
      String id, String deletedBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document:
              gql(ConversationQuery.updateConversationByIdDeletedByDeletedAt),
          variables: {
            'id': id,
            'deletedBy': deletedBy,
            'deletedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateConversationByIdDeletedByDeletedAt: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateConversation']?['conversation'];
      debugPrint('_updateConversationByIdDeletedByDeletedAt, map: $map');
      return convertMapToConversation(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Conversation?> updateConversationByIdTitleDescriptionEditedByEditedAt(
      String id, String? title, String? description, String editedBy) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ConversationQuery
              .updateConversationByIdTitleDescriptionEditedByEditedAt),
          variables: {
            'id': id,
            'title': title,
            'description': description,
            'editedBy': editedBy,
            'editedAt': DateTime.now().toIso8601String()
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateConversationByIdTitleDescriptionEditedByEditedAt: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['updateConversation']?['conversation'];
      debugPrint(
          '_updateConversationByIdTitleDescriptionEditedByEditedAt, map: $map');
      return convertMapToConversation(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  //// Shipments

  Future<Shipment?> shipmentById(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentById),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_shipmentById: ${result.exception}');
        return null;
      }
      final map = result.data?['shipment'];
      debugPrint('_shipmentById, map, $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffer?> createShipmentOfferByShipmentIdCreatedByPriceNotes(
      int shipmentId, String createdBy, int? price, String? notes) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.createShipmentOffer),
          variables: {
            "shipmentId": shipmentId,
            "createdBy": createdBy,
            "price": price,
            "notes": notes,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('createShipmentOffer: ${result.exception}');
        return null;
      }
      final map = result.data?['createShipmentOffer']?['shipmentOffer'];
      debugPrint('createShipmentOffer, map: $map');
      return convertMapToShipmentOffer(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffers?> shipmentOffersByShipmentId(int shipmentId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentOffersByShipmentId),
          variables: {
            'shipmentId': shipmentId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_shipmentOffersByShipmentId: ${result.exception}');
        return null;
      }
      final map = result.data?['shipmentOffers'];
      debugPrint('_shipmentOffersByShipmentId, map, $map');
      return convertMapToShipmentOffers(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffers?> shipmentOffersByShipmentIdSearch(
      int shipmentId, String search) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentOffersByShipmentIdSearch),
          variables: {
            'shipmentId': shipmentId,
            'search': search,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_shipmentOffersByShipmentIdSearch: ${result.exception}');
        return null;
      }
      final map = result.data?['shipmentOffersByShipmentIdSearch'];
      debugPrint('_shipmentOffersByShipmentIdSearch, map, $map');
      return convertMapToShipmentOffers(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Posts?>
      postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter(
    bool shipment,
    bool transport,
    bool delivery,
    bool finding,
    bool saving,
    bool fast,
    String currentUserId,
    int first,
    String? after,
  ) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(PostQuery
              .postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter),
          variables: {
            'shipment': shipment,
            'transport': transport,
            'delivery': delivery,
            'finding': finding,
            'saving': saving,
            'fast': fast,
            'currentUserId': currentUserId,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter: ${result.exception}');
        return null;
      }
      final map = result.data?['postsByTags'];
      debugPrint(
          '_postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter, postsMap: $map');
      return convertMapToPosts(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffers?> shipmentOffersByCreatedByFirstAfter(
      String createdBy, int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentOffersByCreatedByFirstAfter),
          variables: {
            'createdBy': createdBy,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_shipmentOffersByCreatedByFirstAfter: ${result.exception}');
        return null;
      }
      final map = result.data?['shipmentOffers'];
      debugPrint('_shipmentOffersByCreatedByFirstAfter, map: $map');
      return convertMapToShipmentOffers(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipment?> shipmentByIdForShipmentcreen(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentById),
          variables: {
            'id': id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_shipmentByIdForShipmentcreen: ${result.exception}');
        return null;
      }
      final map = result.data?['shipment'];
      debugPrint('_shipmentByIdForShipmentcreen, map: $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipment?> updateShipmentByIdCodNotesPhoneEditedAt(
      int id, int? cod, String? notes, String? phone) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.updateShipmentByIdCodNotesPhoneEditedAt),
          variables: {
            'id': id,
            'cod': cod,
            'notes': notes,
            'phone': phone,
            'editedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_updateShipmentByIdCodNotesPhoneEditedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateShipment']?['shipment'];
      debugPrint('_updateShipmentByIdCodNotesPhoneEditedAt, map: $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipment?> updateShipmentByIdDeletedAt(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.updateShipmentByIdDeletedAt),
          variables: {
            'id': id,
            'deletedAt': DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateShipmentByIdDeletedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateShipment']?['shipment'];
      debugPrint('_updateShipmentByIdDeletedAt, map: $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipment?> updateShipmentByIdStatus(int id, String status) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.updateShipmentByIdStatus),
          variables: {
            'id': id,
            'status': status,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('updateShipmentByIdStatus: ${result.exception}');
        return null;
      }
      final map = result.data?['updateShipment']?['shipment'];
      debugPrint('updateShipmentByIdStatus, map: $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffer?> deleteShipmentOffer(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.deleteShipmentOffer),
          variables: {
            "id": id,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('deleteShipmentOffer: ${result.exception}');
        return null;
      }
      final map = result.data?['deleteShipmentOffer']?['shipmentOffer'];
      debugPrint('deleteShipmentOffer, map: $map');
      return convertMapToShipmentOffer(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffer?> updateShipmentOfferByIdPriceNotesEditedAt(
      int id, int? price, String? notes) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document:
              gql(ShipmentQuery.updateShipmentOfferByIdPriceNotesEditedAt),
          variables: {
            "id": id,
            "price": price,
            "notes": notes,
            "editedAt": DateTime.now().toIso8601String()
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateShipmentOffer: ${result.exception}');
      }
      final map = result.data?['updateShipmentOffer']?['shipmentOffer'];
      debugPrint('_updateShipmentOffer, map: $map');
      return convertMapToShipmentOffer(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffer?> updateShipmentOfferByIdAcceptedAt(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.updateShipmentOfferByIdAcceptedAt),
          variables: {
            "id": id,
            "acceptedAt": DateTime.now().toIso8601String(),
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('updateShipmentOfferByIdAcceptedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateShipmentOffer']?['shipmentOffer'];
      debugPrint('updateShipmentOfferByIdAcceptedAt, map: $map');
      return convertMapToShipmentOffer(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentOffer?> updateShipmentOfferByIdRejectedAt(int id) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery.updateShipmentOfferByIdRejectedAt),
          variables: {"id": id, "rejectedAt": DateTime.now().toIso8601String()},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_updateShipmentOfferByIdRejectedAt: ${result.exception}');
        return null;
      }
      final map = result.data?['updateShipmentOffer']?['shipmentOffer'];
      debugPrint('_updateShipmentOfferByIdRejectedAt, map: $map');
      return convertMapToShipmentOffer(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipments?>
      shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter(
          String currentUserId,
          Map<String, dynamic> condition,
          int first,
          String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery
              .shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter),
          variables: {
            'currentUserId': currentUserId,
            'condition': condition,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter: ${result.exception}');
        return null;
      }
      final map = result.data?['shipmentsByShipmentOffersByCurrentUserId'];
      debugPrint(
          '_shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter, map: $map');
      return convertMapToShipments(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipments?> shipmentsByConditionByFirstAfter(
      Map<String, dynamic> condition, int first, String? after) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.query(
        QueryOptions(
          document: gql(ShipmentQuery.shipmentsByConditionFirstAfter),
          variables: {
            'condition': condition,
            'first': first,
            'after': after,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_shipmentsByConditionByFirstAfter: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['shipments'];
      debugPrint('_shipmentsByConditionByFirstAfter, map: $map');
      return convertMapToShipments(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Shipment?> createShipmentByCreatedByTypeServiceCodNotesPhoneStatus(
      String createdBy,
      String type,
      String service,
      int? cod,
      String? notes,
      String? phone,
      [String status = ShipmentStatus.finding]) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery
              .createShipmentByCreatedByTypeServiceCodNotesPhoneStatus),
          variables: {
            "createdBy": createdBy,
            "type": type,
            "service": service,
            "cod": cod,
            "notes": notes,
            "phone": phone,
            "status": status,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createShipmentByCreatedByTypeServiceCodNotesPhoneStatus: ${result.exception}');
        return null;
      }
      final map = result.data?['createShipment']?['shipment'];
      debugPrint(
          '_createShipmentByCreatedByTypeServiceCodNotesPhoneStatus, map: $map');
      return convertMapToShipment(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentAddressFrom?>
      createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation(
          ShipmentAddressFrom shipmentAddressFrom) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery
              .createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation),
          variables: {
            "shipmentId": shipmentAddressFrom.shipmentId,
            "details": shipmentAddressFrom.details,
            "street": shipmentAddressFrom.street,
            "district": shipmentAddressFrom.district,
            "city": shipmentAddressFrom.city,
            "location": shipmentAddressFrom.location,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation: ${result.exception}');
        return null;
      }
      final map =
          result.data?['createShipmentAddressFrom']?['shipmentAddressFrom'];
      debugPrint(
          '_createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation, map: $map');
      return convertMapToShipmentAddressFrom(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<Post?> createPostByCreatedByShipmentId(
      String createdBy, int shipmentId) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(PostQuery.createPostByCreatedByShipmentId),
          variables: {
            "createdBy": createdBy,
            "shipmentId": shipmentId,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint('_createPostByCreatedByShipmentId: ${result.exception}');
        return null;
      }
      final map = result.data?['createPost']?['post'];
      debugPrint('_createPostByCreatedByShipmentId, map: $map');
      return convertMapToPost(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }

  Future<ShipmentAddressTo?>
      createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation(
          ShipmentAddressTo shipmentAddressTo) async {
    if (client == null) {
      return null;
    }
    try {
      var result = await client!.mutate(
        MutationOptions(
          document: gql(ShipmentQuery
              .createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation),
          variables: {
            "shipmentId": shipmentAddressTo.shipmentId,
            "details": shipmentAddressTo.details,
            "street": shipmentAddressTo.street,
            "district": shipmentAddressTo.district,
            "city": shipmentAddressTo.city,
            "location": shipmentAddressTo.location,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['createShipmentAddressTo']?['shipmentAddressTo'];
      debugPrint(
          '_createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation, map: $map');
      return convertMapToShipmentAddressTo(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }
}
