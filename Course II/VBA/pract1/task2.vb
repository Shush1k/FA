'Вариант 2 Напишите программу диалога с пользователем.
'Вначале появляется окно ввода, в котором ваше имя (значение по умолчанию).
'После обработки полученных данных, на экране должно появиться окно сообщения с текстом приветствия,
'содержащего обращение по имени, введенному ранее.
Sub MAIN()
    Dim username As String
    Dim outstring As String

    username = InputBox("Введите ваше имя", "Ввод данных", "Георгий")
    outstring = "Здравствуйте, " + username + "!"
    MsgBox outstring, , "Вывод данных"
    
End Sub
