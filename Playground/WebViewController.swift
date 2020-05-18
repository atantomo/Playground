//
//  WebViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2019/01/04.
//  Copyright © 2019年 Andrew Tantomo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var changeCSSButton: UIButton!

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
//        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
//        print(config.websiteDataStore.isPersistent)
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    var fontsize = 72
    var cssrule : String {
        let script = """
        var s = document.createElement('style');
        s.textContent = 'body { font-size: \(fontsize)px; }';
        document.documentElement.appendChild(s);
        """
        return script
    }

//    var scrapingScript: String {
//        let script = """
//        var h1s = document.getElementsByTagName("h1");
//        alert(h1s[0].textContent);
//        """
//        return script
//    }

    var scrapingScript: String {
        let script = """
        var elements = document.getElementsByClassName("vi-bin-primary-price__main-price");
        var trimmedContent = elements[0].textContent.trim();

        const regex = /\\$.*[0-9\\.]*/g;
        const found = trimmedContent.match(regex);
        alert(found[0]);
        if (found[0]) {
        const amountRegex = /(\\d).*/g;
        const amountFound = found[0].match(amountRegex);
        var amountFloat = amountFound[0].replace(/[,]*/g, "");
        var result = parseFloat(amountFloat)

        alert(result);
        }
        """
        return script
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addWebView(webView: webView)

        webView.uiDelegate = self
        print(("BLABLABLA", webView))
        communicatingIntoWebPage()

//        URLSession.shared.reset {}
//        UserDefaults.standard.synchronize()
//
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            print("AAAAAAAAAAAAAAAAAAAA")
            for record in records {
                print((record, record.displayName, record.dataTypes))
            }
//            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {})
        }


        let url = URL(string: "https://www.ebay.com/itm/5-Charitable-Donation-For-Delivering-Critical-Blood-to-Those-in-Need/133366892539?_trkparms=%26rpp_cid%3D5e73a6708361a24eb9ad6d93%26rpp_icid%3D5e73a6708361a24eb9ad6d92&_trkparms=pageci%3A10e7a187-9596-11ea-9f61-74dbd180f9a5%7Cparentrq%3A114e2a6f1720acc1a8d906d0ffa0e3e5%7Ciid%3A1")!
//        let url = URL(string: "https://www.w3schools.com/js/js_htmldom_elements.asp")!
//        let url = URL(string: "https://www.ebay.com/")!
//        let url = URL(string: "https://www.booking.com/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func communicatingIntoWebPage() {
        let script = WKUserScript(source: cssrule,
                                  injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let config = webView.configuration
        config.userContentController.addUserScript(script)
    }

    @IBAction func changeCSSButtonTapped(_ sender: Any) {
        fontsize -= 1
        if fontsize < 10 {
            fontsize = 20
        }
        webView.evaluateJavaScript(cssrule)
    }

    @IBAction func scraperButtonTapped(_ sender: Any) {
        webView.evaluateJavaScript(scrapingScript)
    }

    private func addWebView(webView: WKWebView) {
        view.insertSubview(webView, belowSubview: changeCSSButton)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

}

extension WebViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let host = frame.request.url?.host
        let alert = UIAlertController(title: host, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })
        self.present(alert, animated:true)
    }
}
