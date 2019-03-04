//
//	AIChatModel.swift
//
//	Create by Tim Tse on 4/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AIChatModel : NSObject, NSCoding, Mappable{

	var answers : [AIAnswer]?
	var channel : String?
	var chatId : String?
	var question : String?
	var sessionId : String?
	var userId : String?


	class func newInstance(map: Map) -> Mappable?{
		return AIChatModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		answers <- map["answers"]
		channel <- map["channel"]
		chatId <- map["chatId"]
		question <- map["question"]
		sessionId <- map["sessionId"]
		userId <- map["userId"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         answers = aDecoder.decodeObject(forKey: "answers") as? [AIAnswer]
         channel = aDecoder.decodeObject(forKey: "channel") as? String
         chatId = aDecoder.decodeObject(forKey: "chatId") as? String
         question = aDecoder.decodeObject(forKey: "question") as? String
         sessionId = aDecoder.decodeObject(forKey: "sessionId") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if answers != nil{
			aCoder.encode(answers, forKey: "answers")
		}
		if channel != nil{
			aCoder.encode(channel, forKey: "channel")
		}
		if chatId != nil{
			aCoder.encode(chatId, forKey: "chatId")
		}
		if question != nil{
			aCoder.encode(question, forKey: "question")
		}
		if sessionId != nil{
			aCoder.encode(sessionId, forKey: "sessionId")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}

	}

}