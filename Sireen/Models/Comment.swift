//
//  Comment.swift
//  PawsAndFound
//
//  Created by Ernesto Alva on 11/13/23.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var comment: String?
    var user: User?
    var post: Post?
    //var profilePic: ParseFile?
}
