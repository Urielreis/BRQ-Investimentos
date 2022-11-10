import Foundation
import UIKit

class ViewController: UITableViewController {
    
    var moedas = [Currency]()
    let carteira = Carteira()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Puxando API na tela
        requisicaoAPI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return moedas.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let espacoEntreCelulas: CGFloat = 24
        
        return espacoEntreCelulas
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cabecalho = UIView()
        cabecalho.backgroundColor = UIColor.black
        
        return cabecalho
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celulaView = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as? BotaoDaTableView else { fatalError() }
        
        adicionandoLabels(celulaView, for: indexPath)
        celulaView.celulaView.valoresCelula()
        
        return celulaView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard,
              let navigationController = navigationController else {return}
        
        if let cambioViewController = storyboard.instantiateViewController(withIdentifier: "CambioViewController") as? CambioViewController {
            cambioViewController.moedaSelecionada = moedas[indexPath.section]
            cambioViewController.carteira = carteira // cateira
            
            
            guard let celula = tableView.cellForRow(at: indexPath) as? BotaoDaTableView else {return}
            guard let siglaMoeda = celula.siglaDaMoeda.text else {return}
            cambioViewController.siglaMoeda = siglaMoeda
            
            navigationController.pushViewController(cambioViewController, animated: true)
        }
    }
    
    //MARK: - Criação da celula da tabela
    // CelulaHome
    func adicionandoLabels(_ celula: BotaoDaTableView, for indexPath: IndexPath) {
        let moeda = moedas[indexPath.section]
        switch moeda.name {
        case "Dollar":
            celula.siglaDaMoeda.text = "USD"
        case "Euro":
            celula.siglaDaMoeda.text = "EUR"
        case "Pound Sterling":
            celula.siglaDaMoeda.text = "GBP"
        case "Argentine Peso":
            celula.siglaDaMoeda.text = "ARS"
        case "Canadian Dollar":
            celula.siglaDaMoeda.text = "CAD"
        case "Australian Dollar":
            celula.siglaDaMoeda.text = "AUD"
        case "Japanese Yen":
            celula.siglaDaMoeda.text = "JPY"
        case "Renminbi":
            celula.siglaDaMoeda.text = "CNY"
        case "Bitcoin":
            celula.siglaDaMoeda.text = "BTC"
        default:
            break
        }
        
        celula.porcentagemLabel.text = moeda.variationString
        celula.porcentagemLabel.corLabel(variacaoPorcentagem: moeda.variation)
    }
    
    //MARK: - API - Requisição
    func requisicaoAPI() {
        guard let url = URL(string: "https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=a6cb5965") else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                guard let error = error else { return }
                print(error)
                return
            }
            if let safeData = data {
                self.decoderJSON(safeData)
            }
        }
        task.resume()
    }
    
   // JSON Decoder
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
            return
        }
    }
}
