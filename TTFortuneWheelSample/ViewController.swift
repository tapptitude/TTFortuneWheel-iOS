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
        let slices = [ FortuneWheelSlice.init(title: "Win and lose!"),
                       FortuneWheelSlice.init(title: "Horray"),
                       FortuneWheelSlice.init(title: "Super Premiu"),
                       FortuneWheelSlice.init(title: "Bam bam"),
                       FortuneWheelSlice.init(title: "Cool!"),
                       FortuneWheelSlice.init(title: "Bam bam bam bam"),
                       FortuneWheelSlice.init(title: "Try again tomorrow!"),
                       FortuneWheelSlice.init(title: "This is your lucky day!")]
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! FortuneWheelSlice
            let offset = pair.offset
            slice.style = offset % 2 == 1 ? .dark : .light
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rotateButton(_ sender: Any) {
        spinningWheel.startAnimating(rotationCompletionOffset: 45.0, { (finished) in
            print(finished)
        })
    }
}

