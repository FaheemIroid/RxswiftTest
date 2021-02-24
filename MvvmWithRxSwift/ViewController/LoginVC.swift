//
//  LoginVC.swift
//  MvvmWithRxSwift
//
//  Created by MacBook on 23/02/21.
//

import UIKit

import SkyFloatingLabelTextField

import RxSwift

import RxSwiftExt

import RxCocoa

class LoginVC: UIViewController {

    @IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!
    
    @IBOutlet weak var textFieldPassword: SkyFloatingLabelTextField!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var viewBackground: UIView!
    
    let disposeBag = DisposeBag()
    
    var viewModel = LoginViewModel()
    
    public var data = PublishSubject<DataModel>()

    
//MARK:- UI Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetupUI()
    }
    func initialSetupUI(){
        Helper.StatusBarColor(view: self.view)
        self.viewBackground.layer.cornerRadius = Helper.AppViewCornerRadius
        self.viewBackground.layer.masksToBounds = false
        self.viewBackground.layer.shadowColor = Helper.colorFromHexString(hex: "#5B5B5B").cgColor
        self.viewBackground.layer.shadowOffset = CGSize.zero
        self.viewBackground.layer.shadowOpacity = 0.7
        self.viewBackground.layer.shadowRadius = 10
        self.buttonLogin.layer.cornerRadius = Helper.AppButtonCornerRadius
        setupBinding()
    }
//MARK:- Binding Function
    func setupBinding() {
    viewModel.data.observe(on: MainScheduler.instance).bind(to: self.data).disposed(by: disposeBag)
    }
//MARK:- Button Click Action
    @IBAction func bttnLoginClick(_ sender: Any) {
    checkConnectivity()
    }
    
//MARK:- API Call
    func checkConnectivity() {
        if Helper.checkConnectivity() {
            if viewModel.isValid(email: textFieldEmail.text!, password: textFieldPassword.text!) {
            viewModel.LoginAPI(email : textFieldEmail.text!, password : textFieldPassword.text!)
            viewModel.savetoDb()
            viewModel.fetchFromDb()
            }
        } else {
            Helper.showAlert(message: "Please check your Internet connection")
            viewModel.savetoDb()
            viewModel.fetchFromDb()
        }
    }
}


