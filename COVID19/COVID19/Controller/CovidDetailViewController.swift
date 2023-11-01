//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 박새별 on 10/29/23.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    var selectedCityCovidOverview: CovidOverview?

    override func viewDidLoad() {
        super.viewDidLoad()
        displayOverview()
    }
    
    func displayOverview() {
        guard let overview = selectedCityCovidOverview else { return }
        self.title = overview.countryName
        newCaseCell.detailTextLabel?.text = "\(overview.newCase)명"
        totalCaseCell.detailTextLabel?.text = "\(overview.totalCase)명"
        recoveredCell.detailTextLabel?.text = "\(overview.recovered)명"
        deathCell.detailTextLabel?.text = "\(overview.death)명"
        percentageCell.detailTextLabel?.text = "\(overview.percentage)%"
        overseasInflowCell.detailTextLabel?.text = "\(overview.newFcase)명"
        regionalOutbreakCell.detailTextLabel?.text = "\(overview.newCcase)명"
    }

}
