//
//  CardListTableViewController.swift
//  CreditCardList
//
//  Created by 박새별 on 1/9/24.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

class CardListTableViewController: UITableViewController {
    
    // Realtime Database Code
    var ref: DatabaseReference! // Firebase Realtime Database
    
    
    // Firestore Code
    let COLLECTION_NAME = "creditCardList"
    var db: Firestore!
    
    var creditCards: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        let nib = UINib(nibName: "CardListCell", bundle: nil) // .xib file name(not identifier)
        tableView.register(nib, forCellReuseIdentifier: "CardListCell") // identifier of nib UI
        
        /* Realtime Database Code */
        // Database
        ref = Database.database().reference()
        // MARK: Firebase Realtime Database GET
        //        ref.observe(.value, with: { [unowned self] snapshot in
        //            guard let value = snapshot.value as? NSDictionary else { return }
        //            guard let cardData = try? DataUtil().fromDictionary([String: CreditCard].self, withJSONObject: value) else { return }
        //            self.creditCards = cardData.values.sorted { $0.rank < $1.rank }
        //            
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        })
        
        /* Firestore Code */
        // Database
        db = Firestore.firestore()
        // MARK: Firebase Firestore GET
        db.collection(COLLECTION_NAME).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("ERROR: Fetching documents \(error!.localizedDescription)")
                return
            }
            self.creditCards = documents.compactMap {
                let document: [String: Any] = $0.data()
                guard let cardData = try? DataUtil().fromDictionary(CreditCard.self, withJSONObject: document) else { return nil }
                return cardData
            }.sorted { $0.rank < $1.rank }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
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
        updateSelected(id: creditCards[indexPath.row].id)
    }
    
    private func updateSelected(id: Int?) {
        guard let id else { return }
        
        /* Realtime Database Code */
        // 대상의 경로를 확신할 수 있을 때
        //        ref.child("Item\(id)/isSelected").setValue(true)
        
        // 대상의 경로를 확신할 수 없을 때, 쿼리를 날린다
//        ref.queryOrdered(byChild: "id")
//            .queryEqual(toValue: id).observe(.value) { [weak self] snapshot in
//                guard let strongSelf = self,
//                      let value = snapshot.value as? NSDictionary,
//                      let key = value.allKeys.first as? String else { return }
//
//                // MARK: Firebase Realtime Database PUT
//                //                let newCard: CreditCard = strongSelf.creditCards.enumerated().filter { (index, value) in
//                //                    value.id == id
//                //                }.map {
//                //                    let current = $0.element
//                //
//                //                    return CreditCard(id: current.id,
//                //                                      rank: current.rank,
//                //                                      name: current.name,
//                //                                      cardImageURL: current.cardImageURL,
//                //                                      promotionDetail: current.promotionDetail,
//                //                                      isSelected: true)
//                //                }[0]
//                //                guard let data = try? DataUtil().toDictionary(newCard) else { return }
//                //                strongSelf.ref.child(key).setValue(data)   // e.g. ref.child("Item2").setValue(data)
//
//                // MARK: Firebase Realtime Database PATCH
//                //                strongSelf.ref.child("\(key)/isSelected").setValue(true)   // e.g. ref.child("Item2/isSelected").setValue(true)
//            }
        
        /* Firestore Code */
        // 대상의 경로를 확신할 수 있을 때
//        db.collection(COLLECTION_NAME).document("Item\(id)").updateData(["isSelected": true])
        
        // 대상의 경로를 확신할 수 없을 때, 쿼리를 날린다
        db.collection(COLLECTION_NAME)
            .whereField("id", isEqualTo: id)
            .getDocuments { querySnapshot, error in
                guard let document = querySnapshot?.documents.first else {
                    print("ERROR: Cannot find document, \(error!.localizedDescription)")
                    return
                }
                
                document.reference.updateData(["isSelected": true])
            }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = creditCards[indexPath.row].id
            
            /* Realtime Database Code */
            // 대상의 경로를 확신할 수 있을 때
            //            ref.child("Item\(id)").removeValue()
            
            // 대상의 경로를 확신할 수 없을 때, 쿼리를 날린다
//            ref.queryOrdered(byChild: "id")
//                .queryEqual(toValue: id)
//                .observe(.value) { [weak self] snapshot in
//                    guard let strongSelf = self,
//                          let value = snapshot.value as? NSDictionary,
//                          let key = value.allKeys.first as? String else { return }
//                    
//                    strongSelf.ref.child(key).removeValue()
//                }
            
            /* Firestore Code */
            // 대상의 경로를 확신할 수 있을 때
//            db.collection(COLLECTION_NAME).document("Item\(id)").delete()
            
            // 대상의 경로를 확신할 수 없을 때, 쿼리를 날린다
            db.collection(COLLECTION_NAME)
                .whereField("id", isEqualTo: id)
                .getDocuments { querySnapshot, error in
                    guard let document = querySnapshot?.documents.first else {
                        print("ERROR: Cannot find document, \(error!.localizedDescription)")
                        return
                    }
                    
                    document.reference.delete()
                }
        }
    }
    
}
