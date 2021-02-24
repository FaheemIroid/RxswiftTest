//
//  DataModel.swift
//  MvvmWithRxSwift
//
//  Created by MacBook on 23/02/21.
//

import Foundation

struct DataModel : Decodable {
    var status : Bool?
    var name : String?
    var email : String?
    var token : String?
    var message : String?
}
