//
//  TextField.swift
//  IsisJungleRocks
//
//  Created by Ígor Yamamoto on 02/05/19.
//  Copyright © 2019 Jungle Devs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TextField: UITextField {

    enum TextFieldState {
        case unselected, selected, error

        var borderColor: UIColor {
            switch self {
            case .unselected: return .clear
            case .selected: return .white
            case .error: return .red
            }
        }

        var placeholderColor: UIColor {
            switch self {
            case .unselected, .selected: return .black
            case .error: return .red
            }
        }
    }

    // MARK: - Private Properties

    private var disposeBag = DisposeBag()

    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    private var validation: (String?) -> Bool = { _ in return true }

    private var didValidate: ((Bool) -> Void)?

    // MARK: - Public Properties

    var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    var placeholderColor: UIColor? {
        didSet {
            guard let placeholderColor = placeholderColor else { return }
            let placeholderText = self.placeholder ?? ""
            self.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
    }

    var placeholderText: String = "" {
        didSet {
            placeholder = placeholderText
        }
    }

    private (set) var isValid: Bool = true {
        didSet {
            guard isValid else {
                applyStyle(forState: .error)
                return
            }
            if state != .selected {
                applyStyle(forState: .unselected)
            } else {
                applyStyle(forState: .selected)
            }
        }
    }

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupBindings()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        applyStyle(forState: .unselected)
        layer.borderWidth = 2
        font = UIFont.getFontOrDefault(font: nil, size: 14)
        borderColor = .white
        placeholderText = placeholder ?? ""
        applyStyle(forState: .unselected)
        autocorrectionType = .no
    }

    private func setupBindings() {
        self.rx
            .controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] _ in
                self?.applyStyle(forState: .selected)
            }).disposed(by: disposeBag)

        self.rx
            .controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] _ in
                self?.validate()
            }).disposed(by: disposeBag)

        self.rx
            .controlEvent([.editingChanged])
            .subscribe(onNext: { [weak self] _ in
                self?.applyStyle(forState: .selected)
            }).disposed(by: disposeBag)
    }

    private func getPlaceholderText(forState state: TextFieldState) -> String? {
        switch state {
        case .unselected, .error:
            return placeholderText
        case .selected:
            return nil
        }
    }

    private func applyStyle(forState state: TextFieldState) {
        placeholder = getPlaceholderText(forState: state)
        UIView.animate(withDuration: 0.3, animations: {
            self.borderColor = state.borderColor
            self.placeholderColor = state.placeholderColor
        })
    }

    // MARK: - Public Methods

    func didValidate(_ handler: @escaping (Bool) -> Void) {
        didValidate = handler
    }

    func setValidationAction(_ action: @escaping (String?) -> Bool) {
        validation = action
    }

    @discardableResult
    func validate() -> Bool {
        isValid = validation(text)
        didValidate?(isValid)
        return isValid
    }

    func setValidationState(_ isValid: Bool) {
        self.isValid = isValid
    }
}
