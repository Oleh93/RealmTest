//
//  ContactRealm.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 16.06.2022.
//

import Foundation
import RealmSwift

class ContactRealm: Object, RealmEntity {
    typealias EntityType = Contact

    @objc dynamic var name: String = ""
    @objc dynamic var number: String = ""

    var entity: Contact {
        return Contact(self)
    }

    init(name: String, number: String) {
        self.name = name
        self.number = number
    }
    
    required init(_ entity: Contact) {
        self.name = entity.name
        self.number = entity.number
    }

    override init() {
        super.init()
    }
}
