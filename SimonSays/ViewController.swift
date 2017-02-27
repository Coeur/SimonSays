//
//  ViewController.swift
//  SimonSays
//
//  Created by Antoine Cœur on 20/02/2017.
//  Copyright © 2017 Cœur. All rights reserved.
//

import UIKit

/// this class demonstrates a Simon Game made in one hour with only a minimum of knowledge of Swift
class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    
    var sequenceToPlay: [Int] = []
    var currentTap: Int = 0
    var indexToPlay: Int = 0
    
    @IBAction func startAction(_ sender: Any) {
        sequenceToPlay = []
        extendSequenceToPlay()
    }
    
    func extendSequenceToPlay() {
        sequenceToPlay.append(Int(arc4random_uniform(4)))
        currentTap = 0
        playMySequence()
    }
    
    func playMySequence() {
        if sequenceToPlay.count <= indexToPlay {
            // nothing more to play
            indexToPlay = 0
            return
        }
        let index = sequenceToPlay[indexToPlay]
        animateAndMakeSound(button: button(forIndex: index), completion: { _ in
            self.indexToPlay += 1
            self.playMySequence()
        })
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        if currentTap >= sequenceToPlay.count {
            // game not started
            playSound("game_over.wav")
            return
        }
        
        let tapIndex = index(forButton: sender)
        if sequenceToPlay[currentTap] == tapIndex {
            // success
            currentTap += 1
            animateAndMakeSound(button: sender, completion: { _ in
                if self.currentTap == self.sequenceToPlay.count {
                    self.extendSequenceToPlay()
                }
            })
        } else {
            // wrong
            playSound("game_over.wav")
            scoreLabel.text = "score: \(sequenceToPlay.count)"
            sequenceToPlay = []
        }
    }

    func animateAndMakeSound(button: UIButton, completion: ((Bool) -> Void)? = nil) {
        // init state
        button.alpha = 0
        UIView.animate(withDuration: 0.75, animations: {
            // end state
            button.alpha = 1
        }, completion: completion)
        // playing a sound
        playSound("tone\(index(forButton: button) + 1).wav")
    }
    
    /// returns index of button
    func index(forButton: UIButton) -> Int {
        switch forButton {
        case bottomLeftButton:
            return 0
        case bottomRightButton:
            return 1
        case topRightButton:
            return 2
        case topLeftButton:
            return 3
        default:
            fatalError()
        }
    }
    
    /// returns button for index
    func button(forIndex: Int) -> UIButton {
        switch forIndex {
        case 0:
            return bottomLeftButton
        case 1:
            return bottomRightButton
        case 2:
            return topRightButton
        case 3:
            return topLeftButton
        default:
            fatalError()
        }
    }
}

import AVFoundation
var audioPlayer: AVAudioPlayer!
/// quick and dirty way to play a sound
func playSound(_ nameOfAudioFile: String) {
    let soundURL = Bundle.main.url(forResource: nameOfAudioFile, withExtension: nil, subdirectory: "audio")!
    audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
    try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    try! AVAudioSession.sharedInstance().setActive(true)
    audioPlayer.play()
}
