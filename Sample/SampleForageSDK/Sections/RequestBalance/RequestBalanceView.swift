//
//  RequestBalanceView.swift
//  SampleForageSDK
//
//  Created by Symphony on 24/10/22.
//

import Foundation
import UIKit
import ForageSDK

protocol RequestBalanceViewDelegate: AnyObject {
    func goToCreatePayment(_ view: RequestBalanceView)
}

class RequestBalanceView: UIView {
    
    // MARK: Public Properties
    
    var isPINValid: Bool = false
    weak var delegate: RequestBalanceViewDelegate?
    
    // MARK: Private Components
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Request Balance"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private let pinNumberTextField: ForagePINTextFieldView = {
        let tf = ForagePINTextFieldView()
        tf.placeholder = "PIN Field"
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.red.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "PIN status"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let requestBalanceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Balance", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getBalanceInfo(_:)), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.isEnabled = false
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go To Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToCreatePayment(_:)), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.isEnabled = false
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Result"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Fileprivate Methods
    
    @objc fileprivate func getBalanceInfo(_ gesture: UIGestureRecognizer) {
        pinNumberTextField.performRequest(
            forPIN:
                    .balance(
                        paymentMethodReference: ClientSharedData.shared.paymentMethodReference,
                        cardNumberToken: ClientSharedData.shared.cardNumberToken
                    )
        )
    }
    
    @objc fileprivate func goToCreatePayment(_ gesture: UIGestureRecognizer) {
        delegate?.goToCreatePayment(self)
    }
    
    // MARK: Public Methods
    
    public func render() {
        pinNumberTextField.delegate = self
        setupView()
        setupConstraints()
    }
    
    // MARK: Private Methods
    
    private func printPINResult(result: Result<ForageBalanceModel, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let response):
                self.resultLabel.text = """
                Success:\n
                SNAP: \(response.snap)\n
                NON SNAP: \(response.nonSnap)\n
                """
                self.updateButtonState(isEnabled: true, button: self.nextButton)
            case .failure(let error):
                self.resultLabel.text = "Error: \n\(error.localizedDescription)"
                self.updateButtonState(isEnabled: false, button: self.nextButton)
            }
            
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
    
    private func setupView() {
        self.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pinNumberTextField)
        contentView.addSubview(statusLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(requestBalanceButton)
        contentView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        setupContentViewConstraints()
    }
    
    private func setupContentViewConstraints() {
        
        contentView.anchor(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            centerXAnchor: self.centerXAnchor
        )
        
        titleLabel.anchor(
            top: contentView.safeAreaLayoutGuide.topAnchor,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        )
        
        pinNumberTextField.anchor(
            top: titleLabel.safeAreaLayoutGuide.bottomAnchor,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24),
            size: .init(width: 0, height: 42)
        )
        
        statusLabel.anchor(
            top: pinNumberTextField.safeAreaLayoutGuide.bottomAnchor,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        )
        
        resultLabel.anchor(
            top: statusLabel.safeAreaLayoutGuide.bottomAnchor,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: nil,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        )
        
        requestBalanceButton.anchor(
            top: nil,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: nextButton.safeAreaLayoutGuide.topAnchor,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: .init(top: 0, left: 24, bottom: 8, right: 24),
            size: .init(width: 0, height: 48)
        )
        
        nextButton.anchor(
            top: nil,
            leading: contentView.safeAreaLayoutGuide.leadingAnchor,
            bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
            trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
            centerXAnchor: contentView.centerXAnchor,
            padding: .init(top: 0, left: 24, bottom: 0, right: 24),
            size: .init(width: 0, height: 48)
        )
    }
    
    private func updateButtonState(isEnabled: Bool, button: UIButton) {
        button.isEnabled = isEnabled
        button.isUserInteractionEnabled = isEnabled
        button.alpha = isEnabled ? 1.0 : 0.5
    }
}

// MARK: - ForagePINTextFieldDelegate

extension RequestBalanceView: ForagePINTextFieldDelegate {
    
    func pinStatus(_ view: UIView, isValid: Bool) {
        if isValid {
            statusLabel.text = "It is a VALID pin"
            statusLabel.textColor = .green
        } else {
            statusLabel.text = "It is a NON VALID pin"
            statusLabel.textColor = .red
        }
        updateButtonState(isEnabled: isValid, button: requestBalanceButton)
        isPINValid = isValid
    }
    
    func balanceCallback(_ view: UIView, result: (Result<ForageBalanceModel, Error>)) {
        printPINResult(result: result)
    }
}
