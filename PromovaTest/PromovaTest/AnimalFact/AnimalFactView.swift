//
//  AnimalFactView.swift
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct AnimalFactView: View {
    
    let store: StoreOf<AnimalFactCore>
    let onDismiss: () -> Void 
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TabView(selection: viewStore.$factIndex) {
                    ForEach(viewStore.facts.indices, id: \.self) { i in
                        cardView(viewStore.facts[i])
                            .tag(i)
                    }
                    .padding(.all, 10)
                }
                .padding(.top, 10)
                .frame(width: UIScreen.main.bounds.width, height: 600)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .navigationBarTitle("Category Details", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:   Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "arrow.left")
                })
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        viewStore.send(.prvFact, animation: .default)
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    Spacer()
                    Button(action: {
                        viewStore.send(.nextFact, animation: .default)
                    }) {
                        Image(systemName: "arrow.right")
                    }
                })
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
    
    func cardView(_ fact: FactModel) -> some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(width: UIScreen.main.bounds.width - 40, height: nil)
                    .overlay(
                        VStack {
                            AsyncImage(url: fact.imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 40, height: geometry.size.height * 0.5)
                                    .clipped()
                            } placeholder: {
                                Color.gray
                                    .frame(height: geometry.size.height * 0.5)
                            }
                            
                            Text(fact.content)
                                .foregroundColor(Color.primary)
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: UIScreen.main.bounds.width - 40)
                            
                            bottomToolbar
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(radius: 5)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
        }
    }
    
    @ViewBuilder
    var bottomToolbar: some View {
        HStack {
            Spacer()
            Button(action: {
                store.send(.prvFact, animation: .default)
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.green)
            }
            
            Spacer()
            
            Button(action: {
                store.send(.nextFact, animation: .default)
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.green)
            }
            Spacer()
        }
        .padding(.bottom, 10)
    }
}



#Preview {
    AnimalFactView(store: Store(initialState: AnimalFactCore.State(facts: [
        FactModel(content: "Fujef oksdck;",
                  imageUrl: URL(string: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg")!),
        FactModel(content: "Part 2",
                  imageUrl: URL(string: "https://images.dog.ceo/breeds/akita/Akita_Inu_dog.jpg")!)
    ])) {
        AnimalFactCore()
    }, onDismiss: {})
}
