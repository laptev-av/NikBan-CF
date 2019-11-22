﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьПакетОшибкуДанныхВОчередь(ОфлайнОборудование, ИдентификаторПередачи, ТекстОшибки) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Прочитать();
	
	НоваяЗапись 						= НаборЗаписей.Добавить();
	НоваяЗапись.ОфлайнОборудование 		= ОфлайнОборудование;
	НоваяЗапись.ИдентификаторПередачи 	= ИдентификаторПередачи;
	НоваяЗапись.Ошибка 					= Истина;
	НоваяЗапись.ОписаниеОшибки 			= ТекстОшибки;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ДобавитьПакетДанныхВОчередь(ОфлайнОборудование, ИдентификаторПередачи, ТекстСообщения, ПорядковыйНомер = 1, ПакетовВсего = 1) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Отбор.ПорядковыйНомер.Установить(ПорядковыйНомер);
	НаборЗаписей.Прочитать();
	
	// Если сообщение с таким номером уже есть в очереди, генерируем исключение.
	Если НаборЗаписей.Количество() > 0 Тогда
		
		ВызватьИсключение(НСтр("ru='Не удалось выполнить отправку данных. Очередь сообщений обмена уже содержит сообщение с номером" + " " + ПорядковыйНомер + ".'"));
		
	КонецЕсли;
	
	НоваяЗапись 						= НаборЗаписей.Добавить();
	НоваяЗапись.ОфлайнОборудование 		= ОфлайнОборудование;
	НоваяЗапись.ИдентификаторПередачи 	= ИдентификаторПередачи;
	НоваяЗапись.ПорядковыйНомер 		= ПорядковыйНомер;
	НоваяЗапись.ДанныеПакета 			= Новый ХранилищеЗначения(ТекстСообщения, Новый СжатиеДанных(9));
	НоваяЗапись.ПакетовВсего 			= ПакетовВсего;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ОчиститьОчередьСообщений(ОфлайнОборудование) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

Функция ПолучитьНеотправленныйИдентификатор(ОфлайнОборудование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи КАК ИдентификаторПередачи
		|ИЗ
		|	РегистрСведений.ОчередьСообщенийОбменаСОфлайнОборудованием КАК ОчередьСообщенийОбменаСОфлайнОборудованием
		|ГДЕ
		|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование = &ОфлайнОборудование
		|	И НЕ ОчередьСообщенийОбменаСОфлайнОборудованием.Отправлен
		|	И НЕ ОчередьСообщенийОбменаСОфлайнОборудованием.Ошибка";
	
	Запрос.УстановитьПараметр("ОфлайнОборудование", ОфлайнОборудование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИдентификаторПередачи;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьСообщениеИзОчереди(ОфлайнОборудование, ИдентификаторПередачи, Рестарт) Экспорт
	
	Если Рестарт Тогда
		СброситьФлагОтправкиВОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование КАК ОфлайнОборудование,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи КАК ИдентификаторПередачи,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПорядковыйНомер КАК ПорядковыйНомер,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ДанныеПакета КАК ДанныеПакета,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПакетовВсего КАК ПакетовВсего,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.Ошибка КАК Ошибка,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОписаниеОшибки КАК ОписаниеОшибки
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийОбменаСОфлайнОборудованием КАК ОчередьСообщенийОбменаСОфлайнОборудованием
	|ГДЕ
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование = &ОфлайнОборудование
	|	И НЕ ОчередьСообщенийОбменаСОфлайнОборудованием.Отправлен
	|	И ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи = &ИдентификаторПередачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПорядковыйНомер";
	
	Запрос.УстановитьПараметр("ОфлайнОборудование",    ОфлайнОборудование);
	Запрос.УстановитьПараметр("ИдентификаторПередачи", ИдентификаторПередачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураПакета = Новый Структура;
		СтруктураПакета.Вставить("ОфлайнОборудование", 		Выборка.ОфлайнОборудование);
		СтруктураПакета.Вставить("ИдентификаторПередачи", 	Выборка.ИдентификаторПередачи);
		СтруктураПакета.Вставить("ПорядковыйНомер", 		Выборка.ПорядковыйНомер);
		СтруктураПакета.Вставить("ДанныеПакета", 			Выборка.ДанныеПакета);
		СтруктураПакета.Вставить("ПакетовВсего", 			Выборка.ПакетовВсего);
		СтруктураПакета.Вставить("Ошибка", 					Выборка.Ошибка);
		СтруктураПакета.Вставить("ОписаниеОшибки", 			Выборка.ОписаниеОшибки);
		
		Возврат СтруктураПакета;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СброситьФлагОтправкиВОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи)
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.Отправлен = Ложь;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


