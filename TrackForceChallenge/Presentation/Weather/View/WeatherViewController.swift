import UIKit
import MapKit

struct ForecastHeaderViewModel {
    let iconName: String
    let weatherDescription: String
    let temperatureLabel: String
    let cityName: String
    let coordinate: LocationCoordinate
}

protocol WeatherView: View {
    func showForecast(_ info: ForecastHeaderViewModel)
}

final class WeatherViewController: UIViewController {
    
    var presenter: WeatherPresenterProtocol!
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.isZoomEnabled = false
        view.isScrollEnabled = false
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners(radius: 16.0)
        return view
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        return table
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 48.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 32.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let mainIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 52).isActive = true
        return imageview
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let view = UIStackView(arrangedSubviews: [temperatureLabel,
                                                  mainLabel])
        view.axis = .vertical
        view.spacing = 16.0
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackViewHeader: UIStackView = {
        let view = UIStackView(arrangedSubviews: [stackViewLabel, UIView(),
                                                  mainIcon])
        view.axis = .horizontal
        view.spacing = 16.0
        view.distribution = .fillProportionally
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.onViewDidLoad()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureStackViewHeader() {
        view.addSubview(stackViewHeader)
        NSLayoutConstraint.activate([
            stackViewHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackViewHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureMapView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: stackViewHeader.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func configureCityLabel() {
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .white
        configureStackViewHeader()
        configureMapView()
        configureCityLabel()
        configureTableView()
        configureSpinner()
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.forecastCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = presenter.forecastViewModel(at: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseIdentifier, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        cell.configure(with: forecast)
        return cell
    }
}

extension WeatherViewController: WeatherView {
    func transformToMkLocation(location: LocationCoordinate) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude,
                                      longitude: location.longitude)
    }
    
    func showForecast(_ info: ForecastHeaderViewModel) {
        mainIcon.image = UIImage(named: info.iconName)?.resized(to: CGSize(width: 60, height: 60))
        mainLabel.text = info.weatherDescription
        temperatureLabel.text = info.temperatureLabel
        cityLabel.text = info.cityName
        let region = MKCoordinateRegion(center: transformToMkLocation(location: info.coordinate),
                                        latitudinalMeters: 10000,
                                        longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = transformToMkLocation(location: info.coordinate)
        annotation.title = info.cityName
        mapView.addAnnotation(annotation)
        self.tableView.reloadData()
    }
    
    func showLoading(_ value: Bool) {
        if value {
            spinner.isHidden = false
            tableView.isHidden = true
            cityLabel.isHidden = true
            mapView.isHidden = true
            spinner.startAnimating()
        } else {
            spinner.isHidden = true
            tableView.isHidden = false
            cityLabel.isHidden = false
            mapView.isHidden = false
            spinner.stopAnimating()
        }
    }
    
    func showError(_ title: String?, _ message: String) {
        let alert = UIAlertController(title: title ?? "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
