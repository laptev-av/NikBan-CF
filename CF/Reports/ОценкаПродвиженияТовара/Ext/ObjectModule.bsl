﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПеременныеМодуля

Перем КоличествоПериодовДоАкции;

Перем КоличествоПериодовАкции;

Перем КоличествоПериодовПослеАкции;

Перем КоличествоСекундВДне;

Перем ОписаниеПериодаПриведения;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	НачалоПериода  = '0001-01-01';
	КонецПериода = '0001-01-01';
	ЗначенияПользовательскогоПараметраПериод      = МаркетинговыеАкцииСервер.НастройкаПараметра(КомпоновщикНастроек, "Период");
	ЗначенияПользовательскогоПараметраПериодАкция = МаркетинговыеАкцииСервер.НастройкаПараметра(КомпоновщикНастроек, "ПериодАкции");
	
	Если ЗначенияПользовательскогоПараметраПериод <> Неопределено Тогда
		НачалоПериода = ЗначенияПользовательскогоПараметраПериод.Значение.ДатаНачала;
		КонецПериода  = ЗначенияПользовательскогоПараметраПериод.Значение.ДатаОкончания;
		
		Если ЗначениеПараметраНачалоПериода <> Неопределено Тогда
			ЗначениеПараметраНачалоПериода.Значение = НачалоПериода;
			ЗначениеПараметраНачалоПериода.Использование = Истина;
		КонецЕсли;
		
		Если ЗначениеПараметраКонецПериода <> Неопределено Тогда
			ЗначениеПараметраКонецПериода.Значение = КонецПериода;
			ЗначениеПараметраКонецПериода.Использование = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если НачалоПериода  = '0001-01-01' Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если КонецПериода  = '0001-01-01' Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ЗначенияПользовательскогоПараметраПериодАкция <> Неопределено Тогда
		ДатаНачалаАкции = ЗначенияПользовательскогоПараметраПериодАкция.Значение.ДатаНачала;
		ДатаКонцаАкции  = ЗначенияПользовательскогоПараметраПериодАкция.Значение.ДатаОкончания;
	КонецЕсли; 
	
	ДатаНачалаАкции = Макс(ДатаНачалаАкции,НачалоПериода);
	ДатаКонцаАкции  = ?(КонецПериода = '0001-01-01', КонецПериода,Мин(КонецПериода,ДатаКонцаАкции));;
	
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодНачалаАкции"));
	ЗначениеПараметраКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодОкончанияАкции"));
	ЗначениеПараметраПустаяДата = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПустаяДата"));
	
	Если ЗначениеПараметраНачалоПериода <> Неопределено Тогда
		ЗначениеПараметраНачалоПериода.Значение = ДатаНачалаАкции;
		ЗначениеПараметраНачалоПериода.Использование = Истина;
	КонецЕсли;
	
	ДатаКонцаАкцииВОтчет = ?(ДатаКонцаАкции = '0001-01-01',ДатаКонцаАкции,КонецДня(ДатаКонцаАкции));
	Если ЗначениеПараметраКонецПериода <> Неопределено Тогда
		ЗначениеПараметраКонецПериода.Значение = ДатаКонцаАкцииВОтчет;
		ЗначениеПараметраКонецПериода.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеПараметраПустаяДата <> Неопределено Тогда
		ЗначениеПараметраПустаяДата.Значение = '0001-01-01';
		ЗначениеПараметраПустаяДата.Использование = Истина;
	КонецЕсли;
	
	СтруктураДат = Новый Структура;
	СтруктураДат.Вставить("НачалоПериода", НачалоПериода);
	СтруктураДат.Вставить("КонецПериода", КонецПериода);
	СтруктураДат.Вставить("ДатаНачалаАкции", ДатаНачалаАкции);
	СтруктураДат.Вставить("ДатаКонцаАкции", ДатаКонцаАкции);
	СтруктураДат.Вставить("Интервал", Интервал);
	МаркетинговыеАкцииСервер.РасчетКоличестваПериодов(
		СтруктураДат,
		КоличествоПериодовДоАкции,
		КоличествоПериодовАкции,
		КоличествоПериодовПослеАкции,
		ОписаниеПериодаПриведения);
	
	Если КоличествоПериодовДоАкции <= 0 Тогда
		КоличествоПериодовДоАкции = 1;
	КонецЕсли;
	
	Если КоличествоПериодовАкции <= 0 Тогда
		КоличествоПериодовАкции = 1;
	КонецЕсли;
	
	Если КоличествоПериодовПослеАкции <= 0 Тогда
		КоличествоПериодовПослеАкции = 1;
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КоличествоПериодовДоАкции"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = КоличествоПериодовДоАкции;
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КоличествоПериодовАкции"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = КоличествоПериодовАкции;
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КоличествоПериодовПослеАкции"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = КоличествоПериодовПослеАкции;
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;

	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОписаниеПериодаПриведения"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Значение = ОписаниеПериодаПриведения;
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
	МаркетинговыеАкцииСервер.ПроставитьПериодВОтчетПоДиаграмме(СхемаКомпоновкиДанных, Интервал);
	
	ПараметрЗаголовка = КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Title"));
	
	Если Диаграмма Тогда
		
		ПараметрЗаголовка.Значение = НСтр("ru = 'Оценка продвижения товара'") + " "
			+ "(" + МаркетинговыеАкцииСервер.ПолучитьОписаниеИнтервалаДиаграммы(Интервал) +")";
		
	Иначе
		
		ПараметрЗаголовка.Значение = НСтр("ru = 'Оценка продвижения товара'") + " " + ОписаниеПериодаПриведения;
		
	КонецЕсли;
	
	ПараметрЗаголовка.Использование = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ЗначенияПользовательскогоПараметраПериод      = МаркетинговыеАкцииСервер.НастройкаПараметра(КомпоновщикНастроек, "Период");
	
	НачалоПериода  = Неопределено;
	КонецПериода = Неопределено;
	
	Если ЗначенияПользовательскогоПараметраПериод <> Неопределено Тогда
		НачалоПериода = ЗначенияПользовательскогоПараметраПериод.Значение.ДатаНачала;
		КонецПериода  = ЗначенияПользовательскогоПараметраПериод.Значение.ДатаОкончания;
	КонецЕсли;
	
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		Текст = НСтр("ru = 'Обязательно заполните дату начала периода'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"КомпоновщикНастроек.ПользовательскиеНастройки",
			,
			Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		Текст = НСтр("ru = 'Обязательно заполните дату окончания периода'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"КомпоновщикНастроек.ПользовательскиеНастройки",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияМодуля

КоличествоСекундВДне = 60*60*24;

#КонецОбласти

#КонецЕсли
