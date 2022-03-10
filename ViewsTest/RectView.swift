//
//  RectView.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import SwiftUI

struct RectView: View {
    @State var position: CGSize = CGSize(width: 0, height: 0)
    var body: some View {
        Text("RectView")
            //.position(x: position.width, y: position.height)
    }
}

struct RectView_Previews: PreviewProvider {
    static var previews: some View {
        RectView()
    }
}
