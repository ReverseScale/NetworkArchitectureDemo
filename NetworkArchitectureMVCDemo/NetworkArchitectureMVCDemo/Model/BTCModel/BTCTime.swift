//
//	BTCTime.swift
//
//	Create by Steven Xie on 27/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BTCTime : NSObject, NSCoding, Mappable{

	var updated : String?
	var updatedISO : String?
	var updateduk : String?


	class func newInstance(map: Map) -> Mappable?{
		return BTCTime()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		updated <- map["updated"]
		updatedISO <- map["updatedISO"]
		updateduk <- map["updateduk"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         updated = aDecoder.decodeObject(forKey: "updated") as? String
         updatedISO = aDecoder.decodeObject(forKey: "updatedISO") as? String
         updateduk = aDecoder.decodeObject(forKey: "updateduk") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if updated != nil{
			aCoder.encode(updated, forKey: "updated")
		}
		if updatedISO != nil{
			aCoder.encode(updatedISO, forKey: "updatedISO")
		}
		if updateduk != nil{
			aCoder.encode(updateduk, forKey: "updateduk")
		}

	}

}