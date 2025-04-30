//
//  ContentView.swift
//  doomwatch Watch App
//
//  Created by Joey Tarnowski on 4/16/25.
//

import SwiftUI
import SpriteKit
import WatchKit

struct ContentView: View {
    @State private var crownValue = 0.0
    @State private var lastFiredDirection: Int = 0

    let doomScene = DoomScene(size: WKInterfaceDevice.current().screenBounds.size)
    @StateObject private var controller: DoomControlController

    init() {
        let tempCrown = State(initialValue: 0.0)
        _controller = StateObject(wrappedValue: DoomControlController(crownValue: tempCrown.projectedValue))
        _crownValue = tempCrown
    }

    var body: some View {
        ZStack {
            SpriteView(scene: doomScene)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            controller.handleTouch(at: value.location, screenSize: doomScene.size)
                        }
                        .onEnded { _ in
                            controller.releaseAllKeys()
                        }
                )
        }
        .focusable()
        .digitalCrownRotation(
            $crownValue,
            from: -1.0,
            through: 1.0,
            by: 0.005,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownValue) {
            if DG_IsMenuActive() != 0 {
                controller.handleMenuCrown(value: crownValue)
                crownValue = 0
            } else {
                controller.handleGameCrown(value: crownValue)
            }
        }
        .ignoresSafeArea()
    }
}
