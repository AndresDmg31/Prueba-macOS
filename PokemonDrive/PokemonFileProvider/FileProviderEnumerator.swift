//
//  FileProviderEnumerator.swift
//  PokemonFileProvider
//
//  Created by Andres Martinez gonzalez on 30/09/25.
//

import FileProvider
import Foundation

class FileProviderEnumerator: NSObject, NSFileProviderEnumerator {
    
    private let enumeratedItemIdentifier: NSFileProviderItemIdentifier
    private let anchor = NSFileProviderSyncAnchor("anchor-1".data(using: .utf8)!)
    
    init(enumeratedItemIdentifier: NSFileProviderItemIdentifier) {
        self.enumeratedItemIdentifier = enumeratedItemIdentifier
        super.init()
    }

    func invalidate() {
        // TODO: perform invalidation of server connection if necessary
    }

    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        if enumeratedItemIdentifier == .rootContainer {
            let folderItem = FileProviderItem(
                identifier: NSFileProviderItemIdentifier("folder:pokemon"),
                parent: .rootContainer,
                filename: "Pokémon",
                isFolder: true
            )
            observer.didEnumerate([folderItem])
            observer.finishEnumerating(upTo: nil)
            return
        }

        if enumeratedItemIdentifier.rawValue == "folder:pokemon" {
            PokemonAPI.shared.fetchPokemonList(limit: 151) { result in
                switch result {
                case .success(let names):
                    let items: [FileProviderItem] = names.map { name in
                        let filename = "\(name).txt"
                        return FileProviderItem(
                            identifier: NSFileProviderItemIdentifier("file:\(filename)"),
                            parent: NSFileProviderItemIdentifier("folder:pokemon"),
                            filename: filename,
                            isFolder: false
                        )
                    }
                    observer.didEnumerate(items)
                    observer.finishEnumerating(upTo: nil)
                case .failure:
                    let cached = PokemonAPI.shared.cachedPokemonNames()
                    if cached.isEmpty == false {
                        let items: [FileProviderItem] = cached.map { name in
                            let filename = "\(name).txt"
                            return FileProviderItem(
                                identifier: NSFileProviderItemIdentifier("file:\(filename)"),
                                parent: NSFileProviderItemIdentifier("folder:pokemon"),
                                filename: filename,
                                isFolder: false
                            )
                        }
                        observer.didEnumerate(items)
                    }
                    observer.finishEnumerating(upTo: nil)
                }
            }
            return
        }

        observer.finishEnumerating(upTo: nil)
    }
    
    func enumerateChanges(for observer: NSFileProviderChangeObserver, from anchor: NSFileProviderSyncAnchor) {
        /* TODO:
         - query the server for updates since the passed-in sync anchor
         
         If this is an enumerator for the active set:
         - note the changes in your local database
         
         - inform the observer about item deletions and updates (modifications + insertions)
         - inform the observer when you have finished enumerating up to a subsequent sync anchor
         */
        observer.finishEnumeratingChanges(upTo: anchor, moreComing: false)
    }

    func currentSyncAnchor(completionHandler: @escaping (NSFileProviderSyncAnchor?) -> Void) {
        completionHandler(anchor)
    }
}
