//
//  CoreData.swift
//  wallabag
//
//  Created by maxime marinel on 27/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import CoreData

final class CoreData {

    static var containerName: String?
    static let shared: CoreData = CoreData()
    var errorHandler: (Error) -> Void = {_ in }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreData.containerName!)
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                self?.errorHandler(error)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }

    func fetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        return (try? viewContext.fetch(request)) ?? []
    }

    func backgroundFetch<T>(_ request: NSFetchRequest<T>) -> [T] {
        return (try? backgroundContext.fetch(request)) ?? []
    }

    func deleteAll(_ entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        try! viewContext.execute(NSBatchDeleteRequest(fetchRequest: request))
    }
}
