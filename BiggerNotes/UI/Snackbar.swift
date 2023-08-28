//
//  Snackbar.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/25/23.
//

import SwiftUI
import Combine

struct Snackbar<Content: View, ActionLabel: View>: View {
    @Binding private var isShowing: Bool
    private var timeout: Double
    private let content: () -> Content
    private let action: (() -> Void)?
    private let actionLabel: () -> ActionLabel

    @State private var timerConnection: Cancellable? = nil
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .default)
    @State private var timeElapsed: Double = 0
    private var timerStartDate = Date.now
    
    init(
        isShowing: Binding<Bool>,
        timeout: Double = 0,
        @ViewBuilder _ content: @escaping () -> Content,
        action: (() -> Void)? = nil,
        actionLabel: @escaping () -> ActionLabel = { EmptyView() }
    ) {
        self._isShowing = isShowing
        self.timeout = timeout
        self.content = content
        self.action = action
        self.actionLabel = actionLabel
    }
    
    var body: some View {
        HStack {
            content()
                .padding(10)
            
            if let action {
                Spacer()
                Divider()
                    .background(Color.white)
                Button {
                    action()
                } label: {
                    actionLabel()
                    if timeout > 0 {
                        Circle()
                            .fill(.clear)
                            .overlay {
                                Circle()
                                    .trim(from: (timeElapsed / timeout), to: 1)
                                    .stroke(style: StrokeStyle(lineWidth: 3))
                                    .foregroundColor(.white)
                                    .animation(.easeInOut, value: timeElapsed)
                                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 15, height: 15)
                            .padding(.leading, 5)
                    }
                }
                .padding(10)
            }
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity)
        .animation(.linear, value: isShowing)
        .background(Color.orange)
        .foregroundColor(.white)
        .cornerRadius(8)
        .shadow(radius: 5)
        .fixedSize(horizontal: false, vertical: true)
        .offset(y: isShowing ? 0 : UIScreen.main.bounds.height)
        .padding()
        .onReceive(timer) { _ in
            timeElapsed += 0.1
        }
        .onChange(of: timeElapsed) { _ in
            if timeElapsed >= timeout {
                withAnimation {
                    isShowing = false
                }
            }
        }
        .onChange(of: isShowing) { _ in
            if timeout > 0 {
                if isShowing {
                    resetTimer()
                } else {
                    stopTimer()
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .default)
        timerConnection = timer.connect()
    }
    
    func stopTimer() {
        timerConnection?.cancel()
    }
    
    func resetTimer() {
        timeElapsed = 0
        stopTimer()
        startTimer()
    }
}

struct Snackbar_Previews: PreviewProvider {
    static var previews: some View {
        Snackbar(isShowing: .constant(true), timeout: 5) {
            Text("Snackbar with action and timeout")
        } action: {
        } actionLabel: {
            Text("Action")
        }
        
        Snackbar(isShowing: .constant(true)) {
            Text("Snackbar with action")
        } action: {
        } actionLabel: {
            Text("Action")
        }
        
        Snackbar(isShowing: .constant(true)) {
            Text("Snackbar without action")
        }
    }
}
