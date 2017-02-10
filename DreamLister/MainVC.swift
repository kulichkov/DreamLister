//
//  MainVC.swift
//  DreamLister
//
//  Created by Mikhail Kulichkov on 07/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let itemContext = appDelegate.persistentContainer.viewContext

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var itemFRC: NSFetchedResultsController<Item>!

    // MARK: - IBOutlets

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //generateContent()
        attemptFetch()
    }

    // MARK: - TableView Delegate And DataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let itemCell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath) as? ItemTableViewCell {
            configureCell(itemCell, indexPath: indexPath)
            return itemCell
        } else {
            return UITableViewCell()
        }
    }

    func configureCell(_ cell: ItemTableViewCell, indexPath: IndexPath) {
        let item = itemFRC.object(at: indexPath) as Item
        cell.configureCell(item: item)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchedSectionInfo = itemFRC.sections?[section] {
            return fetchedSectionInfo.numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemViewController", sender: itemFRC.object(at: indexPath))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return itemFRC.sections?.count ?? 0
    }

    func attemptFetch() {
        let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        itemFetchRequest.sortDescriptors = [createdSort]
        itemFRC = NSFetchedResultsController(fetchRequest: itemFetchRequest, managedObjectContext: itemContext, sectionNameKeyPath: nil, cacheName: nil)
        itemFRC.delegate = self
        do {
            try itemFRC.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let deletedIndexPath = indexPath {
                tableView.deleteRows(at: [deletedIndexPath], with: .fade)
            }
        case .insert:
            if let insertedIndexPath = newIndexPath {
                tableView.insertRows(at: [insertedIndexPath], with: .fade)
            }
        case .move:
            if let deletedIndexPath = indexPath {
                tableView.deleteRows(at: [deletedIndexPath], with: .fade)
            }
            if let insertedIndexPath = newIndexPath {
                tableView.insertRows(at: [insertedIndexPath], with: .fade)
            }
        case .update:
            if let updatedIndexPath = indexPath {
                if let updatedCell = tableView.cellForRow(at: updatedIndexPath) as? ItemTableViewCell {
                    if let item = controller.object(at: updatedIndexPath) as? Item {
                        updatedCell.configureCell(item: item)
                    }
                }
            }
        }
    }

    func generateContent() {
        let item1 = Item(context: itemContext)
        item1.title = "Ford Focus"
        item1.price = 50000
        item1.details = "This car is a dreamcar! Nobody can touch it! And someting like that.."
        let item2 = Item(context: itemContext)
        item2.title = "New MacBook Pro"
        item2.price = 1000
        item2.details = "Just a wonderful computer& Can't wait to buy it!"
        let item3 = Item(context: itemContext)
        item3.title = "Electric guitar"
        item3.price = 2000
        item3.details = "Just wanna rock and metal thigs up! Amp nad pedal are next!"

        appDelegate.saveContext()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        switch identifier {
        case "ItemViewController":
            if let item = sender as? Item {
                if let destination = segue.destination as? ItemViewController {
                    destination.currentItem = item
                    destination.navigationItem.title = "Edit Item"
                }
            }
        case "ItemViewControllerNew":
            if let destination = segue.destination as? ItemViewController {
                destination.navigationItem.title = "New item"
                destination.navigationItem.rightBarButtonItem = nil
            }
        default:
            break
        }
    }

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
