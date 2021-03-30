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
    var place : Place
    var offset : CGFloat
    private var height : CGFloat {
        maxHeight - gestureClose
    }
    
    var currentDay : String {
        let day = Date().get(.weekday)
        return Date.weekDayList[day-1]
    }
    
    var body: some View {
        if visible{
            ZStack(alignment: .top){
                Blur(effect: UIBlurEffect(style: .systemThickMaterial))
                    .cornerRadius(RadiusSize.small.rawValue)
                VStack{
                    Capsule()
                        .fill(Color(UIColor.lightGray))
                        .frame(width: 30, height: 3)
                        .padding(Pad.medium.rawValue)
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
                            withAnimation(.easeInOut(duration: AnimationDurr.short.rawValue)){
                                visible = false
                            }
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.secondary)
                                .font(.system(size: 20))
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
            .animation(.default)
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

struct HalfModal_Previews: PreviewProvider {
    static var previews: some View {
        HalfModal(
            visible: Binding.constant(true),
            place: Place(
                id: "1",
                latitude: 59,
                longitude: 18,
                name: "Fors Artisan",
                address: "Löjtnantsgatan 8, 115 50 Stockholm",
                openingHours: ["mon" : "09:00-21:00"]
            ),
            offset: 200.0
        )
    }
}
