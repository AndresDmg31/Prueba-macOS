//
//  FileProviderExtension.swift
//  PokemonFileProvider
//
//  Created by Andres Martinez gonzalez on 30/09/25.
//

import FileProvider
import UniformTypeIdentifiers
import Foundation

class FileProviderExtension: NSObject, NSFileProviderReplicatedExtension {
    
    let domainIdentifier: NSFileProviderDomainIdentifier

    required init(domain: NSFileProviderDomain) {
        self.domainIdentifier = domain.identifier
        super.init()
    }
    
    func invalidate() {
    }
    
    func item(for identifier: NSFileProviderItemIdentifier, request: NSFileProviderRequest, completionHandler: @escaping (NSFileProviderItem?, Error?) -> Void) -> Progress {
        if identifier == .rootContainer {
            let item = FileProviderItem(
                identifier: .rootContainer,
                parent: .rootContainer,
                filename: "Pokémon",
                isFolder: true
            )
            completionHandler(item, nil)  
            return Progress()
        }

        if identifier.rawValue == "folder:pokemon" {
            let item = FileProviderItem(
                identifier: NSFileProviderItemIdentifier("folder:pokemon"),
                parent: .rootContainer,
                filename: "Pokémon",
                isFolder: true
            )
            completionHandler(item, nil)
            return Progress()
        }

        if identifier.rawValue.hasPrefix("file:") {
            let name = String(identifier.rawValue.dropFirst("file:".count))
            let item = FileProviderItem(
                identifier: identifier,
                parent: NSFileProviderItemIdentifier("folder:pokemon"),
                filename: name,
                isFolder: false
            )
            completionHandler(item, nil)
            return Progress()
        }

        completionHandler(nil, NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil))
        return Progress()
    }
    
    func fetchContents(for itemIdentifier: NSFileProviderItemIdentifier, version requestedVersion: NSFileProviderItemVersion?, request: NSFileProviderRequest, completionHandler: @escaping (URL?, NSFileProviderItem?, Error?) -> Void) -> Progress {
        guard itemIdentifier.rawValue.hasPrefix("file:") else {
            completionHandler(nil, nil, nil)
            return Progress()
        }

        let filename = String(itemIdentifier.rawValue.dropFirst("file:".count))
        let item = FileProviderItem(
            identifier: itemIdentifier,
            parent: NSFileProviderItemIdentifier("folder:pokemon"),
            filename: filename,
            isFolder: false
        )

        let nameWithoutExt = filename.replacingOccurrences(of: ".txt", with: "")
        let text = "name: \(nameWithoutExt)\n"
        do {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("txt")
            try text.data(using: .utf8)?.write(to: tempURL)
            completionHandler(tempURL, item, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
        return Progress()
    }
    
    func createItem(basedOn itemTemplate: NSFileProviderItem, fields: NSFileProviderItemFields, contents url: URL?, options: NSFileProviderCreateItemOptions = [], request: NSFileProviderRequest, completionHandler: @escaping (NSFileProviderItem?, NSFileProviderItemFields, Bool, Error?) -> Void) -> Progress {
        // TODO: a new item was created on disk, process the item's creation
        
        completionHandler(itemTemplate, [], false, nil)
        return Progress()
    }
    
    func modifyItem(_ item: NSFileProviderItem, baseVersion version: NSFileProviderItemVersion, changedFields: NSFileProviderItemFields, contents newContents: URL?, options: NSFileProviderModifyItemOptions = [], request: NSFileProviderRequest, completionHandler: @escaping (NSFileProviderItem?, NSFileProviderItemFields, Bool, Error?) -> Void) -> Progress {
        // TODO: an item was modified on disk, process the item's modification
        
        completionHandler(nil, [], false, NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:]))
        return Progress()
    }
    
    func deleteItem(identifier: NSFileProviderItemIdentifier, baseVersion version: NSFileProviderItemVersion, options: NSFileProviderDeleteItemOptions = [], request: NSFileProviderRequest, completionHandler: @escaping (Error?) -> Void) -> Progress {
        
        completionHandler(NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:]))
        return Progress()
    }
    
    func enumerator(for containerItemIdentifier: NSFileProviderItemIdentifier, request: NSFileProviderRequest) throws -> NSFileProviderEnumerator {
        return FileProviderEnumerator(enumeratedItemIdentifier: containerItemIdentifier)
    }
}
