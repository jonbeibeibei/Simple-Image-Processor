//: Playground - noun: a place where people can play
// Author: Jonathan Bei Qi Yang

import UIKit


//------------------------------------------------------------------------------------------------
// Image Processor
//------------------------------------------------------------------------------------------------
class InstaFilterProcessor{
    var image: RGBAImage
    var avgRed = 0
    var avgGreen = 0
    var avgBlue = 0
    
    init(image: UIImage){
        self.image = RGBAImage(image:image)!
    }
    
    
    //----------------------------------------------------------------------------------------
    // Function: runFilters
    // Parameters: filterChoices: [String]
    // Returns: None
    //
    // Runs the specified list of filter choices as inputted.
    //----------------------------------------------------------------------------------------
    func runFilters(filterChoices: [String]){
        
        for choice in filterChoices {
            switch choice.lowercased(){
                case "dark dots":
                    self.dotsFilter(by: "dark")
                
                case "light dots":
                    self.dotsFilter(by: "light")
                
                case "blue 50%":
                    self.blueFilter(by: 2)
                
                case "blue 100%":
                    self.blueFilter(by: 5)
                
                case "green 50%":
                    self.greenFilter(by: 2)
                
                case "green 100%":
                    self.greenFilter(by: 5)
                
                case "red 50%":
                    self.redFilter(by: 2)
                
                case "red 100%":
                    self.redFilter(by: 5)
                
                case "brightness 50%":
                    self.brightnessFilter(by: 50)
                
                case "brightness 150%":
                    self.brightnessFilter(by: 150)
                
                
                
            default:
                print("This filter ", choice.lowercased(), " is an invalid choice!")
                
                
            }
            
        }
        
    }
    
    
    
    //----------------------------------------------------------------------------------------
    // Function: getImageValues
    // Parameters: image: RGBAImage
    // Returns: [Int] Array
    //
    // Utility helper function to get the average color values of each image.
    //----------------------------------------------------------------------------------------
    func getImageValues(image: RGBAImage) -> [Int]{
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        //Run filter over all pixels in the image
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        let count = image.width * image.height
        let avgRed = totalRed/count
        let avgGreen = totalGreen/count
        let avgBlue = totalBlue/count
        
        return [avgRed, avgGreen, avgBlue]
    }
    
    //----------------------------------------------------------------------------------------
    // Function: blueFilter
    // Parameters: intensity: Int
    // Returns: None
    // Notes: Use values between -4 and 4 for the intensity, for best results
    //
    // Applies a blue filter over the image, depending on the intensity specified.
    //----------------------------------------------------------------------------------------
    func blueFilter(by intensity: Int) {
        
        let imageAverages = getImageValues(image: self.image)
        let avgBlue = imageAverages[2]
        
        //Run filter over all pixels in the image
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                let blueDiff = Int(pixel.blue) - avgBlue
                if(blueDiff > 0){
                    pixel.blue = UInt8(max(0, min(255, avgBlue + (blueDiff * intensity))))
                    self.image.pixels[index] = pixel
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------------------
    // Function: redFilter
    // Parameters: intensity: Int
    // Returns: None
    // Notes: Use values between -4 and 4 for the intensity, for best results
    //
    // Applies a red filter over the image, depending on the intensity specified.
    //----------------------------------------------------------------------------------------
    func redFilter(by intensity: Int){
    
        let imageAverages = getImageValues(image: self.image)
        let avgRed = imageAverages[0]
        
        //Run filter over all pixels in the image
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                let redDiff = Int(pixel.blue) - avgRed
                if(redDiff > 0){
                    pixel.red = UInt8(max(0, min(255, avgRed + (redDiff * intensity))))
                    self.image.pixels[index] = pixel
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------------------
    // Function: greenFilter
    // Parameters: intensity: Int
    // Returns: None
    // Notes: Use values between -4 and 4 for the intensity, for best results
    //
    // Applies a green filter over the image, depending on the intensity specified.
    //----------------------------------------------------------------------------------------
    func greenFilter(by intensity: Int){
        
        let imageAverages = getImageValues(image: self.image)
        let avgGreen = imageAverages[1]
        
        //Run filter over all pixels in the image
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                let greenDiff = Int(pixel.blue) - avgGreen
                if(greenDiff > 0){
                    pixel.green = UInt8(max(0, min(255, avgGreen + (greenDiff * intensity))))
                    self.image.pixels[index] = pixel
                }
            }
        }
    }
    
    //----------------------------------------------------------------------------------------
    // Function: brightnessFilter
    // Parameters: intensity: Int
    // Returns: None
    // Notes: Use percentage values, for best results (eg: 50% or 150%...etc)
    //
    // Applies a brightness filter over the image, based on the percentage configured.
    //----------------------------------------------------------------------------------------
    func brightnessFilter(by intensity: Int){
        
        let change = Double(intensity)/100
        
        //Run filter over all pixels in the image
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                //Modify the respective pixels by the specified percentage
                let updateRed = round(Double(pixel.red) * change)
                let updateGreen = round(Double(pixel.green) * change)
                let updateBlue = round(Double(pixel.blue) * change)
                
                //Apply the changes to each pixel
                pixel.red = UInt8(max(0, min(255, updateRed)))
                pixel.green = UInt8(max(0, min(255, updateGreen)))
                pixel.blue = UInt8(max(0, min(255, updateBlue)))
                
                self.image.pixels[index] = pixel
            }
        }
    }
    
    //----------------------------------------------------------------------------------------
    // Function: dotsFilter
    // Parameters: choice: String
    // Returns: None
    // Notes: Use only "light" or dark" for choice parameter
    //
    // Applys a dotted look over the image, can choose either light or dark dots to be applied.
    //----------------------------------------------------------------------------------------
    func dotsFilter(by choice: String){
        
        
        //Run filter over all pixels in the image
        for y in 0..<self.image.height {
            for x in 0..<self.image.width{
                let index = y * self.image.width + x
                var pixel = self.image.pixels[index]
                
                if(x%2 == 0){
                    if(y%2 == 0){
                        if(choice == "light"){
                            pixel.red = UInt8(0)
                            pixel.green = UInt8(0)
                            pixel.blue = UInt8(0)
                            pixel.alpha = UInt8(0)
                        
                            self.image.pixels[index] = pixel
                        }
                        if (choice == "dark"){
                            pixel.red = UInt8(0)
                            pixel.green = UInt8(0)
                            pixel.blue = UInt8(0)
                            
                            self.image.pixels[index] = pixel
                        }
                    }
                }

                
            }
        }
        
    }
    
    //----------------------------------------------------------------------------------------
    // Function: displayImage
    // Parameters: None
    // Returns: UIImage
    //
    // Displays the image currently in the specified InstaFilterProcessor Instance.
    //----------------------------------------------------------------------------------------
    
    func displayImage() -> UIImage {
        return self.image.toUIImage()!
    }

}



//---------------------------------------------------------------------------------
// Example uses
// --> Feel free to uncomment the sample code snippets to test out the filters!
//---------------------------------------------------------------------------------
let image1 = UIImage(named: "sample")
//
let filter1 = InstaFilterProcessor(image: image1!)
//let filter2 = InstaFilterProcessor(image: image1!)
//let filter3 = InstaFilterProcessor(image: image1!)
//let filter4 = InstaFilterProcessor(image: image1!)

filter1.runFilters(filterChoices: ["blue 50%", "dark dots"])
filter1.displayImage()

//filter2.runFilters(["blue 100%", "light dots"])
//filter2.displayImage()

//filter3.runFilters(["red 100%"])
//filter3.displayImage()

//filter4.runFilters(["green 50%", "brightness 50%", "light dots"])
//filter4.displayImage()















