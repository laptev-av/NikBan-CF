﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если (Запись.ВидДвижения = ВидДвиженияНакопления.Расход И Запись.Заказано <> 0) Тогда
			ТребуетсяКонтроль = УправлениеПользователями.ПолучитьБулевоЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.КонтролироватьОстатокПриПроведении, Ложь);
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Не ТребуетсяКонтроль Тогда
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;

	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения = Истина;

	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыНаСкладахПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.Номенклатура              КАК Номенклатура,
	|	Таблица.Характеристика            КАК Характеристика,
	|	Таблица.Магазин                   КАК Магазин,
	|	Таблица.Заказ                     КАК Заказ,
	|	Таблица.КодСтроки                 КАК КодСтроки,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Заказано
	|		ИНАЧЕ -Таблица.Заказано
	|	КОНЕЦ                            КАК ЗаказаноПередЗаписью
	|ПОМЕСТИТЬ ДвиженияЗаказыПокупателейПередЗаписью
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей КАК Таблица
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
	|	ТаблицаИзменений.Номенклатура             КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика           КАК Характеристика,
	|	ТаблицаИзменений.Магазин                  КАК Магазин,
	|	ТаблицаИзменений.Заказ                    КАК Заказ,
	|	ТаблицаИзменений.КодСтроки                КАК КодСтроки,
	|	СУММА(ТаблицаИзменений.ЗаказаноИзменение) КАК ЗаказаноИзменение
	|ПОМЕСТИТЬ ДвиженияЗаказыПокупателейИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура                    КАК Номенклатура,
	|		Таблица.Характеристика                  КАК Характеристика,
	|		Таблица.Магазин                         КАК Магазин,
	|		Таблица.Заказ                           КАК Заказ,
	|		Таблица.КодСтроки                       КАК КодСтроки,
	|		Таблица.ЗаказаноПередЗаписью            КАК ЗаказаноИзменение
	|	ИЗ
	|		ДвиженияЗаказыПокупателейПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Магазин,
	|		Таблица.Заказ,
	|		Таблица.КодСтроки,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Заказано
	|			ИНАЧЕ Таблица.Заказано
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗаказыПокупателей КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Магазин,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Заказ,
	|	ТаблицаИзменений.КодСтроки
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.ЗаказаноИзменение) > 0 
	|;
	// По Количество к не правильному состоянию регистра приведет уменьшение прихода и увеличение расхода.
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияЗаказыПокупателейПередЗаписью";
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияЗаказыПокупателейИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
