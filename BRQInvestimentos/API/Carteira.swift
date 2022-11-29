import Foundation
import UIKit

class Carteira {
    
    var saldoDisponivel: Double 
    let siglaAPI = ["USD", "EUR", "GBP", "ARS", "AUD", "BTC", "CAD", "CNY", "JPY"]
    var carteiraUsuario: [String: Int]
    var precoTotalCompra: Double
    var precoTotalCompraFormatado: String {
        
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.currencyCode = "BRL"
        
        if let resultado = formatador.string(from: NSNumber(value: precoTotalCompra)) {
            
            return resultado
        }
        return "R$0.00"
    }
    var precoTotalVenda: Double
    var precoTotalVendaFormatado: String {
        
        let formatador = NumberFormatter()
        
        formatador.numberStyle = .currency
        
        formatador.currencyCode = "BRL"
        
        if let resultado = formatador.string(from: NSNumber(value: precoTotalVenda)) {
            
            return resultado
            
        }
        
        return "R$0.00"
        
    }
    
    init() {
        
        self.saldoDisponivel = 1000.0
        var carteira = [String: Int]()
        
        // Todas as siglas comecam em 0
        for sigla in siglaAPI {
            carteira[sigla] = 0
        }
        self.carteiraUsuario = carteira
        self.precoTotalVenda = 0.0
        self.precoTotalCompra = 0.0
    }
    
    func compraEVenda(quantidade: Int, Sigla: String, valor: Double, Tag: Int, moeda: Currency) {
        guard let saldoMoeda = carteiraUsuario[Sigla] else { return }
        
        if Tag == 1 {
            guard let precoCompraMoeda = moeda.buy else { return }
            
            let valorTotalCompra = precoCompraMoeda * Double(quantidade)
            carteiraUsuario[Sigla] = saldoMoeda + quantidade
            saldoDisponivel -= valorTotalCompra
            
            precoTotalCompra = valorTotalCompra
        }else {
            guard let precoVendaMoeda = moeda.sell else { return }
            
            let valorTotalVenda = precoVendaMoeda * Double(quantidade)
            carteiraUsuario[Sigla] = saldoMoeda - quantidade
            saldoDisponivel += valorTotalVenda
            
            precoTotalVenda = valorTotalVenda
        }
    }
}
