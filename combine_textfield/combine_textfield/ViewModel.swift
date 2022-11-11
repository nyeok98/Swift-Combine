//
//  ViewModel.swift
//  combine_textfield
//
//  Created by NYEOK on 2022/11/11.
//

import Foundation
import Combine

class ViewModel {
    
    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    
    // 두 퍼블리셔들의 값의 일치여부를 확인하는 퍼블리셔
    // CombineLatest - 여러가지 퍼블리셔들의 마지막 값이 들어옴
    lazy var isMatchPasswordInput: AnyPublisher<Bool, Never> = Publishers
        .CombineLatest($passwordInput, $passwordConfirmInput)
        .map({(password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            if password == passwordConfirm {
                return true;
            } else {
                return false
            }
        })
        .print()
        .eraseToAnyPublisher()
    
}
