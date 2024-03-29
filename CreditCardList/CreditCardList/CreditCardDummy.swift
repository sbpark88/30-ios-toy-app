//
//  CreditCardDummy.swift
//  CreditCardList
//
//  Created by Bo-Young PARK on 2021/07/13.
//

import Foundation

fileprivate struct CreditCardList {
    static let card0 = CreditCard(id: 0, rank: 1, name: "신한카드", cardImageURL: "https://www.shinhancard.com/_ICSFiles/afieldfile/2019/04/26/190426_pc_mrlife_cardplate600x380.png", promotionDetail: PromotionDetail(companyName: "신한", period: "2023.01.07(목)~2023.01.31(토)", amount: 13, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상 결제", benefitDetail: "현금 10만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card1 = CreditCard(id: 1, rank: 2, name: "taptap S", cardImageURL: "https://static11.samsungcard.com/wcms/scard/personal/__icsFiles/afieldfile/2019/06/12/AAP1482_s.png", promotionDetail: PromotionDetail(companyName: "삼성", period: "2023.01.07(목)~2023.01.31(토)", amount: 12, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상 결제", benefitDetail: "포인트 10만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card2 = CreditCard(id: 2, rank: 3, name: "KB국민 톡톡", cardImageURL: "https://img1.kbcard.com/ST/img/cxc/kbcard/upload/img/product/09223.png", promotionDetail: PromotionDetail(companyName: "KB국민", period: "2023.01.07(목)~2023.01.31(토)", amount: 13, condition: "온라인 채널을 통해 대상카드를 보유하신 분", benefitCondition: "이벤트 카드로 10만원 이상 이용 ", benefitDetail: "현금 10만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card3 = CreditCard(id: 3, rank: 4, name: "올바른 FLEX 카드", cardImageURL: "https://card.nonghyup.com/content/imgs/shopmall/pro_img/card/F10043.png", promotionDetail: PromotionDetail(companyName: "농협", period: "2023.01.07(목)~2023.01.31(토)", amount: 10, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 이벤트에 응모하신 분", benefitCondition: "이벤트 대상 카드로 누적 10만원 이상 이용", benefitDetail: "현금 10만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card4 = CreditCard(id: 4, rank: 5, name: "신한카드 Deep Dream", cardImageURL: "https://www.shinhancard.com/pconts/images/contents/card/plate/cdCreaditBJABE3.png", promotionDetail: PromotionDetail(companyName: "신한", period: "2023.01.07(목)~2023.01.31(토)", amount: 7, condition: "해당카드 보유회원", benefitCondition: "해당 카드로 결제기간동안 합산 8만원 이상 결제", benefitDetail: "포인트 8만원", benefitDate: "2023.04.01(목)이후"), isSelected: nil)
    static let card5 = CreditCard(id: 5, rank: 6, name: "우리 카드의 정석 POINT", cardImageURL: "https://pc.wooricard.com/webcontent/cdPrdImgFileList/2020/6/30/15a0b20b-f685-4155-a9bf-5e71674ab674.png", promotionDetail: PromotionDetail(companyName: "우리", period: "2023.01.07(목)~2023.01.31(토)", amount: 4, condition: "온라인 채널을 통해 이벤트 카드를 받은 고객 중 이벤트에 응모하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상", benefitDetail: "현금 8만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card6 = CreditCard(id: 6, rank: 7, name: "NEW 씨티 클리어 카드", cardImageURL: "https://www.citibank.co.kr/download/cms/card/master/070045_8.png", promotionDetail: PromotionDetail(companyName: "씨티", period: "2023.01.07(목)~2023.01.31(토)", amount: 7, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상 이용 (1인 1회한)", benefitDetail: "7만원 캐시백", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card7 = CreditCard(id: 7, rank: 8, name: "하나 클럽SK 카드", cardImageURL: "https://www.hanacard.co.kr/ATTACH/NEW_HOMEPAGE/images/cardinfo/card_img/03496.png", promotionDetail: PromotionDetail(companyName: "하나", period: "2023.01.07(목)~2023.01.31(토)", amount: 7, condition: "참여 기간 내 응모하고 이벤트 대상 카드 이용한 손님", benefitCondition: "이벤트 카드로 합산 7만원이상 결제", benefitDetail: "현금 7만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
    static let card8 = CreditCard(id: 8, rank: 9, name: "LIKIT FUN+", cardImageURL: "https://image.lottecard.co.kr/UploadFiles/ecenterPath/cdInfo/ecenterCdInfoP12158-A12158_nm1_v.gif", promotionDetail: PromotionDetail(companyName: "롯데", period: "2023.01.07(목)~2023.01.31(토)", amount: 5, condition: "온라인 채널을 통해 이벤트 카드를 보유한 회원 중 아래 '이벤트 참여하기'를 통해 이벤트에 응모한 회원", benefitCondition: "이벤트 카드로 합산 5만원 이상 이용 시 5만원 캐시백(1인 1회)", benefitDetail: "현금 5만원", benefitDate: "2023.09.01(금)이전"), isSelected: nil)
    static let card9 = CreditCard(id: 9, rank: 10, name: "IBK 무민", cardImageURL: "https://www.bccard.com/images/individual/card/renew/list/card_100914.png", promotionDetail: PromotionDetail(companyName: "IBK기업은행", period: "2023.01.07(목)~2023.01.31(토)", amount: 5, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상 결제", benefitDetail: "포인트 5만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
}

let CreditCardDummy: [String: CreditCard] = [
    "Item0": CreditCardList.card0,
    "Item1": CreditCardList.card1,
    "Item2": CreditCardList.card2,
    "Item3": CreditCardList.card3,
    "Item4": CreditCardList.card4,
    "Item5": CreditCardList.card5,
    "Item6": CreditCardList.card6,
    "Item7": CreditCardList.card7,
    "Item8": CreditCardList.card8,
    "Item9": CreditCardList.card9
]
