//
//  Contact.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 16.06.2022.
//

import Foundation

struct Contact: Entity, Decodable {
    typealias RealmEntityType = ContactRealm

    let name: String
    let number: String

    var realmEntity: ContactRealm {
        return ContactRealm(self)
    }

    init(_ realmEntity: ContactRealm) {
        self.name = realmEntity.name
        self.number = realmEntity.number
    }
}

extension Contact {
    var firstNameLetter: String? {
        return name.first?.uppercased()
    }
}
