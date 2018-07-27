//
//	BTCBpi.swift
//
//	Create by Steven Xie on 27/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BTCBpi : NSObject, NSCoding, Mappable{

	var cNY : BTCCNY?
	var uSD : BTCCNY?


	class func newInstance(map: Map) -> Mappable?{
		return BTCBpi()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		cNY <- map["CNY"]
		uSD <- map["USD"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cNY = aDecoder.decodeObject(forKey: "CNY") as? BTCCNY
         uSD = aDecoder.decodeObject(forKey: "USD") as? BTCCNY

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cNY != nil{
			aCoder.encode(cNY, forKey: "CNY")
		}
		if uSD != nil{
			aCoder.encode(uSD, forKey: "USD")
		}

	}

}