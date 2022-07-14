class ConversationQuery {
  static String conversationsByCurrentUser = '''
query MyQuery {
  currentUser {
    participants(condition: { deletedAt: null }) {
      nodes {
        conversation {
          id
          deletedAt
          participants(condition: { deletedAt: null }) {
            nodes {
              id
              conversationId
              userId
              deletedAt
            }
            totalCount
          }
        }
      }
      totalCount
    }
  }
}
''';

  static String conversationsByCurrentUserFirstAfter = '''
query MyQuery(\$first: Int = 1, \$after: Cursor) {
  currentUser {
    participants(
      orderBy: ID_DESC
      condition: { deletedAt: null }
      first: \$first
      after: \$after
    ) {
      nodes {
        conversation {
          id
          deletedAt
          title
          photoUrl
          description
          createdBy
          lastMessage {
            id
            conversationId
            createdBy
            createdAt
            deletedBy
            deletedAt
            text
            userByCreatedBy {
              id
              name
            }
          }
          participants(condition: { deletedAt: null }) {
            nodes {
              id
              conversationId
              userId
              deletedAt
              nickname
              user {
                id
                name
                avatarUrl
                lastSeen
              }
            }

            totalCount
          }
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
}
''';

  static String conversationById = '''
query MyQuery(\$id: String!) {
  conversation(id: \$id) {
    id
    createdBy
    createdAt
    editedBy
    editedAt
    deletedBy
    deletedAt
    title
    photoUrl
    description
    lastMessageId
    participants {
      nodes {
        id
        conversationId
        userId
        createdBy
        createdAt
        editedBy
        editedAt
        deletedBy
        deletedAt
        nickname
        role
        roleEditedBy
        roleEditedAt
        user {
          id
          name
          avatarUrl
          lastSeen
        }
      }
      totalCount
    }
    lastMessage {
      id
      conversationId
      createdBy
      createdAt
      deletedBy
      deletedAt
      text
      replyTo
      messageEmotes {
        nodes {
          id
          messageId
          createdBy
          createdAt
          code
        }
        totalCount
      }
    }
    messages {
      nodes {
        id
        conversationId
        createdBy
        createdAt
        deletedBy
        deletedAt
        text
        replyTo
        messageAttachments {
          nodes {
            id
            messageId
            fileUrl
            thumbUrl
            type
          }
          totalCount
        }
        messageByReplyTo {
          id
          conversationId
          createdBy
          createdAt
          deletedBy
          deletedAt
          text
          messageAttachments {
            nodes {
              id
              messageId
              fileUrl
              thumbUrl
              type
            }
            totalCount
          }
        }
        messageEmotes {
          nodes {
            id
            messageId
            createdBy
            createdAt
            code
          }
          totalCount
        }
      }
      totalCount
    }
  }
}
''';

  static String createConversationByIdCreatedBy = '''
mutation MyMutation(\$id: String!, \$createdBy: String!) {
  createConversation(
    input: { conversation: { id: \$id, createdBy: \$createdBy } }
  ) {
    conversation {
      id
      createdBy
      createdAt
    }
  }
}
''';

  static String createConversationByCreatedBy = '''
mutation MyMutation(\$createdBy: String!) {
  createConversation(
    input: { conversation: { createdBy: \$createdBy } }
  ) {
    conversation {
      id
      createdBy
      createdAt
    }
  }
}
''';

  static String createParticipantByConversationIdUserIdCreatedByRole = '''
mutation MyMutation(
  \$conversationId: String!
  \$userId: String!
  \$createdBy: String!
  \$role: String!
) {
  createParticipant(
    input: {
      participant: {
        conversationId: \$conversationId
        userId: \$userId
        createdBy: \$createdBy
        role: \$role
      }
    }
  ) {
    participant {
      id
      conversationId
      userId
      createdBy
      createdAt
    }
  }
}
''';

  static String messagesByConversationId = '''
query MyQuery(
  \$conversationId: String!
  \$last: Int = 15
  \$orderBy: [MessagesOrderBy!] = ID_ASC
) {
  messages(
    condition: { conversationId: \$conversationId }
    orderBy: \$orderBy
    last: \$last
  ) {
    nodes {
      id
      conversationId
      createdBy
      createdAt
      deletedBy
      deletedAt
      text
      replyTo
      messageAttachments {
        nodes {
          id
          messageId
          fileUrl
          thumbUrl
          type
        }
        totalCount
      }
      messageByReplyTo {
        id
        conversationId
        createdBy
        createdAt
        deletedBy
        deletedAt
        text
        messageAttachments {
          nodes {
            id
            messageId
            fileUrl
            thumbUrl
            type
          }
          totalCount
        }
      }
      messageEmotes {
        nodes {
          id
          messageId
          createdBy
          createdAt
          code
        }
        totalCount
      }
    }
    totalCount
  }
}

''';

  static String readUsersForContactsScreen = '''
query MyQuery {
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

  static String addMessageToConversation = '''
mutation MyMutation(
  \$conversationId: String!
  \$createdBy: String!
  \$text: String
  \$replyTo: Int
) {
  createMessage(
    input: {
      message: {
        conversationId: \$conversationId
        createdBy: \$createdBy
        text: \$text
        replyTo: \$replyTo
      }
    }
  ) {
    message {
      id
      conversationId
      createdBy
      createdAt
      text
      replyTo
    }
  }
}
 ''';

  static String subscriptionMessagesByConversationId = '''
subscription MySubscription(\$conversationId: String!, \$last: Int = 15, \$orderBy: [MessagesOrderBy!] = ID_ASC) {
  messagesByConversationId(
    condition: {conversationId: \$conversationId}
    orderBy: \$orderBy
    last: \$last
  ) {
    nodes {
      id
      createdBy
      createdAt
      deletedAt
      deletedBy
      text
      replyTo
      messageAttachments {
        nodes {
          id
          messageId
          fileUrl
          thumbUrl
          type
        }
      }
      messageEmotes {
        nodes {
          id
          messageId
          createdBy
          code
        }
      }
    }
  }
}
''';

  static String updateConversationByIdDeletedByDeletedAt = '''
mutation MyMutation(
  \$id: String!
  \$deletedBy: String!
  \$deletedAt: Datetime!
) {
  updateConversation(
    input: { patch: { deletedBy: \$deletedBy, deletedAt: \$deletedAt }, id: \$id }
  ) {
    conversation {
      id
      deletedBy
      deletedAt
    }
  }
}
''';

  static String updateConversationByIdTitleDescriptionEditedByEditedAt = '''
mutation MyMutation(
  \$id: String!
  \$title: String
  \$description: String
  \$editedBy: String!
  \$editedAt: Datetime!
) {
  updateConversation(
    input: {
      patch: {
        title: \$title
        description: \$description
        editedBy: \$editedBy
        editedAt: \$editedAt
      }
      id: \$id
    }
  ) {
    conversation {
      id
      title
      description
      editedBy
      editedAt
    }
  }
}
''';
}
