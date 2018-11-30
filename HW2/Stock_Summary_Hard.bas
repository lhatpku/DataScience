Attribute VB_Name = "Module3"
Sub Stock_Summary_Hard()
    
    Dim Stock_Index As Integer
    Dim Rng_Ticker, Rng_Vol, Rng_Sum_Vol, Rng_Sum_Percent, Rng_Sum_Ticker As Range
     
    With ActiveSheet
        
         'Summary Column Name
        .Range("I1").Value = "Ticker"
        .Range("J1").Value = "Yearly Change"
        .Range("K1").Value = "Percent Change"
        .Range("L1").Value = "Total Stock Volume"
         
         'Copy ticker without duplicate
        .Range("A2", .Range("A2").End(xlDown)).Copy Destination:=.Range("I2")
        .Range("I2", .Range("I2").End(xlDown)).RemoveDuplicates Columns:=1, Header:=xlNo
        
        lastStockRow = .Range("I" & .Rows.Count).End(xlUp).Row
        lastDataRow = .Range("A" & .Rows.Count).End(xlUp).Row
        
        'Aggregate total volume
        Set Rng_Ticker = .Range("A2:A" & lastDataRow)
        Set Rng_Vol = .Range("G2:G" & lastDataRow)
        
        For Stock_Index = 2 To lastStockRow
                    
             'The Year-end Close Price
            .Cells(Stock_Index, 13).FormulaArray = "=index(F2:F" & lastDataRow & ",match(max(if(A2:A" & lastDataRow & "=I" & Stock_Index & ",B2:B" & lastDataRow _
            & ",0)),if(A2:A" & lastDataRow & "=I" & Stock_Index & ",B2:B" & lastDataRow & ",0),0))"
             
             'The Year-begin Open Price
             .Cells(Stock_Index, 14).FormulaArray = "= index(C2:C" & lastDataRow & ",match(min(if(A2:A" & lastDataRow & "=I" & Stock_Index & ",B2:B" & lastDataRow _
            & ",99999999)),if(A2:A" & lastDataRow & "=I" & Stock_Index & ",B2:B" & lastDataRow & ",99999999),0))"
            
            'The Yearly Price Change
            .Cells(Stock_Index, 10).Value = .Cells(Stock_Index, 13).Value - .Cells(Stock_Index, 14).Value
            
            If .Cells(Stock_Index, 10).Value > 0 Then
                .Cells(Stock_Index, 10).Interior.Color = RGB(0, 255, 0)
            ElseIf .Cells(Stock_Index, 10).Value < 0 Then
                .Cells(Stock_Index, 10).Interior.Color = RGB(255, 0, 0)
            End If
            
            'The Yearly Price Change Percent
            If .Cells(Stock_Index, 14).Value = 0 Then
                .Cells(Stock_Index, 11).Value = 0
            Else
                .Cells(Stock_Index, 11).Value = (.Cells(Stock_Index, 13).Value - .Cells(Stock_Index, 14).Value) / .Cells(Stock_Index, 14).Value
            End If
            
            .Cells(Stock_Index, 11).NumberFormat = "0.00%"
            
            'The Yearly Total Volume
            .Cells(Stock_Index, 12).Value = Application.WorksheetFunction.SumIfs(Rng_Vol, Rng_Ticker, Cells(Stock_Index, 9).Value)
        
        Next Stock_Index
        
        'Clear extra outputs
        .Range("M2:M" & lastStockRow).Clear
        .Range("N2:N" & lastStockRow).Clear
        
        'Extra Summary - column name
        .Cells(2, 15).Value = "Greatest % Increase"
        .Cells(3, 15).Value = "Greatest % Decrease"
        .Cells(4, 15).Value = "Greatest Total Volume"
        .Cells(1, 16).Value = "Ticker"
        .Cells(1, 17).Value = "Value"
        
        'Extra Summary - Range with summarized data
        Set Rng_Sum_Percent = .Range("K2:K" & lastStockRow)
        Set Rng_Sum_Vol = .Range("L2:L" & lastStockRow)
        Set Rng_Sum_Ticker = .Range("I2:I" & lastStockRow)
        
        'Extra Summary - Value Outputs
        
        .Cells(2, 16).Value = Application.WorksheetFunction.Index(Rng_Sum_Ticker, Application.WorksheetFunction.Match(Application.WorksheetFunction.Max(Rng_Sum_Percent), Rng_Sum_Percent, 0))
        .Cells(2, 17).Value = Application.WorksheetFunction.Index(Rng_Sum_Percent, Application.WorksheetFunction.Match(Application.WorksheetFunction.Max(Rng_Sum_Percent), Rng_Sum_Percent, 0))
        .Cells(2, 17).NumberFormat = "0.00%"
            
        .Cells(3, 16).Value = Application.WorksheetFunction.Index(Rng_Sum_Ticker, Application.WorksheetFunction.Match(Application.WorksheetFunction.Min(Rng_Sum_Percent), Rng_Sum_Percent, 0))
        .Cells(3, 17).Value = Application.WorksheetFunction.Index(Rng_Sum_Percent, Application.WorksheetFunction.Match(Application.WorksheetFunction.Min(Rng_Sum_Percent), Rng_Sum_Percent, 0))
        .Cells(3, 17).NumberFormat = "0.00%"
            
        .Cells(4, 16).Value = Application.WorksheetFunction.Index(Rng_Sum_Ticker, Application.WorksheetFunction.Match(Application.WorksheetFunction.Max(Rng_Sum_Vol), Rng_Sum_Vol, 0))
        .Cells(4, 17).Value = Application.WorksheetFunction.Index(Rng_Sum_Vol, Application.WorksheetFunction.Match(Application.WorksheetFunction.Max(Rng_Sum_Vol), Rng_Sum_Vol, 0))
        
    End With
    
End Sub

