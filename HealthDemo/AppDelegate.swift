//
//  AppDelegate.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var coodinator:Coordinator!
    var health:HealthKitManager?
    var coreDataManager:CoreDataDBManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        coreDataManager = .init(persistentContainer: persistentContainer)

        DispatchQueue(label: "db", qos: .userInitiated).async {
            let db = self.coreDataManager?.fetch(.general)?.data?.toDict
            DataBase.dbHolder = db
        }
        health = .init(delegate: self)
        coodinator = .init()
        window?.rootViewController = UINavigationController(rootViewController: coodinator.start())
        window?.tintColor = K.Colors.link
        return true
    }


    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if !(health?.progrecing ?? false) {
            health?.read.all {
                DispatchQueue.main.async {
                    self.fetchComplited(self.health?.read.results ?? .init(dict: [:]))
                }
            }
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HealthDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
           //     fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
           //     fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate: HealthKitManagerProtocol {
    func progressUpdated(_ progress: CGFloat) {
//        if let vc = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first(where: {$0 is LoadingViewController}) as? LoadingViewController {
//            vc.updateProgress(progress)
//        }
    }
    
    func fetchComplited(_ result: ReadHealthData.ResultData) {
        if let nav = self.window?.rootViewController as? UINavigationController {
            
            nav.viewControllers.forEach {
                if let tabbar = $0 as? TabBarController {
                    tabbar.viewControllers?.forEach({
                        let vc = $0 as? BaseVC
                        vc?.healthUpdated()
                    })
                    let vc = $0 as? BaseVC
                    vc?.healthUpdated()
                } else if let vc = $0 as? MessageViewController,
                          health?.requestingAccess ?? false
                {
                    let newVC = coodinator.start()
                    if let vc = newVC as? MessageViewController {
                        vc.view.animatedTransition(type:.moveIn)
                        vc.messageType = .healphError
                    } else {
                        
                        self.health?.requestingAccess = false
                        let nav = UINavigationController(rootViewController: newVC)
                        vc.navigationController?.view.removeWithAnimation(animation:Styles.launchAnimation1, complation: {
                            self.window?.animatedTransition(Styles.launchAnimation2, type:.fade)
                            vc.navigationController?.removeFromParent()
                            self.window?.rootViewController = nav
                        })
                        
                    }

                }
                

            }

        }
    }
    
    
}
