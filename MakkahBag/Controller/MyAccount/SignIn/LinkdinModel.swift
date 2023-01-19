//
//  LinkdinModel.swift
//  MakkahBag
//
//  Created by appleguru on 19/5/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

struct LinkedInConstants {
    
    static let CLIENT_ID = "866humi9vzbzk8"
    static let CLIENT_SECRET = "wSQTb3VizUR891g8"
    static let REDIRECT_URI = "https://johncodes.com/login/callback"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}

struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String

    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}


// MARK: - LinkedInProfileModel
struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let profilePicture: ProfilePicture
    let id: String
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String

    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
    }
}

// MARK: - ProfilePicture
struct ProfilePicture: Codable {
    let displayImage: DisplayImage

    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}
