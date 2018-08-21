//
//  ViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

protocol Subject {

    func registerObserver(o: Observer)
    func removeObserver(o: Observer)
    func notifyObservers()
}

protocol Observer: class {

    func update(temperature: Float, humidity: Float, pressure: Float)
}

protocol DisplayElement {

    func display()
}

let notificationName = Notification.Name("NotificationIdentifier")

class WeatherData: Subject {

    private var observers = [Observer]()
    private var temperature: Float = 0.0
    private var humidity: Float = 0.0
    private var pressure: Float = 0.0

    init() {
    }

    func registerObserver(o: Observer) {

        observers.append(o)
    }

    func removeObserver(o: Observer) {

        let i = observers.index { $0 === o }
        if let i = i, i >= 0 {
            observers.remove(at: i)
        }
    }

    func notifyObservers() {

        for i in 0..<observers.count {
            let observer = observers[i]
            observer.update(temperature: temperature, humidity: humidity, pressure: pressure)
        }
    }

    func measurementChanged() {

        notifyObservers()
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    func setMeasurements(temperature: Float, humidity: Float, pressure: Float) {

        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        measurementChanged()
    }

    func getTemperature() -> Float {

        return temperature
    }

    func getHumidity() -> Float {

        return humidity
    }

    func getPressure() -> Float {

        return pressure
    }
}

class CurrentConditionsDisplay: Observer, DisplayElement {

    private var temperature: Float = 0.0
    private var humidity: Float = 0.0
    private var weatherData: Subject?

    init(weatherData: WeatherData) {

        self.weatherData = weatherData
        weatherData.registerObserver(o: self)
    }

    func update(temperature: Float, humidity: Float, pressure: Float) {

        // pull
        if let weatherData = weatherData as? WeatherData {
            self.temperature = weatherData.getTemperature()
            self.humidity = weatherData.getHumidity()
        }
        // push
        //        self.temperature = temperature
        //        self.humidity = humidity
        display()
    }

    func display() {

        print("Current condition: " + String(temperature) + "F degrees and " + String(humidity) + "% humidity")
    }
}

class ForecastDisplay: NSObject, DisplayElement {

    let observable: Subject?

    init(observable: Subject) {

        self.observable = observable

        super.init()

        print("aAaa")

        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: notificationName, object: nil)
    }
    
    @objc
    func update(notification: Notification) {
        
        //print(notification.object)
    }
    
    func display() {
        
        print("success")
    }
}

class PlaygroundViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!

//    @IBOutlet weak var basicTextView: UITextView!
//    @IBOutlet weak var basicTableview: UITableView!

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"

    var fD: ForecastDisplay?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //basicTextView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.printTest), name: notificationName, object: nil)

        let weatherData = WeatherData()

        let _ = CurrentConditionsDisplay(weatherData: weatherData)
        fD = ForecastDisplay(observable: weatherData)


        weatherData.setMeasurements(temperature: 80, humidity: 65, pressure: 30.4)
        weatherData.setMeasurements(temperature: 80, humidity: 67, pressure: 30.5)

//        basicTableview.setEditing(true, animated: true)
//        basicTableview.allowsMultipleSelection = true
//        basicTableview.dataSource = self

        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc
    func printTest(notif: Notification) {
        print("Test")
    }

    override func viewDidLayoutSubviews() {
        let diff = view.bounds.height - bgView.bounds.height
        if diff > 0 {
            scrollView.contentInset = UIEdgeInsetsMake(diff / 2, 0, diff / 2, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension PlaygroundViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableCell", for: indexPath)
        cell.textLabel?.text = "apple"
        return cell
    }
}

extension PlaygroundViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        textView.isScrollEnabled = true
        print(textView.contentSize)
        textView.isScrollEnabled = false
    }
}

