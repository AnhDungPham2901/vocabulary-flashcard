//
//  FailNoti.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct FailNoti: View {
    let message: String
    @State private var isVisible = false
    @State private var scale: CGFloat = 0.8
    
    init(message: String = "Failed!") {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .opacity(isVisible ? 1 : 0)
            
            // Failure notification box
            VStack(spacing: 16) {
                // Failure icon
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Failure message
                Text(message)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .scaleEffect(scale)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
                scale = 1.0
            }
            
            // Auto dismiss after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isVisible = false
                    scale = 0.8
                }
            }
        }
    }
}

#Preview {
    FailNoti(message: "Task failed. Please try again!")
}
