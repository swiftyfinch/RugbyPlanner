//
//  NSApplication+ToggleSidebar.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import AppKit

extension NSApplication {
    static func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        let selector = #selector(NSSplitViewController.toggleSidebar(_:))
        firstResponder.tryToPerform(selector, with: nil)
    }
}
