//
//  AgendaItemSettableCell.swift
//  MyAgenda
//
//  Created by Michael Vork on 5/8/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import Foundation

protocol AgendaItemSettableCell {
    var agendaItem: AgendaItem? { get set }
    func updateUI()
}
