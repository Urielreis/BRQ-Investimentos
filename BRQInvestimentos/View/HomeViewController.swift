import Foundation
import UIKit


class HomeViewController: UITableViewController {
    
    // Variavel que esta chamando a Currency da api
    var moedas = [Currency]()
    // Constante que esta chamando classe Carteira
    let carteira = Carteira()
    // Constante que esta sendo usada para puxar classe API e link URL
    let URLApi = "https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=57edaf28"
    
    // Metodo de carregar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Puxando API na tela
        requisicaoAPI()
    }
    
    // numberOfSections (Solicita dados que retorna numero de secoes)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return moedas.count
    }
    
    // numberOfRowsInSection (Retorna numero de linhas)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // heightForHeaderInSection (Altura que sera usado no cabecalho da secao)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let espacoEntreCelulas: CGFloat = 24
        
        return espacoEntreCelulas
    }
    
    // viewForHeaderInSection (Cabecalho da secao especificada da tabela)
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cabecalho = UIView()
        cabecalho.backgroundColor = UIColor.black
        
        return cabecalho
    }
    
    // cellForRowAt (Retorna uma celula para inserir na tabela)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell (Retorna um objeto da celula de tabela apos indentificar)
        guard let celulaView = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as? BotaoDaTableView else { fatalError() }
        
        adicionandoLabels(celulaView, for: indexPath)
        celulaView.celulaView.valoresCelula()
        
        return celulaView
    }
    
    // didSelectRowAt (Responde quando clica em uma linha)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard,
              let navigationController = navigationController else {return}
        
        // instantiateViewController (Cria o controlador de exibicao com o identificador)
        if let cambioViewController = storyboard.instantiateViewController(withIdentifier: "CambioViewController") as? CambioViewController {
            cambioViewController.moedaSelecionada = moedas[indexPath.section]
            cambioViewController.carteira = carteira
            
            
            // cellForRow (Retorna celula da tabela)
            guard let celula = tableView.cellForRow(at: indexPath) as? BotaoDaTableView else {return}
            guard let siglaMoeda = celula.siglaDaMoeda.text else {return}
            cambioViewController.siglaMoeda = siglaMoeda
            
            // pushViewController (Parametro que faz sua visualizacao seja incorpocada na navegacao)
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
}
