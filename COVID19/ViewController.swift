//
//  ViewController.swift
//  COVID19
//
//  Created by Jamong on 2023/01/11.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {
	
	@IBOutlet var totalCaseLabel: UILabel!
	@IBOutlet var newCaseLabel: UILabel!
	
	@IBOutlet var indicatorView: UIActivityIndicatorView!
	@IBOutlet var labelStackView: UIStackView!
	@IBOutlet var pieChartView: PieChartView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.indicatorView.startAnimating()
		self.fetchCovidOverview(completionHandler: { [weak self] result in
			guard let self = self else { return }
			self.indicatorView.stopAnimating()
			self.indicatorView.isHidden = true
			self.labelStackView.isHidden = false
			self.pieChartView.isHidden = false
			switch result {
			case let .success(result):
				self.configureStackView(koreaCovidOverview: result.korea)
				let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
				self.configureChatView(covidOverviewList: covidOverviewList)
				
			case let .failure(error):
				debugPrint("error \(error)")
			}
		})
	}
	
	func makeCovidOverviewList(
		cityCovidOverview: CityCovidOverview
	) -> [CovidOverview] {
		return [
			cityCovidOverview.seoul,
			cityCovidOverview.busan,
			cityCovidOverview.daegu,
			cityCovidOverview.incheon,
			cityCovidOverview.gwangju,
			cityCovidOverview.daejeon,
			cityCovidOverview.ulsan,
			cityCovidOverview.sejong,
			cityCovidOverview.gyeonggi,
			cityCovidOverview.chungbuk,
			cityCovidOverview.chungnam,
			cityCovidOverview.gyeongbuk,
			cityCovidOverview.gyeongnam,
			cityCovidOverview.jeju
		]
	}
	
	func configureChatView(covidOverviewList: [CovidOverview]) {
		self.pieChartView.delegate = self
		let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
			guard let self = self else { return nil }
			return PieChartDataEntry(
				value: self.removeFormatString(string: overview.newCase),
				label: overview.countryName,
				data: overview
			)
		}
		let dataSet = PieChartDataSet(entries: entries, label: "????????? ?????? ??????")
		dataSet.sliceSpace = 1
		dataSet.entryLabelColor = .black
		dataSet.valueTextColor = .black
		dataSet.xValuePosition = .outsideSlice
		dataSet.valueLinePart1OffsetPercentage = 0.8
		dataSet.valueLinePart1Length = 0.2
		dataSet.valueLinePart2Length = 0.3

		
		dataSet.colors = ChartColorTemplates.vordiplom() +
		ChartColorTemplates.joyful() +
		ChartColorTemplates.liberty() +
		ChartColorTemplates.pastel() +
		ChartColorTemplates.material()
		
		self.pieChartView.data = PieChartData(dataSet: dataSet)
		self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
	}
	
	func removeFormatString(string: String) -> Double {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter.number(from: string)?.doubleValue ?? 0
	}
	
	func configureStackView(koreaCovidOverview: CovidOverview) {
		self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase) ???"
		self.newCaseLabel.text = "\(koreaCovidOverview.newCase) ???"
	}
	
	func fetchCovidOverview(
		completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
	) {
		let url = "https://api.corona-19.kr/korea/country/new/"
		let param = [
			"serviceKey": "XSLRzO52NmhF4xtZHvouDbUTClPgJrnaf"
		]
		
		AF.request(url, method: .get, parameters: param)
			.responseData(completionHandler: { response in
				switch response.result {
				case let .success(data):
					do {
						let decoder = JSONDecoder()
						let result = try decoder.decode(CityCovidOverview.self, from: data)
						completionHandler(.success(result))
					} catch {
						completionHandler(.failure(error))
					}
					
				case let .failure(error):
					completionHandler(.failure(error))
				}
			})
	}


}

extension ViewController: ChartViewDelegate {
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
		guard let covidOverview = entry.data as? CovidOverview else { return }
		covidDetailViewController.covidOverview = covidOverview
		self.navigationController?.pushViewController(covidDetailViewController, animated: true)
	}
}
