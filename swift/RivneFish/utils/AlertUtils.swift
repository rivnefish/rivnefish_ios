//
//  AlertExtension.swift
//  RivneFish
//
//  Created by Anatolii Kyryliuk on 11/08/16.
//  Copyright © 2016 rivnefish. All rights reserved.
//

import UIKit

class AlertUtils {
    static func okeyAlertWith(title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = NSLocalizedString("Гаразд", comment: "OK")
        let okAction = UIAlertAction(title: ok, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }

    static func connectionErrorAlert() -> UIAlertController {
        let title = NSLocalizedString("Помилка Підключення", comment: "ConnectionError")
        let message = NSLocalizedString("Немає підключення або відсутній звя'зок з сервером", comment: "You are offline or there is no connection with server")
        return AlertUtils.okeyAlertWith(title: title, message: message)
    }

    static func locationTurnedOffAlert() -> UIAlertController {
        let title = NSLocalizedString("Ідентифікацію місцезнаходження вимкнено", comment: "Location turn off")
        let message = NSLocalizedString("Увімкніть доступ до геолокації в системних налаштуваннях цього пристрою щоб мати можливість використовувати навігацію до водойми:\n1. Системні налаштування\n2. rivnefish\n3. Місце", comment: "Please allow use location in system settings")
        return AlertUtils.okeyAlertWith(title: title, message: message)
    }
}
