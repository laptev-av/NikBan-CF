﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
	мИмяКомпьютера = ИмяКомпьютера();
	#КонецЕсли
	
	ОтборыСписковКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Компьютер", мИмяКомпьютера, Истина);
	
КонецПроцедуры

#КонецОбласти