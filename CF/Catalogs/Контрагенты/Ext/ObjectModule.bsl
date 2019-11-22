﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Организации") Тогда
		
		Наименование           = ДанныеЗаполнения.Наименование;
		ЮрФизЛицо              = ДанныеЗаполнения.ЮрФизЛицо;
		НаименованиеПолное     = ДанныеЗаполнения.НаименованиеПолное;
		ОсновнойБанковскийСчет = ДанныеЗаполнения.ОсновнойБанковскийСчет;
		ИНН                    = ДанныеЗаполнения.ИНН;
		КПП                    = ДанныеЗаполнения.КПП;
		КодПоОКПО              = ДанныеЗаполнения.КодПоОКПО;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Наименование") Тогда
			Наименование = ДанныеЗаполнения.Наименование;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("НаименованиеПолное") Тогда
			НаименованиеПолное = ДанныеЗаполнения.НаименованиеПолное;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("ИНН") Тогда
			ИНН = ДанныеЗаполнения.ИНН;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("КПП") Тогда
			КПП = ДанныеЗаполнения.КПП;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем ТекстСообщения;
	ЭтоЮрЛицо = ЭтоЮрЛицо(ЮрФизЛицо);
	
	Если Не ЭтоНовый() Тогда
		ЗначенияРеквизитовВИнформационнойБазе = ОбщегоНазначенияРТ.ПолучитьЗначенияРеквизитовОбъекта(Ссылка, Новый Структура("ИНН,КПП,КодПоОКПО,ЮрФизЛицо"));
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда 
		Если (ЭтоНовый() ИЛИ ЗначенияРеквизитовВИнформационнойБазе.ИНН <> ИНН
			ИЛИ ЗначенияРеквизитовВИнформационнойБазе.ЮрФизЛицо <> ЮрФизЛицо)
			И НЕ РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, ЭтоЮрЛицо,ТекстСообщения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ИНН",
				,
				Отказ);
		КонецЕсли;
	Иначе
		Если НЕ ОбщегоНазначенияРТ.УпрощенныйВводДоступен() 
			И (ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель 
			ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указан ИНН'"),
				ЭтотОбъект,
				"ИНН",
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо 
		ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		
		Если НЕ ПустаяСтрока(КПП) 
			И (ЭтоНовый() ИЛИ ЗначенияРеквизитовВИнформационнойБазе.КПП <> КПП)
			И НЕ РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(КПП, ТекстСообщения) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"КПП",
			,
			Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо 
		ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		
		Если НЕ ПустаяСтрока(КодПоОКПО) 
			И (ЭтоНовый() ИЛИ ЗначенияРеквизитовВИнформационнойБазе.КодПоОКПО <> КодПоОКПО)
			И НЕ РегламентированныеДанныеКлиентСервер.КодПоОКПОСоответствуетТребованиям(КодПоОКПО,ЭтоЮрЛицо,ТекстСообщения) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"КодПоОкпо",
				,
				Отказ);
			
		КонецЕсли;
			
	КонецЕсли;

	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		ЗакупкиСервер.ОтразитьПоставщикаТоваровКакДействующего(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// По переданному значению перечисления ЮрФизЛицо определяет, является ли оно признаком ЮрЛица.
//
// Параметры:
//  ЮрФизЛицо  -   Перечисления.ЮрФизЛицо.
// Возвращаемое значение:
//   Булево   - Истина, если юридическое лицо, Ложь если нет.
Функция ЭтоЮрЛицо(ЮрФизЛицо) 

	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
		Возврат Истина;
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо 
			ИЛИ ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецЕсли
