//
//  SceneDelegate.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let windowScene = (scene as? UIWindowScene) else { return }

        guard let _ = (scene as? UIWindowScene) else { return }
////        // 미리 선언되어있던 window 프로퍼티에 휴대폰의 크기를 가져와 window를 생성해 할당해줍니다.
////        window = UIWindow(frame: UIScreen.main.bounds)
////
////        // window의 루트뷰에 실제로 앱 실행 시에 보여질 ViewController를 NavigationController의 루트뷰로 넣어줍니다.
////        window?.rootViewController = LoginVC()
////
////        // 이 window가 실제로 보이도록 설정해줍니다.
////        window?.makeKeyAndVisible()
////
////        // 우리가 만든 윈도우씬을 실제 윈도우 씬에 넣어줍니다.
////        window?.windowScene = windowScene
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//               window?.windowScene = windowScene
//               window?.rootViewController = LoginVC()
//               window?.makeKeyAndVisible()
//
//        guard let _ = (scene as? UIWindowScene) else { return }
//
//        let vc = LoginVC()
//        if let windowScene = scene as? UIWindowScene {
//            self.window = UIWindow(windowScene: windowScene)
//            self.window?.rootViewController = vc
//            self.window?.makeKeyAndVisible()
            
        
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
