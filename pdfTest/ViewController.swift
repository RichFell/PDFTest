//
//  ViewController.swift
//  pdfTest
//
//  Created by Dave Krawczyk on 2/3/15.
//  Copyright (c) 2015 Mobile Makers Academy. All rights reserved.
//
import UIKit

extension NSDate {
    func addDaysToDateAndReturnNormalString(days: Int)->String {
        let dateComponent = NSDateComponents()
        dateComponent.day = days
        let calendar = NSCalendar.currentCalendar()
        let nextDate = calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.allZeros)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.stringFromDate(nextDate!)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        writeWordOnPDF()
    }
    
    func writeWordOnPDF()
    {
        var localUrl: NSURL = NSBundle.mainBundle().URLForResource("ActionPlan", withExtension: "pdf")!

        var pdfDocumentRef: CGPDFDocumentRef = CGPDFDocumentCreateWithURL(localUrl as CFURLRef)
        
        
        var page1: CGPDFPageRef = CGPDFDocumentGetPage(pdfDocumentRef, 1)
        var page2: CGPDFPageRef = CGPDFDocumentGetPage(pdfDocumentRef, 2)
        var page3: CGPDFPageRef = CGPDFDocumentGetPage(pdfDocumentRef, 3)


        var paperSize = CGRectMake(0.0, 0.0, 792, 612)
        var pageSize = CGPDFPageGetBoxRect(page1, kCGPDFArtBox);
        
       
        var path = NSTemporaryDirectory()
        var temporaryPdfFilePath = path.stringByAppendingPathComponent("actionPlan.pdf")
        println("\(path)")

    
        var graphicsContext = UIGraphicsBeginPDFContextToFile(temporaryPdfFilePath, pageSize, nil)
    
        
        
        UIGraphicsBeginPDFPageWithInfo(paperSize, nil)
        
        let currentContext: CGContextRef = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(currentContext, 0.0, paperSize.height)
        CGContextScaleCTM(currentContext, 1.0, -1.0)

        writeTextOnPageOne("The club is going up on a Tuesday", andTeacherName: "Rich (super Awesome)", andNumberOfStudents: "100,000", andStartDate: "Dec, 23 2100", forCurrentContext: currentContext, andDocumentRef: pdfDocumentRef, andPaperSize: paperSize)

        UIGraphicsBeginPDFPageWithInfo(paperSize, nil)
        CGContextTranslateCTM(currentContext, 0.0, paperSize.height)
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        writeTextOnPageTwo("Some date", forCurrentContext: currentContext, andDocumentRef: pdfDocumentRef, andPaperSize: paperSize)
        UIGraphicsBeginPDFPageWithInfo(paperSize, nil)
        CGContextTranslateCTM(currentContext, 0.0, paperSize.height)
        CGContextScaleCTM(currentContext, 1.0, -1.0)
        writePageThreeText(currentContext, andDocumentRef: pdfDocumentRef, andPaperSize: paperSize)

        UIGraphicsEndPDFContext()
    }

    private func writeTextOnPageOne(schoolName: String, andTeacherName teacherName:String, andNumberOfStudents students: String, andStartDate date: String, forCurrentContext context: CGContextRef, andDocumentRef documentRef: CGPDFDocumentRef, andPaperSize size: CGRect) {

        var page: CGPDFPageRef = CGPDFDocumentGetPage(documentRef, 1)
        CGContextDrawPDFPage(context, page)

        CGContextTranslateCTM(context, 0.0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)

        writeText(schoolName, inRect: CGRectMake(179, 322, 500, 500))
        writeText(teacherName, inRect: CGRectMake(179, 382, 500, 500))
        writeText(students, inRect: CGRectMake(290, 480, 200, 200))
        writeText(date, inRect: CGRectMake(590, 480, 200, 200))
    }

    private func fishOutDateLogic() {
        let date = NSDate()
    }

    private func writeTextOnPageTwo(date: String, forCurrentContext context: CGContextRef, andDocumentRef docRef: CGPDFDocumentRef, andPaperSize size: CGRect) {
        var page : CGPDFPageRef = CGPDFDocumentGetPage(docRef, 2)
        CGContextDrawPDFPage(context, page)

        CGContextTranslateCTM(context, 0.0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)

        let date = NSDate()
        writeDateText(date.addDaysToDateAndReturnNormalString(150), inRect: CGRectMake(75, 160, 200, 200))
        writeDateText(date.addDaysToDateAndReturnNormalString(150), inRect: CGRectMake(75, 250, 200, 200))
        writeDateText(date.addDaysToDateAndReturnNormalString(120), inRect: CGRectMake(75, 330, 200, 200))
        writeDateText(date.addDaysToDateAndReturnNormalString(120), inRect: CGRectMake(75, 450, 200, 200))
        writeDateText(date.addDaysToDateAndReturnNormalString(60), inRect: CGRectMake(75, 520, 200, 200))
    }

    private func writePageThreeText(context: CGContextRef, andDocumentRef docReg: CGPDFDocumentRef, andPaperSize size: CGRect) {
        var page : CGPDFPageRef = CGPDFDocumentGetPage(docReg, 3)
        CGContextDrawPDFPage(context, page)
        CGContextTranslateCTM(context, 0.0, size.height)
        CGContextScaleCTM(context, 1.0, -1.0)

        let date = NSDate()
        writeDateText(date.addDaysToDateAndReturnNormalString(30), inRect: CGRectMake(75, 160, 200, 200))
        writeDateText(date.addDaysToDateAndReturnNormalString(1), inRect: CGRectMake(75, 215, 200, 200))
    }

    private func writeText(text: String, inRect rect: CGRect) {
        let font = UIFont(name: "Courier", size: 16)
        let text: String = text
        let rectText = rect
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        let textColor = UIColor.blackColor()
        let textFontAttributes = [
            NSFontAttributeName : font!,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle,
        ]

        text.drawInRect(rectText, withAttributes: textFontAttributes)
    }

    private func writeDateText(text:String, inRect rect: CGRect) {
        let font = UIFont(name: "Courier", size: 12)
        let text: String = text
        let rectText = rect
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        let textColor = UIColor.blackColor()
        let textFontAttributes = [
            NSFontAttributeName : font!,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle,
        ]

        text.drawInRect(rectText, withAttributes: textFontAttributes)
    }
}

