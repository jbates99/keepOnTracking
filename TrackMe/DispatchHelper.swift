//
//        .........     .........
//      ......  ...........  .....
//      ...        .....       ....
//     ...         ....         ...
//     ...       ........        ...
//     ....      .... ....      ...
//      ...      .... ....      ...
//      .....     .......     ....
//        ...      .....     ....
//         ....             ....
//           ....         ....
//            .....     .....
//              .....  ....
//                .......
//                  ...

import Foundation


enum Dispatch {
    
    static let main = dispatch_get_main_queue()
    static let High = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    static let Default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    static let Low = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
}

public extension dispatch_queue_t {
    
    public func apply(count: Int, block: Int -> Void) {
        dispatch_apply(count, self, block)
    }
    
    public func async(barrier: Bool = false, block: dispatch_block_t) {
        let function = barrier ? dispatch_barrier_async : dispatch_async
        function(self, block)
    }
    
    public func sync(barrier: Bool = false, block: dispatch_block_t) {
        let function = barrier ? dispatch_barrier_sync : dispatch_sync
        function(self, block)
    }
    
    public func after(interval: NSTimeInterval, block: dispatch_block_t) {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
        dispatch_after(when, self, block)
    }
    
}
