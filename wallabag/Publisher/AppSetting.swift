//
//  AppSetting.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/06/2020.
//

import Combine
import Foundation

final class AppSetting: ObservableObject {
    @Published var webFontSizePercent: Double

    private var cancellable = Set<AnyCancellable>()

    init() {
        webFontSizePercent = WallabagUserDefaults.webFontSizePercent

        $webFontSizePercent
            .sink(receiveValue: updateWebFontSizePercent)
            .store(in: &cancellable)
    }

    private func updateWebFontSizePercent(_ value: Double) {
        WallabagUserDefaults.webFontSizePercent = value
    }
}
