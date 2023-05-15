//
//  PlansEditorView.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import CodeEditTextView
import ComposableArchitecture
import SwiftUI

struct PlansEditorView: View {
    let store: StoreOf<PlansEditorReducer>

    @State private var content = ""
    @State private var cursorPosition: (Int, Int) = (0, 0)

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            editorView(viewStore: viewStore)
            .toolbar {
                toolbar(viewStore: viewStore)
            }
        }
    }

    private func editorView(
        viewStore: ViewStore<PlansEditorReducer.State, PlansEditorReducer.Action>
    ) -> some View {
        Group {
            switch viewStore.content {
            case .empty:
                Color.clear
            case let .error(error):
                Color.clear
                    .alert(
                        error.beautifulDescription,
                        isPresented: .constant(true),
                        actions: {
                            Button("OK", role: .cancel, action: { viewStore.send(.hideAlert) })
                        }
                    )
            case let .ready(url, content, _):
                CodeEditTextView(
                    viewStore.binding(get: { _ in content }, send: { .updateContent(url, $0) }),
                    language: .yaml,
                    theme: .init(
                        text: NSColor(white: 1, alpha: 0.85),
                        insertionPoint: .white,
                        invisibles: .init(hex: 0x424d5b).withAlphaComponent(0.33),
                        background: .init(hex: 0x1c1c20),
                        lineHighlight: NSColor.white.withAlphaComponent(0.08),
                        selection: NSColor.white.withAlphaComponent(0.08),
                        keywords: .init(hex: 0xc9538c),
                        commands: .red, // Not used
                        types: .red, // Not used
                        attributes: .red, // Not used
                        variables: .init(hex: 0xc9538c),
                        values: .red, // Not used
                        numbers: .init(hex: 0xd18770),
                        strings: .init(hex: 0x679c76),
                        characters: .red, // Not used
                        comments: .init(hex: 0x5c697f)
                    ),
                    font: .monospacedSystemFont(ofSize: 15, weight: .regular),
                    tabWidth: 2,
                    indentOption: .spaces(count: 2),
                    lineHeight: 1.2,
                    wrapLines: false,
                    cursorPosition: $cursorPosition
                )
                // minHeight zero fixes a bug where the app would freeze if the contents of the file are empty.
                .frame(minHeight: .zero)
            }
        }
    }

    private func toolbar(
        viewStore: ViewStore<PlansEditorReducer.State, PlansEditorReducer.Action>
    ) -> some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            if viewStore.selectedPlan != nil, let plans = viewStore.plans {
                if !plans.isEmpty {
                    Picker(
                        selection: viewStore.binding(
                            get: \.selectedPlanId,
                            send: { .selectPlan($0) }
                        ),
                        content: {
                            ForEach(plans) {
                                Text($0.name)
                            }
                        },
                        label: {}
                    )
                    .help("Select plan")
                } else {
                    Button(action: {}) {
                        Image(systemName: "exclamationmark.triangle.fill").imageScale(.medium)
                        Text("No plans")
                    }
                    .disabled(true)
                }
            }
        }
    }
}
