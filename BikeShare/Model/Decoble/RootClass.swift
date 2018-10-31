//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct BikeRootModel  : Codable {

	let color : String
	let id : String?
	var location : Location
	let name : String
	let pin : String
	let rented : Bool?


	enum CodingKeys: String, CodingKey {
		case color = "color"
		case id = "id"
		case location = "location"
		case name = "name"
		case pin = "pin"
		case rented = "rented"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		color = try values.decode(String.self, forKey: .color)
		location = try values.decode(Location.self, forKey: .location)
		name = try values.decode(String.self, forKey: .name)
		pin = try values.decode(String.self, forKey: .pin)
		rented = try values.decodeIfPresent(Bool.self, forKey: .rented)
      
        
        do {
            id = try values.decodeIfPresent(String.self, forKey: .id) // need to check
        } catch {
            let systemID = try values.decodeIfPresent(Int.self, forKey: .id)
            id = String(systemID!)// need to check
        }

	}

    
  

}


extension  BikeRootModel {
    
    
    init(name:String,color: String, location: Location,pin:String) {
        self.color = color
        self.location = Location(lat: location.latitude, long: location.longitude)
        self.name = name
        self.pin = pin
        self.id = nil
        self.rented = nil

    }

    func payload() -> Dictionary<String,Any> {

            return [
            "color" :self.color,
            "name" : self.name,
            "pin" : self.pin,
            "location" : location.payload()]
    }
    
}

