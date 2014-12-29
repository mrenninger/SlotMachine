//
//  ViewController.swift
//  SlotMachine
//
//  Created by Michael Renninger on 11/24/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Properties
    var container1: UIView!
    var container2: UIView!
    var container3: UIView!
    var container4: UIView!
    
    var titleLbl:UILabel!
    
    // Information Labels
    var creditsLbl:UILabel!
    var betLbl:UILabel!
    var winnerPaidLbl:UILabel!
    var creditsTitleLbl:UILabel!
    var betTitleLbl:UILabel!
    var winnerPaidTitleLbl:UILabel!
    
    // Buttons
    var resetBtn:UIButton!
    var betOneBtn:UIButton!
    var betMaxBtn:UIButton!
    var spinBtn:UIButton!
    
    var slots:[[Slot]] = []
    
    var credits = 0
    var curBet = 0
    var winnings = 0
    
    // Constants
    let MARGIN_VIEW:CGFloat = 10.0
    let MARGIN_SLOT:CGFloat = 2.0
    
    let SIXTH:CGFloat = 1.0/6.0
    let THIRD:CGFloat = 1.0/3.0
    let HALF:CGFloat = 1.0/2.0
    let EIGHTH:CGFloat = 1.0/8.0
    
    let NUM_CONTAINERS = 3
    let NUM_SLOTS = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpContainerViews()
        
        setupContainer1(self.container1)
        setupContainer3(self.container3)
        setupContainer4(self.container4)
        
        hardReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // IBActions
    func onResetBtnPressed(btn:UIButton) {
        //println("onResetBtnPressed")
        hardReset()
    }

    func onBetOneBtnPressed(btn:UIButton) {
        //println("onBetOneBtnPressed")
        if credits == 0 {
            showAlertWithText(header: "No More Credits", msg: "Reset Game")
        } else {
            if curBet < 5 {
                curBet += 1
                credits -= 1
                updateMainView()
            } else {
                showAlertWithText(msg: "You can only bet 5 credits at a time")
            }
        }
    }
    
    func onBetMaxBtnPressed(btn:UIButton) {
        //println("onBetMaxBtnPressed")
        if credits < 5 {
            showAlertWithText(header: "Not Enough Credits", msg: "Bet Less")
        } else {
            if curBet < 5 {
                var diff = 5 - curBet
                curBet += diff
                credits -= diff
                updateMainView()
            } else {
                showAlertWithText(msg: "You can only bet 5 credits at a time")
            }
        }
        
    }
    
    func onSpinBtnPressed(btn:UIButton) {
        //println("onSpinBtnPressed")
        self.removeSlotImageViews()
        slots = Factory.createSlots()
        setupContainer2(self.container2)
        
        var winningsMultiplier = SlotBrain.calculateWinnings(slots)
        winnings = winningsMultiplier * curBet
        credits += winnings
        curBet = 0
        updateMainView()
    }
    
    
    
    // Methods
    func setUpContainerViews() {
        self.container1 = UIView(frame: CGRect(
            x: self.view.bounds.origin.x + MARGIN_VIEW,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width - (MARGIN_VIEW * 2),
            height: self.view.bounds.height * SIXTH
            )
        )
        self.container1.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.container1)
        
        self.container2 = UIView(frame: CGRect(
            x: self.view.bounds.origin.x + MARGIN_VIEW,
            y: container1.frame.height,
            width: self.view.bounds.width - (MARGIN_VIEW * 2),
            height: self.view.bounds.height * (3 * SIXTH)
            )
        )
                self.container2.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.container2)
        
        self.container3 = UIView(frame: CGRect(
            x: self.view.bounds.origin.x + MARGIN_VIEW,
            y: container1.frame.height + container2.frame.height,
            width: self.view.bounds.width - (MARGIN_VIEW * 2),
            height: self.view.bounds.height * SIXTH
            )
        )
                self.container3.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.container3)
        
        self.container4 = UIView(frame: CGRect(
            x: self.view.bounds.origin.x + MARGIN_VIEW,
            y: container1.frame.height + container2.frame.height + container3.frame.height,
            width: self.view.bounds.width - (MARGIN_VIEW * 2),
            height: self.view.bounds.height * SIXTH
            )
        )
        self.container4.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.container4)
    }
    
    func setupContainer1(view:UIView) {
        self.titleLbl = UILabel()
        self.titleLbl.text = "Super Slots"
        self.titleLbl.textColor = UIColor.yellowColor()
        self.titleLbl.font = UIFont(name: "MarkerFelt-Wide", size:40)
        self.titleLbl.sizeToFit()
        self.titleLbl.center = view.center
        view.addSubview(self.titleLbl)
    }
    
    func setupContainer2(view:UIView) {
        for var i = 0; i < NUM_CONTAINERS; i++ {
            for var j = 0; j < NUM_SLOTS; j++ {
                
                var tSlot:Slot
                var tSlotIV = UIImageView()
                
                if slots.count != 0 {
                    let slotContainer = slots[i]
                    tSlot = slotContainer[j]
                    tSlotIV.image = tSlot.img
                } else {
                    tSlotIV.image = UIImage(named: "Ace")
                }
                
                tSlotIV.backgroundColor = UIColor.yellowColor()
                tSlotIV.frame = CGRect(
                    x: view.bounds.origin.x + (view.bounds.size.width * CGFloat(i) * THIRD),
                    y: view.bounds.origin.y + (view.bounds.size.height * CGFloat(j) * THIRD),
                    width: view.bounds.width * THIRD - MARGIN_SLOT,
                    height: view.bounds.height * THIRD - MARGIN_SLOT)
                view.addSubview(tSlotIV)
            }
        }
    }

    func setupContainer3(view:UIView) {
        
        let col1X = view.frame.width * SIXTH
        let col2X = view.frame.width * SIXTH * 3
        let col3X = view.frame.width * SIXTH * 5
        let row1Y = view.frame.height * THIRD
        let row2Y = view.frame.height * THIRD * 2
        
        self.creditsLbl = createAmountsLabel("000000")
        self.creditsLbl.center = CGPoint(x:col1X, y:row1Y)
        view.addSubview(self.creditsLbl)
        
        self.betLbl = createAmountsLabel("0000")
        self.betLbl.font = UIFont(name:"Menlo-Bold", size: 16);
        self.betLbl.center = CGPoint(x:col2X, y:row1Y)
        view.addSubview(self.betLbl)
        
        self.winnerPaidLbl = createAmountsLabel("000000")
        self.winnerPaidLbl.font = UIFont(name:"Menlo-Bold", size: 16);
        self.winnerPaidLbl.center = CGPoint(x:col3X, y:row1Y)
        view.addSubview(self.winnerPaidLbl)

        self.creditsTitleLbl = createLabelTitle("Credits")
        self.creditsTitleLbl.center = CGPoint(x:col1X, y:row2Y)
        view.addSubview(self.creditsTitleLbl)

        self.betTitleLbl = createLabelTitle("Bet");
        self.betTitleLbl.center = CGPoint(x:col2X, y:row2Y)
        view.addSubview(self.betTitleLbl)

        self.winnerPaidTitleLbl = createLabelTitle("Paid")
        self.winnerPaidTitleLbl.center = CGPoint(x:col3X, y:row2Y)
        view.addSubview(self.winnerPaidTitleLbl)
    }
    
    func setupContainer4(view:UIView) {
        self.resetBtn = createBtn("Reset")
        self.resetBtn.backgroundColor = UIColor.lightGrayColor()
        self.resetBtn.center = CGPoint(x:view.frame.width * EIGHTH, y:view.frame.height * HALF)
        self.resetBtn.addTarget(self, action: "onResetBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(self.resetBtn)
        
        self.betOneBtn = createBtn("Bet One")
        self.betOneBtn.backgroundColor = UIColor.greenColor()
        self.betOneBtn.center = CGPoint(x:view.frame.width * EIGHTH  * 3, y:view.frame.height * HALF)
        self.betOneBtn.addTarget(self, action: "onBetOneBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(self.betOneBtn)
        
        self.betMaxBtn = createBtn("Bet Max");
        self.betMaxBtn.backgroundColor = UIColor.redColor()
        self.betMaxBtn.center = CGPoint(x:view.frame.width * EIGHTH  * 5, y:view.frame.height * HALF)
        self.betMaxBtn.addTarget(self, action: "onBetMaxBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(self.betMaxBtn)
        
        self.spinBtn = createBtn("Spin")
        self.spinBtn.backgroundColor = UIColor.greenColor()
        self.spinBtn.center = CGPoint(x:view.frame.width * EIGHTH  * 7, y:view.frame.height * HALF)
        self.spinBtn.addTarget(self, action: "onSpinBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(self.spinBtn)
    }
    
    func removeSlotImageViews() {
        if self.container2 != nil {
            let container:UIView? = self.container2
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }

        }
    }
    
    func hardReset() {
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        self.setupContainer2(self.container2)
        
        credits = 50
        winnings = 0
        curBet = 0
        
        updateMainView()
    }
    
    func updateMainView() {
        self.creditsLbl.text = "\(credits)"
        self.betLbl.text = "\(curBet)"
        self.winnerPaidLbl.text = "\(winnings)"
    }
    
    func showAlertWithText(header:String = "Warning", msg:String) {
        //var alert:UIAlertController = UIAlertController(
        var alert = UIAlertController(title: header, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // Helpers
    func createAmountsLabel(str:String) -> UILabel{
        var lbl = UILabel()
        lbl.text = str
        lbl.textColor = UIColor.redColor()
        lbl.font = UIFont(name: "Menlo", size: 16)
        lbl.sizeToFit()
        lbl.textAlignment = NSTextAlignment.Center
        lbl.backgroundColor = UIColor.darkGrayColor()
        
        return lbl
    }
    
    func createLabelTitle(str:String) -> UILabel {
        var lbl = UILabel()
        lbl.text = str
        lbl.textColor = UIColor.blackColor()
        lbl.font = UIFont(name:"AmericanTypewriter", size: 14);
        lbl.sizeToFit()
        
        return lbl
    }
    
    func createBtn(str:String) -> UIButton {
        var btn = UIButton()
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        btn.sizeToFit()

        return btn
    }
    
}

