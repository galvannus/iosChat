//
//  RegisterViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 11/10/23.
//

import FirebaseAuth
import UIKit

class RegisterViewController: UIViewController {
    var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    var lastNameField: UITextField!
    var emailField: UITextField!
    var passwordField: UITextField!
    var firstNameField: UITextField!
    private var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Register"

        setUpView()
        setUpLayout()
    }

    private func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 24

        imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true

        firstNameField = UITextField()
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .continue
        firstNameField.layer.cornerRadius = 12
        firstNameField.layer.borderWidth = 1
        firstNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstNameField.layer.borderColor = UIColor.lightGray.cgColor
        firstNameField.placeholder = "First Name..."
        firstNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstNameField.leftViewMode = .always
        firstNameField.backgroundColor = .white

        lastNameField = UITextField()
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .continue
        lastNameField.layer.cornerRadius = 12
        lastNameField.layer.borderWidth = 1
        lastNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lastNameField.layer.borderColor = UIColor.lightGray.cgColor
        lastNameField.placeholder = "Last Name..."
        lastNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastNameField.leftViewMode = .always
        lastNameField.backgroundColor = .white

        emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.placeholder = "Email Adress..."
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white

        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.placeholder = "Password..."
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true

        registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        emailField.delegate = self
        passwordField.delegate = self
    }

    private func setUpLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(registerButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        ])
    }

    @objc func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()

        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }

        // Firebase Register

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Error creating user.")
                return
            }

            let user = result.user
            print("Created User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }

    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to create a new account.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
}
