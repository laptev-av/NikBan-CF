﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Наименование");
	Поля.Добавить("ТребуетсяЗагрузка");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.ТребуетсяЗагрузка = Истина Тогда
		СтандартнаяОбработка = Ложь;
		Представление = НСтр("ru = '<не загружено>'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

