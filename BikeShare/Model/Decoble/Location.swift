//
//	Location.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Location : Codable {

	let latitude : Float
	let longitude : Float


	enum CodingKeys: String, CodingKey {
		case latitude = "latitude"
		case longitude = "longitude"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		latitude = try values.decode(Float.self, forKey: .latitude)
		longitude = try values.decode(Float.self, forKey: .longitude)
	}
    
   
}

extension  Location {
    
    
    init (lat:Float,long:Float){
        self.latitude = lat
        self.longitude = long
    }
    
    func payload() -> Dictionary<String, Float> {
    
       return [
        "latitude" : self.latitude,
        "longitude" : self.longitude]
    }

    
}

