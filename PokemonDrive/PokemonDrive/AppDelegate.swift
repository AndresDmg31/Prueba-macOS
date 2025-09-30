//
//  AppDelegate.swift
//  PokemonDrive
//
//  Created by Andres Martinez gonzalez on 30/09/25.
//

import Cocoa
import FileProvider

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenuBar()
        // Insert code here to initialize your application
    }
    
    func setupMenuBar() {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
            if let button = statusItem?.button {
                button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "Pokémon Drive")
            }
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Conectar", action: #selector(connectDomain), keyEquivalent: "c"))
            menu.addItem(NSMenuItem(title: "Desconectar", action: #selector(disconnectDomain), keyEquivalent: "d"))
            menu.addItem(NSMenuItem(title: "Refrescar lista", action: #selector(refreshList), keyEquivalent: "r"))
            statusItem?.menu = menu
        }
        
        @objc func connectDomain() {
            let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier("pokemon"), displayName: "Pokémon Drive")
            NSFileProviderManager.add(domain) { error in
                if let error = error {
                    print("Error al agregar: \(error.localizedDescription)")
                } else {
                    print("Agregado correctamente")
                }
            }
        }
        
        @objc func disconnectDomain() {
            let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier("pokemon"), displayName: "Pokémon Drive")
            NSFileProviderManager.remove(domain) { error in
                if let error = error {
                    print("Error al remover: \(error.localizedDescription)")
                } else {
                    print("Removido correctamente")
                }
            }
        }
        
        @objc func refreshList() {
            let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier("pokemon"), displayName: "Pokémon Drive")
            guard let manager = NSFileProviderManager(for: domain) else {
                print("No se pudo obtener")
                return
            }
            manager.signalEnumerator(for: NSFileProviderItemIdentifier.rootContainer) { error in
                if let error = error {
                    print("Error al refrescar: \(error.localizedDescription)")
                } else {
                    print("Lista refrescada")
                }
            }
        }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

