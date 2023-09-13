//
//  AlarmItemCell.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/29.
//

import UIKit

enum AlarmItemType {
    case none
    case top
    case bottom
    case topBottom
}

class AlarmItemCell: UITableViewCell {
    
    private let option: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "unSelect"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let desc: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let timeDesc: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let sv = UIStackView(arrangedSubviews: [option, desc, timeDesc])
        sv.axis = .horizontal
        sv.spacing = 10.0
        sv.alignment = .leading
        sv.distribution = .fill
        contentView.addSubview(sv)
        
        sv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(10)
        }
        timeDesc.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        option.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview()
        }
    }
    
    func setData(data: SaveData, index: Int, type: AlarmItemType = .none) {
        desc.text = data.desc
        timeDesc.text = data.dateStr
        option.image = UIImage(named: (data.option) ? "select": "unSelect")
        if data.expired {
            contentView.backgroundColor = .red
        } else {
            contentView.backgroundColor = .orange
        }
        
        switch type {
        case .none:
            contentView.layer.cornerRadius = 0
            contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .top:
            contentView.layer.cornerRadius = 14
            contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .bottom:
            contentView.layer.cornerRadius = 14
            contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .topBottom:
            contentView.layer.cornerRadius = 14
            contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
}
