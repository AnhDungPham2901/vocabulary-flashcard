//
//  TaskList.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 25/8/25.
//

import SwiftUI

struct Task {
    let id: Int
    let name: String
    let status: TaskStatus
}

enum TaskStatus {
    case passed
    case failed
    case pending
    
    var icon: String {
        switch self {
        case .passed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .pending: return "clock.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .passed: return .green
        case .failed: return .red
        case .pending: return .orange
        }
    }
}

struct TaskList: View {
    @State private var tasks: [Task] = [
        Task(id: 1, name: "Test Pronunciation", status: .passed),
        Task(id: 2, name: "Tell the meaning", status: .passed),
        Task(id: 3, name: "Give an example", status: .pending),
    ]
    
    @State private var showDoTask = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Daily Tasks")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                // Task List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tasks, id: \.id) { task in
                            Button(action: {
                                showDoTask = true
                            }) {
                                TaskRow(task: task)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                // Progress Summary
                VStack(spacing: 12) {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    HStack(spacing: 20) {
                        TaskSummaryItem(
                            count: tasks.filter { $0.status == .passed }.count,
                            label: "Passed",
                            color: .green
                        )
                        
                        TaskSummaryItem(
                            count: tasks.filter { $0.status == .failed }.count,
                            label: "Failed",
                            color: .red
                        )
                        
                        TaskSummaryItem(
                            count: tasks.filter { $0.status == .pending }.count,
                            label: "Pending",
                            color: .orange
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemBackground))
            .fullScreenCover(isPresented: $showDoTask) {
                DoTask()
            }
        }
        .navigationBarHidden(true)
    }
}

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 16) {
            // Task Name
            Text(task.name)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Status Icon
            Image(systemName: task.status.icon)
                .font(.title3)
                .foregroundColor(task.status.color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(task.status.color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TaskSummaryItem: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    TaskList()
    .background(Color.black.opacity(0.3))
}
