//
//  LocationPickerViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 28/11/23.
//

import CoreLocation
import MapKit
import UIKit

class LocationPickerViewController: UIViewController {
    private var map: MKMapView!
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    private var isPickable = true

    init(coordinates: CLLocationCoordinate2D?) {
        self.coordinates = coordinates
        isPickable = false
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // title = "Pick Location"
        view.backgroundColor = .systemBackground

        if isPickable {
            setUpView()
        } else {
            // Just showing location
            guard let coordinates = coordinates else {
                return
            }
            // Drop a pin on that location
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            map.addAnnotation(pin)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setUpLayout()
    }

    private func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendButtonTapped))

        map = MKMapView()
        map.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        map.addGestureRecognizer(gesture)
        map.frame = view.bounds
    }

    private func setUpLayout() {
        view.addSubview(map)
    }

    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        navigationController?.popViewController(animated: true)
        completion?(coordinates)
    }

    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: map)
        let coordinates = map.convert(locationInView, toCoordinateFrom: map)
        self.coordinates = coordinates

        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }

        // Drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
    }
}
