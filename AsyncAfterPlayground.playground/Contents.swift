import Foundation

class AsyncAfter {
    
    static func dispatchLater(time: TimeInterval, task: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: task)
    }
    
    typealias ExchangableTask = (_ newDelayTime: TimeInterval?, _ anotherTask: @escaping (() -> ())) -> Void
    
    static func delay(_ time: TimeInterval, task: @escaping () -> ()) -> ExchangableTask {
        var exchangingTask: (() -> ())?
        var newDelayTime: TimeInterval?
        
        let finalClosure = {
            if let newTask = exchangingTask {
                if newDelayTime == nil {
                    DispatchQueue.main.async(execute: newTask)
                }
            } else {
                DispatchQueue.main.async(execute: task)
            }
        }
        
        dispatchLater(time: time, task: finalClosure)
        
        let exchangableTask: ExchangableTask = { delayTime, anotherTask in
            exchangingTask = anotherTask
            newDelayTime = delayTime
            
            if let delayTime = delayTime {
                self.dispatchLater(time: delayTime, task: anotherTask)
            }
        }
        
        return exchangableTask
    }
}
