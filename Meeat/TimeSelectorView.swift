import SwiftUI

let foodCategories = ["Japanese", "Korean", "Thai", "Italian", "Chinese", "Hot Pot", "Vegetarian", "Fast Food", "Desserts"]

struct TimeSelectorView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    let onStartMatching: () -> Void
    
    @State private var firstChoice: String = foodCategories[0]
    @State private var secondChoice: String = foodCategories[1]
    @State private var thirdChoice: String = foodCategories[2]
    
    private var isTimeValid: Bool {
        endTime > startTime
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Food Preferences (in order of priority)")
                .font(.headline)
                .padding(.top)
            
            FoodPreferencePickerView(priority: 1, selection: $firstChoice)
            FoodPreferencePickerView(priority: 2, selection: $secondChoice)
            FoodPreferencePickerView(priority: 3, selection: $thirdChoice)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Select Available Time Slot")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Start Time")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("End Time")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Display selected time interval
                VStack(spacing: 4) {
                    Text("Selected Time Slot")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(startTime, style: .time) - \(endTime, style: .time)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.vertical, 8)
            }
            
            // Start Matching button
            Button(action: {
                onStartMatching()
            }) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Start Matching")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isTimeValid ? Color.pink : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(!isTimeValid)
            
            if !isTimeValid {
                Text("Please select a valid time interval")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct FoodPreferencePickerView: View {
    let priority: Int
    @Binding var selection: String
    var body: some View {
        HStack {
            Text("Priority \(priority)")
                .font(.subheadline)
                .frame(width: 80, alignment: .leading)
            Picker("", selection: $selection) {
                ForEach(foodCategories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(8)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    TimeSelectorView(
        startTime: .constant(Date()),
        endTime: .constant(Date().addingTimeInterval(3600)),
        onStartMatching: {}
    )
} 