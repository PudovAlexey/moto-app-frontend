// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

public struct Query: GraphQLQuery {
  public static let operationName: String = "Query"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Query($search: GetMyContactInput!) { getContact(search: $search) { __typename id isMyContact name } }"#
    ))

  public var search: GetMyContactInput

  public init(search: GetMyContactInput) {
    self.search = search
  }

  @_spi(Unsafe) public var __variables: Variables? { ["search": search] }

  public struct Data: MotoApi.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { MotoApi.Objects.Query }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("getContact", [GetContact].self, arguments: ["search": .variable("search")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      Query.Data.self
    ] }

    public var getContact: [GetContact] { __data["getContact"] }

    /// GetContact
    ///
    /// Parent Type: `GetMyContactResponse`
    public struct GetContact: MotoApi.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { MotoApi.Objects.GetMyContactResponse }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", String.self),
        .field("isMyContact", Bool.self),
        .field("name", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        Query.Data.GetContact.self
      ] }

      /// id
      public var id: String { __data["id"] }
      public var isMyContact: Bool { __data["isMyContact"] }
      /// name
      public var name: String { __data["name"] }
    }
  }
}
