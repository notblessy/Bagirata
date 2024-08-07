//
//  InterstitialAdsView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 06/08/24.
//

import Foundation
import GoogleMobileAds

class InterstisialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
    // Properties
   @Published var interstisialAdLoaded:Bool = false
    var interstisialAd:GADInterstitialAd?
    
    override init() {
        super.init()
    }
    
    // Load InterstisialAd
    func loadInterstisialAd(){
//        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()) { [weak self] add, error in
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8857414531432199/1481715708", request: GADRequest()) { [weak self] add, error in
            
            guard let self = self else {return}
            if let error = error{
                print("🔴: \(error.localizedDescription)")
                self.interstisialAdLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.interstisialAdLoaded = true
            self.interstisialAd = add
            self.interstisialAd?.fullScreenContentDelegate = self
        }
    }
    
    // Display InterstitialAd
    func displayInterstisialAd(){
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        if let add = interstisialAd{
            add.present(fromRootViewController: root)
            self.interstisialAdLoaded = false
        }else{
            print("🔵: Ad wasn't ready")
            self.interstisialAdLoaded = false
            self.loadInterstisialAd()
        }
    }
    
    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🟡: Failed to display interstitial ad")
        self.loadInterstisialAd()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🤩: Displayed an interstitial ad")
        self.interstisialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("😔: Interstitial ad closed")
    }
}
