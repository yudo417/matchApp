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
    let adjustIndex: (Bool) -> Void

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
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"),
            object: nil)){ data in
            receiveHandler(data: data)

        }
    }
}

#Preview {
    ListView()
}

// MARK: -UI
extension CardView {
    private var imageLayer: some View{

        Group{
            if let urlString = user.photoUrl, let url = URL(string: urlString){
                AsyncImage(url:url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth-16)
                } placeholder: {
                    ProgressView()
                }

            }else{
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100)
            }
        }


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
                .likeNopeText(isLike: true)
                .opacity(opacity)
            Spacer()

            Text("NOPE")
                .likeNopeText(isLike: false)
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
        withAnimation(.linear(duration: 0.4)){
            offset = CGSize(width: isLiked ? screenWidth * 1.5 : -screenWidth * 1.5, height: height)
        }
        adjustIndex(false)
    }

    private func resetCard(){
        withAnimation(.linear(duration: 0.1)){
            offset = .zero
        }
        adjustIndex(true)
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

    private func receiveHandler(data: NotificationCenter.Publisher.Output){
        guard let info = data.userInfo,
              let id = info["id"] as? String,
              let action = info["action"] as? Action
        else{ return }
        
        if id == user.id{
            switch action{

            case .nope:
                removeCard(isLiked: false)
            case .redo:
                resetCard()
            case .like:
                removeCard(isLiked: true)
            }
        }
    }
}
