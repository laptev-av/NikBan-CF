﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Если ДокументСсылка.ДляВсехМагазинов ИЛИ НЕ ДокументСсылка.ДляВсехМагазиновОдноПоложение Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка КАК Ссылка,
		|	ПоложениеОПремированииПравилаРасчетаПремий.НомерСтроки КАК НомерСтроки,
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка.ДатаНачалаДействия КАК ПЕРИОД,
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка.ДатаОкончанияДействия КАК ДатаОкончания,
		|	ПоложениеОПремированииПравилаРасчетаПремий.Магазин КАК Магазин,
		|	ПоложениеОПремированииПравилаРасчетаПремий.ПравилоРасчетаПремий КАК ПравилоРасчетаПремий
		|ИЗ
		|	Документ.ПоложениеОПремировании.ПравилаРасчетаПремий КАК ПоложениеОПремированииПравилаРасчетаПремий
		|ГДЕ
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка = &Ссылка
		|";
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка КАК Ссылка,
		|	ПоложениеОПремированииПравилаРасчетаПремий.НомерСтроки КАК НомерСтроки,
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка.ДатаНачалаДействия КАК ПЕРИОД,
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка.ДатаОкончанияДействия КАК ДатаОкончания,
		|	ПоложениеОПремированииПравилаРасчетаПремий.ПравилоРасчетаПремий КАК ПравилоРасчетаПремий
		|ПОМЕСТИТЬ ТаблицаПравилаРасчетаПремий
		|ИЗ
		|	Документ.ПоложениеОПремировании.ПравилаРасчетаПремий КАК ПоложениеОПремированииПравилаРасчетаПремий
		|ГДЕ
		|	ПоложениеОПремированииПравилаРасчетаПремий.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоложениеОПремированииМагазины.Ссылка,
		|	ПоложениеОПремированииМагазины.Магазин
		|ПОМЕСТИТЬ ТаблицаМагазины
		|ИЗ
		|	Документ.ПоложениеОПремировании.Магазины КАК ПоложениеОПремированииМагазины
		|ГДЕ
		|	ПоложениеОПремированииМагазины.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ТаблицаМагазины.Магазин, ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)) КАК Магазин,
		|	ТаблицаПравилаРасчетаПремий.НомерСтроки,
		|	ТаблицаПравилаРасчетаПремий.ПЕРИОД,
		|	ТаблицаПравилаРасчетаПремий.ДатаОкончания,
		|	ТаблицаПравилаРасчетаПремий.ПравилоРасчетаПремий
		|ИЗ
		|	ТаблицаМагазины КАК ТаблицаМагазины,
		|	ТаблицаПравилаРасчетаПремий КАК ТаблицаПравилаРасчетаПремий
		|";
		
	КонецЕсли;
	
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаДействующихПравил", ТаблицаРезультат);
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
