//
//  BarvaURL.swift
//  Barva.
//
//  Created by 김동겸 on 2022/09/06.
//

import Foundation

struct BarvaURL {
    
    //MARK: - 로그인
    static let loginURL = "http://3.34.183.110:3003/auth/login"
    
    //MARK: - 회원가입
    static let signupURL = "http://3.34.183.110:3003/auth/signup"
    static let nickCheckURL = "http://3.34.183.110:3003/auth/isExistNick"
    static let idCheckURL = "http://3.34.183.110:3003/auth/isExistId"
    static let sendMailURL = "http://3.34.183.110:3003/auth/sendMail"
    static let insepectMailURL = "http://3.34.183.110:3003/auth/authMail"
    
    //MARK: - 아이디, 비번 찾기
    static let idFindURL = "http://3.34.183.110:3003/auth/findId"
    static let pwFindURL = "http://3.34.183.110:3003/auth/findPw"
    static let updatePWURL = "http://3.34.183.110:3003/auth/updatePw"
    static let pwFindEmailURL = "http://3.34.183.110:3003/auth/findPwMail"
    
    
    //MARK: - 홈
    static let newestCheckerboardURL = "http://3.34.183.110:3003/sort/newestCheckerboard"
    static let newestSingleURL = "http://3.34.183.110:3003/sort/newestSingle"
    
    static let genderCheckerboardURL = "http://3.34.183.110:3003/sort/genderCheckerboard"
    static let genderSingleURL = "http://3.34.183.110:3003/sort/genderSingle"
    
    //MARK: - 업로드
    static let uploadPostURL = "http://3.34.183.110:3003/upload/uploadPost"
    

    //MARK: - 프로필
    static let profileURL = "http://3.34.183.110:3003/user/myProfile"
    
    static let setProfileImageURL = "http://3.34.183.110:3003/upload/setProfileImg"
    static let setProfileURL = "http://3.34.183.110:3003/user/setProfileIntro"
    
    static let userCheckerboardURL = "http://3.34.183.110:3003/user/userCheckerboard"
    static let userSingleURL = "http://3.34.183.110:3003/user/userSingle"
    
    static let storageImagesURL = ""

    static let othereUpImagesURL = ""
}
