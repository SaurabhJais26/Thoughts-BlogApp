//
//  CreateNewPostViewController.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
//

import UIKit

class CreateNewPostViewController: UITabBarController {
    
    // Title field
    private let titleField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Title..."
        field.backgroundColor = .secondarySystemBackground
        field.layer.masksToBounds = true
        return field
    }()
    
    // Image Header
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    // TextView for post
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleField)
        view.addSubview(headerImageView)
        view.addSubview(textView)
        configureButtons()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleField.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top,
            width: view.width-20,
            height: 50
        )
        
        headerImageView.frame = CGRect(
            x: 0,
            y: titleField.bottom+5,
            width: view.width,
            height: 160
        )
        
        textView.frame = CGRect(
            x: 10,
            y: headerImageView.bottom+10,
            width: view.width-20,
            height: view.height-210-view.safeAreaInsets.top
        )
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapPost() {
        // Check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let alert = UIAlertController(title: "Enter Post Details", message: "Please enter a title, body and select a image to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        print("Starting post...")
        ActivityIndicatorManager.shared.showIndicator("Posting...", vc: self)
        let newPostId = UUID().uuidString
        
        // Upload header image
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else {
                DispatchQueue.main.async {
                    ActivityIndicatorManager.shared.hideIndicator(from: self)
                    let alert = UIAlertController(title: "Failed to Post", message: "There was an error uploading the image.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
                guard let headerUrl = url else {
                    DispatchQueue.main.async {
                        ActivityIndicatorManager.shared.hideIndicator(from: self)
                        let alert = UIAlertController(title: "Failed to Post", message: "There was an error getting the image URL.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    print("Failed to upload url for header")
                    return
                }
                // Insert of post into DB
                
                let post = BlogPost(
                    identifier: newPostId   ,
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageUrl: headerUrl,
                    text: body
                )
                
                DatabaseManager.shared.insertBlogPost(blogPost: post, email: email) { [weak self] posted in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        ActivityIndicatorManager.shared.hideIndicator(from: self)
                        
                        if posted {
                            HapticsManager.shared.vibrate(for: .success)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            let alert = UIAlertController(title: "Failed to Post", message: "There was an error posting your blog.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}
