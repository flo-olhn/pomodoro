//
//  ConfigureView.swift
//  pomodoro
//
//  Created by Florian Ouilhon on 29/07/2024.
//

import SwiftUI

struct ConfigureView: View {
    @State private var workInput: String = "25"
    @State private var picked = 25
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
                HStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 80)
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 80)
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 80)
                }
            
            /*
            TextField("", text: $workInput)
                .frame(width: 70, height: 70)
                .font(.system(size: 40, weight: .thin))
                .background(.blue)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                .focused($isFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isFocused = true
                    }
                }
                .onChange(of: workInput) { newValue in
                    inputValidator(newVal: newValue)
                }
                .onChange(of: isFocused) { newValue in
                    if !newValue {
                        validateOnFocusOut()
                    }
                }
                .multilineTextAlignment(.center)*/
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /*.onTapGesture {
            // Sélectionner tout le texte lorsque le TextField est cliqué
            self.isFocused = true
        }*/
    }
    
    func inputValidator(newVal: String) {
        // Supprimer tous les caractères non numériques
        let filtered = newVal.filter { "0123456789".contains($0) }
        
        if let number = Int(filtered), number >= 1, number <= 60 {
            // Assurer que le texte est toujours à deux chiffres
            let padded = filtered.count == 1 ? "0" + filtered : filtered
            workInput = String(padded.prefix(2))
        } else if filtered.isEmpty {
            // Si le champ est vide, réinitialiser à "10"
            workInput = "10"
        } else {
            // Si le nombre n'est pas valide, garder la dernière valeur valide
            workInput = String(filtered.prefix(2))
        }
    }
    
    func validateOnFocusOut() {
        // Assurer que la valeur est au moins 10 lorsqu'on quitte le focus
        if let number = Int(workInput), number < 10 {
            workInput = "10"
        } else if let number = Int(workInput), number > 60 {
            workInput = "60"
        }
        picked = Int(workInput) ?? 10
    }
}

#Preview {
    ConfigureView()
}
