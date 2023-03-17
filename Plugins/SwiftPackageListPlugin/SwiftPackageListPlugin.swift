//
//  File.swift
//  swift-package-list
//
//  Created by Dave Thompson on 14/03/2023.
//

import Foundation
import PackagePlugin

@main struct Plugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext,
                             target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let projectFilePath = "\(context.package.directory)/\(context.package.displayName).xcodeproj"
        let outputFilePath = try outputFilePath(workDirectory: context.pluginWorkDirectory)
        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: try context.tool(named: "SwiftPackageListCommand").path,
                arguments: [projectFilePath, "--output-path", outputFilePath.removingLastComponent(), "--requires-license"],
                outputFiles: [outputFilePath]
            )
        ]
    }
}

extension Plugin {
    private func outputFilePath(workDirectory: Path) throws -> Path {
        let outputDirectory = workDirectory.appending("Output")
        try FileManager.default.createDirectoryIfNotExists(atPath: outputDirectory.string)
        return outputDirectory.appending("package-list.json")
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension Plugin: XcodeBuildToolPlugin {
        /// This entry point is called when operating on an Xcode project
        func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext,
                                 target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
            let projectFilePath = "\(context.xcodeProject.directory)/\(target.displayName).xcodeproj"
            let outputFilePath = try outputFilePath(workDirectory: context.pluginWorkDirectory)
            return [
                .buildCommand(
                    displayName: "SwiftPackageListPlugin",
                    executable: try context.tool(named: "SwiftPackageListCommand").path,
                    arguments: [projectFilePath, "--output-path", outputFilePath.removingLastComponent(), "--requires-license"],
                    outputFiles: [outputFilePath]
                )
            ]
        }

        
    }
#endif
