//
//  mainMenuView.swift
//  welli Watch App
//
//

import SwiftUI
import HealthKit
import WatchConnectivity


//This is the main page view where you can see the main questions that leads everything else off, this is the first interface that asks about their feelings


struct ContentView: View {
    var username = "Brian" //MARK: PUT USERNAME FOR EACH USER HERE
    @EnvironmentObject var environmentObject: WriteViewModel
    
    let healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    let heartrate = HKHeartRateMotionContext.sedentary
    
    @State var num = 0.0
    @State var scale = 1.0
    @State private var value = 0

    var body: some View {
        var buttonTapped = false
        let heartrate = "\(value)"
        
        
        NavigationView()
        {
            ScrollView {
                VStack {
                    Text("How do you feel?")
                        .padding()
                }
                
                //GOOD button -> Pass to Deep Breathing Intervention viewpage
                VStack {
                    NavigationLink(destination: exitView(), label:{ Text("Good")})
                        .foregroundColor(.green)
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded{
                            buttonTapped = true
                                if buttonTapped == true {
                                    environmentObject.data["user"] = "\(username)"
                                    environmentObject.data["st_mood"] = "Good"
                                    environmentObject.data["hr_before"] = heartrate
                                    environmentObject.data["st_time"] = MyStruct.init().currentDate + " " + MyStruct.init().currentMilitary
                                    print(environmentObject.sendDictionaryToiOSApp(environmentObject.data))


                                }
                            })
                .onChange(of: environmentObject.data) {
                    newEnvironmentObject in print("State: \(newEnvironmentObject)")
                }
                
                //OKAY button -> Pass to Deep Breathing Intervention viewpage
                VStack {
                    NavigationLink(destination: exitView(), label:{ Text("Okay")
                            .foregroundColor(.blue)
                            .bold()
                    })
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded{
                            buttonTapped = true
                            if buttonTapped == true {
                                environmentObject.data["user"] = "\(username)"
                                environmentObject.data["st_mood"] = "Okay"
                                environmentObject.data["hr_before"] = heartrate
                                environmentObject.data["st_time"] = MyStruct.init().currentDate + " " + MyStruct.init().currentMilitary
                                

                            }
                        })
                
                //I NEED HELP button -> Pass to multiple Intervention viewpage
                VStack {
                    NavigationLink(destination: exitView(), label:{ Text("I Need Help")
                            .foregroundColor(.red)
                            .bold()
                    })
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded{
                            buttonTapped = true
                            if buttonTapped == true {
                                environmentObject.data["user"] = "\(username)"
                                environmentObject.data["st_mood"] = "I need help"
                                environmentObject.data["hr_before"] = heartrate
                                environmentObject.data["st_time"] = MyStruct.init().currentDate + " " + MyStruct.init().currentMilitary
                                
                            }
                        })
                
                
            }
        }.onAppear(perform: start)
        
    }
    
    
    func start() {
        authorizeHealthkit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }

    func authorizeHealthkit() {
        // Used to define the identifiers that create quanitity type objects.
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        // Request permission to save and read the specified data types.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) {
            (success, error)
            in
        }
    }

    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        // We want data points from our current device
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        // A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-runninig query.
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
        // A sample that represents a quantity, including the value and the units.
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            self.process(samples, type: quantityTypeIdentifier)
            
        }
        
        // It provides us with both the ability to receive a snapshot of data, and then on subsequeny calls, a snapshot of what has changed.
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // query execution
        
        healthStore.execute(query)
    }

    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        // variable initialization
        var lastHeartRate = 0.0
        
        // cycle and value assignment
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            
            self.value = Int(lastHeartRate)
        }
    }
    
    
}





struct mainMenuView_Previews: PreviewProvider {
    static let environmentObject = WriteViewModel()
    
    static var previews: some View {
        ContentView().environmentObject(environmentObject)
    }
}

