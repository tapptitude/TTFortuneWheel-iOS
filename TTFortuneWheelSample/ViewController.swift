//
//  ViewController.swift
//  TTFortuneWheelSample
//
//  Created by Efraim Budusan on 10/31/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import UIKit
import TTFortuneWheel

class ViewController: UIViewController {

    @IBOutlet weak var spinningWheel: TTFortuneWheel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let slices = [ CarnivalWheelSlice.init(title: "Roller Coaster"),
                       CarnivalWheelSlice.init(title: "Try again"),
                       CarnivalWheelSlice.init(title: "Free\nticket"),
                       CarnivalWheelSlice.init(title: "Teddy\nbear"),
                       CarnivalWheelSlice.init(title: "Large popcorn"),
                       CarnivalWheelSlice.init(title: "Balloon figures"),
                       CarnivalWheelSlice.init(title: "Ferris Wheel"),
                       CarnivalWheelSlice.init(title: "Pony\nRide")]
        spinningWheel.slices = slices
        spinningWheel.in
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 0
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0: slice.style = .brickRed
            case 1: slice.style = .sandYellow
            case 2: slice.style = .babyBlue
            case 3: slice.style = .deepBlue
            default: slice.style = .brickRed
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rotateButton(_ sender: Any) {
        spinningWheel.startAnimating(fininshIndex: 1) { (finished) in
            print(finished)
        }
    }
}

