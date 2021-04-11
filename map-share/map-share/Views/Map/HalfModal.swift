//
//  HalfModal.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-29.
//

import SwiftUI

struct HalfModal: View{
    
    //MARK: - Variables
    @Binding var visible : Bool
    @Binding var place : Place
    var offset : CGFloat
    
    //MARK: - Components
    let closeButtonLabel = TokenButtonLabel(systemName: "xmark.circle.fill", iconSize: .large)
    
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
                        VStack(alignment: .leading, spacing: Space.times1.rawValue){
                            Text(place.name)
                                .font(.headline)
                            Text(place.address)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text( place.openingHours[currentDay] ?? "" )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            visible = false
                        }, label: {
                            closeButtonLabel
                                .frame(width: minButtonSize, height: minButtonSize, alignment: .topTrailing)
                        })
                    }
                    .padding(Space.times2.rawValue)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 0, maxHeight: maxHeight, alignment: .bottom)
            .offset(y: offset - height)
            .gesture(closeGesture())
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: AnimationDurr.short.rawValue))
            .onChange(of: self.place){ place in self.place.deselect() }
            .onDisappear{ self.place.deselect() }
        }else{
            EmptyView()
        }
    }
    
    var currentDay : String {
        let day = Date().get(.weekday)
        return Date.weekDayList[day-1]
    }
    
    //MARK: - Gestures
    
    @GestureState var gestureClose : CGFloat = 0.0
    
    private var height : CGFloat {
        maxHeight - gestureClose
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
    
    let minCloseGesture : CGFloat = 40
    let maxHeight : CGFloat = 280
    let minButtonSize: CGFloat = 44
}


struct Blur: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
