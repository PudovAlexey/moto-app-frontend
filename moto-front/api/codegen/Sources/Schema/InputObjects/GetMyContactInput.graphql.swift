// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

public struct GetMyContactInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    searchField: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "search_field": searchField
    ])
  }

  /// is_success
  public var searchField: GraphQLNullable<String> {
    get { __data["search_field"] }
    set { __data["search_field"] = newValue }
  }
}
