//
//  BoardView.swift
//  Comboz!
//
//  Created by Alexander Ushakov on 19.05.2018.
//  Copyright © 2018 Alexander Ushakov. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var cardViews = [CardView]()

    var gridRows: Int { return gridCards?.dimensions.rowCount ?? 0 }
   
    private var gridCards: ScreenGrid?
    
    private func layoutSetCard() {
        if let grid = gridCards {
        if grid.cellCount >= 12 {
            for row in 0..<gridRows {
                for column in 0..<grid.dimensions.columnCount {
                    if cardViews.count > (row * grid.dimensions.columnCount + column) {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                                       delay: TimeInterval(column + row) * 0.1,
                                                                       options: [.curveEaseInOut],
                                                                       animations: {
                                                                        self.cardViews[row * grid.dimensions.columnCount + column].frame = grid[row,column]!.insetBy(dx: Constants.spacingDx, dy: Constants.spacingDy)
                                                                    },completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func removeCardsView(cardsViewForRemove: [CardView]) {
        cardsViewForRemove.forEach{ (cardView) in
            cardViews.removeArray(elements: [cardView])
            cardView.removeFromSuperview()
        }
        layoutIfNeeded()
    }
    
    func addCardsView(newCardsView: [CardView]) {
        cardViews += newCardsView
        newCardsView.forEach{ (cardView) in
            cardView.center = CGPoint(x: bounds.midX, y: bounds.maxY + cardView.bounds.size.height)
            addSubview(cardView)
        }
        layoutIfNeeded()
    }
    
    func resetAllCards() {
        cardViews.forEach{ (cardView) in
//            cardView.removeFromSuperview()
            cardView.alpha = 0
        }
        cardViews = []
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridCards = ScreenGrid(layout: ScreenGrid.Layout.aspectRatio(Constants.cellRatio), frame: bounds)
        gridCards?.cellCount = cardViews.count
        layoutSetCard()
    }

    struct Constants {
        static let cellRatio: CGFloat = 0.625
        static let spacingDx: CGFloat = 4.0
        static let spacingDy: CGFloat = 4.0
    }

}
