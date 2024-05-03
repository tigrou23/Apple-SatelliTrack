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
    @State private var showingAlert = false
    let FILE_NAME = "satellite_tle.txt"

    var body: some View {
        VStack {

            MapView(satellites: satellites)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    //DownloadManager.shared.downloadFile()
                    updateFromFile()
                }
            .alert("bad data, maybe too many queries?", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            let message: String = String(satellites.count);
            Text("Number of satellites: \(message)")
            Button("Reset"){
                DownloadManager.shared.downloadFile()
                sleep(4)
                updateFromFile()
            }
        }
    }
    
    func updateFromFile(){
        // Get the file URL
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(FILE_NAME)
                    
        // Parse the TLE file to extract the satellite information
        if let satellites = TLEParser.parseTLEFile(at: fileURL) {
            self.satellites = satellites
        }
        
        if satellites.count == 0 { showingAlert = true }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
