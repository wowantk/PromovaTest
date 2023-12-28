//
//  AnimalCellView.swift
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AnimalCellView: View {
    let model: AnimalModel
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                AsyncImage(url: model.imageUrl) { image in
                    image
                        .image?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 121, height: 90)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(model.description)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
                    
                    Spacer()
                    
                    if model.state == .paid {
                        Text("Premium")
                            .lineLimit(1)
                            .padding(8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            if model.state == .comingSoon {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    Spacer()
                    Text("Coming Soon")
                        .rotationEffect(Angle(degrees: -55))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }

    }
    
#Preview {
    AnimalCellView(model: AnimalModel.mock[0]).previewLayout(.fixed(width: 300, height: 300))
}
