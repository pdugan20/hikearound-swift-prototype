//
//  Hike.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import Foundation
import CoreLocation
import SwiftUI

struct Hike: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let difficulty: Difficulty
    let distance: Double // in miles
    let elevationGain: Double // in feet
    let estimatedTime: TimeInterval // in seconds
    
    // MARK: - Computed Properties
    var formattedTime: String {
        let hours = Int(estimatedTime) / 3600
        let minutes = Int(estimatedTime) % 3600 / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var formattedDistance: String {
        return "\(String(format: "%.1f", distance)) mi"
    }
    
    var formattedElevation: String {
        return "\(Int(elevationGain)) ft"
    }
    let imageURL: String?
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case moderate = "Moderate"
        case hard = "Hard"
        case expert = "Expert"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .moderate: return .blue
            case .hard: return .orange
            case .expert: return .red
            }
        }
    }
    
    static func == (lhs: Hike, rhs: Hike) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Sample data
extension Hike {
    static let sampleHikes = [
        Hike(
            name: "Eagle Peak Trail",
            description: "A scenic trail offering panoramic views of the valley below. Perfect for sunrise hikes with moderate elevation gain throughout.",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            difficulty: .moderate,
            distance: 5.2,
            elevationGain: 1200,
            estimatedTime: 3 * 3600,
            imageURL: nil
        ),
        Hike(
            name: "Redwood Loop",
            description: "Wind through ancient redwood groves on this family-friendly trail. Mostly shaded with gentle slopes.",
            coordinate: CLLocationCoordinate2D(latitude: 37.8716, longitude: -122.2727),
            difficulty: .easy,
            distance: 2.8,
            elevationGain: 300,
            estimatedTime: 1.5 * 3600,
            imageURL: nil
        ),
        Hike(
            name: "Summit Ridge Trail",
            description: "Challenging climb to the highest peak in the region. Experienced hikers only. Bring plenty of water.",
            coordinate: CLLocationCoordinate2D(latitude: 37.6879, longitude: -122.4702),
            difficulty: .expert,
            distance: 12.5,
            elevationGain: 3500,
            estimatedTime: 6 * 3600,
            imageURL: nil
        ),
        Hike(
            name: "Coastal Bluff Walk",
            description: "Stunning ocean views along dramatic cliffs. Watch for migrating whales during winter months.",
            coordinate: CLLocationCoordinate2D(latitude: 37.6909, longitude: -122.5037),
            difficulty: .easy,
            distance: 3.5,
            elevationGain: 200,
            estimatedTime: 2 * 3600,
            imageURL: nil
        ),
        Hike(
            name: "Mountain Lake Trail",
            description: "A beautiful trail leading to a pristine alpine lake. Great for swimming in summer months.",
            coordinate: CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.3821),
            difficulty: .hard,
            distance: 8.3,
            elevationGain: 2100,
            estimatedTime: 4.5 * 3600,
            imageURL: nil
        )
    ]
}
