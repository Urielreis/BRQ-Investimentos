//
//  ComprarEVenderController.swift
//  BRQInvestimentos
//
//  Created by user on 01/11/22.
//Projeto 99%

import UIKit

class ComprarEVenderController: UIViewController {
    
    @IBOutlet weak var mensagemLabel: UILabel!
    
    @IBOutlet weak var botaoHome: UIButton!
    
    // Variaveis
    var mensagem: String?
    var precoTotal = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mensagem = mensagem else {return}
        mensagemLabel.text = mensagem
    
        // Home
        BotaoRedondo()
    
    }

    func BotaoRedondo() {
        botaoHome.layer.cornerRadius = 20
    }
    
    // Botão Home
    @IBAction func botaoHomePressionado(_ sender: Any) {
        
    guard let storyboard = storyboard,
              let ViewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController,
              let navigationController = navigationController else { return }
    
        navigationController.popToRootViewController(animated: false)
    }
}
