import Foundation

/// 多线程计算N个数的和

struct ThreadContext {
    let inputs: [Int]
}

struct ThreadResult {
    let sum: Int
}

// 求和计算
func sum(pointer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
    let context = pointer.bindMemory(to: ThreadContext.self, capacity: 1)
    let sum = context.pointee.inputs.reduce(0, +)
    let result = ThreadResult(sum: sum)
    let resultPointer = UnsafeMutablePointer<ThreadResult>.allocate(capacity: 1)
    resultPointer.pointee = result
    return .init(resultPointer)
}

// 1000000大小的数组拆分到4个线程分别求和
let count = 1000000
let threadCount = 4

// 初始化数组
let inputs = (0..<count).map { _ in Int(arc4random()) }

// 创建多线程
var threads = [pthread_t]()
for i in (0..<threadCount) {
    let start = (count / threadCount) * i
    let end = start + min(count - start, count / threadCount)
    let threadInputs = Array(inputs[start..<end])
    let contextPointer = UnsafeMutablePointer<ThreadContext>.allocate(capacity: 1)
    contextPointer.pointee = ThreadContext(inputs: threadInputs)
    var thread: pthread_t?
    let error = pthread_create(&thread, nil, sum, contextPointer)
    guard error == 0, let tid = thread else {
        fatalError()
    }
    threads.append(tid)
}

// 等待多线程返回结果
var results = [ThreadResult]()
for thread in threads {
    var resultPointer: UnsafeMutableRawPointer? = nil
    let error = pthread_join(thread, &resultPointer)
    guard error == 0, let pointer = resultPointer else {
        fatalError()
    }
    let result = pointer.bindMemory(to: ThreadResult.self, capacity: 1)
    results.append(result.pointee)
}

// 加总各个线程计算结果
let total = results.reduce(0) { $0 + $1.sum }
debugPrint("总和: \(total)")
