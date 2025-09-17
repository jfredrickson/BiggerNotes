//
//  Snackbar.swift
//  BiggerNotes
//
//  Created by Jeff Fredrickson on 8/25/23.
//

import SwiftUI
import Combine

extension View {
    func snackbarDynamicStyle() -> some View {
        if #available(iOS 26.0, *) {
            return self.glassEffect()
        } else {
            return self.background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct Snackbar<Content: View, ActionLabel: View>: View {
    @Binding private var isShowing: Bool
    private var timeout: Double
    private let content: () -> Content
    private let action: (() -> Void)?
    private let actionLabel: () -> ActionLabel

    @State private var timerConnection: Cancellable? = nil
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .default)
    @State private var timeElapsed: Double = 0
    @State private var offset = CGFloat.zero
    
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
                .padding([.leading, .trailing], 10)
            
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
                                    .animation(.easeInOut, value: timeElapsed)
                                    .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 15, height: 15)
                            .padding(.leading, 5)
                    }
                }
                .padding(10)
                .padding([.leading, .trailing], 10)
            }
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, minHeight: 50)
        .snackbarDynamicStyle()
        .fixedSize(horizontal: false, vertical: true)
        .offset(y: isShowing ? offset : UIScreen.main.bounds.height)
        .padding()
        .onAppear {
            startTimer()
        }
        .onReceive(timer) { t in
            timeElapsed += 0.1
        }
        .onChange(of: timeElapsed) { elapsed in
            if timeout > 0 && elapsed >= timeout {
                withAnimation {
                    isShowing = false
                }
            }
        }
        .onDisappear {
            stopTimer()
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 0 {
                        offset = gesture.translation.height
                    }
                }
                .onEnded { value in
                    if offset > 30 {
                        withAnimation {
                            isShowing = false
                        }
                    } else {
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        )
    }
    
    func startTimer() {
        timeElapsed = 0
        timer = Timer.publish(every: 0.1, on: .main, in: .default)
        timerConnection = timer.connect()
    }
    
    func stopTimer() {
        timerConnection?.cancel()
        timerConnection = nil
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
