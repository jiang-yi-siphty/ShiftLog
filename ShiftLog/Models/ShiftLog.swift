//
//	ShiftLog.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ShiftLog : Codable {

	let end : String?
	let endLatitude : String?
	let endLongitude : String?
	let id : Int?
	let image : String?
	let start : String?
	let startLatitude : String?
	let startLongitude : String?

	enum CodingKeys: String, CodingKey {
		case end = "end"
		case endLatitude = "endLatitude"
		case endLongitude = "endLongitude"
		case id = "id"
		case image = "image"
		case start = "start"
		case startLatitude = "startLatitude"
		case startLongitude = "startLongitude"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		end = try values.decodeIfPresent(String.self, forKey: .end)
		endLatitude = try values.decodeIfPresent(String.self, forKey: .endLatitude)
		endLongitude = try values.decodeIfPresent(String.self, forKey: .endLongitude)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		start = try values.decodeIfPresent(String.self, forKey: .start)
		startLatitude = try values.decodeIfPresent(String.self, forKey: .startLatitude)
		startLongitude = try values.decodeIfPresent(String.self, forKey: .startLongitude)
	}

}
