class PostQuery {
  static String
      postsByShipmentTransportDeliveryFindingSavingFastCurrentUserIdFirstAfter =
      '''
query MyQuery(
  \$shipment: Boolean = false
  \$transport: Boolean = false
  \$delivery: Boolean = false
  \$finding: Boolean = false
  \$saving: Boolean = false
  \$fast: Boolean = false
  \$currentUserId: String!
  \$first: Int = 1
  \$after: Cursor
) {
  postsByTags(
    shipment: \$shipment
    transport: \$transport
    delivery: \$delivery
    finding: \$finding
    saving: \$saving
    fast: \$fast
    orderBy: ID_DESC
    condition: { deletedAt: null }
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      shipmentId
      postAddress {
        postId
        details
        street
        district
        city
        location {
          x
          y
        }
      }
      postAttachments {
        nodes {
          id
          postId
          fileUrl
          type
        }
        totalCount
      }
      postComments(condition: { deletedAt: null }) {
        totalCount
      }
      emoteByCurrentUserId: postEmotes(
        condition: { createdBy: \$currentUserId }
      ) {
        nodes {
          id
          code
        }
        totalCount
      }
      emotesByLike: postEmotes(
        condition: { code: "like" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByLove: postEmotes(
        condition: { code: "love" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByCare: postEmotes(
        condition: { code: "care" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByHaha: postEmotes(
        condition: { code: "haha" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByWow: postEmotes(
        condition: { code: "wow" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesBySad: postEmotes(
        condition: { code: "sad" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByAngry: postEmotes(
        condition: { code: "angry" }
        first: 10
      ) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      shipment {
        id
        createdBy
        createdAt
        editedAt
        deletedAt
        service
        type
        status
        cod
        notes
        phone
        shipmentAddressFrom {
          shipmentId
          details
          street
          district
          city
          location {
            x
            y
          }
        }
        shipmentAddressTo {
          shipmentId
          details
          street
          district
          city
          location {
            x
            y
          }
        }
        shipmentParcel {
          shipmentId
          code
          width
          length
          height
          weight
          nameFrom
          nameTo
          phoneFrom
          phoneTo
          description
        }
        shipmentAttachments {
          nodes {
            id
            shipmentId
            fileUrl
            thumbUrl
            type
          }
          totalCount
        }
        shipmentOffers {
          nodes {
            id
            shipmentId
            createdBy
            createdAt
            editedAt
            deletedAt
            price
            notes
            acceptedAt
            rejectedAt
            userByCreatedBy {
              id
              name
              avatarUrl
              lastSeen
            }
          }
          totalCount
        }
        acceptedOfferId
        acceptedOffer {
          id
          shipmentId
          createdBy
          createdAt
          editedAt
          deletedAt
          price
          notes
          acceptedAt
          rejectedAt
          userByCreatedBy{
            id
            uid
            name
            avatarUrl
            lastSeen
          }
        }
      }
      userByCreatedBy {
        id
        name
        avatarUrl
        lastSeen
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

  static String postsByUserIdCurrentUserIdFirstAfter = '''
query MyQuery(
  \$userId: String!
  \$currentUserId: String!
  \$first: Int = 1
  \$after: Cursor) {
  postsByUserId(
    orderBy: ID_DESC
    condition: { deletedAt: null }
    userId: \$userId
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      shipmentId
      postAddress {
        postId
        details
        street
        district
        city
        location {
          x
          y
        }
      }
      postAttachments {
        nodes {
          id
          postId
          fileUrl
          type
        }
        totalCount
      }
      postComments(condition: { deletedAt: null }) {
        totalCount
      }
      emoteByCurrentUserId: postEmotes(
        condition: { createdBy: \$currentUserId }
      ) {
        nodes {
          id
          code
        }
        totalCount
      }
      emotesByLike: postEmotes(condition: { code: "like" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByLove: postEmotes(condition: { code: "love" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByCare: postEmotes(condition: { code: "care" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByHaha: postEmotes(condition: { code: "haha" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByWow: postEmotes(condition: { code: "wow" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesBySad: postEmotes(condition: { code: "sad" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByAngry: postEmotes(condition: { code: "angry" }, first: 10) {
        nodes {
          id
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      shipment {
        id
        createdBy
        createdAt
        editedAt
        deletedAt
        service
        type
        status
        cod
        notes
        phone
        shipmentAddressFrom {
          shipmentId
          details
          street
          district
          city
          location {
            x
            y
          }
        }
        shipmentAddressTo {
          shipmentId
          details
          street
          district
          city
          location {
            x
            y
          }
        }
        shipmentParcel {
          shipmentId
          code
          width
          length
          height
          weight
          nameFrom
          nameTo
          phoneFrom
          phoneTo
          description
        }
        shipmentAttachments {
          nodes {
            id
            shipmentId
            fileUrl
            thumbUrl
            type
          }
          totalCount
        }
        shipmentOffers {
          nodes {
            id
            shipmentId
            createdBy
            createdAt
            editedAt
            deletedAt
            price
            notes
            acceptedAt
            rejectedAt
            userByCreatedBy {
              id
              name
              avatarUrl
              lastSeen
            }
          }
          totalCount
        }
        acceptedOfferId
        acceptedOffer {
          id
          shipmentId
          createdBy
          createdAt
          editedAt
          deletedAt
          price
          notes
          acceptedAt
          rejectedAt
          userByCreatedBy {
            id
            uid
            name
            avatarUrl
            lastSeen
          }
        }
      }
      userByCreatedBy {
        id
        name
        avatarUrl
        lastSeen
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

  static String postByIdCurrentUserId = '''
query MyQuery(\$id: Int!, \$currentUserId: String!) {
  post(id: \$id) {
    id
    createdBy
    createdAt
    editedAt
    deletedBy
    deletedAt
    text
    shipmentId
    postAddress {
      postId
      details
      street
      district
      city
      location {
        x
        y
      }
    }
    postAttachments {
      nodes {
        id
        postId
        fileUrl
        type
      }
      totalCount
    }
    postComments(condition: { deletedAt: null }) {
      totalCount
    }
    emoteByCurrentUserId: postEmotes(condition: { createdBy: \$currentUserId }) {
      nodes {
        id
        code
      }
      totalCount
    }
    emotesByLike: postEmotes(condition: { code: "like" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesByLove: postEmotes(condition: { code: "love" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesByCare: postEmotes(condition: { code: "care" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesByHaha: postEmotes(condition: { code: "haha" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesByWow: postEmotes(condition: { code: "wow" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesBySad: postEmotes(condition: { code: "sad" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    emotesByAngry: postEmotes(condition: { code: "angry" }, first: 10) {
      nodes {
        id
        code
        userByCreatedBy {
          name
        }
      }
      totalCount
    }
    shipment {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      service
      type
      status
      cod
      notes
      phone
      shipmentAddressFrom {
        shipmentId
        details
        street
        district
        city
        location {
          x
          y
        }
      }
      shipmentAddressTo {
        shipmentId
        details
        street
        district
        city
        location {
          x
          y
        }
      }
      shipmentParcel {
        shipmentId
        code
        width
        length
        height
        weight
        nameFrom
        nameTo
        phoneFrom
        phoneTo
        description
      }
      shipmentAttachments {
        nodes {
          id
          shipmentId
          fileUrl
          thumbUrl
          type
        }
        totalCount
      }
      shipmentOffers {
        nodes {
          id
          shipmentId
          createdBy
          createdAt
          editedAt
          deletedAt
          price
          notes
          acceptedAt
          rejectedAt
          userByCreatedBy {
            id
            name
            avatarUrl
            lastSeen
          }
        }
        totalCount
      }
      acceptedOfferId
      acceptedOffer {
        id
        shipmentId
        createdBy
        createdAt
        editedAt
        deletedAt
        price
        notes
        acceptedAt
        rejectedAt
        userByCreatedBy {
          id
          uid
          name
          avatarUrl
          lastSeen
        }
      }
    }
    userByCreatedBy {
      id
      name
      avatarUrl
      lastSeen
    }
  }
}
''';

  static String postCommentsByPostIdFirstAfterCurrentUserId = '''
query MyQuery(\$postId: Int!, \$first: Int = 1, \$after: Cursor, \$currentUserId: String!) {
  postComments(
    condition: { postId: \$postId, replyTo: null, deletedAt: null }
    orderBy: ID_DESC
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      postId
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      commentAttachmentsByCommentId {
        nodes {
          id
          commentId
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
      emoteByCurrentUserId: commentEmotesByCommentId(
        condition: { createdBy: \$currentUserId }
      ) {
        nodes {
          id
          code
        }
        totalCount
      }
      emotesByLike: commentEmotesByCommentId(
        condition: { code: "like" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByLove: commentEmotesByCommentId(
        condition: { code: "love" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByCare: commentEmotesByCommentId(
        condition: { code: "care" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByHaha: commentEmotesByCommentId(
        condition: { code: "haha" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByWow: commentEmotesByCommentId(
        condition: { code: "wow" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesBySad: commentEmotesByCommentId(
        condition: { code: "sad" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByAngry: commentEmotesByCommentId(
        condition: { code: "angry" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      postCommentsByReplyTo(condition: { deletedAt: null }) {
        totalCount
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

  static String postCommentsByReplyToFirstAfterCurrentUserId = '''
query MyQuery(\$replyTo: Int!, \$first: Int = 1, \$after: Cursor, \$currentUserId: String!) {
  postComments(
    condition: { replyTo: \$replyTo, deletedAt: null }
    orderBy: ID_DESC
    first: \$first
    after: \$after
  ) {
    nodes {
      id
      postId
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      commentAttachmentsByCommentId {
        nodes {
          id
          commentId
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
      emoteByCurrentUserId: commentEmotesByCommentId(
        condition: { createdBy: \$currentUserId }
      ) {
        nodes {
          id
          code
        }
        totalCount
      }
      emotesByLike: commentEmotesByCommentId(
        condition: { code: "like" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByLove: commentEmotesByCommentId(
        condition: { code: "love" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByCare: commentEmotesByCommentId(
        condition: { code: "care" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByHaha: commentEmotesByCommentId(
        condition: { code: "haha" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByWow: commentEmotesByCommentId(
        condition: { code: "wow" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesBySad: commentEmotesByCommentId(
        condition: { code: "sad" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      emotesByAngry: commentEmotesByCommentId(
        condition: { code: "angry" }
        first: 10
      ) {
        nodes {
          code
          userByCreatedBy {
            name
          }
        }
        totalCount
      }
      postCommentsByReplyTo(condition: { deletedAt: null }) {
        totalCount
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

  static String createPostEmoteByPostIdCreatedByCode = '''
mutation MyMutation(\$postId: Int!, \$createdBy: String!, \$code: String!) {
  createPostEmote(
    input: {
      postEmote: { postId: \$postId, createdBy: \$createdBy, code: \$code }
    }
  ) {
    postEmote {
      id
      postId
      createdBy
      createdAt
      editedAt
      code
      userByCreatedBy {
        id
        name
      }
    }
  }
}

''';

  static String updatePostEmoteByIdEditedAtCode = '''
mutation MyMutation(\$id: Int!, \$editedAt: Datetime!, \$code: String!) {
  updatePostEmote(
    input: { patch: { editedAt: \$editedAt, code: \$code }, id: \$id }
  ) {
    postEmote {
      id
      postId
      createdBy
      createdAt
      editedAt
      code
      userByCreatedBy {
        id
        name
      }
    }
  }
}
''';

  static String createPostComment = '''
mutation MyMutation(
  \$postId: Int!
  \$createdBy: String!
  \$replyTo: Int
  \$text: String
) {
  createPostComment(
    input: {
      postComment: {
        postId: \$postId
        createdBy: \$createdBy
        replyTo: \$replyTo
        text: \$text
      }
    }
  ) {
    postComment {
      id
      postId
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      replyTo
    }
  }
}
''';

  static String subscriptionPostEmotesByPostId = '''
subscription MySubscription(\$postId: Int!) {
  postEmotesByPostId(condition: {postId: \$postId}) {
    nodes {
      id
      postId
      createdBy
      code
      createdAt
    }
    totalCount
  }
}
''';

  static String updatePostCommentByIdPatch = '''
mutation MyMutation(\$id: Int!, \$patch: PostCommentPatch = {}) {
  updatePostComment(input: { id: \$id, patch: \$patch }) {
    postComment {
      id
      postId
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      replyTo
    }
  }
}
''';

  static String subscriptionPostCommentsByPostId = '''
subscription MySubscription(\$postId: Int!) {
  postEmotesByPostId(condition: {postId: \$postId}) {
    nodes {
      id
      postId
      createdBy
      code
      createdAt
    }
    totalCount
  }
}
''';

  static String postEmoteByPostIdAndCreatedBy = '''
query MyQuery(\$postId: Int!, \$createdBy: String!) {
  postEmoteByPostIdAndCreatedBy(createdBy: \$createdBy, postId: \$postId) {
    id
    postId
    createdBy
    createdAt
    code
  }
}
''';

  static String deletePostEmote = '''
mutation MyMutation(\$id: Int!) {
  deletePostEmote(input: { id: \$id }) {
    postEmote {
      id
      postId
      createdBy
      createdAt
      code
    }
  }
}
''';

  static String postEmotesByPostId = '''
query MyQuery(\$postId: Int!) {
  postEmotes(condition: { postId: \$postId }) {
    nodes {
      id
      postId
      createdBy
      createdAt
      code
      userByCreatedBy {
        id
        name
      }
    }
    totalCount
  }
}
''';

  static String commentEmotesByCommentId = '''
query MyQuery(\$commentId: Int!) {
  commentEmotes(condition: { commentId: \$commentId }) {
    nodes {
      id
      commentId
      createdBy
      createdAt
      code
      userByCreatedBy {
        id
        name
      }
    }
    totalCount
  }
}
''';

  static String commentEmotesV1 = '''
query MyQuery(\$commentId: Int!) {
  commentEmotesV1(condition: { commentId: \$commentId }) {
    emotesCount {
      angry
      care
      haha
      like
      love
      sad
      wow
    }
    hasCurrentUserId
    totalCount
  }
}
''';

  static String commentEmoteByCommentIdAndCreatedBy = '''
query MyQuery(\$commentId: Int!, \$createdBy: String!) {
  commentEmoteByCommentIdAndCreatedBy(
    createdBy: \$createdBy
    commentId: \$commentId
  ) {
    id
    commentId
    createdBy
    createdAt
    code
  }
}
''';

  static String createCommentEmote = '''
mutation MyMutation(\$commentId: Int!, \$createdBy: String!, \$code: String!) {
  createCommentEmote(
    input: {
      commentEmote: {
        commentId: \$commentId
        createdBy: \$createdBy
        code: \$code
      }
    }
  ) {
    commentEmote {
      id
      commentId
      createdBy
      createdAt
      code
    }
  }
}
''';

  static String deleteCommentEmote = '''
mutation MyMutation(\$id: Int!) {
  deleteCommentEmote(input: { id: \$id }) {
    commentEmote {
      id
      commentId
      createdBy
      createdAt
      code
    }
  }
}
''';

  static String createPostByCreatedByText = '''
mutation MyMutation(\$createdBy: String!, \$text: String) {
  createPost(input: { post: { createdBy: \$createdBy, text: \$text } }) {
    post {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      shipmentId
      userByCreatedBy {
        id
        uid
        name
        avatarUrl
        lastSeen
      }
    }
  }
}
''';

  static String createPostByCreatedByShipmentId = '''
mutation MyMutation(\$createdBy: String!, \$shipmentId: Int!) {
  createPost(
    input: { post: { createdBy: \$createdBy, shipmentId: \$shipmentId } }
  ) {
    post {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      shipmentId
    }
  }
}
''';

  static String updatePostByIdDeletedByDeleteAt = '''
mutation MyMutation(\$id: Int!, \$deletedBy: String!, \$deletedAt: Datetime!) {
  updatePost(
    input: { id: \$id, patch: { deletedBy: \$deletedBy, deletedAt: \$deletedAt } }
  ) {
    post {
      id
      deletedBy
      deletedAt
    }
  }
}
''';

  static String updatePostByIdEditedAtText = '''
mutation MyMutation(\$id: Int!, \$editedAt: Datetime!, \$text: String) {
  updatePost(input: { id: \$id, patch: { editedAt: \$editedAt, text: \$text } }) {
    post {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      text
      shipmentId
    }
  }
}
''';
}
