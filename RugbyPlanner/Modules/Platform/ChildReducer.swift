//
//  ChildReducer.swift
//  RugbyPlanner
//
//  Created by Vyacheslav Khorkov on 07.05.2023.
//

import ComposableArchitecture

struct ChildReducer<Parent: ReducerProtocol, Child: ReducerProtocol> {
    let parent: Parent
    let child: Child
    let toChildState: WritableKeyPath<Parent.State, Child.State>
    let toChildAction: CasePath<Parent.Action, Child.Action>
    let file: StaticString
    let fileID: StaticString
    let line: UInt

    private func reduceChild(
        into state: inout Parent.State, action: Parent.Action
    ) -> EffectTask<Parent.Action> {
        guard let childAction = toChildAction.extract(from: action) else { return .none }
        return child.reduce(into: &state[keyPath: toChildState], action: childAction)
            .map { toChildAction.embed($0) }
    }
}

extension ChildReducer: ReducerProtocol {
    func reduce(
        into state: inout Parent.State, action: Parent.Action
    ) -> EffectTask<Parent.Action> {
        reduceChild(into: &state, action: action)
            .merge(with: parent.reduce(into: &state, action: action))
    }
}

extension ReducerProtocol {
    func child<WrappedState, WrappedAction, Wrapped: ReducerProtocol>(
        _ toWrappedState: WritableKeyPath<State, WrappedState>,
        action toWrappedAction: CasePath<Action, WrappedAction>,
        @ReducerBuilder<WrappedState, WrappedAction> then wrapped: () -> Wrapped,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) -> ChildReducer<Self, Wrapped> where WrappedState == Wrapped.State, WrappedAction == Wrapped.Action {
        ChildReducer(parent: self,
                     child: wrapped(),
                     toChildState: toWrappedState,
                     toChildAction: toWrappedAction,
                     file: file,
                     fileID: fileID,
                     line: line)
    }
}
