VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ModRegis 
   Caption         =   "Modificar Registro"
   ClientHeight    =   6120
   ClientLeft      =   108
   ClientTop       =   456
   ClientWidth     =   6948
   OleObjectBlob   =   "ModRegis.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ModRegis"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private genero As String, fator As Integer, resultadoTMB As Double
Public name As String, indexLine

Private Sub UserForm_Activate()
    Sheets(name).Select
    
    'pega os valores para os campos de dados
    txtNome.Value = Me.name
    txtNome.Enabled = False
    txtPeso.Value = Cells(Me.indexLine, 2).Value
    txtAltura.Value = Cells(Me.indexLine, 3).Value
    txtIdade.Value = Cells(Me.indexLine, 4).Value
    
    'insere os valores do listbox (cbFatores)
    cbFatores.AddItem "Sedent�rio"
    cbFatores.AddItem "Levemente ativo"
    cbFatores.AddItem "Moderadamente ativo"
    cbFatores.AddItem "Altamente ativo"
    cbFatores.AddItem "Extremamente ativo"
    
    For i = 2 To Range("A1").End(xlDown).Row
        If Me.name = Cells(i, 1).Value Then
            cbFatores.ListIndex = Utils.StrFactorToInteger(Cells(i, 6).Value)
            fator = Utils.StrFactorToInteger(Cells(i, 6).Value)
            Exit For
        End If
    Next i
    
    'insere os valores dos OptionButtons (opBtn)
    For i = 2 To Range("A1").End(xlDown).Row
        If Me.name = Cells(i, 1).Value Then
            If Cells(i, 5).Value = "Mulher" Then
                optBtnMulher.Value = True
                genero = "Mulher"
            Else
                optBtnHomem.Value = True
                genero = "Homem"
            End If
            Exit For
        End If
    Next i
End Sub

Private Sub btnSlvAlt_Click()
    Call checkFielsIsNotEmpty
    Call ModRegis
    Menu.fullUpdateListBox
    Unload Me 'fecha o userforme
End Sub

Sub ModRegis()
    Sheets(Me.name).Select
    
    nomeInicial = Me.name
    resultadoTMB = MathFun.calcTMB(txtNome.Value, CDbl(txtPeso.Value), CInt(txtAltura.Value), CInt(txtIdade.Value), genero, False)
    
    Cells(indexLine, 1).Value = txtNome.Value
    Cells(indexLine, 2).Value = txtPeso.Value
    Cells(indexLine, 3).Value = txtAltura.Value
    Cells(indexLine, 4).Value = txtIdade.Value
    If optBtnHomem.Value = "Verdadeiro" Then
        Cells(indexLine, 5).Value = "Homem"
    Else
        Cells(indexLine, 5).Value = "Mulher"
    End If
    Cells(indexLine, 6).Value = intFactorToString(cbFatores.ListIndex)
    Cells(indexLine, 7).Value = resultadoTMB
    Cells(indexLine, 8).Value = MathFun.calcGET(resultadoTMB, cbFatores.ListIndex)
    
    
    'For i = 2 To Range("A1").End(xlDown).Row
    '    If nomeInicial = Cells(i, 1).Value Then
    '        For j = 1 To 8
    '            Select Case j
    '                Case 1
    '                    Cells(i, j).Value = txtNome.Value
    '                Case 2
    '                    Cells(i, j).Value = txtPeso.Value
    '                Case 3
    '                    Cells(i, j).Value = txtAltura.Value
    '                Case 4
    '                    Cells(i, j).Value = txtIdade.Value
    '                Case 5
    '                    If optBtnHomem.Value = "Verdadeiro" Then
    '                        Cells(i, j).Value = "Homem"
    '                    Else
    '                        Cells(i, j).Value = "Mulher"
    '                    End If
    '                Case 6
    '                    Cells(i, j).Value = intFactorToString(cbFatores.ListIndex)
    '                Case 7
    '                    Cells(i, j).Value = resultadoTMB
    '                Case 8
    '                    Cells(i, j).Value = MathFun.calcGET(resultadoTMB, fator)
    '            End Select
    '        Next j
    '        Exit For
    '    End If
    'Next i
End Sub

Private Sub checkFielsIsNotEmpty()
    Dim nome As String
    Dim doubleTxtPeso As Double
    Dim intTxtAltura As Integer
    Dim intTxtIdade As Integer
    Dim genero As String
    Dim calc1918 As Boolean
    
    'verifica se o nome foi preenchido
    If txtNome.Value = "" Then
        MsgBox "Insira um nome"
        Exit Sub
    End If
    
    On Error Resume Next 'cancela o tratamento de excecoes
    'trata o erro caso insiram uma letra ao inves de um numero
    doubleTxtPeso = CDbl(txtPeso.Value)
    intTxtAltura = CDbl(txtAltura.Value)
    intTxtIdade = CInt(txtIdade.Value)
    
    If Err.Number <> 0 Then
        MsgBox "Campos inv�lidos ou vazios"
        Exit Sub
    End If
    Err.Clear
    On Error GoTo 0 'retoma o tramento normal de excecoes
    
    'verifica se o genero foi selecionado; true para homem e false para mulher
    If optBtnHomem.Value = "Verdadeiro" Then
        genero = "Homem"
        ElseIf optBtnMulher.Value = "Verdadeiro" Then
        genero = "Mulher"
        Else
        MsgBox "Selecione um g�nero"
    End If
End Sub
