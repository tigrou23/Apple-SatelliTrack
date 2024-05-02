//
//  DownloadManager.swift
//  SatelliTrack
//
//  Created by Hugo Pereira on 02/05/2024.
//

import Foundation

/// Class to manage the download of the TLE file from Celestrak
class DownloadManager {
    static let shared = DownloadManager()
    
    let CELESTRAK_URL = URL(string: "https://www.celestrak.com/NORAD/elements/amateur.txt")!
    let FILE_NAME = "satellite_data.txt"
    
    /// Download the TLE file from Celestrak
    func downloadFile() {
        URLSession.shared.downloadTask(with: CELESTRAK_URL) { (location, response, error) in
            guard let location = location, error == nil else {
                print("Erreur de téléchargement : \(error!.localizedDescription)"); return
            }
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsURL.appendingPathComponent(self.FILE_NAME)
            try? FileManager.default.moveItem(at: location, to: destinationURL)
            print("Téléchargement terminé. Fichier enregistré à : \(destinationURL)")
        }.resume()
    }
}