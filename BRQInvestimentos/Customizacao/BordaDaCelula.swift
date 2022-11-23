//
//  BordaDaCelula.swift
//  BRQInvestimentos
//
//  Created by user on 11/11/22.
//

import Foundation
import UIKit

class BordaDaCelula: UIView {

    func valoresCelula() {
        
        // borda
        self.layer.cornerRadius = 15
        // largura
        self.layer.borderWidth = 1
        // cor
        self.layer.borderColor = UIColor.white.cgColor
        
    }
}
