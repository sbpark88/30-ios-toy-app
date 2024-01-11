//
//  CardListTableViewController.swift
//  CreditCardList
//
//  Created by 박새별 on 1/9/24.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListTableViewController: UITableViewController {
    
    var ref: DatabaseReference! // Firebase Realtime Database
    
    var creditCards: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        let nib = UINib(nibName: "CardListCell", bundle: nil)   // .xib file name(not identifier)
        tableView.register(nib, forCellReuseIdentifier: "CardListCell") // identifier of nib UI
        
        // Database
        ref = Database.database().reference()
        ref.observe(.value, with: { [unowned self] snapshot in
            guard let value = snapshot.value as? NSDictionary else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCards = cardList.sorted { $0.rank < $1.rank }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("ERROR: JSON parsing error \(error.localizedDescription)")
            }
        })
                
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creditCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return CardListCell() }
                
        let card = creditCards[indexPath.row]
        cell.rankLabel.text = "\(card.rank)위"
        cell.promotionLabel.text = "\(card.promotionDetail.amount)만원 캐시백"
        cell.cardNameLabel.text = "\(card.name)"
        
        let imageURL = URL(string: card.cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cardDetailViewController = self.storyboard?.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        cardDetailViewController.promotionDetail = creditCards[indexPath.row].promotionDetail
//        self.navigationController?.pushViewController(cardDetailViewController, animated: true)
        self.show(cardDetailViewController, sender: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
