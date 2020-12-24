//
//  SoundPlayer.swift
//  WorkoutTimer
//
//  Created by Mykhaylo Levchuk on 19/12/2020.
//  Copyright © 2020 Mykhaylo Levchuk. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundPlayable {
    mutating func playSound(of type: SoundType)
}

struct SoundPlayer: SoundPlayable {
    private let bundlePath = Bundle.main.bundlePath
    private var player: AVAudioPlayer?
        
    mutating func playSound(of type: SoundType) {
        let soundPath = Bundle.main.path(forResource: type.path, ofType: nil)!
        let url = URL(fileURLWithPath: soundPath)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error as NSError {
            print(#file, error)
        }
    }
}

enum SoundType {
    case tick
    case deepTick
    
    var path: String {
        switch self {
        case .tick: return tickFileName
        case .deepTick: return deepTickFileName
        }
    }

    private var tickFileName: String { "tick.mp3" }
    private var deepTickFileName: String { "deepTick.mp3" }
}
