//
//	BTCCNY.swift
//
//	Create by Steven Xie on 27/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BTCCNY : NSObject, NSCoding, Mappable{

	var code : String?
	var descriptionField : String?
	var rate : String?
	var rateFloat : Float?


	class func newInstance(map: Map) -> Mappable?{
		return BTCCNY()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		code <- map["code"]
		descriptionField <- map["description"]
		rate <- map["rate"]
		rateFloat <- map["rate_float"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         code = aDecoder.decodeObject(forKey: "code") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         rate = aDecoder.decodeObject(forKey: "rate") as? String
         rateFloat = aDecoder.decodeObject(forKey: "rate_float") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if rate != nil{
			aCoder.encode(rate, forKey: "rate")
		}
		if rateFloat != nil{
			aCoder.encode(rateFloat, forKey: "rate_float")
		}

	}

}