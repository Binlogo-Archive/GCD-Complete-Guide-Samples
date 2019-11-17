import Foundation
import UIKit

class AsyncAfter {
    
    static func dispatchLater(time: TimeInterval, task: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: task)
    }
    
    typealias CancelTask = () -> Void
    
    static func delay(_ time: TimeInterval, task: @escaping () -> ()) -> CancelTask {
        var isCancel: Bool = false
        
        let finalClosure = {
            guard !isCancel else {
                print("任务已取消")
                return
            }
            DispatchQueue.main.async(execute: task)
        }
        
        dispatchLater(time: time, task: finalClosure)
        
        return { isCancel = true }
    }
    
    typealias TickTask = () -> Void
    
    static func delayIfNeeded(_ interval: TimeInterval, task: @escaping () -> ()) -> TickTask {
        let submitTime = CFAbsoluteTimeGetCurrent()
        var isDelayNeeded: Bool = false
        
        let finalClosure = {
            guard isDelayNeeded else {
                print("延时时间间隔已到，任务将随后被执行")
                return
            }
            DispatchQueue.main.async(execute: task)
        }
        
        dispatchLater(time: interval, task: finalClosure)
        
        let tickTask: TickTask = {
            let tickInterval = CFAbsoluteTimeGetCurrent() - submitTime
            if tickInterval < interval {
                isDelayNeeded = true
            } else {
                DispatchQueue.main.async(execute: task)
            }
        }
        return tickTask
    }
}

let cancel = AsyncAfter.delay(5) {
    print("5s后叫我")
}

AsyncAfter.dispatchLater(time: 2) {
    cancel()
}

//print(Date())
//let tick = AsyncAfter.delayIfNeeded(1.0) {
//    print("拆红包动画完成，展示红包详情")
//    print(Date())
//}
//
//AsyncAfter.dispatchLater(time: 2.0) {
//    tick()
//}
