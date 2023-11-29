//
//  LoginViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 11/10/23.
//

import FBSDKLoginKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import JGProgressHUD
import UIKit

class LoginViewController: UIViewController {
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    var emailField: UITextField!
    var passwordField: UITextField!
    private var loginButton: UIButton!
    private var loginFacebookButton = FBLoginButton()
    private var loginGoogleButton = GIDSignInButton()
    var spinner: JGProgressHUD!

    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.dismiss(animated: true)
        })

        view.backgroundColor = .systemBackground
        title = "Log In"

        setUpView()
        setUpLayout()
    }

    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = true

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 24

        imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

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
        emailField.backgroundColor = .secondarySystemBackground

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
        passwordField.backgroundColor = .secondarySystemBackground
        passwordField.isSecureTextEntry = true

        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        loginButton.backgroundColor = .link
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        loginFacebookButton.center = view.center
        loginFacebookButton.layer.cornerRadius = 12
        loginFacebookButton.layer.masksToBounds = true
        loginFacebookButton.permissions = ["public_profile", "email"]

        loginGoogleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)

        spinner = JGProgressHUD()
        spinner.style = .dark

        emailField.delegate = self
        passwordField.delegate = self
        loginFacebookButton.delegate = self
    }

    private func setUpLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(loginFacebookButton)
        stackView.addArrangedSubview(loginGoogleButton)

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

        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }

        spinner.show(in: view)

        // Firebase Loign
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }

            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }

            let user = result.user
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case let .success(data):
                    guard let userData = data as? [String: Any],
                          let firstName = userData["first_name"],
                          let lastName = userData["last_name"] else {
                        return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case let .failure(error):
                    print("Failed to read data with error \(error)")
                }
            })

            UserDefaults.standard.set(email, forKey: "email")

            print("Logged In User \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }

    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                return
            }

            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                print("missing auth object off of google user")
                return
            }

            print("did sign in with google: \(user)")

            guard let email = user.profile?.email,
                  let firstName = user.profile?.givenName,
                  let lastName = user.profile?.familyName else {
                return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

            DatabaseManager.shared.userExists(with: email) { exists in
                // print("Existe \(email): \(exists)")
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    // insert to database
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            // Check if profile image of google exists
                            if (user.profile?.hasImage) != nil {
                                guard let url = user.profile?.imageURL(withDimension: 200) else {
                                    return
                                }

                                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                    guard let data = data else {
                                        return
                                    }

                                    // Upload image
                                    let fileName = chatUser.profilePictureFileName
                                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                                        switch result {
                                        case let .success(downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case let .failure(error):
                                            print("Storage Manager error. \(error)")
                                        }
                                    })
                                }).resume()
                            }
                        }
                    })
                }
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            // If sign in succeeded, display the app's main content View.

            FirebaseAuth.Auth.auth().signIn(with: credential) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("failed to log in with google credential")
                    return
                }

                print("successfully signed in with google")
                NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            }
        }
    }
}

// MARK: - Login Facebook Delegate

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // No operation
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        // Unwrap token
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook.")
            return
        }

        // Make request object - Get name & email from Facebook
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":
                                                             "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil, httpMethod: .get)
        // print("Despues de request.")

        // Execute request
        facebookRequest.start(completion: { _, result, error in
            // Get email and facebook
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph request.")
                return
            }
            print(result)

            // Unwrap data
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                print("Failed to get email and name from facebook result.")
                return
            }

            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")

            // Split name
            /*
             let nameComponents = userName.components(separatedBy: " ")

             guard nameComponents.count == 3 else {
                 return
             }

             let firstName = nameComponents[0]
             let lastName = "\(nameComponents[1]) \(nameComponents[2])"
              */
            // print("Picture Facebook: \(pictureUrl)")

            // Check if the email exists
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    // Insert into the DB
                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                        if success {
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            print("Downloading data from facebook image")

                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else {
                                    print("Failed to get data from facebook")
                                    return
                                }
                                print("got data from FB, uploading...")

                                // Upload image
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                                    switch result {
                                    case let .success(downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case let .failure(error):
                                        print("Storage Manager error. \(error)")
                                    }
                                })
                            }).resume()
                        }
                    })
                }
            })

            // Facebook Crerencial - Get firebase credential
            let credential = FacebookAuthProvider.credential(withAccessToken: token)

            // Using the credential to firebase auth to sign in
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed. - \(error)")
                    }
                    return
                }

                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })

        })
    }
}
