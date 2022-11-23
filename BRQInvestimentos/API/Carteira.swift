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
    
    // Funcao de vender
    func vender(quantidade: Int, _ siglaMoeda: String, _ moeda: Currency) {
        guard let valorMoeda = carteiraUsuario[siglaMoeda],
              let precoVendaMoeda = moeda.sell else {
            return
        }
        
        let precoVenda = precoVendaMoeda * Double(quantidade)
        
        if valorMoeda >= quantidade {
            saldoDisponivel += precoVenda
            carteiraUsuario[siglaMoeda] = valorMoeda - quantidade
        }
        
        precoTotalVenda = precoVenda
        
       
    }
    
    // Funcao de Comprar
    func comprar(quantidade: Int, _ siglaMoeda: String, _ moeda: Currency) {
        guard let currencyAmount = carteiraUsuario[siglaMoeda],
              let precoCompraMoeda = moeda.buy else {
            return
        }
        
        let precoCompra = precoCompraMoeda * Double(quantidade)
        
        if saldoDisponivel - precoCompra > 0 {
            carteiraUsuario[siglaMoeda] = currencyAmount + quantidade
            saldoDisponivel -= precoCompra
        }
        
        precoTotalCompra = precoCompra
        
      
    }
}

