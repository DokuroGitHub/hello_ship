class ShipmentQuery {
  static String shipmentById = '''
query MyQuery(\$id: Int!) {
  shipment(id: \$id) {
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
    userByCreatedBy{
      id
      uid
      name
    	avatarUrl
      lastSeen
    }
  }
}
''';

  static String shipmentsByConditionFirstAfter = '''
query MyQuery(
  \$condition: ShipmentCondition
  \$first: Int = 1, 
  \$after: Cursor
  ) {
  shipments(
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
      userByCreatedBy {
        id
        uid
        name
        avatarUrl
        lastSeen
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

  static String shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter =
      '''
query MyQuery(
  \$currentUserId: String!
  \$condition: ShipmentCondition
  \$first: Int = 1
  \$after: Cursor
) {
  shipmentsByShipmentOffersByCurrentUserId(
    orderBy: ID_DESC
    currentUserId: \$currentUserId
    condition: \$condition
    first: \$first
    after: \$after
  ) {
    nodes {
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
      userByCreatedBy {
        id
        uid
        name
        avatarUrl
        lastSeen
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

  static String deleteShipmentOffer = '''
mutation MyMutation(\$id: Int!) {
  deleteShipmentOffer(input: { id: \$id }) {
    shipmentOffer {
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
    }
  }
}
''';

  static String createShipmentByCreatedByTypeServiceCodNotesPhoneStatus = '''
mutation MyMutation(
  \$createdBy: String!
  \$type: String!
  \$service: String!
  \$cod: Int
  \$notes: String
  \$phone: String
  \$status: String!
) {
  createShipment(
    input: {
      shipment: {
        createdBy: \$createdBy
        type: \$type
        service: \$service
        cod: \$cod
        notes: \$notes
        phone: \$phone
        status: \$status
      }
    }
  ) {
    shipment {
      id
      createdBy
      createdAt
      editedAt
      deletedAt
      type
      service
      cod
      notes
      phone
      status
      acceptedOfferId
    }
  }
}
''';

  static String
      createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation =
      '''
mutation MyMutation(
  \$shipmentId: Int!
  \$details: String
  \$street: String
  \$district: String
  \$city: String
  \$location: PointInput
) {
  createShipmentAddressFrom(
    input: {
      shipmentAddressFrom: {
        shipmentId: \$shipmentId
        details: \$details
        street: \$street
        district: \$district
        city: \$city
        location: \$location
      }
    }
  ) {
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
  }
}
''';

  static String
      createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation = '''
mutation MyMutation(
  \$shipmentId: Int!
  \$details: String
  \$street: String
  \$district: String
  \$city: String
  \$location: PointInput
) {
  createShipmentAddressTo(
    input: {
      shipmentAddressTo: {
        shipmentId: \$shipmentId
        details: \$details
        street: \$street
        district: \$district
        city: \$city
        location: \$location
      }
    }
  ) {
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
  }
}
''';

  static String createShipmentOffer = '''
mutation MyMutation(
  \$shipmentId: Int!
  \$createdBy: String!
  \$price: Int
  \$notes: String
) {
  createShipmentOffer(
    input: {
      shipmentOffer: {
        shipmentId: \$shipmentId
        createdBy: \$createdBy
        price: \$price
        notes: \$notes
      }
    }
  ) {
    shipmentOffer {
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
}
''';

  static String shipmentOffersByShipmentId = '''
query MyQuery(\$shipmentId: Int!) {
  shipmentOffers(condition: { shipmentId: \$shipmentId }, orderBy: ID_DESC) {
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
      userByCreatedBy{
        id
        uid
        avatarUrl
        name
        lastSeen
      }
    }
    totalCount
  }
}
''';

  static String shipmentOffersByCreatedByFirstAfter = '''
query MyQuery(\$createdBy: String!, \$first: Int = 1, \$after: Cursor) {
  shipmentOffers(
    orderBy: ID_DESC
    condition: { createdBy: \$createdBy, deletedAt: null }
    first: \$first
    after: \$after
  ) {
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
      userByCreatedBy{
        id
        uid
        avatarUrl
        name
        lastSeen
      }
    }
    totalCount
  }
}
''';

  static String updateShipmentOfferByIdPriceNotesEditedAt = '''
mutation MyMutation(
  \$id: Int!
  \$price: Int
  \$notes: String
  \$editedAt: Datetime!
) {
  updateShipmentOffer(
    input: {
      patch: { notes: \$notes, price: \$price, editedAt: \$editedAt }
      id: \$id
    }
  ) {
    shipmentOffer {
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
}
''';

  static String updateShipmentOfferByIdAcceptedAt = '''
mutation MyMutation(\$id: Int!, \$acceptedAt: Datetime) {
  updateShipmentOffer(input: { patch: { acceptedAt: \$acceptedAt }, id: \$id }) {
    shipmentOffer {
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
    }
  }
}
''';

  static String updateShipmentOfferByIdRejectedAt = '''
mutation MyMutation(\$id: Int!, \$rejectedAt: Datetime) {
  updateShipmentOffer(input: { patch: { acceptedAt: null, rejectedAt: \$rejectedAt }, id: \$id }) {
    shipmentOffer {
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
}
''';

  static String shipmentOffersByShipmentIdSearch = '''
query MyQuery(\$shipmentId: Int!, \$search: String = "") {
  shipmentOffersByShipmentIdSearch(shipmentId: \$shipmentId, search: \$search) {
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
        uid
        avatarUrl
        lastSeen
        name
        phone
      }
    }
    totalCount
  }
}
''';

  static String updateShipmentByIdCodNotesPhoneEditedAt = '''
mutation MyMutation(
  \$id: Int!
  \$cod: Int
  \$notes: String
  \$phone: String
  \$editedAt: Datetime
) {
  updateShipment(
    input: {
      patch: { cod: \$cod, notes: \$notes, phone: \$phone, editedAt: \$editedAt }
      id: \$id
    }
  ) {
    shipment {
      id
      cod
      notes
      phone
      editedAt
    }
  }
}
''';

  static String updateShipmentByIdDeletedAt = '''
mutation MyMutation(
  \$id: Int!
  \$deletedAt: Datetime
) {
  updateShipment(
    input: {
      patch: { deletedAt: \$deletedAt }
      id: \$id
    }
  ) {
    shipment {
      id
      deletedAt
    }
  }
}
''';

  static String updateShipmentByIdStatus = '''
mutation MyMutation(
  \$id: Int!
  \$status: String
) {
  updateShipment(
    input: {
      patch: { status: \$status }
      id: \$id
    }
  ) {
    shipment {
      id
      status
    }
  }
}
''';

  static String shipmentOffersByShipmentIdFirst = '''
subscription MySubscription(\$shipmentId: Int!, \$first: Int = 1) {
  shipmentOffersByShipmentId(
    condition: { shipmentId: \$shipmentId }
    first: \$first
    orderBy: ID_DESC
  ) {
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
    }
    totalCount
  }
}
''';
}
