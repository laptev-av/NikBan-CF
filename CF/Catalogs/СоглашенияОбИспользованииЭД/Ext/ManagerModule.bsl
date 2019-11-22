﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления БЭД 1.0.4.0
// Разбивает ТОРГ12 на ТОРГ12Продавец и ТОРГ12Покупатель, АктВыполненныхРабот на АктИсполнитель и АктЗаказчик.
//
Процедура ОбновитьВидыДокументов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		ТОРГ12Продавец = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12Продавец, "ИсходящийДокумент");
		
		Если ТОРГ12Продавец = Неопределено Тогда
			НайденнаяСтрока= ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12, "ИсходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.ТОРГ12Продавец;
				НоваяСтрока.ИспользоватьЭП            = НайденнаяСтрока.ИспользоватьЭП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				НоваяСтрока.МаршрутПодписания         = НайденнаяСтрока.МаршрутПодписания;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		ТОРГ12Покупатель = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12Покупатель,
			"ИсходящийДокумент");
		
		Если ТОРГ12Покупатель = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ВходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12, "ВходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.ТОРГ12Покупатель;
				НоваяСтрока.ИспользоватьЭП            = НайденнаяСтрока.ИспользоватьЭП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				НоваяСтрока.МаршрутПодписания         = НайденнаяСтрока.МаршрутПодписания;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		АктИсполнитель = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.АктИсполнитель, "ИсходящийДокумент");
		
		Если АктИсполнитель = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.АктВыполненныхРабот,
				"ИсходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.АктИсполнитель;
				НоваяСтрока.ИспользоватьЭП            = НайденнаяСтрока.ИспользоватьЭП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				НоваяСтрока.МаршрутПодписания         = НайденнаяСтрока.МаршрутПодписания;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		АктЗаказчик = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.АктЗаказчик, "ИсходящийДокумент");
		
		Если АктЗаказчик = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ВходящиеДокументы.Найти(Перечисления.ВидыЭД.АктВыполненныхРабот,
				"ВходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.АктЗаказчик;
				НоваяСтрока.ИспользоватьЭП            = НайденнаяСтрока.ИспользоватьЭП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				НоваяСтрока.МаршрутПодписания         = НайденнаяСтрока.МаршрутПодписания;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗаписатьОбъект Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИскомоеСоглашение)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.6.3
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ЗаполнитьВерсииФорматов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)";
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ВидДокумента.Формировать И Не ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.КаталогТоваров Тогда
				
				ВидДокумента.ВерсияФормата = "CML 4.02";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		Если ЗаписатьОбъект Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИскомоеСоглашение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.7.1
// Переносит сертификат ЭП из реквизита "Сертификат авторизации" в таб.часть "СертификатыПодписейОрганизации".
//
Процедура ПеренестиСертификатАвторизацииВТЧ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка,
	|	СоглашенияОбИспользованииЭД.УдалитьСертификатАбонента
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = &СпособОбменаЭД";
	
	Запрос.УстановитьПараметр("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СертификатЭП = Выборка.УдалитьСертификатАбонента;
		Если ЗначениеЗаполнено(СертификатЭП) Тогда
			СоглашениеЭД = Выборка.Ссылка.ПолучитьОбъект();
			НоваяСтрока = СоглашениеЭД.СертификатыПодписейОрганизации.Добавить();
			НоваяСтрока.Сертификат = СертификатЭП;
			СоглашениеЭД.УдалитьСертификатАбонента = Неопределено;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СоглашениеЭД);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.7.4
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ЗаполнитьВерсииФорматовИсходящихЭДИПакета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД В(&СпособыОбменаЭД)";
	
	СпособыОбменаЭД = Новый Массив;
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезКаталог);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезFTP);
	Запрос.УстановитьПараметр("СпособыОбменаЭД", СпособыОбменаЭД);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если Не ЗначениеЗаполнено(ВидДокумента.ВерсияФормата) Тогда
				ВерсияФормата = "CML 4.02";
				Если ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
					ВерсияФормата = "";
				ИначеЕсли ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.АктЗаказчик
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.АктИсполнитель
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ТОРГ12Покупатель
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда
					ВерсияФормата = "ФНС 5.01";
				КонецЕсли;
				ВидДокумента.ВерсияФормата = ВерсияФормата;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(ИскомоеСоглашение.ВерсияФорматаПакета) Тогда
			ИскомоеСоглашение.ВерсияФорматаПакета = Перечисления.ВерсииФорматаПакетаЭД.Версия10;
		КонецЕсли;
			
		Если ЗаписатьОбъект Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИскомоеСоглашение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.13.6
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсииФорматовИсходящихЭДИПакета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.СпособОбменаЭД В(&СпособыОбменаЭД)";
	
	СпособыОбменаЭД = Новый Массив;
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезКаталог);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезFTP);
	Запрос.УстановитьПараметр("СпособыОбменаЭД", СпособыОбменаЭД);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И ВидДокумента.ВерсияФормата = "CML 2.06" Тогда
				
				ВидДокумента.ВерсияФормата = "CML 2.07";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		Если ЗаписатьОбъект Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИскомоеСоглашение);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Обработчик обновления БЭД 1.1.14.2
// Производит заполнение реквизита "ИспользуетсяКриптография".
//
Процедура ЗаполнитьИспользованиеКриптографии() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.УдалитьИспользуетсяКриптография
	|
	|СГРУППИРОВАТЬ ПО
	|	СоглашенияОбИспользованииЭД.Ссылка
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(СоглашенияОбИспользованииЭД.СертификатыПодписейОрганизации.Ссылка) > 0";
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		СоглашениеЭД = Результат.Ссылка.ПолучитьОбъект();
		СоглашениеЭД.ОбменДанными.Загрузка = Истина;
		СоглашениеЭД.УдалитьИспользуетсяКриптография = Истина;
		СоглашениеЭД.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.2.2.2
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсиюФорматаИсходящихЭД207_208() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.СпособОбменаЭД В(&СпособыОбменаЭД)";
	
	СпособыОбменаЭД = Новый Массив;
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезКаталог);
	СпособыОбменаЭД.Добавить(Перечисления.СпособыОбменаЭД.ЧерезFTP);
	Запрос.УстановитьПараметр("СпособыОбменаЭД", СпособыОбменаЭД);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И (ВидДокумента.ВерсияФормата = "CML 2.06"
					Или ВидДокумента.ВерсияФормата = "CML 2.07") Тогда
				ВидДокумента.ВерсияФормата = "CML 2.08";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		Если ЗаписатьОбъект Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ИскомоеСоглашение);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Обработчик обновления БЭД 1.2.7.1
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсиюФорматаИсходящихЭД501_502() Экспорт
	
	ИсходящиеДокументы = Новый Массив;
	ИсходящиеДокументы.Добавить(Перечисления.ВидыЭД.СчетФактура);
	ИсходящиеДокументы.Добавить(Перечисления.ВидыЭД.КорректировочныйСчетФактура);
	ВерсияФормата = "ФНС 5.01";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК Профиль
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент В(&ИсходящиеДокументы)
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ВерсияФормата = &ВерсияФормата";
	Запрос.УстановитьПараметр("ИсходящиеДокументы", ИсходящиеДокументы);
	Запрос.УстановитьПараметр("ВерсияФормата", ВерсияФормата);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПрофильОбъект = Выборка.Профиль.ПолучитьОбъект();
			Для Каждого ТекСтрока Из ПрофильОбъект.ИсходящиеДокументы Цикл
				Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура
					Или ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
					ТекСтрока.ВерсияФормата = НСтр("ru = 'ФНС 5.02'");
				КонецЕсли;
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильОбъект);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК Соглашение
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент В(&ИсходящиеДокументы)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.ВерсияФормата = &ВерсияФормата";
	
	Запрос.УстановитьПараметр("ИсходящиеДокументы", ИсходящиеДокументы);
	Запрос.УстановитьПараметр("ВерсияФормата", ВерсияФормата);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НастройкаОбъект = Выборка.Соглашение.ПолучитьОбъект();
		Для Каждого ТекСтрока Из НастройкаОбъект.ИсходящиеДокументы Цикл
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура
				Или ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				ТекСтрока.ВерсияФормата = НСтр("ru = 'ФНС 5.02'");
			КонецЕсли;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НастройкаОбъект);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.3.2.4
// Из табличной части Исходящие документы настроек и профилей ЭДО удаляются ответные титулы.
//
Процедура УдалитьОтветныеТитулы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК Профиль
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент В(&ОтветныеТитулы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК Настройка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент В(&ОтветныеТитулы)";
	
	ОтветныеТитулы = Новый Массив;
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.АктЗаказчик);
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиПолучатель);
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.ТОРГ12Покупатель);
	
	Запрос.УстановитьПараметр("ОтветныеТитулы", ОтветныеТитулы);
	Результаты = Запрос.ВыполнитьПакет();
	
	Профили = Результаты[0].Выгрузить();
	Для Каждого ТекСтрока Из Профили Цикл
		УдалитьИсходящиеЭД(ТекСтрока.Профиль, ОтветныеТитулы);
	КонецЦикла;
	
	Настройки = Результаты[1].Выгрузить();
	Для Каждого ТекСтрока Из Настройки Цикл
		УдалитьИсходящиеЭД(ТекСтрока.Настройка, ОтветныеТитулы);
	КонецЦикла;
	
КонецПроцедуры

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПустойМаршрут = Справочники.МаршрутыПодписания.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустойМаршрут", ПустойМаршрут);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Настройки.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК Настройки
	|ГДЕ
	|	Настройки.МаршрутПодписания = &ПустойМаршрут
	|	И Настройки.ИспользоватьЭП = ИСТИНА";
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Обрабатывать настройки можно только после обновления предопределенных маршрутов.
	Если ОбновлениеИнформационнойБазы.ОбъектОбработан("Справочник.МаршрутыПодписания").Обработан Тогда		
		Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(
			Параметры.Очередь, "Справочник.СоглашенияОбИспользованииЭД");
			
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			
			ПараметрыОтбора = Новый Структура("МаршрутПодписания, ИспользоватьЭП", 
				Справочники.МаршрутыПодписания.ПустаяСсылка(), Истина);
			СтрокиСПустымМаршрутом = Объект.ИсходящиеДокументы.НайтиСтроки(ПараметрыОтбора);
			
			Если СтрокиСПустымМаршрутом.Количество() Тогда
				Для Каждого СтрокаНастройки Из СтрокиСПустымМаршрутом Цикл
					СтрокаНастройки.МаршрутПодписания = Справочники.МаршрутыПодписания.ОднойДоступнойПодписью;
				КонецЦикла;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			Иначе 
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ПрофилиНастроекЭДО");
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы.
Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт
	
	Если МетаданныеИОтбор.ПолноеИмя = "Справочник.СоглашенияОбИспользованииЭД" Тогда
		МетаданныеИОтборНастройки = МетаданныеИОтбор;
	ИначеЕсли МетаданныеИОтбор.ПолноеИмя = "Документ.ЭлектронныйДокументИсходящий" 
		ИЛИ МетаданныеИОтбор.ПолноеИмя = "Документ.ЭлектронныйДокументВходящий" Тогда
		Настройка = МетаданныеИОтбор.Отбор.НастройкаЭДО;
		МетаданныеИОтборНастройки = ОбновлениеИнформационнойБазы.МетаданныеИОтборПоДанным(Настройка);
	КонецЕсли;
	
	Возврат ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтборНастройки);
	
КонецФункции

// Функция - Получить данные печати
//
// Параметры:
//  Субъекты			 - Массив - структура, данные о субъектах, заключающих соглашение.
//  МассивИменМакетов	 - Массив - строка, наименование макетов печатных форм.
// 
// Возвращаемое значение:
//  СтруктураВозврата - данные для формирования печатной формы.
//
Функция ПолучитьДанныеПечати(Знач Субъекты, Знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	Для Каждого Субъект Из Субъекты Цикл
		ДанныеОбъектаПоМакетам = Новый Соответствие;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, Субъект);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(Субъект.НастройкаЭДО, ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		Если ИмяМакета = "ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, УправлениеПечатью.МакетПечатнойФормы("Справочник.СоглашенияОбИспользованииЭД.ПФ_DOC_СоглашениеОбОбменеЭлектроннымиДокументами"));
			ТипыМакетов.Вставить(ИмяМакета, "DOC");
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ПолучитьОписаниеОбластейМакетаОфисногоДокумента());
	КонецЦикла;
	
	СтруктураМакетов = Новый Структура("ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов",
										ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Данные", ДанныеПоВсемОбъектам);
	СтруктураВозврата.Вставить("Макеты", СтруктураМакетов);
	
	Возврат СтруктураВозврата;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Функция ПолучитьОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Шапка", "Общая");
	Возврат ОписаниеОбластей;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьИсходящиеЭД(СправочникСсылка, ВидыЭД)
	
	СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
	ИсходящиеДокументы = СправочникОбъект.ИсходящиеДокументы;
	Счетчик = 0;
	Пока Счетчик < ИсходящиеДокументы.Количество() Цикл
		СтрокаТЗ = ИсходящиеДокументы[Счетчик];
		ИсходящийЭД = СтрокаТЗ.ИсходящийДокумент;
		Если ВидыЭД.Найти(ИсходящийЭД) = Неопределено Тогда
			Счетчик = Счетчик + 1;
			Продолжить;
		Иначе
			ИсходящиеДокументы.Удалить(СтрокаТЗ);
		КонецЕсли;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытийТолстыйКлиент

// Согласно стандарта: http://its.1c.ru/db/v8std#content:-2145782967:hdoc: вынесено из инструкции препроцессора.
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка"
		Или ВидФормы = "ФормаВыбора" Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		РеквизитыСоглашения = ОбменСКонтрагентамиСлужебныйВызовСервера.РеквизитыНастройкиЭДО(Параметры.Ключ);
		ЭтоИнтеркампани = РеквизитыСоглашения.ЭтоИнтеркампани;
		СпособОбменаЭД = РеквизитыСоглашения.СпособОбменаЭД;
		
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") 
		И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура")
		И Параметры.ЗначенияЗаполнения.Свойство("ЭтоИнтеркампани")
		И Параметры.ЗначенияЗаполнения.Свойство("СпособОбменаЭД") Тогда
		
		ЭтоИнтеркампани = Параметры.ЗначенияЗаполнения.ЭтоИнтеркампани;
		СпособОбменаЭД = Параметры.ЗначенияЗаполнения.СпособОбменаЭД;
		
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") 
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования)
		И ТипЗнч(Параметры.ЗначениеКопирования) = Тип("СправочникСсылка.СоглашенияОбИспользованииЭД") Тогда 
		
		РеквизитыСоглашения = ОбменСКонтрагентамиСлужебныйВызовСервера.РеквизитыНастройкиЭДО(Параметры.ЗначениеКопирования);
		ЭтоИнтеркампани = РеквизитыСоглашения.ЭтоИнтеркампани;
		СпособОбменаЭД = РеквизитыСоглашения.СпособОбменаЭД;
		
	Иначе
		ЭтоИнтеркампани = Неопределено;
		СпособОбменаЭД = Неопределено;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяФорма = "ФормаЭлемента";
	Если ЭтоИнтеркампани = Истина Тогда
		ВыбраннаяФорма = "ФормаЭлементаИнтеркампани";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

