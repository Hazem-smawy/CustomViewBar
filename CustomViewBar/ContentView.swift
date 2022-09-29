//
//  ContentView.swift
//  CustomViewBar
//
//  Created by hazem smawy on 9/29/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @State var selectedTab = "app"
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    // MARK: - Location for each Curve..
    @State var xAxis: CGFloat = 0
    var body: some View {
        ZStack(alignment:Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                Color.blue
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("app")
                
                
                Color.purple
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("phone")
                
                Color.green
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("person")
                
                Color.black
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("bell")
            }
            
            // MARK: -  Custom tab Bar...
            
            HStack(spacing:0){
                ForEach(tabs, id: \.self){ image in
                    GeometryReader { reader in
                        Button {
                            withAnimation(.spring()) {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        } label: {
                            Image(systemName: image)
                                .frame(width: 25, height: 25)
                                .font(.title2.weight(.bold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(selectedTab == image ? getColor(image: image) : .gray)
                                .padding(selectedTab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedTab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0 ,y: selectedTab == image ? -45 : 0)

                                
                        }
                        .onAppear {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        }
                    }//: geometryReader
                    .frame(width: 25, height: 25)
                    if image != tabs.last { Spacer(minLength: 0)}

                }
            }//:HStack
            .padding(.horizontal, 20)
            .padding(.vertical)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12))
           
            .padding(.horizontal)
            .padding(.vertical, 1)
            
            // Bottom Edge...
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
           
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // MARK: -  getting Image Color
    func getColor(image: String)-> Color {
        switch image {
        case "app":
            return Color.blue
        case "bell":
            return Color.black
        case "person":
            return Color.green
        case "phone":
            return Color.purple
        default:
            return Color.black
        }
    }
}

var tabs = ["app","phone","person","bell"]


// MARK: -  Curve...

struct CustomShape:Shape {
    // MARK: - property
    var xAxis: CGFloat
    var animationData: CGFloat {
        get {return xAxis}
        set { self.xAxis = newValue }
    }
    
    // MARK: - body for path
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25, y: 0)
            let control2 = CGPoint(x: center - 25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25, y: 35)
            let control4 = CGPoint(x: center + 25, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
