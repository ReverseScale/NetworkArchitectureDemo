//
//	TestListModel.swift
//
//	Create by Steven Xie on 12/9/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TestListModel : NSObject, NSCoding, Mappable{

	var videos : [Video]?


	class func newInstance(map: Map) -> Mappable?{
		return TestListModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		videos <- map["videos"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         videos = aDecoder.decodeObject(forKey: "videos") as? [Video]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if videos != nil{
			aCoder.encode(videos, forKey: "videos")
		}

	}

}