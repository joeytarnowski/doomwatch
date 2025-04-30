//
//  MenuModePoller.swift
//  doomwatch Watch App
//
//  Created by Joey Tarnowski on 4/16/25.
//
//  Checks at regular intervals of .1 seconds if the game is in the menu
//  and switches the fire/action controls to correspond. Probably a better
//  way to do this but I'm too lazy to deep-dive into it :)

import Foundation
import Combine

class MenuModePoller: ObservableObject {
    @Published var isMenuActive: Bool = DG_IsMenuActive() != 0

    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let current = DG_IsMenuActive() != 0
            if current != self.isMenuActive {
                DispatchQueue.main.async {
                    self.isMenuActive = current
                }
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
