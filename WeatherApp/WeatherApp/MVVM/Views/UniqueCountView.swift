//
//  UniqueCountView.swift
//  AppisKeyAssignment
//
//  Created by Hamza Hashmi on 14/10/2023.
//

import SwiftUI

struct UniqueCountView: View {
    
    let width = UIScreen.main.bounds.width
    
    @ObservedObject var viewModel: ViewModel
    
    @State var text = ""
    
    var body: some View {
        
        GeometryReader { reader in
            
            VStack {
                
                List {
                    
                    HStack {
                        
                        HStack {
                            Text("Word")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()
                        
                        Divider()
                        
                        Spacer()
                        
                        HStack {
                            Text("Count")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .font(.headline)
                    
                    
                    ForEach(0 ..< viewModel.dictionary.count, id: \.self) { index in
                        
                        let key = viewModel.dictionary.map({ $0.key })[index]
                        
                        HStack {
                            
                            HStack {
                                Text("\(key)")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Divider()
                            
                            HStack {
                                Text("\(viewModel.dictionary[key] ?? 0)")
                                    .padding(.trailing)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .listRowSeparator(.visible, edges: .all)
            }
            .frame(width: width, alignment: .center)
            
            VStack {
                
                Spacer()
                
                TextField("Enter Input", text: $text)
                    .frame(width: width - 80, height: 50)
                    .padding(.horizontal)
//                    .foregroundStyle(.black)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: .init())
                            .opacity(0.5)
                    }
                    .onSubmit {
                        viewModel.addElement(input: text)
                        self.text = ""
                    }
            }
            .frame(width: width, alignment: .center)
        }
    }
    

}

#Preview {
    UniqueCountView(viewModel: ViewModel())
}
