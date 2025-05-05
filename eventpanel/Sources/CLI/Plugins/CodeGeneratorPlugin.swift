//
//  CodeGeneratorPlugin.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 05.05.2025.
//

protocol CodeGeneratorPlugin: Sendable {
    func run() async throws
}
