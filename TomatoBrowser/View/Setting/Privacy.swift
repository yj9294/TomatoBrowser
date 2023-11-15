//
//  Privacy.swift
//  TomatoBrowser
//
//  Created by yangjian on 2023/10/23.
//

import Foundation
import ComposableArchitecture

struct Privacy: Reducer {
    struct State: Equatable {
        var item: Item = .privacy
    }
    enum Action: Equatable {
        case dismiss
    }
    var body: some Reducer<State, Action> {
        Reduce{ state, action in
            return .none
        }
    }
}

extension Privacy.State {
    enum Item {
        case privacy, terms
        var title: String {
            switch self {
            case .privacy:
                return .privacy
            case .terms:
                return .terms
            }
        }
        var body: String {
            switch self {
            case .privacy:
                return .privacyBody
            case .terms:
                return .termsBody
            }
        }
    }
}

extension String {
    static let privacyBody = """
We provide you with this privacy policy to let you understand how we legally collect, organize and use your information, which includes information you may provide to us or that we legally obtain from our products and services. information. We take your privacy very seriously. Your privacy is important to us, please rest assured that we will fully protect your privacy
Information Collection and Use
- Personal information refers to important data that can be used to uniquely identify or contact an individual.
- When you access, download, install or upgrade our applications or products, we do not collect, store or use any of your personal information, other than the personal information you submit to us when sending a bug report.
- We may only use the personal information you submit for the following purposes: to help us develop and upgrade our product content and services; to manage online surveys or other activities in which you participate.
- We may disclose your personal information based on your wishes or legal requirements under the following circumstances:
(1) With your prior permission
(2) According to the laws and litigation requirements in and outside your country of residence
(3) At the request of public and governmental authorities
(4) Safeguard our legitimate rights and interests.
How we share information
We may engage third party companies and individuals for the following reasons:
comprehensively promote our applications;
To provide service assistance policies on our behalf;
Perform service content related to the service;
Help us analyze how to make our services more responsive to our customers' needs.
Update
We may update and adjust the privacy policy from time to time. When we change the content of our policy, we will post a notice on the website to inform you and also mark the updated privacy policy content.
Contact us
If you have any questions or concerns about the content of our privacy policy or data processing, please contact us in time:support@quickgetclean.com
"""
    static let termsBody = """
Please be sure to read these terms carefully.
Use of the application
1. You agree that we will use your information for the purposes required by laws and regulations.
2. You agree that you shall not use our Application for illegal purposes.
3. You agree that we may stop providing our products and services at any time without prior notice.
4. By agreeing to download or install our software, you accept our Privacy Policy.
Update
We may update our privacy policy from time to time. When we make material changes to our policy, we will post a notice on our website along with the updated privacy policy.
Contact us
If you have any questions or concerns about our Privacy Policy or data processing, please contact us:support@quickgetclean.com
"""
}
