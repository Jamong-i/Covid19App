//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by Jamong on 2023/01/11.
//

import UIKit

class CovidDetailViewController: UITableViewController {

	@IBOutlet var newCaseCell: UITableViewCell!
	@IBOutlet var totalCaseCell: UITableViewCell!
	@IBOutlet var recoverdCell: UITableViewCell!
	@IBOutlet var deathCell: UITableViewCell!
	@IBOutlet var percentageCell: UITableViewCell!
	@IBOutlet var overseasInflowCell: UITableViewCell!
	@IBOutlet var reginalOutbreakCell: UITableViewCell!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
