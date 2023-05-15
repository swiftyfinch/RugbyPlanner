//
//  RugbyPlannerApp.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import SwiftUI

@main
struct RugbyPlannerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView(
                store: .init(
                    initialState: .init(
                        projectNavigator: .init(),
                        plansEditor: .init()
                    ),
                    reducer: MainReducer()
                )
            )
            .navigationTitle("")
            .preferredColorScheme(.dark)
        }
    }
}
