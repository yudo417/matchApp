//
//   Card.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/09/26.
//

import SwiftUI

struct CardView: View {
    @State private var offset: CGSize = .zero
    let user : User

    var body: some View {
        ZStack(alignment: .bottom){
            //background
            Color.gray

            //image
            imageLayer
            //Gradient
            LinearGradient(colors: [.clear,.black], startPoint: .center, endPoint: .bottom)
            //information

            informationLayer

            // LIKE AND NOPE
            LikeAndNope
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .offset(offset)
        .gesture(gesture)
        .scaleEffect(scale)
        .rotationEffect(.degrees(degree))
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NOPEACTION"),object: nil)) { data in
            print(data)

            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}

            if id == user.id {
                removeCard(isLiked: false)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LIKEACTION"),object: nil)) { data in
            print(data)

            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}

            if id == user.id {
                removeCard(isLiked: true)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("REDOACTION"),object: nil)) { data in
            print(data)

            guard
                let info = data.userInfo,
                let id = info["id"] as? String
            else {return}

            if id == user.id {
                removeCard(isLiked: true)
            }
        }
    }
}

#Preview {
    ListView()
}

// MARK: -UI
extension CardView {
    private var imageLayer: some View{
        Image(user.photoUrl ?? "avatar")
            .resizable()
            .scaledToFill()
            .frame(width: 100)
//                            .border(.red)
    }

    private var informationLayer: some View{
        VStack(alignment:.leading){
            HStack(alignment:.bottom){
                Text(user.name)
                    .font(.largeTitle.bold())
                Text("\(user.age)")
                    .font(.title2)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.white,.blue)
                    .font(.title2)
            }

            if let message = user.message{
                Text(message)
            }


        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity,alignment: .leading)
//            .border(.red)
        .padding()
    }

    private var LikeAndNope: some View{
        HStack{
            // LIKE
            Text("LIKE")
                .tracking(4)
                .foregroundStyle(.green)
                .font(.system(size: 40))
                .fontWeight(.heavy)
                .padding(.horizontal,8)
                .padding(.vertical,2)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green,lineWidth: 5)
                }
                .rotationEffect(.degrees(-15))
                .offset(x: 16, y: 30)
                .opacity(opacity)
            Spacer()

            Text("NOPE")
                .tracking(4)
                .foregroundStyle(.red)
                .font(.system(size: 40))
                .fontWeight(.heavy)
                .padding(.horizontal,8)
                .padding(.vertical,2)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red,lineWidth: 5)
                }
                .rotationEffect(.degrees(15))
                .offset(x: -15, y: 30)
                .opacity(-opacity)

            // NOPE
        }
        .frame(maxHeight: .infinity, alignment: .top)
//        .border(.red)
    }
}


// MARK: -Action
extension CardView {

    private var screenWidth:CGFloat{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return 0.0}
        return  window.screen.bounds.width
    }

    private var scale: CGFloat{
        return max((screenWidth - abs(offset.width)) / screenWidth, 0.75)
    }

    private var degree :Double{
        return offset.width * 0.03
    }

    private var opacity: Double{
        return (offset.width)/screenWidth * 4.0
    }

    private func removeCard(isLiked: Bool, height: CGFloat=0.0){
        withAnimation(.linear(duration: 0.2)){
            offset = CGSize(width: isLiked ? screenWidth * 1.5 : -screenWidth * 1.5, height: height)
        }
    }

    private var gesture: some Gesture{
        DragGesture()
            .onChanged{ value in

                let width = value.translation.width
                let height = value.translation.height

//                var limitedHeight:CGFloat = 0

                let limitedHeight = height > 0 ? min(height, 100) : max(height, -100)

                offset = CGSize(width: width, height: limitedHeight)
            }
            .onEnded { value in
                    let width = value.translation.width
                    let height = value.translation.height

                    if (abs(width) > (screenWidth / 4)){
//                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//                            offset = .zero
//                        }
                        removeCard(isLiked: width > 0, height: height)
                    }else{
                        withAnimation(.linear(duration: 0.1)){
                            offset = .zero
                        }
                    }

            }
    }
}
