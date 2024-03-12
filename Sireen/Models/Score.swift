//
//  Score.swift
//  Sireen
//
//  Created by Allan Prieb on 3/10/24.
//

import Foundation
import UIKit

struct Score: Decodable {
    let userName: String
    let userScore: String
    let userProfileImageName: String
    let userPosition: String

    var userProfile: UIImage? {
            return UIImage(named: userProfileImageName)
        }
    
}

extension Score {
    static var mockScores: [Score] = [
        //Score(userName: "Lauren A",     userScore: "8945", userProfileImageName: "userPicture-1",   userPosition: "1"),
        //Score(userName: "Raidel C",     userScore: "8731", userProfileImageName: "userPicture-2",   userPosition: "2"),
        //Score(userName: "Dabian L",     userScore: "8729", userProfileImageName: "userPicture-3",   userPosition: "3"),
        Score(userName: "Logan R",      userScore: "8394", userProfileImageName: "userPicture-4",   userPosition: "4"),
        Score(userName: "Vanessa S",    userScore: "8193", userProfileImageName: "userPicture-5",   userPosition: "5"),
        Score(userName: "Allan P",      userScore: "8029", userProfileImageName: "userPicture-6",   userPosition: "6"),
        Score(userName: "Brianna P",    userScore: "8003", userProfileImageName: "userPicture-7",   userPosition: "7"),
        Score(userName: "Daniel C",     userScore: "7840", userProfileImageName: "userPicture-8",   userPosition: "8"),
        Score(userName: "Dhruvi P",     userScore: "7762", userProfileImageName: "userPicture-9",   userPosition: "9"),
        Score(userName: "Alan R",       userScore: "7309", userProfileImageName: "userPicture-10",  userPosition: "10"),
        Score(userName: "David U",      userScore: "7239", userProfileImageName: "userPicture-11",  userPosition: "11"),
        Score(userName: "Ngoc N",       userScore: "7104", userProfileImageName: "userPicture-12",  userPosition: "12"),
        Score(userName: "Leah H",       userScore: "7078", userProfileImageName: "userPicture-13",  userPosition: "13"),
        Score(userName: "Miguel A",     userScore: "6930", userProfileImageName: "userPicture-14",  userPosition: "14"),
        Score(userName: "Jose P",       userScore: "6874", userProfileImageName: "userPicture-15",  userPosition: "15"),
        Score(userName: "Kyla B",       userScore: "6732", userProfileImageName: "userPicture-16",  userPosition: "16"),
        Score(userName: "Lexi V",       userScore: "6520", userProfileImageName: "userPicture-17",  userPosition: "17"),
        Score(userName: "Carlos T",     userScore: "6340", userProfileImageName: "userPicture-18",  userPosition: "18"),
        Score(userName: "Daniel J",     userScore: "6320", userProfileImageName: "userPicture-19",  userPosition: "19"),
        Score(userName: "Bryan C",      userScore: "6104", userProfileImageName: "userPicture-20",  userPosition: "20"),
        Score(userName: "Mohammed",     userScore: "6053", userProfileImageName: "userPicture-21",  userPosition: "21"),
        Score(userName: "Trace W",      userScore: "5999", userProfileImageName: "userPicture-22",  userPosition: "22"),
        Score(userName: "Manny C",      userScore: "5735", userProfileImageName: "userPicture-23",  userPosition: "23"),
        Score(userName: "Pablo R",      userScore: "5656", userProfileImageName: "userPicture-24",  userPosition: "24"),
        Score(userName: "Fernando S",   userScore: "5274", userProfileImageName: "userPicture-25",  userPosition: "25")
    ]
}
