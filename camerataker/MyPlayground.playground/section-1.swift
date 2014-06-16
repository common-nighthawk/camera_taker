// Playground - noun: a place where people can play

import UIKit

var str = "10.12345678"


var answerlat = ""
var counterlat = 0

for x in str {
    if x == "." {
        counterlat = 1
    }
    if counterlat < 8 {
        answerlat += x
    }
    counterlat += 1
}

println(answerlat)


var startTime = NSDate()

var nowTime = NSDate()

var timeElapsed = nowTime.timeIntervalSinceDate(startTime)
