﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Лист кассовой книги
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КассоваяКнига";
	КомандаПечати.Представление = НСтр("ru = 'Лист кассовой книги'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Титульный лист и последняя страница.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Обложка";
	КомандаПечати.Представление = НСтр("ru = 'Титульный лист и последняя страница'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КассоваяКнига") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"КассоваяКнига",
		НСтр("ru = 'Кассовая книга'"),
		СформироватьПечатнуюФормуЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Обложка") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"Обложка",
		НСтр("ru = 'Титульный лист кассовой книги'"),
		СформироватьПечатнуюФормуОбложкиИПоследнегоЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати));
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

Функция ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(Организация, ДоговорПлатежногоАгента, ДатаНач, ДатаКон)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КассоваяКнигаДокументы.НомерЛиста) КАК КоличествоЛистов
	|ИЗ
	|	Документ.КассоваяКнига КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|	ПО	
	|		ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И ДанныеДокумента.Организация = &Организация
	|	И ДанныеДокумента.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	И ДанныеДокумента.Проведен
	|");
	
	Запрос.УстановитьПараметр("ДатаНач",     ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон",     ДатаКон);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДоговорПлатежногоАгента", ДоговорПлатежногоАгента);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоЛистов;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьОбороты(РабочаяТаблица, Приход, Расход)
	
	НоваяСтрока = РабочаяТаблица.Добавить();
	
	НоваяСтрока.Остаток    = 0;
	НоваяСтрока.Приход     = Приход;
	НоваяСтрока.Расход     = Расход;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуОбложкиИПоследнегоЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати)
	
	// Печать обложки и титульного листа.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	МакетОбложка 	  = УправлениеПечатью.МакетПечатнойФормы("Документ.КассоваяКнига.ПФ_MXL_ОбложкаКассовойКниги");
	ОбластьОбложка 	  = МакетОбложка.ПолучитьОбласть("Обложка");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(КассоваяКнига.Дата, ГОД) КАК Год,
	|	КассоваяКнига.Организация КАК Организация,
	|	КассоваяКнига.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнига.Магазин) КАК МагазинПредставление,
	|	КассоваяКнига.Организация.КодПоОКПО КАК КодПоОКПО,
	|	ПОДСТРОКА(КассоваяКнига.Организация.НаименованиеПолное, 1, 200) КАК НаименованиеОрганизации
	|ИЗ
	|	Документ.КассоваяКнига КАК КассоваяКнига
	|ГДЕ
	|	КассоваяКнига.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
		Выборка.Организация,
		Выборка.ДоговорПлатежногоАгента,
		НачалоГода(Выборка.Год),
		КонецГода(Выборка.Год));
		
		ОбластьОбложка.Параметры.НазваниеОрганизации = Выборка.НаименованиеОрганизации;
		ОбластьОбложка.Параметры.Магазин = Выборка.МагазинПредставление;
		ОбластьОбложка.Параметры.НадписьОбложка = " на "+Формат(Выборка.Год, "ДФ=yyyy") + " г.";
		ОбластьОбложка.Параметры.КодОКПО 		= Выборка.КодПоОКПО;
		
		ТабличныйДокумент.Вывести(ОбластьОбложка);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(ОбластьОбложка);
		
		// Последний лист кассовой книги.
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ОбластьПослДеньГода = МакетОбложка.ПолучитьОбласть("ПослДеньГода");
		
		Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(Выборка.Организация, ТекущаяДатаСеанса());
		
		ОбластьПослДеньГода.Параметры.ГлБухгалтер 			= Руководители.ГлавныйБухгалтер;
		ОбластьПослДеньГода.Параметры.Руководитель 			= Руководители.Руководитель;
		ОбластьПослДеньГода.Параметры.РуководительДолжность = Руководители.РуководительДолжность;
		ОбластьПослДеньГода.Параметры.ЛистовЗаГод 			= КоличествоЛистов;
		
		ТабличныйДокумент.Вывести(ОбластьПослДеньГода);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		Неопределено);
		
	КонецЦикла;
	
	ТабличныйДокумент.ОтображатьСетку     = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуЛистаКассовойКниги(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ВыводитьОснования = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КассоваяКнига.Ссылка КАК Ссылка,
	|	КассоваяКнига.ТипЛиста КАК ТипЛиста,
	|	КассоваяКнига.Дата КАК Дата,
	|	КассоваяКнига.Организация КАК Организация,
	|	КассоваяКнига.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	КассоваяКнига.Магазин КАК Магазин,
	|	КассоваяКнига.Ответственный.ФизическоеЛицо КАК Ответственный
	|ИЗ
	|	Документ.КассоваяКнига КАК КассоваяКнига
	|ГДЕ
	|	КассоваяКнига.Ссылка В(&МассивДокументов)
	|	И КассоваяКнига.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	Результат = Запрос.Выполнить();
	ВыборкаПоДокументамКассоваяКнига = Результат.Выбрать();
	
	Пока ВыборкаПоДокументамКассоваяКнига.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Начало года. В этом случае не требуется получать номера листов кассовой книги.
		ДатаНач = НачалоДня(ВыборкаПоДокументамКассоваяКнига.Дата);
		
		Организация = ВыборкаПоДокументамКассоваяКнига.Организация;
		ДоговорПлатежногоАгента = ВыборкаПоДокументамКассоваяКнига.ДоговорПлатежногоАгента;
		Магазин = ВыборкаПоДокументамКассоваяКнига.Магазин;
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.КассоваяКнига.ПФ_MXL_ЛистКассовойКниги");
		
		ОбластьПодвалОтчет                  = Макет.ПолучитьОбласть("Подвал|Отчет");
		ОбластьЛистовЗаМесяцОтчет           = Макет.ПолучитьОбласть("ЛистовЗаМесяц|Отчет");
		ОбластьЛистовЗаГодОтчет             = Макет.ПолучитьОбласть("ЛистовЗаГод|Отчет");
		ОбластьВкладнойЛистОтчет            = Макет.ПолучитьОбласть("ВкладнойЛист|Отчет");
		ОбластьВкладнойЛист373ПОтчет        = Макет.ПолучитьОбласть("ВкладнойЛист373П|Отчет");
		ОбластьОтчетКассираОтчет            = Макет.ПолучитьОбласть("ОтчетКассира|Отчет");
		ОбластьОтчетКассира373ПОтчет        = Макет.ПолучитьОбласть("ОтчетКассира373П|Отчет");
		ОбластьШапкаОтчет                   = Макет.ПолучитьОбласть("Шапка|Отчет");
		ОбластьОстатокНаНДОтчет             = Макет.ПолучитьОбласть("ОстатокНаНД|Отчет");
		ОбластьПереносОтчет                 = Макет.ПолучитьОбласть("Перенос|Отчет");
		ОбластьСтрокаШирокаяОтчет           = Макет.ПолучитьОбласть("СтрокаШирокая|Отчет");
		ОбластьСтрокаОтчет                  = Макет.ПолучитьОбласть("Строка|Отчет");
		ОбластьОборотОтчет                  = Макет.ПолучитьОбласть("Оборот|Отчет");
		ОбластьКонечныйОстатокОтчет         = Макет.ПолучитьОбласть("КонечныйОстаток|Отчет");
		
		ЗапросПоИтогам = Новый Запрос;
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	&ДатаНачала КАК Период,
		|	ДенежныеСредстваНаличныеОстатки.СуммаОстаток КАК СуммаНачальныйОстатокДт,
		|	0 КАК СуммаОборотДт,
		|	0 КАК СуммаОборотКт,
		|	0 КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(
		|			&ДатаНачала,
		|			Организация = &Организация
		|			И ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
		|				%УсловиеМагазин%) КАК ДенежныеСредстваНаличныеОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ДенежныеСредства.Период, ДЕНЬ),
		|	0,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ДенежныеСредства.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			ТОГДА -ДенежныеСредства.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			ТОГДА -ДенежныеСредства.Сумма
		|		ИНАЧЕ ДенежныеСредства.Сумма
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
		|	%УсловиеМагазин1%
		|	И НЕ ДенежныеСредства.СтатьяДвиженияДенежныхСредств.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|ИТОГИ
		|	СУММА(СуммаНачальныйОстатокДт),
		|	СУММА(СуммаОборотДт),
		|	СУММА(СуммаОборотКт),
		|	СУММА(СуммаОборот)
		|ПО
		|	ОБЩИЕ,
		|	Период ПЕРИОДАМИ(ДЕНЬ, , )";
		
		Если ЗначениеЗаполнено(Магазин) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин%", " И Магазин = &Магазин");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин1%", " И ДенежныеСредства.Магазин = &Магазин");
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин%", "");
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин1%", "");
		КонецЕсли;
		
		ЗапросПоИтогам.Текст = ТекстЗапроса;
		
		ЗапросПоИтогам.УстановитьПараметр("ДатаНачала",НачалоДня(ДатаНач));
		ЗапросПоИтогам.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаНач));
		ЗапросПоИтогам.УстановитьПараметр("Организация",Организация);
		ЗапросПоИтогам.УстановитьПараметр("ДоговорПлатежногоАгента",ДоговорПлатежногоАгента);
		ЗапросПоИтогам.УстановитьПараметр("Магазин", Магазин);
		
		РезультатЗапросаПоИтогам = ЗапросПоИтогам.Выполнить();
		
		Если РезультатЗапросаПоИтогам.Пустой() Тогда
			Продолжить;
		КонецЕсли;
		
		ЗапросПоДокументам = Новый Запрос;
		ЗапросПоДокументам.Текст = 
		"ВЫБРАТЬ
		|	КассоваяКнигаДокументы.КассовыйОрдер КАК Документ,
		|	НАЧАЛОПЕРИОДА(КассоваяКнигаДокументы.КассовыйОрдер.Дата, ДЕНЬ) КАК День,
		|	КассоваяКнигаДокументы.КассовыйОрдер.Дата КАК ДатаДок,
		|	КассоваяКнигаДокументы.КассовыйОрдер.Номер КАК НомерДок,
		|	ПОДСТРОКА(КассоваяКнигаДокументы.КассовыйОрдер.Основание, 1, 200) КАК Основание,
		|	ВЫБОР
		|		КОГДА КассоваяКнигаДокументы.КассовыйОрдер ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|			ТОГДА КассоваяКнигаДокументы.КассовыйОрдер.ПринятоОт
		|		ИНАЧЕ КассоваяКнигаДокументы.КассовыйОрдер.Выдать
		|	КОНЕЦ КАК ТекстДок,
		|	ЕСТЬNULL(КассоваяКнигаДокументы.Приход, 0) КАК Приход,
		|	ЕСТЬNULL(КассоваяКнигаДокументы.Расход, 0) КАК Расход,
		|	КассоваяКнигаДокументы.КорреспондирующийСчет КАК Счет,
		|	КассоваяКнигаДокументы.НомерЛиста КАК НомерЛиста,
		|	КассоваяКнигаДокументы.НомерСтроки КАК НомерСтроки,
		|	ДанныеДокумента.ТипЛиста КАК ТипЛиста,
		|	ДанныеДокумента.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента
		|ИЗ
		|	Документ.КассоваяКнига КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
		|		ПО ДанныеДокумента.Ссылка = КассоваяКнигаДокументы.Ссылка
		|ГДЕ
		|	ДанныеДокумента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДанныеДокумента.Организация = &Организация
		|	И ДанныеДокумента.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
		|	И ДанныеДокумента.Магазин = &Магазин
		|	И ДанныеДокумента.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	День,
		|	НомерЛиста,
		|	НомерСтроки
		|ИТОГИ
		|	СУММА(Приход),
		|	СУММА(Расход),
		|	МИНИМУМ(НомерЛиста)
		|ПО
		|	День,
		|	Документ,
		|	Счет";
		
		ЗапросПоДокументам.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНач));
		ЗапросПоДокументам.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаНач));
		ЗапросПоДокументам.УстановитьПараметр("Организация", Организация);
		ЗапросПоДокументам.УстановитьПараметр("ДоговорПлатежногоАгента", ДоговорПлатежногоАгента);
		ЗапросПоДокументам.УстановитьПараметр("Магазин", Магазин);
		РезультатЗапросаПоДокументам = ЗапросПоДокументам.Выполнить();
		
		ТаблицаДокументы = РезультатЗапросаПоДокументам.Выгрузить();
		ТаблицаДокументы.Очистить();
		ТаблицаДокументы.Колонки.Добавить("СтрокаСчет");
		ТаблицаДокументы.Колонки.Добавить("ВидДокумента");
		
		ТипЧисло = ОбщегоНазначенияРТКлиентСервер.ПолучитьОписаниеТиповЧисла(15,2);
		
		РабочаяТаблица = Новый ТаблицаЗначений;
		РабочаяТаблица.Колонки.Добавить("Остаток",   ТипЧисло);
		РабочаяТаблица.Колонки.Добавить("Приход",    ТипЧисло);
		РабочаяТаблица.Колонки.Добавить("Расход",    ТипЧисло);
		
		ВыборкаОбщихИтогов = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Общие");
		
		Строка        = РабочаяТаблица.Добавить();
		
		Если ВыборкаОбщихИтогов.Следующий() Тогда
			Строка.Остаток    = ВыборкаОбщихИтогов["СуммаНачальныйОстатокДт"]-РабочаяТаблица.Итог("Остаток");
		Иначе
			Строка.Остаток    = 0
		КонецЕсли;
		
		ВыборкаИтоговПоДням     = РезультатЗапросаПоИтогам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Период");
		ВыборкаДокументовПоДням = РезультатЗапросаПоДокументам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"День");
		
		ПоПроводкам  = ВыборкаИтоговПоДням.Следующий();
		ПоДокументам = ВыборкаДокументовПоДням.Следующий();
		
		БылиОшибки    = Ложь;
		ВывестиПодвал = Ложь;
		
		СведенияОбОрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(Организация, КонецДня(ДатаНач));
		
		ТипПКО = Тип("ДокументСсылка.ПриходныйКассовыйОрдер");
		ТипРКО = Тип("ДокументСсылка.РасходныйКассовыйОрдер");
		
		Пока ПоПроводкам Или ПоДокументам  Цикл
			
			Если НЕ ПоПроводкам  Тогда
				ДатаЛиста = ВыборкаДокументовПоДням.День;
			ИначеЕсли НЕ ПоДокументам Тогда
				ДатаЛиста = ВыборкаИтоговПоДням.Период;
			Иначе
				ДатаЛиста = Мин(ВыборкаДокументовПоДням.День, ВыборкаИтоговПоДням.Период);
			КонецЕсли;
			
			Если ВыборкаИтоговПоДням.СуммаОборотДт = 0 И ВыборкаИтоговПоДням.СуммаОборотКт = 0 Тогда
				Если НЕ ПоДокументам ИЛИ ДатаЛиста <> ВыборкаДокументовПоДням.День Тогда
					ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			КоличествоПриходныхДокументов = 0;
			КоличествоРасходныхДокументов = 0;
			
			ДатаДействияПриказа373П = Дата('20120101');
			
			Остаток = РабочаяТаблица.Итог("Остаток");
			Если ДатаЛиста >= ДатаНач Тогда
				
				Если ДатаЛиста < ДатаДействияПриказа373П Тогда
					
					ЗаголовокЛиста = НСтр("ru = 'КАССА за'") + " " + Формат(ДатаЛиста, "ДЛФ=D");
					ОбластьВкладнойЛистОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ТабличныйДокумент.Вывести(ОбластьВкладнойЛистОтчет);
					
					ОбластьОтчетКассираОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ТабличныйДокумент.Присоединить(ОбластьОтчетКассираОтчет);
					
					// Номер первого листа документа "Кассовая книга".
					ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = НСтр("ru = 'Лист'") + " " + ВыборкаДокументовПоДням.НомерЛиста;
					
				Иначе
					
					ЗаголовокЛиста = НСтр("ru = 'КАССА за'") + " " + Формат(ДатаЛиста, "ДЛФ=DD");
					ТекстНомерЛиста = НСтр("ru = 'Лист'") + " " + ВыборкаДокументовПоДням.НомерЛиста;
					
					ОбластьВкладнойЛист373ПОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ОбластьВкладнойЛист373ПОтчет.Параметры.ТекстНомерЛиста = ТекстНомерЛиста;
					ТабличныйДокумент.Вывести(ОбластьВкладнойЛист373ПОтчет);
					
					ОбластьОтчетКассира373ПОтчет.Параметры.ЗаголовокЛиста = ЗаголовокЛиста;
					ОбластьОтчетКассира373ПОтчет.Параметры.ТекстНомерЛиста = ТекстНомерЛиста;
					ТабличныйДокумент.Присоединить(ОбластьОтчетКассира373ПОтчет);
					
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьШапкаОтчет);
				ТабличныйДокумент.Присоединить(ОбластьШапкаОтчет);
				
				ОбластьОстатокНаНДОтчет.Параметры.ОстатокНачало = Остаток;
				ТабличныйДокумент.Вывести(ОбластьОстатокНаНДОтчет);
				ТабличныйДокумент.Присоединить(ОбластьОстатокНаНДОтчет);
				
			КонецЕсли;
			
			ТаблицаДокументы.Очистить();
			
			Если ПоДокументам И ВыборкаДокументовПоДням.День = ДатаЛиста Тогда
				
				ВыборкаДокументов = ВыборкаДокументовПоДням.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Документ");
				
				Пока ВыборкаДокументов.Следующий() Цикл
					
					НоваяСтрока = ТаблицаДокументы.Добавить();
					НоваяСтрока.ВидДокумента = ?(ТипЗнч(ВыборкаДокументов.Документ) = ТипПКО, "ПриходныйОрдер", "РасходныйОрдер");
					НоваяСтрока.Документ     = ВыборкаДокументов.Документ;
					НоваяСтрока.ДатаДок      = ВыборкаДокументов.ДатаДок;
					НоваяСтрока.День         = ВыборкаДокументов.День;
					НоваяСтрока.НомерДок     = ВыборкаДокументов.НомерДок;
					НоваяСтрока.Приход       = ВыборкаДокументов.Приход;
					НоваяСтрока.Расход       = ВыборкаДокументов.Расход;
					НоваяСтрока.Основание    = ВыборкаДокументов.Основание;
					НоваяСтрока.ТекстДок     = ВыборкаДокументов.ТекстДок;
					НоваяСтрока.НомерЛиста   = ВыборкаДокументов.НомерЛиста;
					
					ВыборкаСчетов = ВыборкаДокументов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Счет");
					СписокСчетов  = Новый ТаблицаЗначений;
					СписокСчетов.Колонки.Добавить("Счет");
					Пока ВыборкаСчетов.Следующий() Цикл
						
						СтрокаТаблицыСчетов      = СписокСчетов.Добавить();
						СтрокаТаблицыСчетов.Счет = ВыборкаСчетов.Счет;
						
					КонецЦикла;
					
					СписокСчетов.Свернуть("Счет");
					
					СтрокаСчет = "";
					Для Каждого СтрокаТаблицыСчетов Из СписокСчетов Цикл
						СтрокаСчет = СтрокаСчет + СтрокаТаблицыСчетов.Счет + Символы.ПС;
					КонецЦикла;
					
					НоваяСтрока.СтрокаСчет = СтрокаСчет;
					
				КонецЦикла;
				
			КонецЕсли;
			
			ПерваяСтрока = 1;
			
			ПредыдущийНомерЛиста = ВыборкаДокументовПоДням.НомерЛиста;
			
			Для Каждого Документ Из ТаблицаДокументы Цикл
				
				Если Документ.ВидДокумента = "РасходныйОрдер" Тогда
					Клиент = НСтр("ru = 'Выдано'") + " " + СокрЛП(Документ.ТекстДок) + ?(ВыводитьОснования = 1, " " + СокрЛП(Документ.Основание), "");
					КоличествоРасходныхДокументов = КоличествоРасходныхДокументов + 1;
					Расход    = Окр(?(Документ.Расход=null,0,Документ.Расход),2,1);
					Приход    = 0;
				Иначе
					Клиент = НСтр("ru = 'Принято от'") + " " + СокрЛП(Документ.ТекстДок) + ?(ВыводитьОснования = 1, " " + СокрЛП(Документ.Основание), "");
					КоличествоПриходныхДокументов = КоличествоПриходныхДокументов + 1;
					Приход    = Окр(?(Документ.Приход=null,0,Документ.Приход),2,1);
					Расход    = 0;
				КонецЕсли;
				
				НомерДокПечатнойФормы = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
				Документ.НомерДок,
				Ложь,
				Истина);
				КоррСчет = Документ.СтрокаСчет;
				
				// Начинаем новую страницу
				Если ПредыдущийНомерЛиста <> Документ.НомерЛиста Тогда
					
					ПриходЗаДень = РабочаяТаблица.Итог("Приход");
					РасходЗаДень = РабочаяТаблица.Итог("Расход");
					
					Если ДатаЛиста >= ДатаНач Тогда
						
						ОбластьПереносОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
						ОбластьПереносОтчет.Параметры.РасходЗаДень = РасходЗаДень;
						ТабличныйДокумент.Вывести(ОбластьПереносОтчет);
						ТабличныйДокумент.Присоединить(ОбластьПереносОтчет);
						
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ОбластьШапкаОтчет.Параметры.ТекстНомерЛиста = "Лист " + Документ.НомерЛиста;
						ТабличныйДокумент.Вывести(ОбластьШапкаОтчет);
						ТабличныйДокумент.Присоединить(ОбластьШапкаОтчет);
						
					КонецЕсли;
					
					ПредыдущийНомерЛиста = Документ.НомерЛиста;
					
				КонецЕсли;
				
				Если ДатаЛиста >= ДатаНач Тогда
					Если ВыводитьОснования Тогда
						
						ОбластьСтрокаШирокаяОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						ОбластьСтрокаШирокаяОтчет.Параметры.Контрагент = Клиент;
						ОбластьСтрокаШирокаяОтчет.Параметры.КоррСчет   = КоррСчет;
						ОбластьСтрокаШирокаяОтчет.Параметры.Приход     = Приход;
						ОбластьСтрокаШирокаяОтчет.Параметры.Расход     = Расход;
						ОбластьСтрокаШирокаяОтчет.Параметры.Документ   = Документ.Документ;
						
						ТабличныйДокумент.Вывести(ОбластьСтрокаШирокаяОтчет);
						ТабличныйДокумент.Присоединить(ОбластьСтрокаШирокаяОтчет);
						
					Иначе
						
						ОбластьСтрокаОтчет.Параметры.НомерДокПечатнойФормы = НомерДокПечатнойФормы;
						ОбластьСтрокаОтчет.Параметры.Контрагент = Клиент;
						ОбластьСтрокаОтчет.Параметры.КоррСчет   = КоррСчет;
						ОбластьСтрокаОтчет.Параметры.Приход     = Приход;
						ОбластьСтрокаОтчет.Параметры.Расход     = Расход;
						ОбластьСтрокаОтчет.Параметры.Документ   = Документ.Документ;
						
						ТабличныйДокумент.Вывести(ОбластьСтрокаОтчет);
						ТабличныйДокумент.Присоединить(ОбластьСтрокаОтчет);
					КонецЕсли;
				КонецЕсли;
				
				ДобавитьОбороты(РабочаяТаблица, Приход, Расход);
				
			КонецЦикла;
			
			ПриходЗаДень = РабочаяТаблица.Итог("Приход");
			РасходЗаДень = РабочаяТаблица.Итог("Расход");
			
			Если ДатаЛиста >= ДатаНач Тогда
				
				ОбластьОборотОтчет.Параметры.ПриходЗаДень = ПриходЗаДень;
				ОбластьОборотОтчет.Параметры.РасходЗаДень = РасходЗаДень;
				
				ТабличныйДокумент.Вывести(ОбластьОборотОтчет);
				ТабличныйДокумент.Присоединить(ОбластьОборотОтчет);
				
			КонецЕсли;
			
			ПерваяСтрока = Истина;
			Остаток      = Остаток + ПриходЗаДень - РасходЗаДень;
			
			Если ДатаЛиста >= ДатаНач Тогда
				
				ОбластьКонечныйОстатокОтчет.Параметры.ОстатокКонец = Остаток;
				
				ТабличныйДокумент.Вывести(ОбластьКонечныйОстатокОтчет);
				ТабличныйДокумент.Присоединить(ОбластьКонечныйОстатокОтчет);
				
				ОбластьПодвалОтчет.Параметры.НадписьКолПриходныхРасходных= ?(КоличествоПриходныхДокументов>0, ЧислоПрописью(КоличествоПриходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ")
					+ НСтр("ru = 'приходных и'") + " "
					+ ?(КоличествоРасходныхДокументов>0,ЧислоПрописью(КоличествоРасходныхДокументов,"НД=Ложь",",,,,,,,,0")," - ")
					+ НСтр("ru = 'расходных получил.'");
				
				Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(Организация, ТекущаяДатаСеанса());
				
				ОбластьПодвалОтчет.Параметры.ГлБухгалтер = Руководители.ГлавныйБухгалтер;
				ФамилияИмяОтчество = ФормированиеПечатныхФормСервер.ФамилияИмяОтчество(ВыборкаПоДокументамКассоваяКнига.Ответственный, ТекущаяДатаСеанса());
				ОбластьПодвалОтчет.Параметры.Кассир = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФамилияИмяОтчество);
				
				ТабличныйДокумент.Вывести(ОбластьПодвалОтчет);
				ТабличныйДокумент.Присоединить(ОбластьПодвалОтчет);
			КонецЕсли;
			
			Строка.Остаток = 0;
			
			Если (ДатаЛиста = ВыборкаИтоговПоДням.Период) Тогда
				СуммаКонечныйОстатокДт = ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт + ВыборкаИтоговПоДням.СуммаОборот;
				Строка.Остаток = СуммаКонечныйОстатокДт - РабочаяТаблица.Итог("Остаток");
			Иначе
				Если ПоПроводкам Тогда
					Строка.Остаток = ВыборкаИтоговПоДням.СуммаНачальныйОстатокДт - РабочаяТаблица.Итог("Остаток");
				Иначе
					Строка.Остаток = -РабочаяТаблица.Итог("Остаток");
				КонецЕсли;
			КонецЕсли;
			
			РабочаяТаблица.ЗаполнитьЗначения(0,"Приход, Расход");
			
			Если ПоПроводкам И ДатаЛиста = ВыборкаИтоговПоДням.Период Тогда
				ПоПроводкам = ВыборкаИтоговПоДням.Следующий();
			КонецЕсли;
			Если ПоДокументам И ДатаЛиста = ВыборкаДокументовПоДням.День Тогда
				ПоДокументам = ВыборкаДокументовПоДням.Следующий();
			КонецЕсли;
			
			ВывестиПодвал = Истина;
			
		КонецЦикла;
		
		Если ВывестиПодвал Тогда
			
			Если ВыборкаПоДокументамКассоваяКнига.ТипЛиста = Перечисления.ТипыЛистовКассовойКниги.ПоследнийВМесяце Тогда
				
				КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
				ВыборкаПоДокументамКассоваяКнига.Организация,
				ВыборкаПоДокументамКассоваяКнига.ДоговорПлатежногоАгента,
				НачалоМесяца(ВыборкаПоДокументамКассоваяКнига.Дата),
				КонецМесяца(ВыборкаПоДокументамКассоваяКнига.Дата));
				
				ОбластьЛистовЗаМесяцОтчет.Параметры.НадписьЛистовЗаМесяц = НСтр("ru = 'Количество листов кассовой книги за месяц:'")
																			+ " " + КоличествоЛистов;
				ТабличныйДокумент.Вывести(ОбластьЛистовЗаМесяцОтчет);
				ТабличныйДокумент.Присоединить(ОбластьЛистовЗаМесяцОтчет);
				
			КонецЕсли;
			
			Если ВыборкаПоДокументамКассоваяКнига.ТипЛиста = Перечисления.ТипыЛистовКассовойКниги.ПоследнийВГоду Тогда
				
				КоличествоЛистов = ПолучитьКоличествоЛистовКассовойКнигиЗаПериодПоОрганизации(
				ВыборкаПоДокументамКассоваяКнига.Организация,
				ВыборкаПоДокументамКассоваяКнига.ДоговорПлатежногоАгента,
				НачалоГода(ВыборкаПоДокументамКассоваяКнига.Дата),
				КонецГода(ВыборкаПоДокументамКассоваяКнига.Дата));
				
				ОбластьЛистовЗаГодОтчет.Параметры.НадписьЛистовЗаГод = НСтр("ru = 'Количество листов кассовой книги за год:'")
																			+ " " + КоличествоЛистов;
				ТабличныйДокумент.Вывести(ОбластьЛистовЗаГодОтчет);
				ТабличныйДокумент.Присоединить(ОбластьЛистовЗаГодОтчет);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
		ТабличныйДокумент,
		НомерСтрокиНачало,
		ОбъектыПечати,
		ВыборкаПоДокументамКассоваяКнига.Ссылка);
		
	КонецЦикла; // Цикл по выделенным документам.
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
