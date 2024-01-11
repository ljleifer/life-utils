//
//  RandomNumberView.swift
//  Life Utils
//
//  Created by Logan Leifer on 1/11/24.
//

import SwiftUI

struct RandomNumberView: View {
	@State private var useUniqueNumbers = false
	@State private var sortNumbers = false
	@State private var numberOfRands = 0
	@State private var randMax = 19
	@State private var generatedNumbers: Array<Int> = []
	@State private var sortedGeneratedNumbers: Array<Int> = []
	
    var body: some View {
		NavigationStack {
			Form {
				Section {
					Toggle("Use Unique Numbers", isOn: $useUniqueNumbers)
				}
				Section {
					Picker("Generate", selection: $numberOfRands) {
						ForEach(1..<101) {
							if useUniqueNumbers && $0 >= randMax+2 {
								Text("\($0) numbers")
									.foregroundStyle(.red)
							} else {
								Text("\($0) number\($0 > 1 ? "s" : "")")
							}
						}
					}
					Picker("Between 1 and", selection: $randMax) {
						ForEach(1..<101) {
							Text("\($0)")
						}
					}
				} footer: {
					if isDisabled {
						Text("Amount of generated unique numbers should be fewer than maximum RNG value")
							.foregroundStyle(.red)
					}
				}
				.pickerStyle(.navigationLink)
			}
			.navigationTitle("RNG Options")
			NavigationLink(destination: generatedRandomNumbers.onAppear {
				generateNumbers()
			}) {
				Text("Generate")
			}
			.disabled(isDisabled)
		}
    }
	
	func generateNumbers() {
		generatedNumbers = []
		var availableRange = Array(1...randMax+1)
		for _ in 1...numberOfRands+1 {
			let randomIndex = Int.random(in: 0..<availableRange.count);
			generatedNumbers.append(availableRange[randomIndex])
			if useUniqueNumbers {
				availableRange.remove(at: randomIndex)
			}
		}
		sortedGeneratedNumbers = generatedNumbers.sorted()
	}
	
	var isDisabled: Bool {
		if useUniqueNumbers && numberOfRands > randMax {
			return true
		}
		return false
	}
	
	var generatedNumbersDisplay: Array<Int> {
		sortNumbers ? sortedGeneratedNumbers : generatedNumbers
	}
	
	var generatedRandomNumbers: some View {
		Form {
			Section {
				Toggle("Sort", isOn: $sortNumbers)
			}
			Section {
				ForEach(generatedNumbersDisplay, id: \.self) { number in
					Text("\(number)")
				}
			}
		}
		.navigationTitle("Generated Numbers")
	}
}
