//
//  TLEParser.swift
//  SatelliTrack
//
//  Created by Hugo Pereira on 02/05/2024.
//

import Foundation
import CoreLocation
import SGPKit

/// Structure to store the satellite data
struct Satellite {
    let name: String
    let line1: String
    let line2: String
}

/// Class to parse the TLE file and extract the satellite data
class TLEParser {
    
    /// Parse the TLE file and extract the satellite data
    /// - Parameter url: The URL of the TLE file
    /// - Returns: An array of Satellite objects
    static func parseTLEFile(at url: URL) -> [Satellite]? {
        do {
            // Read the content of the file
            let tleString = try String(contentsOf: url)
            
            // Split the file content into lines
            let lines = tleString.components(separatedBy: .newlines)
            
            var satellites: [Satellite] = []
            var name = ""
            var line1 = ""
            var line2 = ""
            
            // Loop through the lines to extract the satellite data
            for line in lines {
                if line.isEmpty { continue }
                // If it's a name, save the name
                if !line.hasPrefix("1 ") && !line.hasPrefix("2 ") {
                    name = line.trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    if line.hasPrefix("1 ") {
                        line1 = line
                    } else if line.hasPrefix("2 ") {
                        line2 = line
                        let satellite = Satellite(name: name, line1: line1, line2: line2)
                        satellites.append(satellite)
                    }
                }
            }
            return satellites
        } catch {
            print("Erreur de lecture du fichier TLE : \(error)")
            return nil
        }
    }
    
    /// Extract the coordinate from a satellite
    /// - Parameter satellite: The satellite object
    /// - Returns: The coordinate of the satellite
    static func extractCoordinate(from satellite: Satellite) -> CLLocationCoordinate2D? {
        let name = satellite.name
        let tleLine1 = satellite.line1
        let tleLine2 = satellite.line2
                
        // Instantiate a new TLE descriptor
        let tle = TLE(title: name, firstLine: tleLine1, secondLine: tleLine2)

        // Instantiate the interpreter
        let interpreter = TLEInterpreter()

        // Obtain the data
        let data: SatelliteData = interpreter.satelliteData(from: tle, date: .now)

        let latitude = data.latitude
        let longitude = data.longitude
        
        //TODO: set the name of the satellite?
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
