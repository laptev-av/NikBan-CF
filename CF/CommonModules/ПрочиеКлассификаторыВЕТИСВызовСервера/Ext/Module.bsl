﻿
#Область ПрограммныйИнтерфейс

#Область ЕдиницыИзмерения

// Возвращает единицу измерения по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЕдиницаИзмеренияПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает единицу измерения по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЕдиницаИзмеренияПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список единиц измерения.
//
// Параметры:
//  КодТипаПродукции - Число - Код типа продукции.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокЕдиницИзмерения(НомерСтраницы = 1, ХозяйствующийСубъект = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЕдиницИзмеренияXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос, ХозяйствующийСубъект);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период элементов единиц измерения.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийЕдиницИзмерения(Интервал, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораЕдиницИзмеренияXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает таблицу доступных единиц измерения для различных видов продукции.
//
Функция ЕдиницыИзмеренияПродукции() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка,
	|	Т.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.ЕдиницыИзмеренияВЕТИС КАК Т";
	
	ТаблицаСсылок = Запрос.Выполнить().Выгрузить();
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ТипПродукцииGUID",       Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("ТипПродукции",           Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ПродукцияGUID",          Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("Продукция",              Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ВидПродукцииGUID",       Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("ВидПродукции",           Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ГруппаЕдиницИзмерения",  Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмеренияGUID",   Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмерения",       Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмеренияСсылка", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмеренияВЕТИС"));
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторЕдиницыИзмеренияПродукции");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		ЕдиницаИзмеренияGUID = СокрЛП(Макет.Область("R" + НомерСтроки + "C9" ).Текст);
		НайденнаяСтрока      = ТаблицаСсылок.Найти(ЕдиницаИзмеренияGUID, "Идентификатор");
		
		Если ЗначениеЗаполнено(НайденнаяСтрока) Тогда
			ЕдиницаИзмеренияСсылка = НайденнаяСтрока.Ссылка;
		ИначеЕсли ПравоДоступа("Добавление", Метаданные.Справочники.ЕдиницыИзмеренияВЕТИС) Тогда
			ЕдиницаИзмеренияСсылка = ИнтеграцияВЕТИС.ЕдиницаИзмерения(ЕдиницаИзмеренияGUID, Неопределено);
		Иначе
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.ЕдиницаИзмеренияGUID   = ЕдиницаИзмеренияGUID;
		НоваяСтрока.ЕдиницаИзмеренияСсылка = ЕдиницаИзмеренияСсылка;
		
		НоваяСтрока.ТипПродукцииGUID       = СокрЛП(Макет.Область("R" + НомерСтроки + "C2" ).Текст);
		НоваяСтрока.ТипПродукции           = СокрЛП(Макет.Область("R" + НомерСтроки + "C3" ).Текст);
		НоваяСтрока.ПродукцияGUID          = СокрЛП(Макет.Область("R" + НомерСтроки + "C4" ).Текст);
		НоваяСтрока.Продукция              = СокрЛП(Макет.Область("R" + НомерСтроки + "C5" ).Текст);
		НоваяСтрока.ВидПродукцииGUID       = СокрЛП(Макет.Область("R" + НомерСтроки + "C6" ).Текст);
		НоваяСтрока.ВидПродукции           = СокрЛП(Макет.Область("R" + НомерСтроки + "C7" ).Текст);
		НоваяСтрока.ГруппаЕдиницИзмерения  = СокрЛП(Макет.Область("R" + НомерСтроки + "C8" ).Текст);
		НоваяСтрока.ЕдиницаИзмерения       = СокрЛП(Макет.Область("R" + НомерСтроки + "C10").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;

КонецФункции

#КонецОбласти

#Область Цели

// Возвращает назначение груза по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЦельПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает цель по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЦельПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список целей.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокЦелей(НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЦелейXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период целей.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
//   * НачалоПериода - Дата - Дата начала периода.
//   * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция ИсторияИзмененийЦелей(Интервал, НомерСтраницы = 1, КоличествоЭлементовНаСтранице = Неопределено) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораЦелейXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОрганизационноПравовыеФормы

Функция ОрганизационноПравовыеФормы() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Код",          Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторОКОНХ");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.Код          = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C3").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область ВидыДеятельностиПредприятий

Функция ВидыДеятельностиПредприятий() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторВидовДеятельностиПредприятий");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область СтраныМира

Функция СтраныМира() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("КодАльфа2",    Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("КодАльфа3",    Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторВЕТИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторСтранМира");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.КодАльфа2    = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.КодАльфа3    = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C3").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C4").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ДанныеСтраныМира(Страна, СтраныМира = Неопределено) Экспорт
	
	КодАльфа2 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Страна, "КодАльфа2");
	
	Если СтраныМира = Неопределено Тогда
		ТаблицаСтранМира = ПрочиеКлассификаторыВЕТИСВызовСервера.СтраныМира();
	Иначе
		ТаблицаСтранМира = СтраныМира;
	КонецЕсли;
	
	СтрокаТЧ = ТаблицаСтранМира.Найти(КодАльфа2, "КодАльфа2");
	
	Если СтрокаТЧ = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка поиска данных стран мира'");
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Идентификатор", СтрокаТЧ.GUID);
	ВозвращаемоеЗначение.Вставить("Наименование",  СтрокаТЧ.Наименование);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область Заболевания

// Возвращает назначение груза по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЗаболеваниеПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
		
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает цель по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторВЕТИС - Идентификатор.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементаКлассификатора().
//
Функция ЗаболеваниеПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции


// Возвращает список заболеваний.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  Структура - см. функцию ИнтеграцияВЕТИСКлиентСервер.РезультатВыполненияЗапросаЭлементовКлассификатора().
//
Функция СписокЗаболеваний(НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЗаболеванийXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос единицы измерения по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЕдиницИзмеренияXML(НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.ИмяСписка        = "unitList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка единиц измерения'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораЕдиницИзмеренияXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.ИмяСписка        = "unitList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов единиц измерения'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос цели по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЦелейXML(НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.ИмяСписка        = "purposeList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка целей'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораЦелейXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.ИмяСписка        = "purposeList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка целей'");
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDiseaseBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "disease";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос заболевания по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЗаболеванийXML(НомерСтраницы)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDiseaseList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "disease";
	ПараметрыЗапроса.ИмяСписка        = "diseaseList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка заболеваний'");
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = ИнтеграцияВЕТИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти