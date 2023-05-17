//
//  AppDelegate.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        setupMenu()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private func setupMenu() {
        if let mainMenu = NSApp.mainMenu {
            let app = mainMenu.item(withTitle: "RugbyPlanner")
            let about = app?.submenu?.item(withTitle: "About RugbyPlanner").map {
                NSMenuItem(title: $0.title, action: $0.action, keyEquivalent: $0.keyEquivalent)
            }
            let quit = app?.submenu?.item(withTitle: "Quit RugbyPlanner").map {
                NSMenuItem(title: $0.title, action: $0.action, keyEquivalent: $0.keyEquivalent)
            }
            let submenu = NSMenu()
            submenu.items = [about, NSMenuItem.separator(), quit].compactMap { $0 }
            app?.submenu = submenu

            ["File", "View", "Help"].forEach { name in
                mainMenu.item(withTitle: name).map { mainMenu.removeItem($0) }
            }
        }
    }
}
