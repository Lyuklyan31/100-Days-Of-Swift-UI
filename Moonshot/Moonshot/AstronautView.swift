//
//  AstronautView.swift
//  Moonshot
//
//  Created by admin on 22.02.2024.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    var body: some View {
        ScrollView {
            VStack{
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
            
              
                   ScrollView( showsIndicators: false){
                       HStack{
                           ForEach(missions.filter { mission in
                               mission.crew.contains(where: { $0.name == astronaut.id })
                           }) { mission in
                                NavigationLink {
                                    MissionView(mission: mission, astronauts: astronauts)
                                } label: {
                                    VStack {
                                        Image(mission.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 90, height: 90)
                                            
                                        VStack{
                                            Text(mission.displayName)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text(mission.formattedLaunchDate)
                                                .font(.headline)
                                                .foregroundStyle(.white.opacity(0.5))
                                        }
                                   
                                       
                                    }
                                    .padding()
                                    .background(Color.black)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.lightBackraund)
                                    )
                                    
                                }
                            }
                    }
                }
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackraund)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return  AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
