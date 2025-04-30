//
//  doomController.swift
//  doomwatch Watch App
//
//  Created by Joey Tarnowski on 4/16/25.
//

import SwiftUI
import Foundation

class DoomControlController: ObservableObject {
    @Binding var crownValue: Double

    init(crownValue: Binding<Double>) {
        self._crownValue = crownValue
    }
    private var lastDirection: Int = 0
    private var isKeyHeld = false
    private var holdTimer: Timer?

    private var isInMenu: Bool = false
    func setMenuMode(value: Bool) {
        isInMenu = value
    }


    func handleMenuCrown(value: Double) {
        let threshold = 0.3
        let direction = value > threshold ? 1 : value < -threshold ? -1 : 0

        if direction != 0 && direction != lastDirection && !isKeyHeld {
            if direction == 1 {
                print("Menu: UP")
                print(value)
                DG_SetKey(0xad, true) // KEY_UPARROW
                self.crownValue = 0.0
            } else if direction == -1 {
                print("Menu: DOWN")
                DG_SetKey(0xaf, true) // KEY_DOWNARROW
                self.crownValue = 0.0
            }

            isKeyHeld = true
            lastDirection = direction

            // Release after delay
            holdTimer?.invalidate()
            holdTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                if direction == 1 {
                    DG_SetKey(0xad, false)
                    self.lastDirection = 0
                } else if direction == -1 {
                    DG_SetKey(0xaf, false)
                    self.lastDirection = 0
                }
                self.isKeyHeld = false
            }
        }
    }

    func handleGameCrown(value: Double) {
        let walkForward = value > 0.2 && value < 0.9
        let runForward = value >= 0.9
        let backward = value < -0.2

        if runForward {
            print("Game: RUN")
            DG_SetKey(0x80+0x36, true)
            DG_SetKey(0xad, true)
            DG_SetKey(0xaf, false)
        } else if walkForward {
            print("Game: WALK FORWARD")
            DG_SetKey(0x80+0x36, false)
            DG_SetKey(0xad, true)
            DG_SetKey(0xaf, false)
        } else if backward {
            print("Game: WALK BACKWARD")
            DG_SetKey(0x80+0x36, false)
            DG_SetKey(0xad, false)
            DG_SetKey(0xaf, true)
        } else {
            DG_SetKey(0x80+0x36, false)
            DG_SetKey(0xad, false)
            DG_SetKey(0xaf, false)
        }
    }

    // Touch Input
    private var activeTouches: [String: Int32] = [:]

    func handleTouch(at point: CGPoint, screenSize: CGSize) {
        let width = screenSize.width
        let height = screenSize.height

        guard point.y >= height * 0.1 else { return }

        var region: String?
        var key: Int32?

        if point.y < height * 0.6 {
            region = point.x < width * 0.5 ? "left" : "right"
            key = point.x < width * 0.5 ? 0xAC : 0xAE // left or right
        } else {
            if point.x < width * 0.3 {
                print("FIRE/BACK")
                region = "fire"
                key = isInMenu ? 0x7f : 0xa3 // BACKSPACE or FIRE
            } else if (point.x > width * 0.35) && (point.x < width * 0.65){
                print("PAUSE")
                region = "pause"
                key = 27
            }
            else {
                print("ACTION/ENTER")
                region = "action"
                key = isInMenu ? 13 : 0xa2 // ENTER or USE
            }
        }

        if let region = region, let key = key, activeTouches[region] != key {
            DG_SetKey(key, true)
            activeTouches[region] = key
        }
    }

    func releaseAllKeys() {
        for (region, key) in activeTouches {
            DG_SetKey(key, false)
        }
        activeTouches.removeAll()
    }
}
