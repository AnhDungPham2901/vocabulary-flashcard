//
//  DoTask.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI
import Speech
import AVFoundation

struct DoTask: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isRecording = false
    @State private var spokenText = ""
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    @State private var speechPermissionStatus = SFSpeechRecognizer.authorizationStatus()
    
    @State private var currentTask = "Pronounce the word: Serendipity"
    @State private var animationScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    
                    Text("Speech Practice")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 40)
                
                // Task Display
                VStack(spacing: 16) {
                    Text("Task")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(currentTask)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 20)
                
                // Speech Recognition Display
                VStack(spacing: 16) {
                    Text("You said:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ScrollView {
                        Text(spokenText.isEmpty ? "Press and hold the microphone to speak..." : spokenText)
                            .font(.body)
                            .foregroundColor(spokenText.isEmpty ? .secondary : .primary)
                            .multilineTextAlignment(.center)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.tertiarySystemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isRecording ? Color.red.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                            )
                    }
                    .frame(maxHeight: 150)
                }
                .padding(.horizontal, 20)
                
                // Microphone Button
                VStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: isRecording ? "mic.fill" : "mic")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: isRecording ? [Color.red, Color.pink] : [Color.blue, Color.purple]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .scaleEffect(animationScale)
                            .shadow(color: (isRecording ? Color.red : Color.blue).opacity(0.4), radius: 15, x: 0, y: 8)
                    }
                    .scaleEffect(isRecording ? 1.1 : 1.0)
                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                        if pressing {
                            startRecording()
                        } else {
                            stopRecording()
                        }
                    }, perform: {})
                    
                    Text(isRecording ? "Release to stop" : "Hold to speak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    
                    Button(action: {
                        // Complete task
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Complete")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .mint]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .disabled(spokenText.isEmpty)
                    .opacity(spokenText.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
            .onAppear {
                requestSpeechPermission()
                startPulseAnimation()
            }
            .onDisappear {
                stopRecording()
            }
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            animationScale = 1.1
        }
    }
    
    private func requestSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                speechPermissionStatus = status
            }
        }
    }
    
    private func startRecording() {
        guard speechPermissionStatus == .authorized else { return }
        
        // Reset previous session
        spokenText = ""
        
        // Cancel any ongoing task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed")
            return
        }
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        // Create audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine start failed")
            return
        }
        
        // Start recognition
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            DispatchQueue.main.async {
                if let result = result {
                    spokenText = result.bestTranscription.formattedString
                }
                
                // Only stop if there's an error, not when final result is received
                if error != nil {
                    stopRecording()
                }
            }
        }
        
        isRecording = true
    }
    
    private func stopRecording() {
        guard isRecording else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        isRecording = false
    }
}

#Preview {
    DoTask()
}