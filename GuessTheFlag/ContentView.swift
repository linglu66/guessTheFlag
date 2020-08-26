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
    @State private var angleAnimation = 0.0
    @State private var animate = false
    @State private var wrongRotation = [0,0,0]
    @State var attempts: Int = 0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue,.pink]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
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
//                        self.flagTapped(number)
                        if number == self.correctAnswer{
                            
                            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)){
                                self.angleAnimation = 360
                                self.animate=true
                            }
                        }else{
                            withAnimation(.default){
                               self.wrongRotation[number] += 1
//                                self.attempts+=1
//                                self.wrongAttempt=true
                            }
//                            withAnimation(Animation.easeInOut(duration: 0.2)
//                            .repeatCount(5, autoreverses: true)){
//                                self.wrongRotation[number]=10
//                            }
                        }
//                        withAnimation(.easeOut(duration: 1)){
//                            print(self.angleAnimation)
//                            self.animate = true
//                            self.angleAnimation=360
//
//
//                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + (number==self.correctAnswer ? 1.5:0.5)) {
                            self.flagTapped(number)
                        }
                    }) {
                        Image(self.countries[number]).renderingMode(.original)
                        .applyFlagStyle()
                       
                            .opacity(number != self.correctAnswer && self.animate ? 0.25 : 1.0)
                            .rotation3DEffect(.degrees(number == self.correctAnswer && self.animate ? self.angleAnimation:0.0), axis: (x: 0, y: 1, z: 0))
                            
                          
                            .modifier(Shake(animatableData: CGFloat(self.wrongRotation[number])))
//                            .rotation3DEffect(.degrees(self.wrongRotation[number]), axis: (x: 0, y: 0, z: 1)  )
                          
                            
                    }
                    
                }
                Text("Current Score: \(score)/ \(totalRounds)")
                    .foregroundColor(.white)
                
                Button("Reset"){
                    self.reset_game()
                }.foregroundColor(.white)
                Spacer()
            }.alert(isPresented: self.$showingScore){
                Alert(title: Text(self.scoreTitle),
                      message: Text("Your score is \(self.score) "+self.supplMessage),
                      dismissButton: .default(Text("Continue"))
                      {
                        self.reset()
                    })
            }
            
        }

    }
//    func getAnimation(_ number: Int){
//        if number == self.correctAnswer{
//            return Animation.default()
//        }
//    }
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
        print("reset")
        print(self.wrongRotation)
        print(self.angleAnimation)
        self.wrongRotation = [0,0,0]
        self.animate=false
        self.countries.shuffle()
        self.correctAnswer = Int.random(in: 0...2)
        
    }
    func reset_game(){
        self.reset()
        score = 0
    }
}

//struct getAnimation: ViewModifier{
//    func body(content: Content) -> some View{
//        content.
//    }
//}
struct Shake: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
struct flagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.white,lineWidth: 4))
//       .shadow(color: .white, radius: 2)
        
    }
    
}



//extension View{
//    func applyAnimation() -> some View{
//        self.modifier(getAnimation())
//    }
//
//}

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
