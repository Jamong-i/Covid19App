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
	
	var covidOverview: CovidOverview?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureView()
	}
	
	func configureView() {
		guard let covidOverview = self.covidOverview else { return }
		self.title = covidOverview.countryName
		self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
		self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
		self.recoverdCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
		self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
		self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
		self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
		self.reginalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
	}
}
