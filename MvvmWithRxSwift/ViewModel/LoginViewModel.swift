//
//  LoginViewModel.swift
//  MvvmWithRxSwift
//
//  Created by MacBook on 23/02/21.
//
import RxSwift

import RxCocoa

import UIKit

import Alamofire

import CoreData


class LoginViewModel  {
    public let data : PublishSubject<DataModel> = PublishSubject()
    public var userData: [NSManagedObject] = []
    public var userModel : DataModel?

    
    //MARK:- Validation function
    func isValid(email : String, password : String) -> Bool {
        if email == ""{
            Helper.showAlert(message: "Email required")
        }else if !Helper.validateEmail(email){
            Helper.showAlert(message: "Valid Email required")
        }else if password == ""{
            Helper.showAlert(message: "Password required")
        }else if password.count < 6{
            Helper.showAlert(message: "Password 6 digit required")
        }else if !password.isValidPassword(){
            Helper.showAlert(message: "Passwords require at least 1 uppercase, 1 lowercase, and 1 number.")
        } else {
        return true
        }
        return false
    }
    
    //MARK:- Login API Call
    public func LoginAPI(email : String, password : String) {
       // let param = ["email":"test@imaginato.com","password":"Imaginato2020"]
        let param = ["email":email,"password":password]
        ApiServer.sharedApiInstance.PostAPI(url: Helper.App_Base_Url+"login", params: param) { (result) in
        switch result {
         case .success(let result) :
                if result.status == true{
                self.data.onNext(result)
                } else {
                    Helper.showAlert(message: result.message!)
                }
         case .failure(let err) :
                Helper.showAlert(message: err.localizedDescription)
                break
            }
        }
    }
    
    //MARK:- Save to Db
    public func savetoDb() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
      let user = NSManagedObject(entity: entity, insertInto: managedContext)
          user.setValue("Faheem", forKeyPath: "name")
          user.setValue("Faheem.h@iroidtechnologies.com", forKeyPath: "email")
          user.setValue("DummyToken ashdgasjhwjhdjhwebmnzbczkxhbnjkbcxznbszcnxbsdjhbc", forKeyPath: "token")
          user.setValue("Login Successfull", forKeyPath: "message")
          user.setValue(true, forKeyPath: "status")
      do {
        try managedContext.save()
        userData.append(user)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    //MARK:- Fetch from Db
    public func fetchFromDb() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
           self.userData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Delete from Db
    public func deleteFromDb() {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }

}
