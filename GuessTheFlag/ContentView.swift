//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Design Work on 2020-08-16.
//  Copyright © 2020 Ling Lu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var showAlert = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var totalRounds = 0
    @State private var supplMessage = ""
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                Spacer()
                VStack{
                    
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(self.countries[self.correctAnswer]).foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0..<3){number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number]).renderingMode(.original)
                        .applyFlagStyle()
                            
                    }
                    .alert(isPresented: self.$showingScore){
                        Alert(title: Text(self.scoreTitle),
                              message: Text("Your score is \(self.score) "+self.supplMessage),
                              dismissButton: .default(Text("Continue"))
                              {
                                self.reset()
                            })
                    }
                }
                Text("Current Score: \(score)/ \(totalRounds)")
                    .foregroundColor(.white)
                
                Button("Reset"){
                    self.reset_game()
                }
                Spacer()
            }
            
        }

    }
    func flagTapped(_ number: Int) {
        totalRounds+=1
        if number == self.correctAnswer{
            scoreTitle = "Correct"
            score += 1
            supplMessage = ""
        }else{
            scoreTitle = "Incorrect"
            supplMessage = "\n That's the flag of \(self.countries[number])"
        }
        showingScore = true
    }
    func reset(){
        self.countries.shuffle()
        self.correctAnswer = Int.random(in: 0...2)
        
    }
    func reset_game(){
        self.reset()
        score = 0
    }
}

struct flagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.white,lineWidth: 1))
//       .shadow(color: .white, radius: 2)
        
    }
    
}

extension View{
    func applyFlagStyle() -> some View{
        self.modifier(flagStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
