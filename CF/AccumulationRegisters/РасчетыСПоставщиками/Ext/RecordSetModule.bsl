﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	Если Не ТребуетсяКонтроль Тогда
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияРасчетыСПоставщикамиПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.Магазин              КАК Магазин,
	|	Таблица.Поставщик            КАК Поставщик,
	|	Таблица.ДокументРасчета      КАК ДокументРасчета,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Сумма
	|		ИНАЧЕ -Таблица.Сумма
	|	КОНЕЦ                            КАК СуммаПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОплате
	|		ИНАЧЕ -Таблица.КОплате
	|	КОНЕЦ                            КАК КОплатеПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КПоступлению
	|		ИНАЧЕ -Таблица.КПоступлению
	|	КОНЕЦ                            КАК КПоступлениюПередЗаписью
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиПередЗаписью
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И (НЕ &ЭтоНовый)";
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаИзменений.Магазин КАК Магазин,
	|	ТаблицаИзменений.Поставщик КАК Поставщик,
	|	ТаблицаИзменений.ДокументРасчета КАК ДокументРасчета,
	|	СУММА(ТаблицаИзменений.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ТаблицаИзменений.КОплатеИзменение) КАК КОплатеИзменение,
	|	СУММА(ТаблицаИзменений.КПоступлениюИзменение) КАК КПоступлениюИзменение
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Магазин КАК Магазин,
	|		Таблица.Поставщик КАК Поставщик,
	|		Таблица.ДокументРасчета КАК ДокументРасчета,
	|		Таблица.СуммаПередЗаписью КАК СуммаИзменение,
	|		Таблица.КОплатеПередЗаписью КАК КОплатеИзменение,
	|		Таблица.КПоступлениюПередЗаписью КАК КПоступлениюИзменение
	|	ИЗ
	|		ДвиженияРасчетыСПоставщикамиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Магазин,
	|		Таблица.Поставщик,
	|		Таблица.ДокументРасчета,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Сумма
	|			ИНАЧЕ Таблица.Сумма
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КОплате
	|			ИНАЧЕ Таблица.КОплате
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КПоступлению
	|			ИНАЧЕ Таблица.КПоступлению
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Магазин,
	|	ТаблицаИзменений.Поставщик,
	|	ТаблицаИзменений.ДокументРасчета
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ТаблицаИзменений.СуммаИзменение) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.КОплатеИзменение) <> 0
	|		ИЛИ СУММА(ТаблицаИзменений.КПоступлениюИзменение) <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияРасчетыСПоставщикамиПередЗаписью";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияРасчетыСПоставщикамиИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
