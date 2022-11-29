import UIKit

class ComprarEVenderController: UIViewController {
    
    @IBOutlet weak var mensagemLabel: UILabel!
    
    @IBOutlet weak var botaoHome: UIButton!
    
    // Variaveis
    var mensagem: String?
    var precoTotal = Double()
    var acaoMensagem: String = ""
    
    // CambioViewController
        var acaoBotaoMensagem: String = ""
        var campoQuantidadeMensagem: Int = 0
        var siglaMoedaMensagem: String = ""
        var moedaSelecionadaMensagem: Currency?
        var precoTransacaoMensagem: String = ""
        var nomeMoedaMensagem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nomeMoedaMensagem = moedaSelecionadaMensagem?.name else { return }
        
        mensagemLabel.text = "Parabéns! Você acabou de \(acaoBotaoMensagem) \(campoQuantidadeMensagem) \(siglaMoedaMensagem) - \(nomeMoedaMensagem), totalizando \(precoTransacaoMensagem)"
    
        // Home
        BotaoRedondo()
    
    }

    func BotaoRedondo() {
        botaoHome.layer.cornerRadius = 20
    }
    
    // Botão Home
    @IBAction func botaoHomePressionado(_ sender: Any) {
        
    guard let navigationController = navigationController else { return }
    
        navigationController.popToRootViewController(animated: false)
    }
}
