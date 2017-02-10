//
//  ItemTableViewCell.swift
//  DreamLister
//
//  Created by Mikhail Kulichkov on 07/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfItem: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func configureCell(item: Item) {
        title.text = item.title!
        price.text = "$\(item.price)"
        details.text = item.details!
        let fetchedImage = item.toImage?.image as? UIImage
        let defaultImage = #imageLiteral(resourceName: "wish-image")
        imageOfItem.image = fetchedImage ?? defaultImage
    }

}
