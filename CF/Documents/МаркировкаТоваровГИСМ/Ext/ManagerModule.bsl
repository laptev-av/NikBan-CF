﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ПриПолученииФормыДокумента(
		"МаркировкаТоваровГИСМ",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаМаркировкаТоваров() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.МаркировкаТоваровГИСМ КАК МаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = МаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	МаркировкаТоваровГИСМ.Ссылка ЕСТЬ НЕ NULL
	|	И СтатусыИнформированияГИСМ.ДальнейшееДействие <> ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется)
	|	И СтатусыИнформированияГИСМ.Документ ССЫЛКА Документ.МаркировкаТоваровГИСМ
	|	И (СтатусыИнформированияГИСМ.Документ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (СтатусыИнформированияГИСМ.Документ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаМаркировкаТоваровОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.МаркировкаТоваровГИСМ КАК МаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = МаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен))
	|	И (МаркировкаТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (МаркировкаТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаМаркировкаТоваровОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.МаркировкаТоваровГИСМ КАК МаркировкаТоваровГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.Документ = МаркировкаТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации))
	|	И (МаркировкаТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (МаркировкаТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередаче;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.Передано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Возврат МаркировкаТоваровXML(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияГИСМ

Функция МаркировкаТоваровXML(ДокументСсылка)
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Возврат МаркировкаТоваровXML2_41(ДокументСсылка);
	Иначе
		Возврат МаркировкаТоваровXML2_40(ДокументСсылка);
	КонецЕсли;
	
КонецФункции

Функция МаркировкаТоваровXML2_40(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = "2.40";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркировкаТоваровГИСМ.Дата                         КАК Дата,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	МаркировкаТоваровГИСМ.Организация        КАК Организация,
	|	МаркировкаТоваровГИСМ.Подразделение      КАК Подразделение,
	|	МаркировкаТоваровГИСМ.ОперацияМаркировки КАК ОперацияМаркировки
	|ИЗ
	|	Документ.МаркировкаТоваровГИСМ КАК МаркировкаТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО МаркировкаТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	МаркировкаТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркировкаТоваровГИСМСерии.НомерСтроки        КАК НомерСтроки,
	|	МаркировкаТоваровГИСМСерии.Номенклатура       КАК Номенклатура,
	|	МаркировкаТоваровГИСМСерии.Характеристика     КАК Характеристика,
	|	МаркировкаТоваровГИСМСерии.GTIN               КАК GTIN,
	|	МаркировкаТоваровГИСМСерии.Серия.Номер        КАК СерийныйНомер,
	|	МаркировкаТоваровГИСМСерии.Серия.НомерКиЗГИСМ КАК НомерКиЗ,
	|	МаркировкаТоваровГИСМСерии.Серия.RFIDTID      КАК TID,
	|	МаркировкаТоваровГИСМСерии.Серия.RFIDEPC      КАК EPC,
	|
	|	МаркировкаТоваровГИСМСерии.РегистрационныйНомерДекларации КАК РегистрационныйНомерДекларации,
	|	МаркировкаТоваровГИСМСерии.НомерТовараВДекларации         КАК НомерТовараВДекларации
	|
	|ИЗ
	|	Документ.МаркировкаТоваровГИСМ.Серии КАК МаркировкаТоваровГИСМСерии
	|ГДЕ
	|	МаркировкаТоваровГИСМСерии.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	МаркировкаТоваровГИСМСерии.НомерСтроки
	|ИТОГИ ПО
	|	GTIN");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если Не Шапка.Следующий()
		ИЛИ Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка, НомерВерсии);
	
	Если Шапка.ОперацияМаркировки <> Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016 Тогда
		
		ИмяТипа   = "query";
		ИмяПакета = "unify_self_signs";
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
		
		МаркировкаТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
		МаркировкаТоваров.action_id  = МаркировкаТоваров.action_id;
		
		Попытка
			МаркировкаТоваров.sender_gln = РеквизитыОгранизации.GLN;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
		КонецПопытки;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			МаркировкаТоваров,
			"unify_date",
			Шапка.Дата,
			ХранилищеВременныхДат);
		
		МаркировкаТоваров.unifies = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров, "unifies", Версия);
		
		Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров.unifies, "by_gtin", Версия);
			НоваяСтрока.sign_gtin = СтрокаТЧИтогПоGTIN.GTIN;
			
			Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл
				
				НоваяСтрокаUnion = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрока, "union", Версия);
				
				Попытка
					НоваяСтрокаUnion.gs1_sgtin = МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 указан некорректный EPC ""%2"".'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика),
							СтрокаТЧ.EPC));
				КонецПопытки;
				
				Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
					
					НоваяСтрокаUnion.sign_num = СтрокаТЧ.НомерКиЗ;
					
				ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.TID)
					И Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
					
					НоваяСтрокаUnion.TID = СтрокаТЧ.TID;
					
				Иначе
					
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 найдены строки в которых не указан номер КиЗ или TID.'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика)));
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
					НоваяСтрокаUnion.EPC = СтрокаТЧ.EPC;
				КонецЕсли;
				
				Если Шапка.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаТоваровПринятыхНаКомиссию Тогда
					НоваяСтрокаUnion.product_type = 1;
				ИначеЕсли Шапка.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаТоваровВозвращенныхПокупателем Тогда
					НоваяСтрокаUnion.product_type = 2;
				КонецЕсли;
				
				НоваяСтрока.union.Добавить(НоваяСтрокаUnion);
				
			КонецЦикла;
			
			МаркировкаТоваров.unifies.by_gtin.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = МаркировкаТоваров;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	Иначе
		
		ИмяТипа   = "query";
		ИмяПакета = "unify_rest";
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
		
		МаркировкаТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
		МаркировкаТоваров.action_id  = МаркировкаТоваров.action_id;
		
		Попытка
			МаркировкаТоваров.sender_gln = РеквизитыОгранизации.GLN;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
		КонецПопытки;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			МаркировкаТоваров,
			"unify_date",
			Шапка.Дата,
			ХранилищеВременныхДат);
		
		МаркировкаТоваров.unifies = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров, "unifies", Версия);
		
		Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров.unifies, "by_gtin", Версия);
			НоваяСтрока.sign_gtin = СтрокаТЧИтогПоGTIN.GTIN;
			
			Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Или ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
					
					НоваяСтрокаSign = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрока, "sign", Версия);
					
					Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
						НоваяСтрокаSign.sign_num = СтрокаТЧ.НомерКиЗ;
					Иначе
						НоваяСтрокаSign.TID = СтрокаТЧ.TID;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации) Тогда
						НоваяСтрокаSign.gtd_number = СтрокаТЧ.РегистрационныйНомерДекларации;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(СтрокаТЧ.НомерТовараВДекларации) Тогда
						НоваяСтрокаSign.goods_number = СтрокаТЧ.НомерТовараВДекларации;
					КонецЕсли;
					
					НоваяСтрока.sign.Добавить(НоваяСтрокаSign);
					
				Иначе
					
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 найдены строки в которых не указан номер КиЗ или TID.'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика)));
					
				КонецЕсли;
				
			КонецЦикла;
			
			МаркировкаТоваров.unifies.by_gtin.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = МаркировкаТоваров;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
		
	КонецЕсли;
	
	СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.Вставить("ТипСообщения", Перечисления.ТипыСообщенийГИСМ.Исходящее);
	СообщениеXML.Вставить("Операция",     Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	СообщениеXML.Вставить("Организация",  Шапка.Организация);
	СообщениеXML.Вставить("Документ",     ДокументСсылка);
	СообщениеXML.Вставить("Версия",       НомерВерсии);
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция МаркировкаТоваровXML2_41(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркировкаТоваровГИСМ.Дата                         КАК Дата,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0) КАК ПоследнийНомерВерсии,
	|	МаркировкаТоваровГИСМ.Организация        КАК Организация,
	|	МаркировкаТоваровГИСМ.Подразделение      КАК Подразделение,
	|	МаркировкаТоваровГИСМ.ОперацияМаркировки КАК ОперацияМаркировки
	|ИЗ
	|	Документ.МаркировкаТоваровГИСМ КАК МаркировкаТоваровГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО МаркировкаТоваровГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	МаркировкаТоваровГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаркировкаТоваровГИСМСерии.НомерСтроки        КАК НомерСтроки,
	|	МаркировкаТоваровГИСМСерии.Номенклатура       КАК Номенклатура,
	|	МаркировкаТоваровГИСМСерии.Характеристика     КАК Характеристика,
	|	МаркировкаТоваровГИСМСерии.GTIN               КАК GTIN,
	|	МаркировкаТоваровГИСМСерии.Серия.Номер        КАК СерийныйНомер,
	|	МаркировкаТоваровГИСМСерии.Серия.НомерКиЗГИСМ КАК НомерКиЗ,
	|	МаркировкаТоваровГИСМСерии.Серия.RFIDTID      КАК TID,
	|	МаркировкаТоваровГИСМСерии.Серия.RFIDEPC      КАК EPC,
	|
	|	МаркировкаТоваровГИСМСерии.КодТаможенногоОргана           КАК КодТаможенногоОргана,
	|	МаркировкаТоваровГИСМСерии.ДатаРегистрацииДекларации      КАК ДатаРегистрацииДекларации,
	|	МаркировкаТоваровГИСМСерии.РегистрационныйНомерДекларации КАК РегистрационныйНомерДекларации,
	|	МаркировкаТоваровГИСМСерии.НомерТовараВДекларации         КАК НомерТовараВДекларации
	|
	|ИЗ
	|	Документ.МаркировкаТоваровГИСМ.Серии КАК МаркировкаТоваровГИСМСерии
	|ГДЕ
	|	МаркировкаТоваровГИСМСерии.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	МаркировкаТоваровГИСМСерии.НомерСтроки
	|ИТОГИ ПО
	|	GTIN");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если Не Шапка.Следующий()
		ИЛИ Товары.Строки.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров, ДокументСсылка, НомерВерсии);
	
	Если Шапка.ОперацияМаркировки <> Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016 Тогда
		
		ИмяТипа   = "query";
		ИмяПакета = "unify_self_signs";
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
		
		МаркировкаТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
		МаркировкаТоваров.action_id  = МаркировкаТоваров.action_id;
		
		Попытка
			МаркировкаТоваров.sender_gln = РеквизитыОгранизации.GLN;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
		КонецПопытки;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			МаркировкаТоваров,
			"unify_date",
			Шапка.Дата,
			ХранилищеВременныхДат);
		
		МаркировкаТоваров.unifies = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров, "unifies", Версия);
		
		Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров.unifies, "by_gtin", Версия);
			НоваяСтрока.sign_gtin = СтрокаТЧИтогПоGTIN.GTIN;
			
			Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл
				
				НоваяСтрокаUnion = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрока, "union", Версия);
				
				Попытка
					НоваяСтрокаUnion.gs1_sgtin = МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 указан некорректный EPC ""%2"".'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика),
							СтрокаТЧ.EPC));
				КонецПопытки;
				
				Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
					
					НоваяСтрокаUnion.sign_num = СтрокаТЧ.НомерКиЗ;
					
				ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.TID)
					И Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
					
					НоваяСтрокаUnion.TID = СтрокаТЧ.TID;
					
				Иначе
					
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 найдены строки в которых не указан номер КиЗ или TID.'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика)));
					
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
					НоваяСтрокаUnion.EPC = СтрокаТЧ.EPC;
				КонецЕсли;
				
				Если Шапка.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаТоваровПринятыхНаКомиссию Тогда
					НоваяСтрокаUnion.product_type = 1;
				ИначеЕсли Шапка.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаТоваровВозвращенныхПокупателем Тогда
					НоваяСтрокаUnion.product_type = 2;
				КонецЕсли;
				
				НоваяСтрока.union.Добавить(НоваяСтрокаUnion);
				
			КонецЦикла;
			
			МаркировкаТоваров.unifies.by_gtin.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = МаркировкаТоваров;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	Иначе
		
		ИмяТипа   = "query";
		ИмяПакета = "unify_rest";
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
		
		МаркировкаТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
		МаркировкаТоваров.action_id  = МаркировкаТоваров.action_id;
		
		Попытка
			МаркировкаТоваров.sender_gln = РеквизитыОгранизации.GLN;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
		КонецПопытки;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			МаркировкаТоваров,
			"unify_date",
			Шапка.Дата,
			ХранилищеВременныхДат);
		
		МаркировкаТоваров.unifies = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров, "unifies", Версия);
		
		Для Каждого СтрокаТЧИтогПоGTIN Из Товары.Строки Цикл
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(МаркировкаТоваров.unifies, "by_gtin", Версия);
			НоваяСтрока.sign_gtin = СтрокаТЧИтогПоGTIN.GTIN;
			
			Для Каждого СтрокаТЧ Из СтрокаТЧИтогПоGTIN.Строки Цикл
				
				Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Или ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
					
					НоваяСтрокаSign = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(НоваяСтрока, "sign", Версия);
					
					Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
						НоваяСтрокаSign.sign_num = СтрокаТЧ.НомерКиЗ;
					Иначе
						НоваяСтрокаSign.TID = СтрокаТЧ.TID;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации) Тогда
						НоваяСтрокаSign.fts_gtd_info = ИнтеграцияГИСМ.ОбъектXDTO("fts_gtd_info_type", Версия);
						НоваяСтрокаSign.fts_gtd_info.customs_code      = СтрокаТЧ.КодТаможенногоОргана;
						НоваяСтрокаSign.fts_gtd_info.registration_date = СтрокаТЧ.ДатаРегистрацииДекларации;
						НоваяСтрокаSign.fts_gtd_info.gtd_number        = СтрокаТЧ.РегистрационныйНомерДекларации;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(СтрокаТЧ.НомерТовараВДекларации) Тогда
						НоваяСтрокаSign.goods_number = СтрокаТЧ.НомерТовараВДекларации;
					КонецЕсли;
					
					НоваяСтрока.sign.Добавить(НоваяСтрокаSign);
					
				Иначе
					
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'Для номенклатуры %1 найдены строки в которых не указан номер КиЗ или TID.'"),
							ИнтеграцияГИСМПереопределяемый.ПредставлениеНоменклатуры(СтрокаТЧ.Номенклатура, СтрокаТЧ.Характеристика)));
					
				КонецЕсли;
				
			КонецЦикла;
			
			МаркировкаТоваров.unifies.by_gtin.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = МаркировкаТоваров;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
		
	КонецЕсли;
	
	СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.Вставить("ТипСообщения", Перечисления.ТипыСообщенийГИСМ.Исходящее);
	СообщениеXML.Вставить("Операция",     Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	СообщениеXML.Вставить("Организация",  Шапка.Организация);
	СообщениеXML.Вставить("Документ",     ДокументСсылка);
	СообщениеXML.Вставить("Версия",       НомерВерсии);
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура инициализации данных документа для механизма проведения.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ.
//  ДополнительныеСвойства - Структура - Дополнительные свойства для проведения.
//  Регистры - Строка, Структура, Неопределено - список регистров, разделенных запятой, или структура, в ключах которой
//                                                  - имена регистров Если неопределено - то всегда возвращается ИСТИНА.
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	МаркировкаТоваровГИСМПереопределяемый.ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры);
	
КонецПроцедуры

#КонецОбласти


Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

#КонецОбласти

#КонецЕсли
