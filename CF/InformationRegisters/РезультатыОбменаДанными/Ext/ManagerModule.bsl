﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		СсылкаНаИсточник = Источник.Ссылка;
		
		НовоеЗначениеПометкиУдаления = Источник.ПометкаУдаления;
		
		ОбменДаннымиВызовСервера.ЗарегистрироватьУстранениеПроблемы(СсылкаНаИсточник, ТипПроблемы, НовоеЗначениеПометкиУдаления);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьОшибкуПроверкиОбъекта(Ссылка, УзелИнформационнойБазы, Причина, ТипПроблемы) Экспорт
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	
	ЗаписьКонфликта = НаборЗаписейКонфликта.Добавить();
	ЗаписьКонфликта.ПроблемныйОбъект = Ссылка;
	ЗаписьКонфликта.ТипПроблемы = ТипПроблемы;
	ЗаписьКонфликта.УзелИнформационнойБазы = УзелИнформационнойБазы;
	ЗаписьКонфликта.ДатаВозникновения = ТекущаяДатаСеанса();
	ЗаписьКонфликта.Причина = СокрЛП(Причина);
	ЗаписьКонфликта.Пропущена = Ложь;
	
	Если ТипПроблемы = Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент Тогда
		
		Если Ссылка.Метаданные().ДлинаНомера > 0 Тогда
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, Номер, Дата");
			
			ЗаписьКонфликта.НомерДокумента  = ЗначенияРеквизитов.Номер;
		Иначе
			ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, Дата");
		КонецЕсли;
		
		ЗаписьКонфликта.ДатаДокумента   = ЗначенияРеквизитов.Дата;
		ЗаписьКонфликта.ПометкаУдаления = ЗначенияРеквизитов.ПометкаУдаления;
		
	Иначе
		
		ЗаписьКонфликта.ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Процедура Игнорировать(Ссылка, ТипПроблемы, Игнорировать) Экспорт
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	НаборЗаписейКонфликта.Прочитать();
	НаборЗаписейКонфликта[0].Пропущена = Игнорировать;
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Функция ПараметрыПоискаПроблем() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТипПроблемы",                Неопределено);
	Параметры.Вставить("УчитыватьПроигнорированные", Ложь);
	Параметры.Вставить("Период",                     Неопределено);
	Параметры.Вставить("СтрокаПоиска",               "");
	
	Возврат Параметры;
	
КонецФункции

Функция КоличествоПроблем(УзлыОбмена = Неопределено, ПараметрыПоиска = Неопределено) Экспорт
	
	Если ПараметрыПоиска = Неопределено Тогда
		ПараметрыПоиска = ПараметрыПоискаПроблем();
	КонецЕсли;
	
	Количество = 0;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РезультатыОбменаДанными.ПроблемныйОбъект) КАК КоличествоПроблем
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	РезультатыОбменаДанными.Пропущена <> &ОтборПоПропущенным
	|	[ОтборПоУзлу]
	|	[ОтборПоТипу]
	|	[ОтборПоПериоду]
	|	[ОтборПоПричине]";
	
	Запрос = Новый Запрос;
	
	ОтборПоПропущенным = ?(ПараметрыПоиска.УчитыватьПроигнорированные, Неопределено, Истина);
	Запрос.УстановитьПараметр("ОтборПоПропущенным", ОтборПоПропущенным);
	
	Если ПараметрыПоиска.ТипПроблемы = Неопределено Тогда
		СтрокаОтбора = "";
	Иначе
		СтрокаОтбора = "И РезультатыОбменаДанными.ТипПроблемы = &ТипПроблемы";
		Запрос.УстановитьПараметр("ТипПроблемы", ПараметрыПоиска.ТипПроблемы);
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоТипу]", СтрокаОтбора);
	
	Если УзлыОбмена = Неопределено Тогда
		СтрокаОтбора = "";
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипЗнч(УзлыОбмена)) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
		Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзлыОбмена);
	Иначе
		СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы В (&УзлыОбмена)";
		Запрос.УстановитьПараметр("УзлыОбмена", УзлыОбмена);
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоУзлу]", СтрокаОтбора);
	
	Если ЗначениеЗаполнено(ПараметрыПоиска.Период) Тогда
		
		СтрокаОтбора = "И (РезультатыОбменаДанными.ДатаВозникновения >= &ДатаНачала
		| И РезультатыОбменаДанными.ДатаВозникновения <= &ДатаОкончания)";
		Запрос.УстановитьПараметр("ДатаНачала", ПараметрыПоиска.Период.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыПоиска.Период.ДатаОкончания);
		
	Иначе
		
		СтрокаОтбора = "";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоПериоду]", СтрокаОтбора);
	
	Если ЗначениеЗаполнено(ПараметрыПоиска.СтрокаПоиска) Тогда
		
		СтрокаОтбора = "И РезультатыОбменаДанными.Причина ПОДОБНО &Причина";
		Запрос.УстановитьПараметр("Причина", "%" + ПараметрыПоиска.СтрокаПоиска + "%");
		
	Иначе
		
		СтрокаОтбора = "";
		
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОтборПоПричине]", СтрокаОтбора);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Количество = Выборка.КоличествоПроблем;
		
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

Процедура ОчиститьСсылкиНаУзелИнформационнойБазы(Знач УзелИнформационнойБазы) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РезультатыОбменаДанными.ПроблемныйОбъект,
	|	РезультатыОбменаДанными.ТипПроблемы,
	|	НЕОПРЕДЕЛЕНО КАК УзелИнформационнойБазы,
	|	РезультатыОбменаДанными.ДатаВозникновения,
	|	РезультатыОбменаДанными.Причина,
	|	РезультатыОбменаДанными.Пропущена,
	|	РезультатыОбменаДанными.ПометкаУдаления,
	|	РезультатыОбменаДанными.НомерДокумента,
	|	РезультатыОбменаДанными.ДатаДокумента
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор["ПроблемныйОбъект"].Установить(Выборка["ПроблемныйОбъект"]);
		НаборЗаписей.Отбор["ТипПроблемы"].Установить(Выборка["ТипПроблемы"]);
		
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли