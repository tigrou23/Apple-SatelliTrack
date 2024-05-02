# SatelliTrack 

> Track satellites in real time with your iPhone 🛰️

## Preview
![327555130-b19bb6f3-a3a6-4683-8e8b-c720994ed095](https://github.com/tigrou23/Apple-SatelliTrack/assets/54220880/c54327e5-352a-488f-9d4f-ae482bb28cb2)
## Presentation
SatelliTack is an iOS app that allows you to track satellites in real time. It gets the data from [CelesTrak](https://www.celestrak.com/) and displays it in a user-friendly way with a map. 

The app is written in [Swift](https://www.swift.org/), [SwiftUI](https://developer.apple.com/xcode/swiftui/) and uses the [MapKit](https://developer.apple.com/documentation/mapkit/) framework to display the satellite positions on a map.

## Data and Calculations

We are using the [NORAD GP Element Sets](https://www.celestrak.com/NORAD/elements/) to get the satellite data. The API provides the TLE (Two-Line Element Set) data for the satellites. The TLE data is used to calculate the satellite position and display it on the map.

Thanks to [SGP4](https://en.wikipedia.org/wiki/Simplified_perturbations_models) (Simplified General Perturbations 4) we can calculate the satellite position with high accuracy. We are using the Swift package [SGP4-Swift](https://swiftpackageindex.com/csanfilippo/swift-sgp4).

___
### // TODO:
- [ ] Add the Gen2 GlobalStar constellation to the app
- [ ] Stop removing all annotations and only update the existing ones
- [ ] Add the user location annotation
- [ ] Add a button to center the map on the user location
- [ ] Add the satellite name to the annotation
- [ ] Add a search bar to filter the satellites by name
