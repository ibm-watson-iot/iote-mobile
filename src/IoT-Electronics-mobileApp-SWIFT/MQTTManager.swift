/* *****************************************************************************
  Copyright (c) 2016 IBM Corporation and other Contributors.

  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html

  Contributors:
  Chungen Kao
  Troy Dugger
  Graeme Fulton
  Sujita Gurung
  Dawn Ahukanna
***************************************************************************** */


import UIKit
import CoreData

let userDefaults = NSUserDefaults.standardUserDefaults()
private let userName = userDefaults.stringForKey("apiKeyMQTT")!
private let topicPublish = "iot-2/evt/status/fmt/json";
private let topicSubscribe = "iot-2/type/+/id/+/evt/+/fmt/+";


class MQTTManager:NSObject,MQTTSessionDelegate, NSFetchedResultsControllerDelegate {
    
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private let _context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var appliancesToTrack: [NSDictionary]?
    
    /// The singleton instance of this class
    class var sharedInstance:MQTTManager {
        struct Static {
            static let instance:MQTTManager = MQTTManager()
        }
        return Static.instance
    }
    
    
    var session:MQTTSession?
    
    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        
        let json:[String : AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : AnyObject]
        processingIncomingMessage(topic, data: data, jsonstring: json.description)
    }
    
    func addAppliancesToTrack(appliances:[NSDictionary]) {
        appliancesToTrack = appliances
        restartConnection()
    }
    
    func start() {
        let clientId = "a:\(userDefaults.stringForKey("orgName")!):\(userDefaults.stringForKey("clientIdMQTT")!)"
        let password = userDefaults.stringForKey("apiTokenMQTT")
        
        session = MQTTSession(
            clientId: clientId,
            userName: userName,
            password: password,
            keepAlive: 3000,
            cleanSession: true,
            will: false,
            willTopic: nil,
            willMsg: nil,
            willQoS: .AtMostOnce,
            willRetainFlag: false,
            protocolLevel: 4,
            runLoop: nil,
            forMode: nil
        )
        
        session!.delegate = self
        session!.persistence.persistent = false
        let host = userDefaults.stringForKey("hostMQTT")!
        session!.connectToHost(host, port: 1883, usingSSL: false)
        
    }
    
    func stop() {
        if session == nil {
            return
        }
        session!.delegate = nil
        session!.close()
    }
    
    func restartMQTTAfterConnectionClosed()
    {
        
        let message = NSLocalizedString("MQTTManager.MQTTDisconnected.Message", comment: "MQTT Connection was disconnected")
        let alert = UIAlertController(title: NSLocalizedString("MQTTManager.MQTTDisconnected.Title",comment:"Title of the alert for reconnecting to MQTT"), message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment:"Cancel"), style: .Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("MQTTManager.MQTTDisconnected.Connect",comment:"Reconnect button to confirm the reconnection"), style: .Destructive, handler: { (alertAction) -> Void in
            
            MQTTManager.sharedInstance.start()
            
        }))
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert,animated: true, completion: nil)
        
    }
    
    func restartConnection()
    {
        MQTTManager.sharedInstance.stop()
        MQTTManager.sharedInstance.start()
    }
    
}

extension MQTTManager {
    
    func handleEvent(session: MQTTSession!, event eventCode: MQTTSessionEvent, error: NSError!) {
        
    }
    
    
    func connected(session: MQTTSession!) {
        print("MQTT connected")
        
        if appliancesToTrack == nil {
            //listen all the devices (for testing purpose), should be replaced by return in production
            session!.subscribeToTopic(topicSubscribe, atLevel: MQTTQosLevel.AtMostOnce)
        }
        else{
            for appliance in appliancesToTrack! {
                session!.subscribeToTopic("iot-2/type/washingmachine/id/\(appliance["applianceID"])/evt/+/fmt/+", atLevel: MQTTQosLevel.AtMostOnce)
            }
        }
    }
    
    func connected(session: MQTTSession!, sessionPresent: Bool) {
        
        print("MQTT connected sessionPresent \(sessionPresent)")
        
    }
    
    func connectionRefused(session: MQTTSession!, error: NSError!) {
        
        print("MQTT connectionRefused \(error)")
        
    }
    
    func connectionClosed(session: MQTTSession!) {
        
        print("MQTT connectionClosed")
        MQTTManager.sharedInstance.stop()
        
    }
    
    func connectionError(session: MQTTSession!, error: NSError!) {
        
        print("MQTT connectionError \(error)")
        MQTTManager.sharedInstance.stop()
        
    }
    
    func protocolError(session: MQTTSession!, error: NSError!) {
        
        print("MQTT protocolError \(error)")
        
    }
    
    func messageDelivered(session: MQTTSession!, msgID: UInt16) {
        
        print("MQTT messageDelivered \(msgID)")
    }
    
    func subAckReceived(session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [AnyObject]!) {
        
        print("MQTT subAckReceived \(msgID)")
        
    }
    
    func unsubAckReceived(session: MQTTSession!, msgID: UInt16) {
        
        print("MQTT unsubAckReceived \(msgID)")
    }
    
    func sending(session: MQTTSession!, type: Int32, qos: MQTTQosLevel, retained: Bool, duped: Bool, mid: UInt16, data: NSData!) {
        
    }
    
    func received(session: MQTTSession!, type: Int32, qos: MQTTQosLevel, retained: Bool, duped: Bool, mid: UInt16, data: NSData!) {
        
        print("MQTT received")
    }
    
    func buffered(session: MQTTSession!, queued: UInt, flowingIn: UInt, flowingOut: UInt) {
        
        print("MQTT buffered")
    }
    
    
    
    func sendCommand(applianceID: String, applianceType: String, cmd: String) {
        
        print ("iot-2/type/\(applianceType)/id/\(applianceID)/cmd/\(cmd)/fmt/json")
        
        let dictionary = [String: String]()
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
        
        session!.publishData(jsonData,
            onTopic: "iot-2/type/\(applianceType)/id/\(applianceID)/cmd/\(cmd)/fmt/json",
            retain: false,
            qos: MQTTQosLevel.AtLeastOnce)
    }
    
    
    
    func processingIncomingMessage(topic:String, data: NSData!, jsonstring: String){
        
        let topicArr = topic.characters.split{$0 == "/"}.map(String.init)
        var key:String = ""
        
        var idIndex = 0
        
        var id: String=""
        
        var _program: String?
        var _failureType: String?
        var _currentCycle: String?
        var _status: String?
        var _doorOpen: Bool?
        
        
        //looking for "id", everything before applianceID will be used as a key
        for i in 0..<topicArr.count {
            if topicArr[i] == "id" {
                idIndex = i + 1
                id=topicArr[i+1]
            }
        }
        
        //get the key of the topic
        for i in 0...idIndex {
            if i==0 {
                key=topicArr[i]
            }
            else {
                key=key+"/"+topicArr[i]
            }
        }
        
        let _context = self._context
        let _request = NSFetchRequest (entityName: "Appliances")
        _request.predicate = NSPredicate (format: "key=%@", key)
        _request.returnsObjectsAsFaults=false
        
        do{
            let results: NSArray = try _context.executeFetchRequest(_request)
            if (results.count>0){
                for res in results {
                    let _a = res as! Appliances
                    if ( _a.topic == topic) && ( _a.json==jsonstring) {
                        //print ("MQTT Skip \(id)")
                    }
                    else {
                        print ("MQTT Update \(id) json:\(jsonstring)")
                        //parse JSON
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                            
                            if let _data = json["d"] as? [String: AnyObject] {
                                _program = _data["program"] as? String
                                _failureType = _data["failureType"] as? String
                                _currentCycle = _data["currentCycle"] as? String
                                _status = _data["status"] as? String
                                _doorOpen = _data["doorOpen"] as? Bool
                            }
                        }catch {
                            print("Error with Json: \(error)")
                        }
                        
                        _a.id=id
                        _a.key=key
                        _a.topic=topic
                        _a.json=jsonstring
                        
                        _a.program=_program
                        _a.failureType=_failureType
                        _a.currentCycle=_currentCycle
                        _a.status=_status
                        _a.doorOpen=_doorOpen
                        
                        
                        //update the record
                        do {
                            try _context.save()
                            //print("success update appliance \(id)")
                        } catch {
                            let saveError = error as NSError
                            print(saveError)
                        }
                    }
                }
            }
            else {
                //create a new record
                //parse JSON
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    if let _data = json["d"] as? [String: AnyObject] {
                        _program = _data["program"] as? String
                        _failureType = _data["failureType"] as? String
                        _currentCycle = _data["currentCycle"] as? String
                        _status = _data["status"] as? String
                        _doorOpen = _data["doorOpen"] as? Bool
                    }
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
                let _entity = NSEntityDescription.entityForName("Appliances", inManagedObjectContext: _context)
                var _appliances: Appliances? = nil
                _appliances = Appliances (entity: _entity!, insertIntoManagedObjectContext: _context)
                _appliances?.id=id
                _appliances?.key=key
                _appliances?.topic=topic
                _appliances?.json=jsonstring
                
                _appliances?.program=_program
                _appliances?.failureType=_failureType
                _appliances?.currentCycle=_currentCycle
                _appliances?.status=_status
                _appliances?.doorOpen=_doorOpen
                
                
                do{
                    try _context.save()
                    print("success when save appliance \(id)")
                }catch{
                    print(error)
                }
            }
        }
        catch{
            print ("error in afterGettingNewMessage :\(error)")
        }
    }
    
    func getStatusbyId (applianceID: String) -> [String: AnyObject] {
        
        //fetech the same key from
        let _context = self._context
        let _request = NSFetchRequest (entityName: "Appliances")
        _request.predicate = NSPredicate (format: "id=%@", applianceID)
        _request.returnsObjectsAsFaults=false
        
        var _data = [String: AnyObject]()
        
        do{
            let results: NSArray = try _context.executeFetchRequest(_request)
            if results.count > 0 {
                //there is a record for this applianceID
                let _app = results[0] as! Appliances
                
                if let _id = _app.id {
                    _data["id"]=_id
                }
                
                if let _status = _app.status {
                    _data["status"] = _status
                }
                
                if let _failureType = _app.failureType {
                    _data["failureType"] = _failureType
                }
                
                if let _program = _app.program {
                    _data["program"] = _program
                }
                
                if let _currentCycle = _app.currentCycle {
                    _data["currentCycle"] = _currentCycle
                }
                
                if let _doorOpen = _app.doorOpen {
                    _data["doorOpen"] = _doorOpen
                }
                
            }
            else {
            
            }
            
        }
        catch{
            print ("error in getStatusbyId :\(error)")
        }
        
        print ("this is the return of getStatusbyId \(_data)")
        return _data
    }
    
}