//
//  ViewController.swift
//  auto_maker
//
//  Created by Ngo Quang Tinh on 6/28/24.
//

import Cocoa
import AVFoundation // ###

class ConsoleVC: NSViewController, AMProcessorDelegate {
  @IBOutlet weak var _txtProjFilePath: NSTextField!
  @IBOutlet weak var _pgProgress: NSProgressIndicator!
  @IBOutlet weak var _txtLogView: NSScrollView!
  
  private let processor = AMProcessor.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    processor.delegate = self
    test()
  }
  
  func test() {
    processor.projFilePath = URL(fileURLWithPath: "/Users/ngoquangtinh/Desktop/AMProjs.nosync/AMProj.json")
  }
  
  func progress(_ progress: Float) {
    self._pgProgress.doubleValue = Double(progress)
  }
  
  func message(_ message: String) {
    let log = "\(Date.hhmmss()) \(message)\n"
    _txtLogView.documentView?.insertText(log)
    print(log)
  }
  
  @IBAction func importBtnTapped(_ sender: Any) {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    if panel.runModal() == .OK {
      _txtProjFilePath.stringValue = panel.url?.path ?? ""
    }
    
    processor.projFilePath = panel.url
  }
  
  @IBAction func renderBtnTapped(_ sender: Any) {
    _pgProgress.doubleValue = 0
    
    do {
      try processor.process()
    }
    catch {
      let log = "\(Date.hhmmss()) \(error.localizedDescription)\n"
      _txtLogView.documentView?.insertText(log)
    }
  }
}
