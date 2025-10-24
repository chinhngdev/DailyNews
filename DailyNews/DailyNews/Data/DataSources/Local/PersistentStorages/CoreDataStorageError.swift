//
//  CoreDataStorageError.swift
//  DailyNews
//
//  Created by Chinh on 9/16/25.
//

import Foundation

enum CoreDataStorageError: Error {
    case failedToLoadStore(Error)
    case failedToSave(Error)
    case failedToFetch(Error)
    case failedToDelete(Error)
    case failedToPerformTask(Error)
}
