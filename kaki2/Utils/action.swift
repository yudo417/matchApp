//
//  action.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/02.
//

import SwiftUI

enum Action: CaseIterable {
    case nope
    case redo
    case like
}

extension Action{

    func createActionButton(viewModel: ListViewModel) -> some View{
        Button(action: {
            viewModel.tappedHandler(action: self )
        }, label: {
            Image(systemName: self.symbol)
                .font(.system(size:26, weight: .bold))
                .foregroundStyle(self.color)
                .background{
                    Circle()
                        .stroke(self.color, lineWidth: 1)
                        .frame(width: self.size, height: self.size)
                    }
        })
    }

    private var symbol: String{
        switch self{
        case .nope:
            return "xmark"
        case .redo:
            return "arrow.2.circlepath"
        case .like:
            return "heart.fill"
        }
    }

    private var color: Color{
        switch self{
        case .nope:
            return .red
        case .redo:
            return .yellow
        case .like:
            return .blue
        }
    }

    private var size:CGFloat{
        switch self{
        case .nope, .like:
            return 60
        case .redo:
            return 50
        }
    }
}
