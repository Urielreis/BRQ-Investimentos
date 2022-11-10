//
//  CambioViewController.swift
//  BRQInvestimentos
//
//  Created by user on 28/10/22.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customização
        customizacaoBotoes()
        customizacaoView()
        customizacaoQuantidade()
        
        // labels recebe os valores da outra tela
        alteracaoLabel()
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
        saldoDisponivel.text = ("Saldo disponível: R$\(carteira.saldoDisponivel)")
        
        // Quantidade em caixa
        moedaEmCaixa.text = ("\(quantidadeDeMoedas) \(siglaMoeda) em caixa")
        
        
        checarBotoes(botaoComprar, carteira, moeda, iso: siglaMoeda)
        checarBotoes(botaoVender, carteira, moeda, iso: siglaMoeda)
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
        
        if botao.tag == 1 {
            // Botao de Comprar
            if (carteira.saldoDisponivel < moedaPrecoCompra || carteira.saldoDisponivel < precoTotal) {
                habilitado(botaoComprar)
            } else {
                desabilitado(botaoComprar)
            }
        } else {
            // Botao de Vender
            if (quantidadeUsuario > dinheiroDisponivel || moeda.sell == nil || dinheiroDisponivel == 0) {
                habilitado(botaoVender)
            } else {
                desabilitado(botaoVender)
            }
        }
    }

   // Função Botão Pressionado
    @IBAction func botaoComprarEVender(_ sender: Any) {
        guard let carteira = carteira,
              let moedaSelecionada = moedaSelecionada,
              let CampoQuantidadeString = quantidadeText.text,
              let campoQuantidade = Int(CampoQuantidadeString),
              let storyboard = storyboard,
              let MensagemViewController = storyboard.instantiateViewController(withIdentifier: "ComprarEVenderController") as? ComprarEVenderController,
              let navigationController = navigationController else {return}
        
        var acaoDoBotao: String
        
        if (sender as AnyObject).tag == 0 {
            acaoDoBotao = "Vender" // Botão vender
            carteira.vender(quantidade: campoQuantidade, siglaMoeda, moedaSelecionada)
            MensagemViewController.mensagem = mensagemVender(acaoBotao: acaoDoBotao, quantidade: campoQuantidade)
            
        } else {
            acaoDoBotao = "Comprar" // Botão comprar
            carteira.comprar(quantidade: campoQuantidade, siglaMoeda, moedaSelecionada)
            MensagemViewController.mensagem = mensagemComprar(acaoBotao: acaoDoBotao, quantidade: campoQuantidade )
            
        }
        MensagemViewController.title = acaoDoBotao.capitalized
        navigationController.pushViewController(MensagemViewController, animated: true)
    }
    
    // Mensagem Vender
    func mensagemVender(acaoBotao: String, quantidade: Int) -> String {
        guard let carteira = carteira,
              let moeda = moedaSelecionada else { return ""}
        return "Parabéns! Você acabou de \(acaoBotao) \(quantidade) \(siglaMoeda) - \(moeda.name), totalizando \(carteira.totalPrecoVenda)"
    }
    
    // Mensagem Vender
    func mensagemComprar(acaoBotao: String, quantidade: Int) -> String {
        guard let carteira = carteira,
              let moeda = moedaSelecionada else { return ""}
        return "Parabéns! Você acabou de \(acaoBotao) \(quantidade) \(siglaMoeda) - \(moeda.name), totalizando \(carteira.totalPrecoCompra)"
    }
    
    
    // Desabilitado
    func desabilitado(_ botao: UIButton) {
        botao.isEnabled = true
    }
    
    // Habilitado
    func habilitado(_ botao: UIButton) {
        botao.isEnabled = false
    }
    
    //  Borda dos Botões
    func customizacaoBotoes() {
        botaoComprar.layer.cornerRadius = 15
        botaoVender.layer.cornerRadius = 15
    }
    // Mostrar na Tela
    func customizacaoView() {
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
