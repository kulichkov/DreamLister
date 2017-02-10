//
//  Item+CoreData.swift
//  DreamLister
//
//  Created by Mikhail Kulichkov on 07/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import Foundation
extension Item {
    public override func awakeFromInsert() {
        super.awakeFromInsert()

        self.created = NSDate()
    }
}
