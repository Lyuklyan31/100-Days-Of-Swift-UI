//
//  MissionView.swift
//  Moonshot
//
//  Created by admin on 22.02.2024.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember{
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.lightBackraund)
                    .padding(.horizontal)
                
                Text(mission.formattedLaunchDate)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.5))
                
                    .padding()
                VStack(alignment: .leading){
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackraund)
                        
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackraund)
                        .padding(.vertical)
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        ForEach(crew, id: \.role) { crewMember in
                            NavigationLink {
                                AstronautView(astronaut: crewMember.astronaut)
                            } label: {
                                HStack {
                                  
                                    Image(crewMember.astronaut.id)
                                    
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(.circle)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 3)
                                        )
                                    VStack(alignment: .leading){
                                        Text(crewMember.astronaut.name)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
                
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackraund)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
