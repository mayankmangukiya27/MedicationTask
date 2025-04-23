//
//  FloatingPointView.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import SwiftUI


struct FloatingLabelInput: View {
    let label: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var isFocused: Bool
    @State private var isSecured: Bool = true
    
    var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .foregroundColor(.gray)
                    .font(shouldFloat ? .caption : .body)
                    .scaleEffect(shouldFloat ? 0.999 : 1.0)
                    .offset(y: shouldFloat ? -10 : 10)
                    .animation(.easeInOut(duration: 0.2), value: shouldFloat)
                
                HStack {
                    if isSecure {
                        Group {
                            if isSecured {
                                SecureField("", text: $text)
                                    .focused($isFocused)
                                    .keyboardType(keyboardType)
                                    .autocapitalization(.none)
                            } else {
                                TextField("", text: $text)
                                    .focused($isFocused)
                                    .keyboardType(keyboardType)
                                    .autocapitalization(.none)
                            }
                        }
                        
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: isSecured ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .keyboardType(keyboardType)
                            .autocapitalization(.none)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .frame(height: 60)
    }
}

struct FloatingLabelInput_Previews: PreviewProvider {
    static var previews: some View {
        FloatingLabelInput(
            label: "Email",
            text: .constant(""),
            isSecure: false, keyboardType: .emailAddress
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

