//
//  Pin+Extensions.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/11/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation
import CoreData

extension Pin {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        string = String()
    }
}
