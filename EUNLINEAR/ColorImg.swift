//
//  ColorImg.swift
//  EUNLINEAR
//
//  Created by EunYeongKim on 2021/08/20.
//

import Foundation

struct ColorImg {
	var img: String
	
	init(img: String) {
		self.img = img
	}
	
	static var colorList: [ColorImg] {
		let array = Array(1...10)
		return array.map { ColorImg(img: "img_\($0)") }
	}
}
