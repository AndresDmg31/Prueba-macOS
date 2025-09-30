//
//  FileProviderItem.swift
//  PokemonFileProvider
//
//  Created by Andres Martinez gonzalez on 30/09/25.
//

import FileProvider
import UniformTypeIdentifiers

class FileProviderItem: NSObject, NSFileProviderItem {

    // TODO: implement an initializer to create an item from your extension's backing model
    // TODO: implement the accessors to return the values from your extension's backing model
    
    private let identifier: NSFileProviderItemIdentifier
    private let parentIdentifier: NSFileProviderItemIdentifier
    private let isDirectory: Bool
    private let name: String
    
    init(identifier: NSFileProviderItemIdentifier, parent: NSFileProviderItemIdentifier, filename: String, isFolder: Bool) {
        self.identifier = identifier
        self.parentIdentifier = parent
        self.name = filename
        self.isDirectory = isFolder
    }
    
    var itemIdentifier: NSFileProviderItemIdentifier { identifier }
    
    var parentItemIdentifier: NSFileProviderItemIdentifier { parentIdentifier }
    
    var capabilities: NSFileProviderItemCapabilities {
        return [.allowsReading]
    }
    
    var itemVersion: NSFileProviderItemVersion {
        NSFileProviderItemVersion(contentVersion: Data("1".utf8), metadataVersion: Data("1".utf8))
    }
    
    var filename: String { name }
    
    var contentType: UTType { isDirectory ? .folder : .plainText }
}
