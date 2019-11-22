﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	НастройкиФормированияОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ЗначениеПараметраПериод = НастройкиФормированияОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметраПериод <> Неопределено Тогда
		ЗначениеПараметраКонецПериодаИзПериода = ЗначениеПараметраПериод.Значение.ДатаОкончания;
		ЗначениеПараметраКонецПериода = НастройкиФормированияОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
		Если ЗначениеПараметраКонецПериода = Неопределено Тогда

			Текст = НСтр("ru = 'Задайте период отчета'"); 
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				"",
				"" ,
				,
				Отказ
			);
			Возврат;
		КонецЕсли;
		
		НеобходимоОбновитьНастройки = Ложь;
		
		Если НЕ ЗначениеПараметраКонецПериода.Использование Тогда
			ЗначениеПараметраКонецПериода.Использование = Истина;
			НеобходимоОбновитьНастройки = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Дата(ЗначениеПараметраКонецПериодаИзПериода)) ИЛИ НЕ ЗначениеЗаполнено(Дата(ЗначениеПараметраКонецПериода.Значение)) Тогда
			ДатаОкончания = КонецДня(ТекущаяДатаСеанса());
			НеобходимоОбновитьНастройки = Истина;
			ЗначениеПараметраПериод.Значение.ДатаОкончания = ДатаОкончания;
			НастройкиФормированияОтчета.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"), ДатаОкончания);
			КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиФормированияОтчета);
			КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
		КонецЕсли;
		
		Если НеобходимоОбновитьНастройки Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиФормированияОтчета);
			КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
