class UserQuery {
  static String currentUser = '''
query MyQuery {
  currentUser {
    id
    uid
    name
    createdAt
    deletedAt
    coverUrl
    blockedUntil
    birthdate
    bios
    avatarUrl
    lastSeen
    email
    role
  }
}
''';

  static String updateUserLastSeen = '''
mutation MyMutation(\$lastSeen: Datetime = "", \$id: String = "") {
  updateUser(input: {patch: {lastSeen: \$lastSeen}, id: \$id}) {
    user {
      id
      lastSeen
    }
  }
}
''';

  static String userByIdForAccountScreen = '''
query MyQuery(\$id: String!) {
  user(id: \$id) {
    id
    uid
    name
    avatarUrl
    coverUrl
    email
    phone
    birthdate
    createdAt
    lastSeen
    bios
    role
    userAddress {
      userId
      details
      street
      district
      city
      location {
        x
        y
      }
    }
    feedbacks(condition: { userId: \$id }) {
      nodes {
        id
        userId
        createdBy
        createdAt
        editedAt
        deletedAt
        rating
        text
        feedbackAttachments {
          nodes {
            id
            feedbackId
            fileUrl
            thumbUrl
            type
          }
          totalCount
        }
        userByCreatedBy {
          id
          name
          avatarUrl
          lastSeen
        }
        feedbackReplies {
          nodes {
            id
            feedbackId
            createdBy
            createdAt
            editedAt
            deletedAt
            text
            replyTo
            replyAttachmentsByReplyId {
              nodes {
                id
                replyId
                fileUrl
                thumbUrl
                type
              }
              totalCount
            }
          }
          totalCount
        }
      }
      totalCount
    }
  }
}
''';

  static String usersByFirstAfter = '''
query MyQuery(\$first: Int = 1, \$after: Cursor) {
  users(
    orderBy: ID_DESC
    condition: { deletedAt: null }
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      avatarUrl
      name
      birthdate
      lastSeen
      role
      phone
      userAddress {
        details
      }
    }
    totalCount
    pageInfo {
      startCursor
      endCursor
      hasPreviousPage
      hasNextPage
    }
  }
}
''';

  static String subscriptionUsersForContactsScreen = '''
subscription MySubscription {
  users {
    nodes {
      id
      avatarUrl
      name
      birthdate
      lastSeen
      role
      phone
      userAddress {
        details
      }
    }
  }
}

''';

  static String updateUserByIdUserPatch = '''
mutation MyMutation(\$id: String!, \$patch: UserPatch = {}) {
  updateUser(input: {patch: \$patch, id: \$id}) {
    user {
      id
    }
  }
}
''';

  static String updateUserByIdBios = '''
mutation MyMutation(\$id: String!, \$bios: String) {
  updateUser(input: { patch: { bios: \$bios }, id: \$id }) {
    user {
      id
      bios
    }
  }
}
''';

  static String updateUserByIdNameBirthdate = '''
mutation MyMutation(\$id: String!, \$name: String, \$birthdate: Datetime) {
  updateUser(
    input: { patch: { name: \$name, birthdate: \$birthdate }, id: \$id }
  ) {
    user {
      id
      name
      birthdate
    }
  }
}
''';

  static String updateUserAddressByUserIdDetailsStreetDistrictCity = '''
mutation MyMutation(
  \$userId: String!
  \$details: String
  \$street: String
  \$district: String
  \$city: String
) {
  updateUserAddress(
    input: {
      patch: {
        details: \$details
        street: \$street
        district: \$district
        city: \$city
      }
      userId: \$userId
    }
  ) {
    userAddress {
      userId
      details
      street
      district
      city
    }
  }
}
''';

  static String updateUserByIdAvatarUrl = '''
mutation MyMutation(\$id: String!, \$avatarUrl: String) {
  updateUser(input: { patch: { avatarUrl: \$avatarUrl }, id: \$id }) {
    user {
      id
      avatarUrl
    }
  }
}
''';

  static String updateUserByIdCoverUrl = '''
mutation MyMutation(\$id: String!, \$coverUrl: String) {
  updateUser(input: { patch: { coverUrl: \$coverUrl }, id: \$id }) {
    user {
      id
      coverUrl
    }
  }
}
''';

  static String usersBySearch = '''
query MyQuery(\$search: String) {
  searchUsers(search: \$search) {
    nodes {
      id
      name
      avatarUrl
      lastSeen
    }
  }
}
''';

  static String
      createReportedUserByUserIdCreatedByTextPostIdConversationIdTypeStatus =
      '''
mutation MyMutation(
  \$userId: String!
  \$createdBy: String!
  \$text: String
  \$postId: Int
  \$conversationId: String
  \$type: String
  \$status: String
) {
  createReportedUser(
    input: {
      reportedUser: {
        userId: \$userId
        createdBy: \$createdBy
        text: \$text
        postId: \$postId
        conversationId: \$conversationId
        type: \$type
        status: \$status
      }
    }
  ) {
    reportedUser {
      id
      userId
      createdBy
      createdAt
      text
      postId
      conversationId
      type
      status
    }
  }
}
''';

  static String reportedUsersByConditionFirstAfter = '''
query MyQuery(
  \$condition: ReportedUserCondition
  \$first: Int = 1
  \$after: Cursor
) {
  reportedUsers(
    orderBy: ID_DESC
    condition: \$condition
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      userId
      createdBy
      createdAt
      text
      postId
      conversationId
      type
      status
    }
    totalCount
    pageInfo {
      startCursor
      endCursor
      hasPreviousPage
      hasNextPage
    }
  }
}
''';

  static String reportedUserById = '''
query MyQuery(\$id: Int!) {
  reportedUser(id: \$id) {
    id
    userId
    createdBy
    createdAt
    text
    postId
    conversationId
    type
    status
    user {
      id
      name
      role
      avatarUrl
      lastSeen
    }
    userByCreatedBy {
      id
      name
      role
      avatarUrl
      lastSeen
    }
  }
}
''';

  static String updateReportedUserByIdStatus = '''
mutation MyMutation(
  \$id: Int!
  \$status: String
) {
  updateReportedUser(
    input: {
      patch: { status: \$status }
      id: \$id
    }
  ) {
    reportedUser {
      id
      status
    }
  }
}
''';

  static String updateUserByIdBlockedUntil = '''
mutation MyMutation(\$id: String!, \$blockedUntil: Datetime) {
  updateUser(input: { patch: { blockedUntil: \$blockedUntil }, id: \$id }) {
    user {
      id
      blockedUntil
    }
  }
}
''';

  static String userRoles = '''
query MyQuery {
  count_admins: userRoles(condition: { role: "role_admin" }) {
    totalCount
  }
  count_shippers: userRoles(condition: { role: "role_shipper" }) {
    totalCount
  }
  count_users: userRoles(condition: { role: "role_user" }) {
    totalCount
  }
}
''';

  static String usersByCreatedAtTimeFromTimeToRole = '''
query MyQuery(
  \$time0: Datetime
  \$time1: Datetime
  \$time2: Datetime
  \$time3: Datetime
  \$time4: Datetime
  \$time5: Datetime
  \$time6: Datetime
  \$time7: Datetime
  \$time8: Datetime
  \$time9: Datetime
  \$time10: Datetime
  \$time11: Datetime
  \$time12: Datetime
) {
  monthFrom0To1Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time0
    timeFrom: \$time1
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom1To2Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time1
    timeFrom: \$time2
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom2To3Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time2
    timeFrom: \$time3
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom3To4Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time3
    timeFrom: \$time4
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom4To5Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time4
    timeFrom: \$time5
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom5To6Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time5
    timeFrom: \$time6
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom6To7Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time6
    timeFrom: \$time7
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom7To8Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time7
    timeFrom: \$time8
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom8To9Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time8
    timeFrom: \$time9
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom9To10Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time9
    timeFrom: \$time10
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom10To11Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time10
    timeFrom: \$time11
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom11To12Admin: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time11
    timeFrom: \$time12
    role: "role_admin"
  ) {
    totalCount
  }
  monthFrom0To1Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time0
    timeFrom: \$time1
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom1To2Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time1
    timeFrom: \$time2
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom2To3Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time2
    timeFrom: \$time3
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom3To4Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time3
    timeFrom: \$time4
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom4To5Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time4
    timeFrom: \$time5
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom5To6Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time5
    timeFrom: \$time6
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom6To7Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time6
    timeFrom: \$time7
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom7To8Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time7
    timeFrom: \$time8
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom8To9Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time8
    timeFrom: \$time9
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom9To10Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time9
    timeFrom: \$time10
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom10To11Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time10
    timeFrom: \$time11
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom11To12Shipper: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time11
    timeFrom: \$time12
    role: "role_shipper"
  ) {
    totalCount
  }
  monthFrom0To1User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time0
    timeFrom: \$time1
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom1To2User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time1
    timeFrom: \$time2
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom2To3User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time2
    timeFrom: \$time3
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom3To4User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time3
    timeFrom: \$time4
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom4To5User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time4
    timeFrom: \$time5
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom5To6User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time5
    timeFrom: \$time6
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom6To7User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time6
    timeFrom: \$time7
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom7To8User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time7
    timeFrom: \$time8
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom8To9User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time8
    timeFrom: \$time9
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom9To10User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time9
    timeFrom: \$time10
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom10To11User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time10
    timeFrom: \$time11
    role: "role_user"
  ) {
    totalCount
  }
  monthFrom11To12User: usersByCreatedAtTimeFromTimeToRole(
    timeTo: \$time11
    timeFrom: \$time12
    role: "role_user"
  ) {
    totalCount
  }
}
''';

  static String unblockRequestsByCreatedByStatus = '''
query MyQuery(\$createdBy: String, \$status: String) {
  unblockRequests(condition: { createdBy: \$createdBy, status: \$status }) {
    nodes {
      id
      createdBy
      createdAt
      editedAt
      text
      status
      checkedBy
      checkedAt
    }
  }
}''';

  static String createUnblockRequestByText = '''
mutation MyMutation(\$text: String) {
  createUnblockRequest(input: { unblockRequest: { text: \$text } }) {
    unblockRequest {
      id
      createdBy
      createdAt
      text
      status
    }
  }
}
''';

  static String updateUnblockRequestByIdTextEditedAt = '''
mutation MyMutation(\$id: Int!, \$text: String, \$editedAt: Datetime) {
  updateUnblockRequest(
    input: { id: \$id, patch: { text: \$text, editedAt: \$editedAt } }
  ) {
    unblockRequest {
      id
      createdBy
      createdAt
      editedAt
      text
      status
      checkedBy
      checkedAt
    }
  }
}
''';

  static String updateUnblockRequestByIdStatusCheckedByCheckedAt = '''
mutation MyMutation(\$id: Int!, \$status: String, \$checkedBy: String, \$checkedAt: Datetime) {
  updateUnblockRequest(
    input: { id: \$id, patch: { status: \$status, checkedBy: \$checkedBy, checkedAt: \$checkedAt } }
  ) {
    unblockRequest {
      id
      createdBy
      createdAt
      editedAt
      text
      status
      checkedBy
      checkedAt
    }
  }
}
''';

  static String unblockRequestsByConditionFirstAfter = '''
query MyQuery(
  \$condition: UnblockRequestCondition
  \$first: Int = 1
  \$after: Cursor
) {
  unblockRequests(
    orderBy: ID_DESC
    condition: \$condition
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      createdBy
      createdAt
      editedAt
      text
      status
      checkedBy
      checkedAt
    }
    totalCount
    pageInfo {
      startCursor
      endCursor
      hasPreviousPage
      hasNextPage
    }
  }
}
''';
}
