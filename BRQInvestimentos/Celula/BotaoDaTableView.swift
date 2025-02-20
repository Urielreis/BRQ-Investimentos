import Foundation
import UIKit

class BotaoDaTableView: UITableViewCell {

    @IBOutlet weak var celulaView: CustomizacaoCelula!
    @IBOutlet weak var siglaDaMoeda: UILabel!
    @IBOutlet weak var porcentagemLabel: UILabel!
    
}

// Customização da HomeViewController
class CustomizacaoCelula: UIView {
    
    func valoresCelula() {
       
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

    // Cor da Porcentagem
extension UILabel {
    
    func corLabel(variacaoPorcentagem: Double) {
        if variacaoPorcentagem < 0 {
            self.textColor = UIColor.red
        } else if variacaoPorcentagem > 0 {
            self.textColor = UIColor.green
        } else {
            self.textColor = UIColor.white
        }
    }
}
