//
//  ChartViewController.swift
//  Vietlott
//
//  Created by CongTruong on 11/19/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let unitsSold = [15.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setChart(values: unitsSold)
    }

    func setChart(values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 1), y: values[i])//(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSets: [chartDataSet])//(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        
        // delete decription
        barChartView.chartDescription?.text = ""
        
        // change color of the bar chart
        //chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        // To change the position of the x-axis labels
        barChartView.xAxis.labelPosition = .bottom
        
        // change the chart’s background color
        //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        // animation
        //barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setChart2(values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSets: [pieChartDataSet])//(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        // delete decription
        pieChartView.chartDescription?.text = ""
        
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(dataSets: [lineChartDataSet])//(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        // delete decription
        lineChartView.chartDescription?.text = ""
        
        // To change the position of the x-axis labels
        lineChartView.xAxis.labelPosition = .bottom
        
        // animation
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    @IBAction func changeChart(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            scrollView.isHidden = false
            barChartView.isHidden = true
            
            setChart2(values: unitsSold)
        } else {
            scrollView.isHidden = true
            barChartView.isHidden = false
        }
    }
}
