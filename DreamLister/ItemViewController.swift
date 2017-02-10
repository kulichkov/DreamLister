//
//  ItemViewController.swift
//  DreamLister
//
//  Created by Mikhail Kulichkov on 08/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleFld: UITextField!
    @IBOutlet weak var priceFld: UITextField!
    @IBOutlet weak var detailsFld: UITextView!

    var imagePickerController = UIImagePickerController()
    var stores = [Store]()
    var currentItem: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        storePicker.dataSource = self
        storePicker.delegate = self
        imagePickerController.delegate = self
        //generateStores()
        fetchStores()
        fillItemForm()
        // Configure navigation items
        if let navItem = self.navigationController?.navigationBar.topItem {
            navItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        detailsFld.layer.borderWidth = 1.0
        detailsFld.layer.cornerRadius = 5.0
        detailsFld.layer.borderColor = UIColor(netHex: 0xE6E6E6).cgColor
        //UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0).cgColor

    }

    func fillItemForm() {
        if let item = currentItem {
            titleFld.text = item.title
            priceFld.text = "$\(item.price)"
            detailsFld.text = item.details
            image.image = (item.toImage?.image as? UIImage) ?? #imageLiteral(resourceName: "img-default")
            if let currentStore = item.toStore {
                if let storeIndex = stores.index(of: currentStore) {
                    storePicker.selectRow(storeIndex, inComponent: 0, animated: true)
                }
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name ?? nil
    }

    func fetchStores() {
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let sorting = NSSortDescriptor(key: "name", ascending: true)
        storeFetchRequest.sortDescriptors = [sorting]
        do {
            try self.stores = itemContext.fetch(storeFetchRequest)
            if self.stores != [] { storePicker.reloadAllComponents() }
        } catch let error {
            print(error.localizedDescription)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = image
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }

    private func generateStores() {
        for index in 0...5 {
            let store = Store(context: itemContext)
            store.name = "Store #\(index)"
            stores.append(store)
        }
        appDelegate.saveContext()
    }

    @IBAction func savePressed(_ sender: UIButton) {
        if titleFld.text == "" {
            return
        }
        var item: Item!
        let picture = Image(context: itemContext)
        picture.image = image.image
        if currentItem != nil {
            item = currentItem
        } else {
            item = Item(context: itemContext)
        }

        item.title = titleFld.text
        let nsStrPrice = priceFld.text as NSString?
        item.price = nsStrPrice?.doubleValue ?? 0
        item.details = detailsFld.text
        item.toImage = picture
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        appDelegate.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

   @IBAction func imagePick(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        itemContext.delete(currentItem!)
        appDelegate.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
