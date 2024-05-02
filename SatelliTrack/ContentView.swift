//
//  ContentView.swift
//  SatelliTrack
//
//  Created by Hugo Pereira on 02/05/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var satellites: [Satellite] = []
    let FILE_NAME = "satellite_data.txt"

    var body: some View {
        VStack {
            MapView(satellites: satellites)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    DownloadManager.shared.downloadFile()
                    // Récupérer l'URL du fichier téléchargé
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileURL = documentsURL.appendingPathComponent("satellite_data.txt")
                                
                    // Parser le fichier TLE pour extraire les informations des satellites
                    if let satellites = TLEParser.parseTLEFile(at: fileURL) {
                        self.satellites = satellites
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
