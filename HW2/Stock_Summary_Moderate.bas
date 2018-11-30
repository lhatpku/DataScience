Attribute VB_Name = "Module2"
Sub Stock_Summary_Moderate()
    
    Dim Stock_Index As Integer
    Dim Rng_Ticker, Rng_Vol, Rng_Date, Rng_Open, Rng_Close As Range
     
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
        Set Rng_Date = .Range("B2:B" & lastDataRow)
        Set Rng_Open = .Range("C2:C" & lastDataRow)
        Set Rng_Close = .Range("F2:F" & lastDataRow)
        
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
        
        .Range("M2:M" & lastDataRow).Clear
        .Range("N2:N" & lastDataRow).Clear
        
    End With
    
End Sub
