import Foundation
import UIKit

extension HomeViewController {
    // Requisição
    func requisicaoAPI() {
        guard let url = URL(string: URLApi) else { return }
        // URLSession (Fornece a API indicado pela URL)
        let session = URLSession(configuration: .default)
        
        //dataTask (Recupera o conteudo da URL)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                guard let error = error else { return }
                print(error)
                return
            }
            if let safeData = data {
                //decoderJSON (Decodificador do Json)
                self.decoderJSON(safeData)
            }
        }
        task.resume()
    }
    
    // JSON Decoder (Decodificador do Json)
    func decoderJSON(_ financeData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Results.self, from: financeData)
            moedas = [
                decodedData.currencies.USD,
                decodedData.currencies.EUR,
                decodedData.currencies.ARS,
                decodedData.currencies.AUD,
                decodedData.currencies.BTC,
                decodedData.currencies.CAD,
                decodedData.currencies.CNY,
                decodedData.currencies.GBP,
                decodedData.currencies.JPY
            ]
            //DispatchQueue (Assincrona o codigo é lido sem ordem) (Sicrona o codigo é lido em ordem)
            DispatchQueue.main.async {
                //reloadData (Recarrega os dados)
                self.tableView.reloadData()
            }
        } catch {
            print(error)
            return
        }
    }
}
