//
//  C.swift
//  Tracker
//
//  Created by Vitaly Lobov on 02.01.2025.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didUpdateSchedule(_ schedule: [DayOfWeek?])
}

final class SceduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var schedule: [DayOfWeek?] = []
    private var tmpSchedule: [DayOfWeek: Bool] = [:]
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15;
        button.layer.borderColor = .init(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.0)
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "saveBtn"
        return button
    }()
    
    private lazy var monLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.cornerRadius = 15
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "monLabel"
        return label
    }()
    
    private lazy var monFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "monFlag"
        flag.isOn = schedule.contains(.mon)
        tmpSchedule[.mon] = flag.isOn
        flag.addTarget(self, action: #selector(monFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var tueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "tueLabel"
        return label
    }()
    
    private lazy var tueFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "tueFlag"
        flag.isOn = schedule.contains(.tue)
        tmpSchedule[.tue] = flag.isOn
        flag.addTarget(self, action: #selector(tueFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var wedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "wedLabel"
        return label
    }()
    
    private lazy var wedFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "wedFlag"
        flag.isOn = schedule.contains(.wed)
        tmpSchedule[.wed] = flag.isOn
        flag.addTarget(self, action: #selector(wedFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var thuLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "thuLabel"
        return label
    }()
    
    private lazy var thuFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "thuFlag"
        flag.isOn = schedule.contains(.thu)
        tmpSchedule[.thu] = flag.isOn
        flag.addTarget(self, action: #selector(thuFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var friLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "friLabel"
        return label
    }()
    
    private lazy var friFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "friFlag"
        flag.isOn = schedule.contains(.fri)
        tmpSchedule[.fri] = flag.isOn
        flag.addTarget(self, action: #selector(friFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var satLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "satLabel"
        return label
    }()
    
    private lazy var satFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "satFlag"
        flag.isOn = schedule.contains(.sat)
        tmpSchedule[.sat] = flag.isOn
        flag.addTarget(self, action: #selector(satFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    private lazy var sunLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.layer.cornerRadius = 15
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.backgroundColor = .ypGray
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = .systemFont(ofSize: .init(17), weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "sunLabel"
        return label
    }()
    
    private lazy var sunFlag: UISwitch = {
        let flag = UISwitch()
        flag.onTintColor = .systemBlue
        flag.translatesAutoresizingMaskIntoConstraints = false
        flag.accessibilityIdentifier = "sunFlag"
        flag.isOn = schedule.contains(.sun)
        tmpSchedule[.sun] = flag.isOn
        flag.addTarget(self, action: #selector(sunFlagChanged(_:)), for: .valueChanged)
        return flag
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addLabel(label: label)
        addSaveBtn(button: saveBtn)
        addWeekLabel(label: monLabel, flag: monFlag,idx: 1)
        addWeekLabel(label: tueLabel, flag: tueFlag,idx: 2)
        addWeekLabel(label: wedLabel, flag: wedFlag,idx: 3)
        addWeekLabel(label: thuLabel, flag: thuFlag,idx: 4)
        addWeekLabel(label: friLabel, flag: friFlag,idx: 5)
        addWeekLabel(label: satLabel, flag: satFlag,idx: 6)
        addWeekLabel(label: sunLabel, flag: sunFlag,idx: 7)
    }
    
    @objc
    private func didTapSave() {
        schedule.removeAll()
        for (key, value) in tmpSchedule {
            if value {
                schedule.append(key)
            }
        }
        delegate?.didUpdateSchedule(schedule)
        dismiss(animated: true, completion: nil)
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addSaveBtn(button: UIButton) {
        view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addWeekLabel(label: UILabel, flag: UISwitch, idx: Int) {
        label.text = "  " + DayOfWeek.getDay(number: idx)
        view.addSubview(label)
        view.addSubview(flag)
        
        NSLayoutConstraint.activate([label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(40 + 60 * idx)),
                                     label.heightAnchor.constraint(equalToConstant: 60)])
        NSLayoutConstraint.activate([flag.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -20),
                                     flag.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 0)])
    }
    
    func loadSelectedSchedule(from schedule: [DayOfWeek?]) {
        self.schedule = schedule
    }
    
    @objc private func monFlagChanged(_ sender: UISwitch) { tmpSchedule[.mon] = sender.isOn }
    @objc private func tueFlagChanged(_ sender: UISwitch) { tmpSchedule[.tue] = sender.isOn }
    @objc private func wedFlagChanged(_ sender: UISwitch) { tmpSchedule[.wed] = sender.isOn }
    @objc private func thuFlagChanged(_ sender: UISwitch) { tmpSchedule[.thu] = sender.isOn }
    @objc private func friFlagChanged(_ sender: UISwitch) { tmpSchedule[.fri] = sender.isOn }
    @objc private func satFlagChanged(_ sender: UISwitch) { tmpSchedule[.sat] = sender.isOn }
    @objc private func sunFlagChanged(_ sender: UISwitch) { tmpSchedule[.sun] = sender.isOn }
    
}
