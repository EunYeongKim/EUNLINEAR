//
//  ViewController.swift
//  EUNLINEAR
//
//  Created by EunYeongKim on 2021/08/20.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var linearPageController: LinearPageController!
	
	let cellSize = CGSize(width: 300, height: 200)
	let insetSize: CGFloat = 10
	let lineSpacing: CGFloat = 10
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		
		// PageController numberOfPage 설정
		linearPageController.numberOfPages = ColorImg.colorList.count
	}
	
	func configureCollectionView() {
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.decelerationRate = .fast
	}
}

extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ColorImg.colorList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! CollectionViewCell
		cell.imageView.image = UIImage(named: ColorImg.colorList[indexPath.row % ColorImg.colorList.count].img)
		return cell
	}
}

extension ViewController: UIScrollViewDelegate {
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let cellWithSpacingWidth =  cellSize.width + lineSpacing
		var offset = targetContentOffset.pointee
		let index = (offset.x + scrollView.contentInset.left) / cellWithSpacingWidth
		let roundedIndex: CGFloat = round(index)

		offset = CGPoint(x: roundedIndex * cellWithSpacingWidth - (scrollView.contentInset.left + lineSpacing + insetSize), y: scrollView.contentInset.top)
		targetContentOffset.pointee = offset
		
		// PageController 호출
		linearPageController.currentPage = Int(roundedIndex)
	}
}


