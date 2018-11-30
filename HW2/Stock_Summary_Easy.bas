Attribute VB_Name = "Module1"
Sub Stock_Summary_Easy()
    
    Dim Stock_Index As Integer
    Dim Rng_Ticker, Rng_Vol As Range
     
    With ActiveSheet
        
         'Summary Column Name
        .Range("I1").Value = "Ticker"
        .Range("J1").Value = "Total Stock Volume"
         
         'Copy ticker without duplicate
        .Range("A2", .Range("A2").End(xlDown)).Copy Destination:=.Range("I2")
        .Range("I2", .Range("I2").End(xlDown)).RemoveDuplicates Columns:=1, Header:=xlNo
        
        lastStockRow = .Range("I" & .Rows.Count).End(xlUp).Row
        lastDataRow = .Range("A" & .Rows.Count).End(xlUp).Row
        
        'Aggregate total volume
        Set Rng_Ticker = .Range("A2:A" & lastDataRow)
        Set Rng_Vol = .Range("G2:G" & lastDataRow)
    
        For Stock_Index = 2 To lastStockRow
        
            .Cells(Stock_Index, 10).Value = Application.WorksheetFunction.SumIfs(Rng_Vol, Rng_Ticker, Cells(Stock_Index, 9).Value)
        
        Next Stock_Index
        
    End With
    
End Sub


