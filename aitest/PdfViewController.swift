//
//  PdfViewController.swift
//  aitest
//
//  Created by Руслан Сидоренко on 30.05.2024.
//

import UIKit
import PDFKit

public var fullText = ""

class PdfViewController: UIViewController, UIDocumentPickerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground

        let loadPdfButton = UIButton(type: .system)
        loadPdfButton.setTitle("Загрузить PDF", for: .normal)
        loadPdfButton.addTarget(self, action: #selector(loadPdfTapped), for: .touchUpInside)
        loadPdfButton.frame = CGRect(x: 18, y: 100, width: 200, height: 50)
        loadPdfButton.backgroundColor = .green
        view.addSubview(loadPdfButton)
        
       
    }
    
    @objc func loadPdfTapped() {
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
        }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            extractTextFromPdf(at: url)
        }
    
    
    func extractTextFromPdf(at url: URL) {
        guard let document = PDFDocument(url: url) else {
            print("Не удалось открыть документ")
            return
        }
        
        for pageIndex in 0..<document.pageCount {
            guard let page = document.page(at: pageIndex) else { continue }
            if let pageContent = page.string {
                        // Убираем переносы строк и лишние пробелы
                let cleanedPageContent = pageContent.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "''", with: " ")
                fullText += cleanedPageContent + " "
            }
        }
        
        print(fullText)
    }
    
}
