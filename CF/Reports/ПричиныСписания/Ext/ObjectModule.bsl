﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек.Настройки,
		"ИспользоватьПрименениеЦен",
		ПолучитьФункциональнуюОпцию("ИспользоватьПрименениеЦен"));
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек.Настройки,
		"ИспользоватьАссортимент",
		ПолучитьФункциональнуюОпцию("УстанавливатьВидыЦенВАссортименте"));
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
