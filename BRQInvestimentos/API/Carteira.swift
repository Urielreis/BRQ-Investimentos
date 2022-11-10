import Foundation
import UIKit

class Carteira {
    var totalPrecoVenda: Double
    var totalPrecoCompra: Double
    var saldoDisponivel: Double
    let siglaAPI = ["USD", "EUR", "GBP", "ARS", "AUD", "BTC", "CAD", "CNY", "JPY"]
    var carteiraUsuario: [String: Int]
    
    init() {

        self.saldoDisponivel = 1000.0
        var carteira = [String: Int]()
        
        // Todas as siglas comecam em 0
        for sigla in siglaAPI {
            carteira[sigla] = 0
        }
        self.carteiraUsuario = carteira
        self.totalPrecoVenda = 0.0
        self.totalPrecoCompra = 0.0
    }
    
    // Funcao de vender
    func vender(quantidade: Int, _ siglaMoeda: String, _ moeda: Currency) -> Double {
        guard let valorMoeda = carteiraUsuario[siglaMoeda],
              let precoVendaMoeda = moeda.sell else {
            return totalPrecoVenda
        }
        
        let precoVenda = precoVendaMoeda * Double(quantidade)
        
        if valorMoeda >= quantidade {
            saldoDisponivel += precoVenda
            carteiraUsuario[siglaMoeda] = valorMoeda - quantidade
        }
        
        totalPrecoVenda = precoVenda
        
        return totalPrecoVenda
    }
    
    // Funcao de Comprar
    func comprar(quantidade: Int, _ siglaMoeda: String, _ moeda: Currency) -> Double {
        guard let currencyAmount = carteiraUsuario[siglaMoeda],
              let precoCompraMoeda = moeda.buy else {
            return totalPrecoCompra
        }
        
        let precoCompra = precoCompraMoeda * Double(quantidade)
        
        if saldoDisponivel - precoCompra > 0 {
            carteiraUsuario[siglaMoeda] = currencyAmount + quantidade
            saldoDisponivel -= precoCompra
        }
        
        totalPrecoCompra = precoCompra
        
        return totalPrecoCompra
    }
}

