//
//  TaskRowView.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import SwiftUI

struct TaskRowView: View {
    var task: Task
    var onToggleCompletion: () -> Void
    
    private var dueDateColor: Color {
        guard task.hasDueDate && !task.isCompleted else {
            return task.isCompleted ? .gray : .primary
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: task.dueDate)
        let daysRemaining = components.day ?? 0
        
        if daysRemaining < 0 {
            return .red
        } else if daysRemaining == 0 {
            return .orange
        } else if daysRemaining <= 2 {
            return .yellow
        } else {
            return .blue
        }
    }
    
    var body: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 8.0
            ) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .strikethrough(task.isCompleted)
                
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                if task.hasDueDate {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(dueDateColor)
                        
                        Text(task.dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(dueDateColor)
                        
                        if task.hasTime {
                            Image(systemName: "clock")
                                .foregroundColor(dueDateColor)
                            
                            Text(task.dueDate, style: .time)
                                .font(.caption)
                                .foregroundColor(dueDateColor)
                        }
                        
                        if task.hasReminder {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                        
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            
            Spacer()
            
            Circle()
                .strokeBorder(task.isCompleted ? .green : .gray, lineWidth: 2.0)
                .background(
                    Circle()
                        .fill(task.isCompleted ? Color.green : Color.clear)
                )
                .frame(width: 24, height: 24)
                .overlay {
                    task.isCompleted ?
                    Image(systemName: "checkmark")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    : nil
                }
                .onTapGesture {
                    withAnimation {
                        onToggleCompletion()
                    }
                }
        }
        .padding(.vertical, 8.0)
        .contentShape(Rectangle())
    }
}

#Preview("Incomplete Task") {
    let task = Task(
        title: "Buy groceries",
        notes: "Milk, eggs, bread",
        isCompleted: false,
        hasDueDate: true,
        dueDate: Date(),
        hasTime: true,
        hasReminder: true,
        priority: .medium
    )
    
    return TaskRowView(task: task) {}
        .padding()
}

#Preview("Completed Task") {
    let task = Task(
        title: "Finish project",
        notes: "Complete the UI design",
        isCompleted: true,
        hasDueDate: true,
        dueDate: Date(),
        hasTime: false,
        hasReminder: false,
        priority: .low
    )
    
    return TaskRowView(task: task) {}
        .padding()
}

#Preview("Overdue Task") {
    let overdueDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    let task = Task(
        title: "Complete tax report",
        notes: "Deadline missed",
        isCompleted: false,
        hasDueDate: true,
        dueDate: overdueDate,
        hasTime: true,
        hasReminder: true,
        priority: .high
    )
    
    return TaskRowView(task: task) {}
        .padding()
}
