//
//  GalleryItem.swift
//  cekilis
//
//  Created by Ezagor on 10.04.2024.
//

import Foundation
struct GalleryItem: Codable, Identifiable {
    var id: UUID = UUID()
    var username: String
    var prompt: String
    var imageBase64: String // or imageUrl if you decide to use image URLs
    var createdAt: Date
}
