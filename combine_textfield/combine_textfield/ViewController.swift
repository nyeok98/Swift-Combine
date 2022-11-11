//
//  ViewController.swift
//  combine_textfield
//
//  Created by NYEOK on 2022/11/11.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var viewModel: ViewModel!
    
    // 메모리 관리를 위해
    private var mySubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ViewModel()
        
        
        /**
         텍스트 필드에서 나가는 이벤트를
         뷰모델의 프로퍼티가 구독
         */
        passwordTextField
            .myTextPublisher
            // 메인 스레드에서 받겠다는 것.
            .receive(on: DispatchQueue.main)
            // 구독(KVO방식으로 구독)
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &mySubscriptions) // 메모리 관리하는 부분
        
        passwordConfirmTextField
            .myTextPublisher
            // 메인 스레드에서 받겠다는 것.
            .receive(on: RunLoop.main)
            // 구독(KVO방식으로 구독)
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscriptions) // 메모리 관리하는 부분
        
        //버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isMatchPasswordInput
            .receive(on: RunLoop.main) // RunLoop 알아보기
            .assign(to: \.isValid, on: confirmBtn)
            .store(in: &mySubscriptions)
    }


}


extension UITextField {
    var myTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            // 퍼블리셔로 들어온 값 중에서 UITextField만 가져옴
            .compactMap{ $0.object as? UITextField }
            // String 만 추출
            .map{ $0.text ?? "" }
            .eraseToAnyPublisher() // 역할 더 살펴보자, AnyPublisher로 포매팅해주는 느낌
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .blue
        }
        set {
            backgroundColor = newValue ? .blue : .lightGray
            isEnabled = newValue
        }
    }
}
