import SnapKit
import UIKit

public final class DoubledSlider: UIControl {
    public struct Constant {
        let height: CGFloat = 4.0
        let trackForegroundImage: UIImage? = UIImage(named: "slider")
        let thumbWrapperSize: CGFloat = 31.0
        let thumbSize: CGFloat = 56.0
        let miniThumbDistance: CGFloat = 5.0
        let edgeMakeup: CGFloat = 5.0
    }

    private let constants = Constant()
    var trackBackgroundColor: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
        // swiftlint:disable force_unwrapping
            return UIColor.White
        } else {
        // swiftlint:disable force_unwrapping
            return UIColor.White
        }
    }

    private lazy var track = UIView()
    private lazy var activeTrack = UIImageView()
    private lazy var leftThumbWrapper = UIImageView()
    private lazy var rightThumbWrapper = UIImageView()
    private lazy var leftThumb = UIImageView(image: UIImage(named: "thumbs"))
    private lazy var rightThumb = UIImageView(image: UIImage(named: "thumbs"))

    // MARK: - Initialization

    public convenience init(minimumValue: Float = .zero, maximumValue: Float = .zero) {
        self.init()
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    private override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = false
        setupTrack()
        setupThumb()
        setupConstraints()
    }

    private func setupTrack() {
        addSubview(track)
        activeTrack = UIImageView(image: constants.trackForegroundImage)
        track.addSubview(activeTrack)
        track.layer.masksToBounds = true
        track.layer.cornerRadius = constants.height / 2
        track.backgroundColor = trackBackgroundColor
        track.clipsToBounds = true
    }

    private func setupThumb() {
        addSubview(leftThumbWrapper)
        addSubview(rightThumbWrapper)
        leftThumbWrapper.addSubview(leftThumb)
        rightThumbWrapper.addSubview(rightThumb)
        [leftThumbWrapper, rightThumbWrapper].forEach {
        $0.clipsToBounds = false
        $0.contentMode = .center
        $0.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragThumb(using:)))
        $0.addGestureRecognizer(gesture)
        }
        [leftThumb, rightThumb].forEach {
        $0.clipsToBounds = false
        $0.contentMode = .center
        }
        self.leftThumbWrapper.tag = 1
        self.rightThumbWrapper.tag = 2
    }

    private func setupConstraints() {
        track.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview()
        make.centerY.equalToSuperview()
        make.height.equalTo(constants.height)
        }

        leftThumbWrapper.snp.makeConstraints { make in
        make.size.equalTo(constants.thumbWrapperSize)
        make.top.bottom.equalToSuperview()
        leftThumbConstraint = make.leading.equalToSuperview().offset(-constants.edgeMakeup).constraint
        make.right.lessThanOrEqualTo(rightThumbWrapper)
        }

        rightThumbWrapper.snp.makeConstraints { make in
        make.size.equalTo(constants.thumbWrapperSize)
        make.top.bottom.equalToSuperview()
        rightThumbConstraint = make.trailing.equalToSuperview()
            .offset(constants.edgeMakeup)
            .constraint
        make.left.greaterThanOrEqualTo(leftThumbWrapper)
        }

        leftThumb.snp.makeConstraints { make in
        make.size.equalTo(constants.thumbSize)
        make.center.equalToSuperview()
        }

        rightThumb.snp.makeConstraints { make in
        make.size.equalTo(constants.thumbSize)
        make.center.equalToSuperview()
        }

        activeTrack.snp.makeConstraints { make in
        leftActiveTrackConstraint = make.leading.equalToSuperview()
            .offset(-constants.edgeMakeup)
            .constraint
        rightActiveTrackConstraint = make.trailing.equalToSuperview()
            .offset(constants.edgeMakeup)
            .constraint
        make.centerY.equalToSuperview()
        make.height.equalTo(constants.height)
        }
    }

    // MARK: - Drag

    @objc private func dragThumb(using gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self)
        switch gesture.state {
        case .began:
        if [1, 2].contains(view.tag) { bringSubviewToFront(view) }

        case .changed:
        self.handleDragging(view, withTranslation: translation)

        case .ended:
        self.handleEndedDragging(view)

        default:
        break
        }
    }

    private func handleDragging(_ view: UIView, withTranslation translation: CGPoint) {
        switch view.tag {
        case 1:
        handleDraggingLeftThumb(view, withTranslation: translation)

        case 2:
        handleDraggingRightThumb(view, withTranslation: translation)

        default:
        break
        }
    }

    private func handleDraggingLeftThumb(_ thumb: UIView, withTranslation translation: CGPoint) {
        let newConstant = translation.x + self.leftThumbConstraintLastConstant
        guard newConstant >= -constants.edgeMakeup else {
        leftThumbWrapper.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(-constants.edgeMakeup)
        }
        activeTrack.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(-constants.edgeMakeup)
        }
        self.updateValues {
            self.sendActions(for: .valueChanged)
        }
        return
        }
        if thumbesInOnePlace(byDraggingThumb: thumb) && translation.x > .zero { return }
        leftThumbWrapper.snp.updateConstraints { make in
        make.leading.equalToSuperview().offset(newConstant)
        }
        activeTrack.snp.updateConstraints { make in
        make.leading.equalToSuperview().offset(newConstant + constants.edgeMakeup)
        }
        self.updateValues {
        self.sendActions(for: .valueChanged)
        }
    }

    private func handleDraggingRightThumb(_ thumb: UIView, withTranslation translation: CGPoint) {
        let newConstant = translation.x + rightThumbConstraintLastConstant
        guard newConstant <= constants.edgeMakeup else {
        rightThumbWrapper.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(constants.edgeMakeup)
        }
        activeTrack.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(constants.edgeMakeup)
        }
        self.updateValues {
            self.sendActions(for: .valueChanged)
        }
        return
        }
        if thumbesInOnePlace(byDraggingThumb: thumb) && translation.x < .zero { return }
        rightThumbWrapper.snp.updateConstraints { make in
        make.trailing.equalToSuperview().offset(newConstant)
        }
        activeTrack.snp.updateConstraints { make in
        make.trailing.equalToSuperview().offset(newConstant - constants.edgeMakeup)
        }
        self.updateValues {
        self.sendActions(for: .valueChanged)
        }
    }

    private func handleEndedDragging(_ view: UIView) {
        switch view.tag {
        case 1:
        leftThumbConstraintLastConstant = leftThumbConstant
        leftActiveTrackConstraintLastConstant = leftActiveTrackConstant

        case 2:
        rightThumbConstraintLastConstant = rightThumbConstant
        rightActiveTrackConstraintLastConstant = rightActiveTrackConstant

        default:
        break
        }
    }

    private func thumbesInOnePlace(byDraggingThumb thumb: UIView) -> Bool {
        let difference = abs(self.leftThumbWrapper.center.x - self.rightThumbWrapper.center.x)
        let onePlace = difference < constants.miniThumbDistance
        if onePlace {
        forceThumbsPositions(byActiveThumb: thumb)
        }
        return onePlace
    }

    private func forceThumbsPositions(byActiveThumb thumb: UIView) {
        switch thumb.tag {
        case 1:
        let newConstant = rightThumbWrapper.frame.origin.x
        leftThumbWrapper.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(newConstant)
        }
        leftThumbConstraintLastConstant = newConstant
        activeTrack.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(newConstant)
        }
        leftActiveTrackConstraintLastConstant = newConstant

        case 2:
        let centerXDifference = rightThumbWrapper.center.x - leftThumbWrapper.center.x
        let newConstant = rightThumbConstant - centerXDifference
        rightThumbWrapper.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(newConstant)
        }
        rightThumbConstraintLastConstant = newConstant
        activeTrack.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(newConstant)
        }
        rightActiveTrackConstraintLastConstant = newConstant

        default:
        break
        }
    }

    // MARK: - Constraints as value

    private var leftThumbConstraint: Constraint?
    private var rightThumbConstraint: Constraint?

    private var leftThumbConstant: CGFloat {
        return leftThumbConstraint?.layoutConstraints[0].constant ?? 0
    }

    private var rightThumbConstant: CGFloat {
        return rightThumbConstraint?.layoutConstraints[0].constant ?? 0
    }

    private var leftThumbConstraintLastConstant: CGFloat = .zero
    private var rightThumbConstraintLastConstant: CGFloat = .zero

    private var leftActiveTrackConstraint: Constraint?
    private var rightActiveTrackConstraint: Constraint?

    private var leftActiveTrackConstant: CGFloat {
        return leftActiveTrackConstraint?.layoutConstraints[0].constant ?? 0
    }

    private var rightActiveTrackConstant: CGFloat {
        return rightActiveTrackConstraint?.layoutConstraints[0].constant ?? 0
    }

    private var leftActiveTrackConstraintLastConstant: CGFloat = .zero
    private var rightActiveTrackConstraintLastConstant: CGFloat = .zero

    // MARK: - Public API

    public var minimumValue: Float = .zero
    public var maximumValue: Float = .zero

    public var values: (minimum: Float, maximum: Float) {
        get { return (minimumValueNow, maximumValueNow) }
        set {
        var newMin: Float = .zero
        var newMax: Float = .zero
        if newValue.0 <= .zero {
            newMin = minimumValue
        }
        if newValue.0 <= minimumValue {
            newMin = minimumValue
        }
        if newValue.0 > newValue.1 {
            newMin = newValue.1
        }
        if newValue.1 <= .zero {
            newMax = minimumValue
        }
        if newValue.1 >= maximumValue {
            newMax = maximumValue
        }
        if newValue.1 < newValue.0 {
            newMax = newValue.0
        }
        self.minimumValueNow = newMin
        self.maximumValueNow = newMax
        }
    }

    // MARK: - Private API

    private var minimumValueNow: Float = .zero
    private var maximumValueNow: Float = .zero

    private func updateValues(_ completion: @escaping () -> Void) {
        minimumValueNow = newMinimalValue
        maximumValueNow = newMaximumValue
        let originXDifference = abs(rightThumbWrapper.frame.origin.x - leftThumbWrapper.frame.origin.x)
        if originXDifference < constants.miniThumbDistance {
        if minimumValueNow == minimumValue {
            maximumValueNow = minimumValueNow
        } else {
            minimumValueNow = maximumValueNow
        }
        }
        completion()
    }

    private var newMinimalValue: Float {
        let leftThumbOriginX = leftThumbConstant
        let distancePassed = leftThumbOriginX + constants.edgeMakeup
        let totalDistance = track.frame.size.width +
        2 * constants.edgeMakeup -
        constants.thumbWrapperSize
        let distancePassedFraction = distancePassed / totalDistance
        if leftThumbOriginX <= -constants.edgeMakeup {
        return minimumValue
        }
        if distancePassed > totalDistance {
        return maximumValue
        }
        let newValue: Float = {
        let difference = maximumValue - minimumValue
        let addingValue = Float(distancePassedFraction) * difference
        return minimumValue + addingValue
        }()
        return newValue
    }

    private var newMaximumValue: Float {
        let constraintConstant = rightThumbConstant
        let distancePassed = abs(constraintConstant - constants.edgeMakeup)
        let totalDistance = track.frame.size.width +
        2 * constants.edgeMakeup -
        constants.thumbWrapperSize
        let distancePassedFraction = distancePassed / totalDistance
        if constraintConstant >= constants.edgeMakeup {
        return maximumValue
        }
        if distancePassed > totalDistance {
        return self.minimumValue
        }
        let newValue: Float = {
        let difference = maximumValue - minimumValue
        let addingValue = difference * Float(distancePassedFraction)
        return maximumValue - addingValue
        }()

        return newValue
    }
}
