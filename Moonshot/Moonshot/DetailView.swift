//
//  DetailView.swift
//  Moonshot
//
//  Created by admin on 22.02.2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        NavigationStack{
            List{
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                        
                    } label: {
                        HStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            VStack{
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(mission.formattedLaunchDate)
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                           
                            .frame(maxWidth: .infinity)
                            .background(.lightBackraund)
                            .clipShape(.capsule)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackraund)
                        )
                    }
                    
                }
                .background(.darkBackraund)
             
                
            }
            .navigationTitle("Moonshot")
         
            .preferredColorScheme(.dark)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "square.grid.2x2")
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
#Preview {
    DetailView()
}
