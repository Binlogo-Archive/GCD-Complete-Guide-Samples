import UIKit

/*
 有 A, B, C, D, E, F 六个任务
 A, B, C: 并发执行
 D -> A, B: D 依赖 A、B 执行完成
 E -> B, C: E 依赖 B、C 执行完成
 F -> D, E: F 依赖 D、E 执行完成
 **/

let groupForD = DispatchGroup()
let groupForE = DispatchGroup()
let groupForF = DispatchGroup()

func scheduleA() {
    groupForD.enter()
    DispatchQueue.global().async {
        for i in 0 ..< arc4random_uniform(10) {
            print("A doing step \(i)")
        }
        print("A done")
        groupForD.leave()
    }
}

func scheduleB() {
    groupForD.enter()
    groupForE.enter()
    DispatchQueue.global().async {
        for i in 0 ..< arc4random_uniform(10) {
            print("B doing step \(i)")
        }
        print("B done")
        groupForD.leave()
        groupForE.leave()
    }
}

func scheduleC() {
    groupForE.enter()
    DispatchQueue.global().async {
        for i in 0 ..< arc4random_uniform(10) {
            print("C doing step \(i)")
        }
        print("C done")
        groupForE.leave()
    }
}

func scheduleD() {
    groupForF.enter()
    groupForD.notify(queue: .global()) {
        for i in 0 ..< arc4random_uniform(10) {
            print("D doing step \(i)")
        }
        print("D done")
        groupForF.leave()
    }
}

func scheduleE() {
    groupForF.enter()
    groupForE.notify(queue: .global()) {
        for i in 0 ..< arc4random_uniform(10) {
            print("E doing step \(i)")
        }
        print("E done")
        groupForF.leave()
    }
}

func scheduleF() {
    groupForF.notify(queue: .global()) {
        for i in 0 ..< arc4random_uniform(10) {
            print("F doing step \(i)")
        }
        print("F done")
    }
}

scheduleA()
scheduleB()
scheduleC()
scheduleD()
scheduleE()
scheduleF()
