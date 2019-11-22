﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаИсправления");
	КонецЕсли;
	
	ДатаНачалаПримененияПостановления1137 = Константы.ДатаНачалаПримененияПостановления1137.Получить();
	Если ДатаСоставления < ДатаНачалаПримененияПостановления1137 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
		МассивНепроверяемыхРеквизитов.Добавить("КодВидаОперации");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПроверитьЗаполнениеДокументовОснований(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект.Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если НЕ Исправление Тогда
		НомерИсправления = "";
		ДатаИсправления  = '00010101';
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьДублиСчетФактуры(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Перем РеквизитыСчетаФактурыОснования, Организация, СчетФактураОснование;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ДанныеЗаполнения = ЗакупкиСервер.ДанныеСчетаФактурыСтруктурой(
			ДанныеЗаполнения.Ссылка,
			ДанныеЗаполнения.Организация,
			ДанныеЗаполнения.Контрагент,
			ДанныеЗаполнения.НомерСчетаФактуры,
			ДанныеЗаполнения.ДатаСчетаФактуры);
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
			
			ДанныеЗаполнения.Свойство("Организация", Организация);
			
			Если ДанныеЗаполнения.Свойство("Исправление") И ДанныеЗаполнения.Исправление Тогда
				// Заполним реквизиты исправления счета-фактуры по реквизитам основания.
				
				Документы.СчетФактураПолученный.СчетаФактурыПоОснованию(
					ДанныеЗаполнения.ДокументОснование,
					Организация,
					РеквизитыСчетаФактурыОснования);
				
					
				СчетФактураОснование = РеквизитыСчетаФактурыОснования.Ссылка;
				
				ДанныеЗаполнения.Вставить("Номер",                              РеквизитыСчетаФактурыОснования.Номер);
				ДанныеЗаполнения.Вставить("ДатаСоставления",                    РеквизитыСчетаФактурыОснования.ДатаСоставления);
				
			КонецЕсли;
			
			ЗаполнитьДокументыОснования(ДанныеЗаполнения.ДокументОснование, СчетФактураОснование);
			ДанныеЗаполнения.Вставить("КодВидаОперации", КодВидаОперации(ДанныеЗаполнения.ДокументОснование));
			
		КонецЕсли;
		
		Если НЕ ДанныеЗаполнения.Свойство("Дата") Тогда
			Если ДанныеЗаполнения.Свойство("ДатаСоставления")
			 И ((НЕ ДанныеЗаполнения.Свойство("Исправление")) ИЛИ (НЕ ДанныеЗаполнения.Исправление)) Тогда
				ДанныеЗаполнения.Вставить("Дата", ДанныеЗаполнения.ДатаСоставления);
			ИначеЕсли ДанныеЗаполнения.Свойство("ДатаИсправления")
			 И ДанныеЗаполнения.Свойство("Исправление") И ДанныеЗаполнения.Исправление Тогда
				ДанныеЗаполнения.Вставить("Дата", ДанныеЗаполнения.ДатаИсправления);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокументыОснования(Основание, СчетФактура = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(СчетФактура) Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ТаблицаОснований.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.СчетФактураПолученный.ДокументыОснования КАК ТаблицаОснований
		|
		|ГДЕ
		|	ТаблицаОснований.Ссылка = &СчетФактура
		|");
		Запрос.УстановитьПараметр("Основание", Основание);
		Запрос.УстановитьПараметр("СчетФактура", СчетФактура);
		
		МассивОснований = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
		Для Каждого ДокументОснование Из МассивОснований Цикл
			НоваяСтрока = ДокументыОснования.Добавить();
			НоваяСтрока.ДокументОснование = ДокументОснование;
		КонецЦикла;
		
	Иначе
		
		НоваяСтрока = ДокументыОснования.Добавить();
		НоваяСтрока.ДокументОснование = Основание;
		
	КонецЕсли;
	
КонецПроцедуры

Функция КодВидаОперации(Основание = Неопределено)
	
	Если (НЕ ЗначениеЗаполнено(Основание)) И ДокументыОснования.Количество() > 0 Тогда
		Основание = ДокументыОснования[0].ДокументОснование;
	КонецЕсли;
	
	КодВидаОперации = "";
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		КодВидаОперации = "03";
	Иначе
		КодВидаОперации = "01";
	КонецЕсли;
	
	Возврат КодВидаОперации;
	
КонецФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ДатаСоставления") Тогда
		ДатаСоставления = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументовОснований(Отказ)
	
	МассивОснований = Новый Массив;
	ЭтоЗакупкаУПоставщика = Неопределено;
	ТипОснования = Неопределено;
	ВалютаОснования = Неопределено;
	
	Для Каждого СтрокаОснование Из ДокументыОснования Цикл
		
		Если ТипЗнч(СтрокаОснование.ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
			Если ЭтоЗакупкаУПоставщика = Неопределено Тогда
				ЭтоЗакупкаУПоставщика = Истина;
			ИначеЕсли НЕ ЭтоЗакупкаУПоставщика Тогда
				СообщитьОбОшибкеТиповОснований(СтрокаОснование.НомерСтроки, Отказ);
			КонецЕсли;
			
		ИначеЕсли ТипОснования = Неопределено Тогда
			ТипОснования = ТипЗнч(СтрокаОснование.ДокументОснование);
			
		ИначеЕсли ТипОснования <> Неопределено И ТипОснования <> ТипЗнч(СтрокаОснование.ДокументОснование) Тогда
			СообщитьОбОшибкеТиповОснований(СтрокаОснование.НомерСтроки, Отказ);
			
		КонецЕсли;
		
		Если МассивОснований.Найти(СтрокаОснование.ДокументОснование) <> Неопределено Тогда
			СообщитьОбОшибкеДублейОснований(СтрокаОснование.НомерСтроки, СтрокаОснование.ДокументОснование, Отказ);
		КонецЕсли;
		
		МассивОснований.Добавить(СтрокаОснование.ДокументОснование);
		
		Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаОснование.ДокументОснование, "Проведен") Тогда
			СообщитьОбОшибкеСостоянияПроведенияОснований(СтрокаОснование.НомерСтроки, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СообщитьОбОшибкеТиповОснований(НомерСтроки, Отказ)
	
	ТекстСообщения = НСтр("ru = 'Запрещено выбирать в качестве оснований документы различных типов.'");
	Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОснования", НомерСтроки, "ДокументОснование");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле,"Объект",Отказ);
	
КонецПроцедуры

Процедура СообщитьОбОшибкеДублейОснований(НомерСтроки, Основание, Отказ)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'В строке %1 в качестве документа-основания повторно указан документ %2.'"),
		НомерСтроки,
		Основание);
	Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОснования", НомерСтроки, "ДокументОснование");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле,"Объект",Отказ);
	
КонецПроцедуры

Процедура СообщитьОбОшибкеСостоянияПроведенияОснований(НомерСтроки, Отказ)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'В строке %1 документ-основание не проведен. Счет-фактуру можно провести только на основании проведенных документов.'"),
		НомерСтроки,);
	Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыОснования", НомерСтроки, "ДокументОснование");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле,"Объект",Отказ);
	
КонецПроцедуры

Процедура ПроверитьДублиСчетФактуры(Отказ)
	
	Если Исправление Тогда
		Возврат;
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОснований.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.Ссылка <> &Ссылка
	|	И ТаблицаОснований.ДокументОснование В(&СписокОснований)
	|	И ТаблицаОснований.Ссылка.Проведен
	|	И (ТаблицаОснований.Ссылка.Организация = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (НЕ ТаблицаОснований.Ссылка.Исправление)
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("СписокОснований", ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для документа %1 по организации %2 уже введен счет-фактура'"),
			Выборка.ДокументОснование,
			Организация);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"ДокументыОснования",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
