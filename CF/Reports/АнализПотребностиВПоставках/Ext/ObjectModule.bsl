﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ДатаРасчета", ТекущаяДатаСеанса());
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ИспользоватьПрименениеЦен", ПолучитьФункциональнуюОпцию("ИспользоватьПрименениеЦен"));
	
	АссортиментСервер.ПроверитьНеобходимостьПереопределенияИВывестиОтчет(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
