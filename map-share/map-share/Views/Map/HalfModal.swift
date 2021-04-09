//
//  HalfModal.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-29.
//

import SwiftUI

struct HalfModal: View{
    @GestureState var gestureClose : CGFloat = 0.0
    
    @Binding var visible : Bool
    @Binding var place : Place
    var offset : CGFloat
    private var height : CGFloat {
        maxHeight - gestureClose
    }
    
    var currentDay : String {
        let day = Date().get(.weekday)
        return Date.weekDayList[day-1]
    }
    
    init(visible: Binding<Bool>, place: Binding<Place>, offset: CGFloat){
        self._visible = visible
        self._place = place
        self.offset = offset
    }
    
    var body: some View {
        if visible {
            ZStack(alignment: .top){
                Blur(effect: UIBlurEffect(style: .systemThickMaterial))
                    .cornerRadius(RadiusSize.small.rawValue)
                VStack{
                    Handlebar()
                    HStack(alignment: .top){
                        VStack(alignment: .leading, spacing: Pad.small.rawValue){
                            Text(place.name)
                                .font(.headline)
                            Text(place.address)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text(
                                place.openingHours[currentDay] ?? ""
                            )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            visible = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .imageScale(.large)
                                .frame(width: 44, height: 44, alignment: .topTrailing)
                        })
                    }
                    .padding(Pad.medium.rawValue)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 0, maxHeight: maxHeight, alignment: .bottom)
            .offset(y: offset - height)
            .gesture(closeGesture())
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: AnimationDurr.short.rawValue))
            .onChange(of: self.place, perform: {place in
                self.place.deselect()
            })
            .onDisappear{
                self.place.deselect()
            }
        }else{
            EmptyView()
        }
    }
    
    private func closeGesture() -> some Gesture {
        DragGesture()
            .updating($gestureClose){ latest, gestureClose, transaction in
                if latest.translation.height > 0 {
                    gestureClose = latest.translation.height
                }
            }
            .onEnded{ finalValue in
                if finalValue.translation.height > minCloseGesture {
                    visible = false
                }
            }
    }
    
    private let minCloseGesture : CGFloat = 40
    private let maxHeight : CGFloat = 280
}


struct Blur: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
