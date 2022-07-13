//
//  ViewController.swift
//  HapticsDemo
//
//  Created by TELOLAHY Hugues Stéphano on 13/07/2022.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorColor = UIColor.gray.withAlphaComponent(0.5)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let feedbackGenerator: (notification: UINotificationFeedbackGenerator,
                            impact: (light: UIImpactFeedbackGenerator,
                                     medium: UIImpactFeedbackGenerator,
                                     heavy: UIImpactFeedbackGenerator),
                            selection: UISelectionFeedbackGenerator) = {
        return (notification: UINotificationFeedbackGenerator(),
                impact: (light: UIImpactFeedbackGenerator(style: .light),
                         medium: UIImpactFeedbackGenerator(style: .medium),
                         heavy: UIImpactFeedbackGenerator(style: .heavy)),
                selection: UISelectionFeedbackGenerator())
    }()
    
    let sections: [(title: String, options: [String])] = [
        ("Haptic Feedback - Notification", ["Success", "Warning", "Error"]),
        ("Haptic Feedback - Impact", ["Light", "Medium", "Heavy"]),
        ("Haptic Feedback - Selection", ["Selection"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Taptic Engine Example"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        if let feedbackSupportLevel = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int {
            print("UIDevice.current _feedbackSupportLevel: \(feedbackSupportLevel)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Wake up the haptic engine
        // "Informs self that it will likely receive events soon, so that it can ensure minimal latency for any feedback generated. Safe to call more than once before the generator receives an event, if events are still imminently possible."
        feedbackGenerator.selection.prepare()
        feedbackGenerator.notification.prepare()
        feedbackGenerator.impact.light.prepare()
        feedbackGenerator.impact.medium.prepare()
        feedbackGenerator.impact.heavy.prepare()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didReceiveMemoryWarning")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].options[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 0:
            // UINotificationFeedbackGenerator
            switch indexPath.row {
            case 0:
                // Success
                feedbackGenerator.notification.notificationOccurred(.success)
            case 1:
                // Warning
                feedbackGenerator.notification.notificationOccurred(.warning)
            case 2:
                // Error
                feedbackGenerator.notification.notificationOccurred(.error)
            default:
                break
            }
        case 1:
            // UIImpactFeedbackGenerator
            switch indexPath.row {
            case 0:
                // Light
                feedbackGenerator.impact.light.impactOccurred()
            case 1:
                // Medium
                feedbackGenerator.impact.medium.impactOccurred()
            case 2:
                // Heavy
                feedbackGenerator.impact.heavy.impactOccurred()
            default:
                break
            }
        case 2:
            // UISelectionFeedbackGenerator
            switch indexPath.row {
            case 0:
                // Selection
                feedbackGenerator.selection.selectionChanged()
            default:
                break
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

