import UIKit

class CambioViewController: UIViewController {

    @IBOutlet weak var cambioView: UIView!
    
    @IBOutlet weak var moedaLabel: UILabel!
    
    @IBOutlet weak var porcentagemLabel: UILabel!
    
    @IBOutlet weak var compraLabel: UILabel!
    
    @IBOutlet weak var vendaLabel: UILabel!
    
    @IBOutlet weak var saldoDisponivel: UILabel!
    
    @IBOutlet weak var moedaEmCaixa: UILabel!
    
    @IBOutlet weak var quantidadeText: UITextField!
    
    @IBOutlet weak var botaoVender: UIButton!
    
    @IBOutlet weak var botaoComprar: UIButton!
    
    // Propriedades
    var moedaSelecionada: Currency?
    var siglaMoeda = String()
    var currencyISO = String()
    var carteira: Carteira?
    var transacaoTotal = Double()
    var valorDeVenda = Double()
    var valorDeCompra = Double()
    
    // Metodo de carregar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantidadeText.delegate = self
        
        // Bordas
        customizacaoBotoes()
        customizacaoView()
        customizacaoQuantidade()
        
        // labels recebe os valores da outra tela
        alteracaoLabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

                view.addGestureRecognizer(tap)
    }
    
    func alteracaoLabel() {
        guard let moeda = moedaSelecionada,
              let carteira = carteira,
              let quantidadeDeMoedas = carteira.carteiraUsuario[siglaMoeda]  else {return}
        
        // Moeda
        moedaLabel.text = "\(siglaMoeda) - \(moeda.name)"
        
        //  Porcentagem
        porcentagemLabel.text = moeda.variationString
        
        // Cor da Porcentagem
        porcentagemLabel.corLabel(variacaoPorcentagem: moeda.variation)
        
        // Preço da Compra
        compraLabel.text = ("Compra: " + moeda.comprar)
        
        // Preço da Venda
        vendaLabel.text = ("Venda: " + moeda.vender)
        
        // Saldo disponível
        saldoDisponivel.text = ("Saldo disponível: \(carteira.saldoDisponivel)")
        
        // Quantidade em caixa
        moedaEmCaixa.text = ("\(quantidadeDeMoedas) \(siglaMoeda) em caixa")
        
        checarBotoes(botaoComprar, carteira, moeda, iso: siglaMoeda)
        checarBotoes(botaoVender, carteira, moeda, iso: siglaMoeda)
        
        quantidadeText.text = ""
    }
    
    // Disponibilidade do Botão.
    func checarBotoes(_ botao: UIButton, _ carteira: Carteira, _ moeda: Currency, iso: String) {
        guard let moedaPrecoCompra = moeda.buy,
              let dinheiroDisponivel = carteira.carteiraUsuario[iso],
              let DinheiroDisponivelString = quantidadeText.text else { return }
        
        var precoTotal = Double()
        var quantidadeUsuario = Int()
        
        if let QuantidadeInseridaInt = Int(DinheiroDisponivelString) {
            quantidadeUsuario = QuantidadeInseridaInt
            precoTotal = moedaPrecoCompra * Double(QuantidadeInseridaInt)
        }
        
        // tag (Separador de tela por numero)
        if botao.tag == 1 {
            // Botao de Comprar
            if (carteira.saldo < moedaPrecoCompra || carteira.saldo < precoTotal) {
                desabilitadoBotaoComprar()
            } else {
                habilitadoBotaoComprar()
            }
        } else {
            // Botao de Vender
            if (quantidadeUsuario > dinheiroDisponivel || moeda.sell == nil || dinheiroDisponivel == 0) {
                desabilitadoBotaoVender()
            } else {
                habilitadoBotaoVender()
            }
            
            // isEmpty (Verifica se esta vazio ou verdadeiro e falso)
            if (DinheiroDisponivelString.isEmpty || quantidadeUsuario <= 0) {
                desabilitadoBotaoVender()
                desabilitadoBotaoComprar()
            }
        }
    }
    
    func desabilitadoBotaoComprar() {
        // isEnabled (Indica se esta habilitado)
            botaoComprar.isEnabled = false
        // alpha (Metodo de transparencia ou opaco)
            botaoComprar.alpha = 0.45
        }

        func habilitadoBotaoComprar(){
            botaoComprar.isEnabled = true
            botaoComprar.alpha = 1
        }

        func desabilitadoBotaoVender() {
            botaoVender.isEnabled = false
            botaoVender.alpha = 0.45
        }

        func habilitadoBotaoVender(){
            botaoVender.isEnabled = true
            botaoVender.alpha = 1
        }
    
    // dismissKeyboard (Tirar o teclado)
    @objc func dismissKeyboard() {
        // endEditing (Faz com que a exibicao renuncie nao apareca)
            view.endEditing(true)
        }

        // viewDidDisappear (Chama toda vez que a tela desaparecer)
        override func viewDidDisappear(_ animated: Bool) {

            alteracaoLabel()
        }

   // Função Botão Pressionado
    @IBAction func botaoComprarEVender(_ sender: UIButton) {
        guard let carteira = carteira,
              let moedaSelecionada = moedaSelecionada,
              let CampoQuantidadeString = quantidadeText.text,
              let campoQuantidade = Int(CampoQuantidadeString),
              let storyboard = storyboard,
              // instantiateViewController (Cria o controlador de exibicao com o identificador)
              let MensagemViewController = storyboard.instantiateViewController(withIdentifier: "ComprarEVenderController") as? ComprarEVenderController,
              let navigationController = navigationController else {return}
        
        var acaoDoBotao: String
        var precoTransacao: String
        
        // AnyObject (Retorna um dos objetos ou nil)
        if (sender as AnyObject).tag == 0 {
            guard let valorVenda = moedaSelecionada.sell else {return}
            acaoDoBotao = "Vender" // Botão vender
            carteira.compraEVenda(quantidade: campoQuantidade, Sigla: siglaMoeda, valor: valorVenda, Tag: sender.tag, moeda: moedaSelecionada)
            precoTransacao = carteira.precoTotalVendaFormatado
        } else {
            guard let valorCompra = moedaSelecionada.buy else {return}
            acaoDoBotao = "Comprar" // Botão comprar
            carteira.compraEVenda(quantidade: campoQuantidade, Sigla: siglaMoeda, valor: valorCompra, Tag: sender.tag, moeda: moedaSelecionada)
            precoTransacao = carteira.precoTotalCompraFormatado
        }
        
        //Mensagem enviadas pra tela CampraEVendaController.
            MensagemViewController.acaoBotaoMensagem = acaoDoBotao
            MensagemViewController.campoQuantidadeMensagem = campoQuantidade
            MensagemViewController.siglaMoedaMensagem = siglaMoeda
            MensagemViewController.moedaSelecionadaMensagem = moedaSelecionada
            MensagemViewController.precoTransacaoMensagem = precoTransacao
        
        MensagemViewController.title = acaoDoBotao.capitalized
        // pushViewController (Parametro que faz sua visualizacao seja incorpocada na navegacao)
        navigationController.pushViewController(MensagemViewController, animated: true)
    }
    
    //  Borda dos Botões
    func customizacaoBotoes() {
        botaoComprar.layer.cornerRadius = 15
        botaoVender.layer.cornerRadius = 15
    }
    // Mostrar na Tela
    func customizacaoView() {
        // Largura da borda
        cambioView.layer.borderWidth = 1
        cambioView.layer.cornerRadius = 15
        cambioView.layer.borderColor = UIColor.white.cgColor
    }
    // Tela Quantidade
    func customizacaoQuantidade() {
        quantidadeText.layer.borderWidth = 1
        quantidadeText.layer.cornerRadius = 10
        quantidadeText.layer.borderColor = UIColor.white.cgColor
        quantidadeText.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension CambioViewController: UITextFieldDelegate {

    

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let moeda = moedaSelecionada,

              let carteira = carteira else { return }

        checarBotoes(botaoComprar, carteira, moeda, iso: siglaMoeda)
        checarBotoes(botaoVender, carteira, moeda, iso: siglaMoeda)
    }
}
