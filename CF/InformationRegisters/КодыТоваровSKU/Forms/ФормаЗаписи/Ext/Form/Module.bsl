﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсходныйSKU                       = Запись.SKU;
	ВерхняяГраницаДиапазонаSKUВесовогоТовара   = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВерхняяГраницаДиапазонаSKUВесовогоТовара");
	НижняяГраницаДиапазонаSKUВесовогоТовара    = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("НижняяГраницаДиапазонаSKUВесовогоТовара");
	
	Если Параметры.Свойство("ПараметрыСозданияSKU") Тогда
		
		Запись.Номенклатура   = Параметры.ПараметрыСозданияSKU.Номенклатура;
		Запись.Характеристика = Параметры.ПараметрыСозданияSKU.Характеристика;
		Запись.Упаковка       = Параметры.ПараметрыСозданияSKU.Упаковка;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Номенклатура.Весовой Тогда
		
		Если ТекущийОбъект.SKU < НижняяГраницаДиапазонаSKUВесовогоТовара ИЛИ ТекущийОбъект.SKU > ВерхняяГраницаДиапазонаSKUВесовогоТовара Тогда
			
			ТекстСообщения = НСтр("ru='SKU весового товара должен находиться в диапазоне от %1 до %2.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НижняяГраницаДиапазонаSKUВесовогоТовара, ВерхняяГраницаДиапазонаSKUВесовогоТовара);
			Отказ = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Если ТекущийОбъект.SKU <= ВерхняяГраницаДиапазонаSKUВесовогоТовара Тогда
			
			ТекстСообщения = НСтр("ru='SKU невесового товара должен находиться в диапазоне от %1.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВерхняяГраницаДиапазонаSKUВесовогоТовара+1);
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Модифицированность И НЕ ТекущийОбъект.SKU = ИсходныйSKU Тогда
		
		SKUСвободен = РегистрыСведений.КодыТоваровSKU.SKUСвободен(ТекущийОбъект.SKU);
		
		Если НЕ SKUСвободен Тогда
			ТекстСообщения = НСтр("ru = 'Выбранный SKU занят, перемещение невозможно'");
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;

	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"SKU", "Запись");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	БылаЗапись = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если БылаЗапись Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрЗакрытия = Новый Структура;
		ПараметрЗакрытия.Вставить("КодТовараSKU", Запись.SKU);
		Закрыть(ПараметрЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
