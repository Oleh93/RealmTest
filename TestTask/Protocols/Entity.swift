//
//  Entity.swift
//  TestTask
//
//  Created by Oleh Mykytyn on 16.06.2022.
//

import Foundation

// implemented by domain structs
protocol Entity {
    associatedtype RealmEntityType

    init(_ realmEntity: RealmEntityType)
    var realmEntity: RealmEntityType { get }
}

// implemented by RealmSwift.Object subclasses
protocol RealmEntity {
    associatedtype EntityType

    init(_ entity: EntityType)
    var entity: EntityType { get }
}
