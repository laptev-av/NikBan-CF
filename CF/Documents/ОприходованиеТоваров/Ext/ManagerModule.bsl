﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт об оприходовании товаров.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОприходованииТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оприходовании товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Опись номенклатуры
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОписьНоменклатуры";
	КомандаПечати.Представление = НСтр("ru = 'Опись номенклатуры'");
	КомандаПечати.ДополнительныеПараметры.Вставить("Представление", КомандаПечати.Представление);
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	ДоступноПечатьЭтикетокИЦенников = ПравоДоступа("Использование", Метаданные.Обработки.ПечатьЭтикетокИЦенников);
	
	Если ДоступноПечатьЭтикетокИЦенников Тогда
		// Ценники
		ПараметрыПечатиЦенников = Новый Структура;
		ПараметрыПечатиЦенников.Вставить("ИмяПроцедурыПодготовкиСтруктурыДанных", "УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикеток");
		ПараметрыПечатиЦенников.Вставить("УстановитьРежим", "ПечатьЦенников");
		ПараметрыПечатиЦенников.Вставить("ИмяДокумента", "ОприходованиеТоваров");
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "Ценники";
		КомандаПечати.Представление = НСтр("ru = 'Ценники'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиЦенниковИЭтикеток";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЦенников);
		
		// Этикетки
		ПараметрыПечатиЭтикеток = Новый Структура;
		ПараметрыПечатиЭтикеток.Вставить("ИмяПроцедурыПодготовкиСтруктурыДанных", "УправлениеПечатьюРТВызовСервера.ПодготовитьСтруктуруДанныхЦенниковИЭтикеток");
		ПараметрыПечатиЭтикеток.Вставить("УстановитьРежим", "ПечатьЭтикеток");
		ПараметрыПечатиЭтикеток.Вставить("ИмяДокумента", "ОприходованиеТоваров");
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "Этикетки";
		КомандаПечати.Представление = НСтр("ru = 'Этикетки'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
		КомандаПечати.Обработчик = "УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиЦенниковИЭтикеток";
		КомандаПечати.ДополнительныеПараметры.Вставить("ПараметрыПечатиЦенниковИЭтикеток", ПараметрыПечатиЭтикеток);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//	Объект - ДокументОбъект или ДанныеФормыСтруктура - документ, для которого нужно сформировать параметры проверки.
//
// Возвращаемое значение:
//	Структура - Состав полей определяется требованиями функции
//	            ОбработкаТабличнойЧастиСервер.ЗаполнитьСтатусыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект)Экспорт
	
	ПоляСвязи = Новый Массив;
	
	ПараметрыУказанияСерий = Новый Структура;
	ИспользованиеСерийСклад = Ложь;
	
	ИспользованиеСерийСклад = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");
	
	ПараметрыУказанияСерий.Вставить("ИспользоватьСерииНоменклатуры", ИспользованиеСерийСклад);
	ПараметрыУказанияСерий.Вставить("ПоляСвязи",ПоляСвязи);
	ПараметрыУказанияСерий.Вставить("ЭтоНакладная", Истина);
	
	СкладскиеОперации = Новый Массив;
	СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтражениеИзлишков);
	
	ПараметрыУказанияСерий.Вставить("СкладскиеОперации", СкладскиеОперации);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст ="ВЫБРАТЬ
	|	ДанныеДокумента.Дата                  КАК Период,
	|	ДанныеДокумента.Ссылка                КАК Ссылка,
	|	ДанныеДокумента.Организация           КАК Организация,
	|	ДанныеДокумента.Контрагент            КАК Контрагент,
	|	ДанныеДокумента.Договор               КАК Договор,
	|	ДанныеДокумента.Склад                 КАК Склад,
	|	ДанныеДокумента.Магазин               КАК Магазин,
	|	ДанныеДокумента.ДокументОснование     КАК ДокументОснование,
	|	ДанныеДокумента.АналитикаХозяйственнойОперации.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.АналитикаХозяйственнойОперации КАК АналитикаХозяйственнойОперации,
	|	ДанныеДокумента.Магазин.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач КАК ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач,
	|	(НЕ ДанныеДокумента.Магазин.СкладУправляющейСистемы) КАК ФормироватьДвижения
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	Реквизиты = РезультатЗапроса.Выбрать();
	Реквизиты.Следующий(); 
	
	ОбщегоНазначенияРТ.ПеренестиСтрокуВыборкиВПараметрыЗапроса(РезультатЗапроса, Реквизиты, Запрос);
	ПоОснованию = Ложь;
	ТипОснования = ТипЗнч(Реквизиты.ДокументОснование);
	Если ЗначениеЗаполнено(Реквизиты.ДокументОснование)
		И ТипОснования <> Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС")
		И ТипОснования <> Тип("ДокументСсылка.ОстаткиЕГАИС") Тогда
		ПоОснованию = Истина;
	КонецЕсли;
	Запрос.УстановитьПараметр("ПоОснованию", ПоОснованию);
	
	Запрос.Текст = 
	"//0 ВтТаблицаТовары
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.НомерГТД КАК НомерГТД, 
	|	&Склад КАК Склад,
	|	&АналитикаХозяйственнойОперации КАК АналитикаХозяйственнойОперации,
	|	ТаблицаТовары.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И (НЕ ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга))
	|   И &ФормироватьДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 1 ТаблицаТоварыНаСкладах
	|
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Склад                    КАК Склад,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество,
	|	ТаблицаТовары.АналитикаХозяйственнойОперации    КАК АналитикаХозяйственнойОперации
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|   &ФормироватьДвижения
	|	И (НЕ &ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	// 2 ТаблицаТоварыОрганизаций
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Организация                           КАК Организация,
	|ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеКомиссионныхТоваров) 
	|	ТОГДА &Контрагент
	|	ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ                                  КАК Поставщик,
	|ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеКомиссионныхТоваров) 
	|	ТОГДА &Договор
	|	ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоговорыПлатежныхАгентов.ПустаяСсылка)
	|	КОНЕЦ                                  КАК Договор,
	|	ТаблицаТовары.Склад                    КАК Склад,
	|	ТаблицаТовары.НомерГТД                 КАК НомерГТД,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|
	|ГДЕ
	|   &ФормироватьДвижения
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 3 ТаблицаДвиженияСерийТоваров
	|ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура КАК Номенклатура,
	|	ТаблицаСерии.Характеристика КАК Характеристика,
	|	ТаблицаСерии.Серия КАК Серия,
	|	ТаблицаСерии.Количество КАК Количество,
	|	&Магазин КАК Магазин,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтражениеИзлишков) КАК СкладскаяОперация,
	|	&Ссылка КАК Документ,
	|	&Период КАК Период,
	|	&Ссылка КАК Регистратор,
	|	ТаблицаСерии.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ОприходованиеТоваров.Серии КАК ТаблицаСерии
	|
	|ГДЕ
	|	ТаблицаСерии.Ссылка = &Ссылка
	|	И ТаблицаСерии.Количество <> 0
	|	И ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	И &ФормироватьДвижения
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	// 4 ТаблицаТоварыКОформлениюИзлишковНедостач
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	&ДокументОснование КАК ДокументОснование,
	|	ТаблицаТовары.Количество КАК КОформлениюАктов
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|   И ТаблицаТовары.Количество <> 0
	|	И &ПоОснованию
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|";
	Запрос.Текст = Запрос.Текст + ТекстЗапросаТаблицаСерийныхНомеров();
			
	Результат = Запрос.ВыполнитьПакет();
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыНаСкладах"                  , Результат[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыОрганизаций"                , Результат[2].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДвиженияСерийТоваров"             , Результат[3].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыКОформлениюИзлишковНедостач", Результат[4].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаСерийныхНомеров"                  , Результат[11].Выгрузить());
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктОбОприходованииТоваров") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктОбОприходованииТоваров",
				НСтр("ru = 'Акт об оприходовании товаров'"),
				ПечатьАктаОбОприходованииТоваров(МассивОбъектов, ОбъектыПечати));

	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОписьНоменклатуры") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОписьНоменклатуры",
				ПараметрыПечати.Представление,
				ПечатьОписиНоменклатуры(МассивОбъектов, ОбъектыПечати));
	
	КонецЕсли;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует текст запроса по серийным номерам.
// Возвращаемое значение - ТекстЗапроса - Строка.
Функция ТекстЗапросаТаблицаСерийныхНомеров()
	
	ТекстЗапроса = 
	"//2 
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	Товары.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров,
	|	Товары.Количество
	|ПОМЕСТИТЬ ТабТоварыВСЕ
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючСвязиСерийныхНомеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 3
	|ВЫБРАТЬ
	|	ТабТовары.Номенклатура,
	|	ТабТовары.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров,
	|	ТабТовары.Количество
	|ПОМЕСТИТЬ ТабТовары
	|ИЗ
	|	ТабТоварыВСЕ КАК ТабТовары
	|ГДЕ
	|	ТабТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючСвязиСерийныхНомеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 4
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СерийныеНомера.СерийныйНомер КАК Справочник.СерийныеНомера) КАК СерийныйНомер,
	|	СерийныеНомера.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров,
	|	1 КАК Количество
	|ПОМЕСТИТЬ ТабСерийныеНомера
	|ИЗ
	|	Документ.ОприходованиеТоваров.СерийныеНомера КАК СерийныеНомера
	|ГДЕ
	|	СерийныеНомера.Ссылка = &Ссылка
    |
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючСвязиСерийныхНомеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 5
	|ВЫБРАТЬ
	|	ТабСерийныеНомера.СерийныйНомер.Владелец КАК Номенклатура,
	|	ТабСерийныеНомера.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров,
	|	СУММА(ТабСерийныеНомера.Количество) КАК Количество
	|ПОМЕСТИТЬ ТабСвернутыхСерийныхНомеров
	|ИЗ
	|	ТабСерийныеНомера КАК ТабСерийныеНомера
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабСерийныеНомера.СерийныйНомер.Владелец,
	|	ТабСерийныеНомера.КлючСвязиСерийныхНомеров
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючСвязиСерийныхНомеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 6
	|ВЫБРАТЬ
	|	ТабТовары.Номенклатура,
	|	ТабТовары.КлючСвязиСерийныхНомеров КАК КлючСвязиСерийныхНомеров,
	|	ТабТовары.Количество - ЕСТЬNULL(ТабСвернутыхСерийныхНомеров.Количество, 0) КАК Количество
	|ПОМЕСТИТЬ ТабОстатокНоменклатур
	|ИЗ
	|	ТабТовары КАК ТабТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТабСвернутыхСерийныхНомеров КАК ТабСвернутыхСерийныхНомеров
	|		ПО ТабТовары.КлючСвязиСерийныхНомеров = ТабСвернутыхСерийныхНомеров.КлючСвязиСерийныхНомеров
	|ГДЕ
	|	(НЕ ТабСвернутыхСерийныхНомеров.КлючСвязиСерийныхНомеров ЕСТЬ NULL )
	|	И ТабТовары.Количество - ЕСТЬNULL(ТабСвернутыхСерийныхНомеров.Количество, 0) > 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючСвязиСерийныхНомеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 7
	|ВЫБРАТЬ
	|	ТабТовары.Номенклатура,
	|	ЕСТЬNULL(ТабСерийныеНомера.СерийныйНомер, ЗНАЧЕНИЕ(Справочник.СерийныеНомера.ПустаяСсылка)) КАК СерийныйНомер,
	|	ВЫБОР
	|		КОГДА ТабСерийныеНомера.СерийныйНомер ЕСТЬ NULL 
	|			ТОГДА ТабТовары.Количество
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Количество
	|ПОМЕСТИТЬ ТабОбщая
	|ИЗ
	|	ТабТовары КАК ТабТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТабСерийныеНомера КАК ТабСерийныеНомера
	|		ПО ТабТовары.КлючСвязиСерийныхНомеров = ТабСерийныеНомера.КлючСвязиСерийныхНомеров
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТабОстатокНоменклатур.Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.СерийныеНомера.ПустаяСсылка),
	|	ТабОстатокНоменклатур.Количество
	|ИЗ
	|	ТабОстатокНоменклатур КАК ТабОстатокНоменклатур
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	// 8
	|ВЫБРАТЬ 
	| ТаблицаСерийныеНомера.Номенклатура    КАК Номенклатура,
	|	ТаблицаСерийныеНомера.СерийныйНомер КАК СерийныйНомер, 
	|	ТаблицаСерийныеНомера.Количество    КАК Количество,
	|   &Склад                              КАК Получатель,
	|   &Организация                        КАК Организация,
	|	&АналитикаХозяйственнойОперации     КАК АналитикаХозяйственнойОперации,
	|   &Период                             КАК Период
	| ИЗ (ВЫБРАТЬ
	|	ТабОбщая.Номенклатура КАК номенклатура,
	|	ТабОбщая.СерийныйНомер КАК СерийныйНомер,
	|	СУММА(ТабОбщая.Количество) КАК Количество
	|ИЗ
	|	ТабОбщая КАК ТабОбщая
	|ГДЕ &ФормироватьДвижения
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабОбщая.Номенклатура,
	|	ТабОбщая.СерийныйНомер) КАК ТаблицаСерийныеНомера
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////";
	
	Возврат ТекстЗапроса;
	

	
КонецФункции

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной.
//
Функция ПечатьАктаОбОприходованииТоваров(МассивОбъектов, ОбъектыПечати)

	КолонкаКодов       = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	ВыводитьКоды       = ЗначениеЗаполнено(КолонкаКодов);
	ВыводитьУпаковки   = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Оприходование товаров'");
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеТоваров_АктОбОприходованиеТоваров";
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Магазин КАК Магазин,
	|   Документ.Организация КАК Организация,
	|   Документ.Склад КАК Склад,
	|   Документ.ДокументОснование КАК Основание,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Магазин) КАК МагазинПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Склад) КАК СкладПредставление,
	|   ПРЕДСТАВЛЕНИЕ(Документ.Организация) КАК ОрганизацияПредставление,
	|   ПРЕДСТАВЛЕНИЕ(Документ.ДокументОснование) КАК ОснованиеПредставление,
	|	Документ.Ответственный.ФизическоеЛицо КАК Ответственный
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|	И Документ.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	" + ?(ВыводитьКоды, "ТаблицаТовары.Номенклатура." + КолонкаКодов +" КАК КолонкаКодов,", "") + "
	|	ТаблицаТовары.Номенклатура.НаименованиеПолное КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Характеристика) КАК ХарактеристикаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Упаковка.ЕдиницаИзмерения)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения)
	|	КОНЕЦ КАК ПредставлениеЕдиницыИзмеренияУпаковки,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|   ТаблицаТовары.Цена КАК Цена,
	|   ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОприходованиеТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка В(&МассивОбъектов)
	|	И ТаблицаТовары.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|   Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");

	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОприходованиеТоваров.ПФ_MXL_АктОбОприходованииТоваров");

	ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	
	ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
	ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
	ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");
	
	ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
	ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");
	
	ОбластьШапкаТаблицыКолонкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов; 
	
	ОбластьШапкаТаблицыКолонкаУпаковок 		= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаУпаковок");
	ОбластьСтрокаТаблицыКолонкаУпаковок 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаУпаковок");
	ОбластьПодвалТаблицыКолонкаУпаковок		= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаУпаковок");
	
	ОбластьКолонкаТоваров = Макет.Область("КолонкаТоваров");
	
	Если НЕ ВыводитьКоды Тогда
		
		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки + Макет.Область("КолонкаКодов").ШиринаКолонки;
		
	КонецЕсли;
	
	Если НЕ ВыводитьУпаковки Тогда
		
		ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки + Макет.Область("КолонкаУпаковокКоличество").ШиринаКолонки
		+ Макет.Область("КолонкаУпаковокПредставление").ШиринаКолонки;
		
	КонецЕсли;
	
	ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаТоваров");
	ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаТоваров");
	ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаТоваров");
	
	ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
	ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
	ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");
	
	ОбластьПодписей       = Макет.ПолучитьОбласть("Подписи");
	ОбластьИтого          = Макет.ПолучитьОбласть("Итого");
	ОбластьСуммаПрописью  = Макет.ПолучитьОбласть("СуммаПрописью");
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// ЗАГОЛОВОК
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// ШАПКА
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
		ВсегоНаименований = 0;
		Итого             = 0;
		// СТРОКИ ТЧ
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			
			ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
			
			Если ВыводитьКоды Тогда
				
				ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
				
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураПредставление,ВыборкаПоСтрокамТЧ.ХарактеристикаПредставление);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
			
			Если ВыводитьУпаковки Тогда
				
				ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
				
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	
			
			ВсегоНаименований = ВсегоНаименований + 1;
			Итого             = Итого + ВыборкаПоСтрокамТЧ.Сумма;
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		
		Если ВыводитьКоды Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		
		Если ВыводитьУпаковки Тогда
			
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаУпаковок);
			
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		
		// ИТОГО
		ТекстИтоговойСтроки = НСтр("ru = '%Итого%'");
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Итого));
		ОбластьИтого.Параметры.Итого = ТекстИтоговойСтроки;
		
		ТабличныйДокумент.Вывести(ОбластьИтого);
		// СУММА ПРОПИСЬЮ
		
		ОбластьСуммаПрописью.Параметры.СуммаПрописью = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(Итого);
		
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%, на сумму %Итого%'");
		
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Итого));
				
		ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;

		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
				
		// ПОДПИСИ
		ОбластьПодписей.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьПодписей.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный);
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьОписиНоменклатуры(МассивОбъектов, ОбъектыПечати)
	
	КолонкаКодов       = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	ВыводитьКоды       = ЗначениеЗаполнено(КолонкаКодов);
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокументов.Организация КАК Организация,
	|	ТаблицаДокументов.Магазин,
	|	ТаблицаДокументов.Склад,
	|	ТаблицаДокументов.Ссылка,
	|	ТаблицаДокументов.ДокументОснование КАК Основание
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ТаблицаДокументов
	|ГДЕ
	|	ТаблицаДокументов.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СтруктураПечати = Новый Структура;
	СтруктураПечати.Вставить("ИмяРеквизита1", "Организация");
	СтруктураПечати.Вставить("ИмяРеквизита2", "Магазин");
	СтруктураПечати.Вставить("ИмяРеквизита3", "Склад");
	СтруктураПечати.Вставить("КоличествоРеквизитов", 3);
	СтруктураПечати.Вставить("ВыводитьКоды", ВыводитьКоды);
	СтруктураПечати.Вставить("КолонкаКодов", КолонкаКодов);
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураПечати.Вставить("Документ", Выборка.Ссылка);
		СтруктураПечати.Вставить("Реквизит1", Выборка.Организация);
		СтруктураПечати.Вставить("Реквизит2", Выборка.Магазин);
		СтруктураПечати.Вставить("Реквизит3", Выборка.Склад);
		
		СтруктураПечати.Вставить("Основание", Выборка.Основание);
		
		УправлениеПечатьюРТ.ПечатьОписиНоменклатуры(ТабличныйДокумент, ОбъектыПечати, СтруктураПечати, ПервыйДокумент);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
