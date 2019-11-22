﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения.
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ЦенаВключаетНДС");
	Результат.Добавить("ИспользоватьПриПродаже");
	Результат.Добавить("ИспользоватьПриПередачеМеждуОрганизациями");
	Результат.Добавить("СпособЗаданияЦены");
	Результат.Добавить("Идентификатор");
	Результат.Добавить("СхемаКомпоновкиДанных; РедактироватьСхемуКомпоновкиДанных");
	
	Результат.Добавить("ОкруглятьВБольшуюСторону");
	Результат.Добавить("ПорогСрабатывания");
	Результат.Добавить("АлгоритмРасчетаЦены; КоманднаяПанельФормулаКонструкторФормул");
	
	Результат.Добавить("ЦеновыеГруппы; ФормулыКонструкторФормулТекущейСтроки");
	Результат.Добавить("ПорогиСрабатывания");
	Результат.Добавить("ПравилаОкругленияЦены");
	Результат.Добавить("Формулы");
	
	
	Возврат Результат;

КонецФункции

// Функция определяет вид цены по умолчанию.
//
// Параметры:
//  ИспользоватьПриПередачеМеждуОрганизациями - Булево - Признак использования вида цены для передачи между
//                                                       организациями.
//
// Возвращаемое значение:
//	СправочникСсылка.ВидыЦен - Найденный вид цен.
//
Функция ВидЦеныПоУмолчанию(ИспользоватьПриПередачеМеждуОрганизациями) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ВидыЦен.Ссылка КАК ВидЦены
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	НЕ ВидыЦен.ПометкаУдаления
	|	И (ВидыЦен.ИспользоватьПриПередачеМеждуОрганизациями = &ИспользоватьПриПередачеМеждуОрганизациями
	|		ИЛИ &ИспользоватьПриПередачеМеждуОрганизациями = Неопределено)
	|");
	
	Запрос.УстановитьПараметр("ИспользоватьПриПередачеМеждуОрганизациями", ИспользоватьПриПередачеМеждуОрганизациями);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий() Тогда
		ВидЦены = Выборка.ВидЦены;
	Иначе
		ВидЦены = Справочники.ВидыЦен.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВидЦены;

КонецФункции

// Возвращает структуру с синонимом и схемой компоновки
// данных по имени макета.
//
// Параметры:
//	Ссылка - СправочникСсылка.ВидыЦены - ссылка на вид цены.
//	ИмяМакета - Строка - имя макета, из которого необходимо получить описание и схему.
//
// Возвращаемое значение:
//	Структура - описание и схема компоновки данных.
//
Функция ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(Ссылка, ИмяМакета = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",                  "");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыЦен.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	ВидыЦен.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не ЗначениеЗаполнено(ИмяМакета) Тогда
		
		ВозвращаемоеЗначение.Описание = ИмяМакета;
		Если Выборка.Следующий() Тогда
			
			СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			Если СхемаКомпоновкиДанных = Неопределено Тогда
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СформироватьНовуюСхемуКомпоновкиДанных();
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Неопределено;
			Иначе
				ВозвращаемоеЗначение.СхемаКомпоновкиДанных = СхемаКомпоновкиДанных;
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.Описание = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Макеты.Найти(ИмяМакета).Синоним;
		ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники.ВидыЦен.ПолучитьМакет(ИмяМакета);
		Если Выборка.Следующий() Тогда
			ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Функция определяет реквизиты выбранного вида цены.
//
// Параметры:
//  ВидыЦены - СправочникСсылка.ВидыЦены - Ссылка на вид цены.
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного вида цены.
//
Функция РеквизитыВидаЦены(ВидЦены) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.ВалютаЦены КАК ВалютаЦены,
	|	ВидыЦен.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка = &ВидЦены
	|");
	
	Запрос.УстановитьПараметр("ВидЦены", ВидЦены);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВалютаЦены = Выборка.ВалютаЦены;
		ЦенаВключаетНДС = Выборка.ЦенаВключаетНДС;
	Иначе
		ВалютаЦены = "";
		ЦенаВключаетНДС = Ложь;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("ВалютаЦены, ЦенаВключаетНДС",
		ВалютаЦены,
		ЦенаВключаетНДС);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Осуществляет формирование новой СКД.
//
// Возвращаемое значение:
//	СхемаКомпоновкиДанных
//
Функция СформироватьНовуюСхемуКомпоновкиДанных() Экспорт
	
	СКД                         = Новый СхемаКомпоновкиДанных;
	Источник                    = СКД.ИсточникиДанных.Добавить();
	Источник.Имя                = "ИсточникДанныхЦеныНоменклатуры";
	Источник.ТипИсточникаДанных = "Local";
	НаборДанных                 = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя             = "ЦеныНоменклатуры";
	НаборДанных.Запрос          =
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,";
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,";
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
		|	ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК Упаковка,
		|	1 КАК Коэффициент,";
	КонецЕсли;
	
	НаборДанных.Запрос = НаборДанных.Запрос + "
		|	0 КАК Цена
		|{ВЫБРАТЬ
		|	Номенклатура.*,";
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
			|	Характеристика.*,";
		КонецЕсли;
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		НаборДанных.Запрос = НаборДанных.Запрос + "
		|	Упаковка.*,
		|	Коэффициент,";
	КонецЕсли;
	
	НаборДанных.Запрос = НаборДанных.Запрос + "
		|	Цена}";
		
	НаборДанных.ИсточникДанных = "ИсточникДанныхЦеныНоменклатуры";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Ложь;
	
	ОбязательныеПоля = Ценообразование.ПолучитьОбязательныеПоляСхемыКомпоновкиДанных();
	
	Для Каждого ОбязательноеПоле Из ОбязательныеПоля Цикл
		
		НовоеПоле             = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		НовоеПоле.Поле        = ОбязательноеПоле.Ключ;
		НовоеПоле.ПутьКДанным = ОбязательноеПоле.Ключ;
		НовоеПоле.ТипЗначения = ОбязательноеПоле.Значение;
		
	КонецЦикла;
	
	Возврат СКД;

КонецФункции

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Перем ЗначениеПараметра;
	
	Если Параметры.Свойство("ВыводитьПроизвольныйВидЦен", ЗначениеПараметра) И ЗначениеПараметра = Истина Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыЦен.Ссылка КАК ВидЦен
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|ГДЕ
		|	ВидыЦен.ПометкаУдаления = ЛОЖЬ
		|	И ВидыЦен.ЦенаВключаетНДС = &ЦенаВключаетНДС");
		Запрос.УстановитьПараметр("ЦенаВключаетНДС", Параметры.Отбор.ЦенаВключаетНДС);
		
		// Если в параметрах передан отбор по реквизиту "ИспользоватьПриПередачеМеждуОрганизациями".
		Если Параметры.Отбор.Свойство("ИспользоватьПриПередачеМеждуОрганизациями") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ВидыЦен.ИспользоватьПриПередачеМеждуОрганизациями = &ИспользоватьПриПередачеМеждуОрганизациями";
			Запрос.УстановитьПараметр("ИспользоватьПриПередачеМеждуОрганизациями", Параметры.Отбор.ИспользоватьПриПередачеМеждуОрганизациями);
		КонецЕсли;
		// Если в параметрах передан отбор по реквизиту "ИспользоватьПриПродаже".
		Если Параметры.Отбор.Свойство("ИспользоватьПриПродаже") Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И ВидыЦен.ИспользоватьПриПродаже = &ИспользоватьПриПродаже";
			Запрос.УстановитьПараметр("ИспользоватьПриПродаже", Параметры.Отбор.ИспользоватьПриПродаже);
		КонецЕсли;
		
		ДанныеВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен"));
		
		ДанныеВыбора.Добавить(Справочники.ВидыЦен.ПустаяСсылка(), НСтр("ru='<произвольная>'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли