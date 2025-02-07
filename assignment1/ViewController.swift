//
//  ViewController.swift
//  assignment1
//
//  Created by Umesh Basnet on 25/01/2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightInchTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var unitSwitch: UISwitch!
    
    @IBOutlet weak var heightUnitLabel: UILabel!
    @IBOutlet weak var inchesLabel: UILabel!
    @IBOutlet weak var bmiCategoryLabel: UILabel!
    
    @IBOutlet weak var heightErrorLabel: UILabel!
    @IBOutlet weak var weightErrorLabel: UILabel!
    @IBOutlet weak var weightUniLabel: UILabel!
    
    var isSIUnit = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unitSwitch.isOn = !isSIUnit
        setupUIForUnit()
        // Do any additional setup after loading the view.
    }


    @IBAction func onUnitChanged(_ sender: UISwitch) {
        isSIUnit =  !sender.isOn
        setupUIForUnit()
    }
    
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
   
        let (heightError, height) = getHeight()
        let (weightError, weight) = getWeight()
        
        print(heightError, weightError)
        if heightError != nil || weightError != nil {
            heightErrorLabel.text = heightError
            weightErrorLabel.text = weightError
            return
        }
        
        heightErrorLabel.text = ""
        weightErrorLabel.text = ""
        
        let bmi = calculateBMI(heghtInMeter: height, weightInKg: weight)
        print(bmi)
        print(height)
        resultLabel.text = String(format: "%.1f", bmi)
        bmiCategoryLabel.text = getBMICategories(fromBMI: bmi)
        
        
    }
    
    func getHeight() -> (String?, Double){
        if isSIUnit {
            return getStandardHeight(feetText: heightTextField.text ?? "", inchText: heightInchTextField.text ?? "")
        } else {
            return getMetricHeight(centiMeterText: heightTextField.text ?? "")
        }
    }
    
    func getStandardHeight(feetText: String, inchText: String) -> (String?, Double){
        if(feetText.isEmpty && inchText.isEmpty){
            return ("Height must not be empty", 0);
        }
        
        let feet = Double(feetText.isEmpty ? "0" : feetText)
        let inch = Double(inchText.isEmpty ? "0" : inchText)
       
        
        if(feet == nil || inch == nil){
            return ("Height must be valid number", 0);
        }
        
        if(feet! > 20) {
            return ("Height is very large", 0)
        }
        let height = convertToM(feet: feet!, inches: inch!)
        
        if(height < 0){
            return ("Height must be positive number", 0)
        }
        
       
        
        return (nil, height)
    }
    
    func getMetricHeight(centiMeterText: String) -> (String?, Double){
        if(centiMeterText.isEmpty){
            return ("Height must not be empty", 0);
        }
        
        guard let cm = Double(centiMeterText) else { return ("Height must be valid number", 0) }
        
        if(cm > 500) {
            return ("Height is very large", 0)
        }
        
        let height = convertToM(cm: cm)
        
        if(height < 0){
            return ("Height must be positive number", 0)
        }
        
       
        
        return (nil, height)
    }
    
    func getWeight() -> (String?, Double){
        let weightText = weightTextField.text ?? ""
        
        if (weightText.isEmpty) {
            return ("Weight must not be empty", 0)
        }
        
        guard let weight = Double(weightText) else {
            return ("Weight must be valid number", 0)
        }
        
        if (weight < 0) {
            return ("Weight must be positive number", 0)
        }
        
        if(weight > 500) {
            return ("Weight is very large", 0)
        }
        
        return (nil, isSIUnit ? convertToKg(pound: weight): weight)
        
    }
    
    
//    func validateHeight(heightText: String?) -> String?{
//        
//    }
    
    func calculateBMI(heghtInMeter height: Double, weightInKg weight: Double) -> Double{
        return weight / (height * height)
    }
    
    func convertToM( cm: Double) -> Double{
        return cm / 100
    }
    
    func convertToM(feet: Double, inches: Double) -> Double {
        return feet*0.3048 + inches * 0.0254
    }
    
    func convertToKg(pound: Double) -> Double {
        return pound * 0.4535924
    }
    
    func getBMICategories(fromBMI bmi: Double) -> String {
        if bmi < 18.5 {
            return "Underweight"
        }
        if bmi < 25 {
            return "Normal weight"
        }
        if(bmi < 30) {
            return "Overweight"
        }
        return "Obesity"
    }
    
    func setupUIForUnit(){
        heightErrorLabel.text = ""
        weightErrorLabel.text = ""
        heightTextField.text = ""
        heightInchTextField.text = ""
        weightTextField.text = ""
        bmiCategoryLabel.text = ""
        resultLabel.text = ""
        if isSIUnit {
            heightUnitLabel.text = "Feet"
            weightUniLabel.text = "Pounds"
            heightInchTextField.isHidden = false
            inchesLabel.isHidden = false
        } else {
            heightUnitLabel.text = "CM"
            weightUniLabel.text = "KG"
            heightInchTextField.isHidden = true
            inchesLabel.isHidden = true
        }
    }
    
}


