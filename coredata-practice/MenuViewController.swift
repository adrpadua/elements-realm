//
//  ViewController.swift
//  coredata-practice
//
//  Created by Adrian Padua on 5/31/16.
//  Copyright © 2016 Adrian Padua. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {

    @IBOutlet weak var logTextView: UITextView!
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var entity: NSEntityDescription!
    
    // MARK: UIViewController boilerplate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: CoreData setup
        // 1 Get AppDelegate object
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // 2 Get ManagedObjectContext from appDelegate
        managedContext = appDelegate.managedObjectContext
        
        // 3 Create Entity Description with your entity name
        entity = NSEntityDescription.entityForName("Element", inManagedObjectContext: managedContext)
        
    }
    
    // MARK: ViewController Buttons

    @IBAction func createBtnPressed(sender: AnyObject) {
        
        createElement("Hydrogen", atomicNumber: 1.0)
    }
    @IBAction func fetchBtnPressed(sender: AnyObject) {
        fetchElements()
    }
    @IBAction func updateBtnPressed(sender: AnyObject) {
    }
    @IBAction func deleteBtnPressed(sender: AnyObject) {
    }
    
    // MARK: CoreData Actions
    
    func createElement(name: String, atomicNumber: Double) {
        
        //var elements = [NSManagedObject]()
        
        // 4 Create Managed Object with help of entity and managedContext
        let elementObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // 5 Set values for represented attributes
        elementObj.setValue("Hydrogen", forKey: "name")
        elementObj.setValue(1.0, forKey: "atomicNumber")
        
        // 6 Handle the exception
        do {
            try managedContext.save()
            ElementsData.instance.append(elementObj)
            
            logTextView.text = "\(name) added to local Database."
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchElements() {
        // 4 Initialize fetch request
        let fetchRequest = NSFetchRequest()
        
        // 5 Configure fetch request
        fetchRequest.entity = entity
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            if (result.count > 0) {
                let elementObj = result[0] as! NSManagedObject
                if let name = elementObj.valueForKey("name"), atomicNumber = elementObj.valueForKey("atomicNumber"){
                    let output: NSString = "\(name) - Atomic Number: \(atomicNumber)"
                    print(output)
                    logTextView.text = "Element record is added to local Database. \n" + (output as String)
                }
            } else {
                logTextView.text = "No element records found in the local Database"
            }
        } catch {
            let fetchError = error as NSError
            print("Error", fetchError)
        }
    }
}










