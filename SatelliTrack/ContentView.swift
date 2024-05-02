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
                    // Get the file URL
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileURL = documentsURL.appendingPathComponent(FILE_NAME)
                                
                    // Parse the TLE file to extract the satellite information
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
