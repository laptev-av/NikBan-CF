﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.БанковскийКредит Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("БанкКредитор");
		МассивНепроверяемыхРеквизитов.Добавить("ПроцентБанковскойКомиссии");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Обработчик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.БанковскийКредит Тогда
			БанкКредитор = Справочники.Контрагенты.ПустаяСсылка();
			ПроцентБанковскойКомиссии = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
