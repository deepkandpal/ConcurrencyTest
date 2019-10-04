//
//  Concurrency.swift


import Foundation

//This method will fetch the data from two data sources concurrently and concatenate the data and return if it receives data within 2 seconds else return error
func loadMessage(completion: @escaping (String) -> Void) {
    
    var message : String = ""
    
    DispatchQueue.global(qos: .background).async {
        
        //create dispatch group for grouping both tasks
        let group = DispatchGroup()
        
        //add first task in group
        group.enter()
        fetchMessageOne { (messageOne) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageOne
            group.leave()
        }
        //add second task in group
        group.enter()
        fetchMessageTwo { (messageTwo) in
            if(!message.isEmpty){
                message = message + " "
            }
            message = message + messageTwo
            group.leave()
        }
        
        //return error if either of the task takes more than 2 seconds
        if group.wait(wallTimeout: DispatchWallTime.now() + .seconds(2)) == .timedOut {
            
            message = "Unable to load message - Time out exceeded"
            DispatchQueue.main.async {
                completion(message)
            }
        }
            // retun the combined string from both the tasks
        else{
            group.notify(queue: .main){
                completion(message)
            }
        }
    }
    
}
