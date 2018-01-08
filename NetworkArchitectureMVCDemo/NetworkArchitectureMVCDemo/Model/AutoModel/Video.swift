//
//	Video.swift
//
//	Create by Steven Xie on 12/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Video : NSObject, NSCoding, Mappable{

	var id : Int?
	var image : String?
	var length : Int?
	var name : String?
	var url : String?


	class func newInstance(map: Map) -> Mappable?{
		return Video()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["id"]
		image <- map["image"]
		length <- map["length"]
		name <- map["name"]
		url <- map["url"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         length = aDecoder.decodeObject(forKey: "length") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if length != nil{
			aCoder.encode(length, forKey: "length")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}

	}

}