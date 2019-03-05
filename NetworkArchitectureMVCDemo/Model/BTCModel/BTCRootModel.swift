//
//	BTCRootModel.swift
//
//	Create by Steven Xie on 27/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BTCRootModel : NSObject, NSCoding, Mappable{

	var bpi : BTCBpi?
	var disclaimer : String?
	var time : BTCTime?


	class func newInstance(map: Map) -> Mappable?{
		return BTCRootModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		bpi <- map["bpi"]
		disclaimer <- map["disclaimer"]
		time <- map["time"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bpi = aDecoder.decodeObject(forKey: "bpi") as? BTCBpi
         disclaimer = aDecoder.decodeObject(forKey: "disclaimer") as? String
         time = aDecoder.decodeObject(forKey: "time") as? BTCTime

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bpi != nil{
			aCoder.encode(bpi, forKey: "bpi")
		}
		if disclaimer != nil{
			aCoder.encode(disclaimer, forKey: "disclaimer")
		}
		if time != nil{
			aCoder.encode(time, forKey: "time")
		}

	}

}