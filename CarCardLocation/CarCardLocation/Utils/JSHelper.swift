//
//  JSHelper.swift
//  rng
//
//  Created by liujianlin on 2017/8/16.
//  Copyright © 2017年 mikazuki. All rights reserved.
//

import JavaScriptCore
import Alamofire
import ObjectMapper
import UIKit

class JSHelper {
    
    enum JSFuncType: String, CaseCountable {
        case getAreas="getAreas", getGasStations="getGasStations"
    }
    
    static let shared = JSHelper()
    private var baseUrl = ""
    private var alamofireManager: SessionManager?
    private var jsFnDict = [JSFuncType: JSValue?]()
    
    private init() {
        initJSFile()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        alamofireManager = SessionManager.init(configuration: configuration)
    }
    private var jsContext: JSContext?
    
    //加载解析方法
    private func initJSFile() {
        let webView = UIWebView()
        webView.loadHTMLString("<html></html>", baseURL: nil)
        jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.exceptionHandler = { (context, error) in
            guard let err = error?.toString() else { return }
            print(err)
        }
        let logFunction : @convention(block) (String) -> Void = { (msg: String) in
            print(msg)
        }
        jsContext?.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, to: AnyObject.self),
                                                                forKeyedSubscript: "log" as NSCopying & NSObjectProtocol)
        
        
        let jsURL = URL(fileURLWithPath: Bundle.main.path(forResource: "app_inject", ofType: "js")!)
        guard let js = try? String(contentsOf: jsURL) else { return }
        _ = jsContext?.evaluateScript(js)
        baseUrl = jsContext?.evaluateScript("baseUrl").toString() ?? "http://market.cmbchina.com/ccard/2012car/"
        JSFuncType.allType.forEach { (type) in
            jsFnDict[type] = jsContext?.objectForKeyedSubscript(type.rawValue)
        }
    }
    
    //获取加油站点
    func getCurrentGasStations(inView view: UIView?, success: @escaping (([GasStationModel])->Void)) {
        guard let link = GasStationManager.shared.currentCity?.link else {
            HudUtils.shared.show(with: "请先选择城市")
            return
        }
        request(withUrl: link, inView: view, fnType: .getGasStations, success: { (json) in
            if let data = json.data(using: .utf8),
                let models = try? JSONDecoder().decode([GasStationModel].self, from: data) {
                success(models)
            }
        }) {
        }
    }
    
    //获取区域城市
    func getAreas(inView view: UIView?, success: @escaping (([AreaModel])->Void), finally: (()->Void)?) {
        request(withUrl: baseUrl, inView: view, fnType: .getAreas, success: { (json) in
            if let data = json.data(using: .utf8),
                let models = try? JSONDecoder().decode([AreaModel].self, from: data) {
                success(models)
            }
            finally?()
        }) {
            finally?()
        }
    }
    
    //请求
    private func request(withUrl url: String, inView view: UIView?, fnType: JSFuncType, success: @escaping ((String)->Void), failure: (()->Void)?) {
        if let view = view {
            HudUtils.shared.show(inView: view)
        }
        alamofireManager?.request(url).responseData { [weak self](response) in
            func showFail(withView view: UIView?, msg: String) {
                if let view = view {
                    HudUtils.shared.hideAll(for: view)
                }
                HudUtils.shared.show(with: msg)
            }
            if let error = response.result.error {
                showFail(withView: view, msg: error.localizedDescription)
                failure?()
                return
            }
            guard let data = response.result.value else {
                showFail(withView: view, msg: "解析失败")
                failure?()
                return
            }
            guard let html = String(data: data, encoding: .utf8) else {
                showFail(withView: view, msg: "解析失败")
                failure?()
                return
            }
            
            guard let result = self?.jsFnDict[fnType]??.call(withArguments: [html]).toString() else {
                showFail(withView: view, msg: "解析失败")
                failure?()
                return
            }
            if result == "undefined" {
                showFail(withView: view, msg: "无法解析")
                failure?()
                return
            }
            if let view = view {
                HudUtils.shared.hideAll(for: view)
            }
            success(result)
        }
    }
}
