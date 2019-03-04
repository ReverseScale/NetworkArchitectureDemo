//
//	AIAnswer.swift
//
//	Create by Tim Tse on 4/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AIAnswer : NSObject, NSCoding, Mappable{

	var answer : String?
	var choices : [AnyObject]?
	var question : String?
	var respond : String?
	var score : Int?
	var semanticId : String?
	var suggestions : [AnyObject]?


	class func newInstance(map: Map) -> Mappable?{
		return AIAnswer()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		answer <- map["answer"]
		choices <- map["choices"]
		question <- map["question"]
		respond <- map["respond"]
		score <- map["score"]
		semanticId <- map["semanticId"]
		suggestions <- map["suggestions"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         answer = aDecoder.decodeObject(forKey: "answer") as? String
         choices = aDecoder.decodeObject(forKey: "choices") as? [AnyObject]
         question = aDecoder.decodeObject(forKey: "question") as? String
         respond = aDecoder.decodeObject(forKey: "respond") as? String
         score = aDecoder.decodeObject(forKey: "score") as? Int
         semanticId = aDecoder.decodeObject(forKey: "semanticId") as? String
         suggestions = aDecoder.decodeObject(forKey: "suggestions") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if answer != nil{
			aCoder.encode(answer, forKey: "answer")
		}
		if choices != nil{
			aCoder.encode(choices, forKey: "choices")
		}
		if question != nil{
			aCoder.encode(question, forKey: "question")
		}
		if respond != nil{
			aCoder.encode(respond, forKey: "respond")
		}
		if score != nil{
			aCoder.encode(score, forKey: "score")
		}
		if semanticId != nil{
			aCoder.encode(semanticId, forKey: "semanticId")
		}
		if suggestions != nil{
			aCoder.encode(suggestions, forKey: "suggestions")
		}

	}

}