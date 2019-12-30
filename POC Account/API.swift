//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UserProfileQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query UserProfile {
      userProfile(userId: 1) {
        __typename
        userId
        firstName
        lastName
      }
    }
    """

  public let operationName = "UserProfile"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("userProfile", arguments: ["userId": 1], type: .nonNull(.object(UserProfile.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(userProfile: UserProfile) {
      self.init(unsafeResultMap: ["__typename": "Query", "userProfile": userProfile.resultMap])
    }

    public var userProfile: UserProfile {
      get {
        return UserProfile(unsafeResultMap: resultMap["userProfile"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "userProfile")
      }
    }

    public struct UserProfile: GraphQLSelectionSet {
      public static let possibleTypes = ["UserProfile"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("userId", type: .nonNull(.scalar(Int.self))),
        GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
        GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(userId: Int, firstName: String, lastName: String) {
        self.init(unsafeResultMap: ["__typename": "UserProfile", "userId": userId, "firstName": firstName, "lastName": lastName])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var userId: Int {
        get {
          return resultMap["userId"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "userId")
        }
      }

      public var firstName: String {
        get {
          return resultMap["firstName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String {
        get {
          return resultMap["lastName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastName")
        }
      }
    }
  }
}
