﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ИнтеграцияГИСМ.ИспользоватьПодразделения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ИнтеграцияГИСМПереопределяемый.ВалютаРегламентированногоУчета();
	Элементы.НомераКиЗСтоимость.Заголовок = СтрЗаменить(НСтр("ru = 'Стоимость (%Валюта%)'"), "%Валюта%", ВалютаРегламентированногоУчета);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("Основание", Объект.Основание);
	Оповестить("Запись_УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомераКиЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент = Элементы.НомераКиЗНоменклатураПредставление Тогда
		ТекущиеДанные = Элементы.НомераКиЗ.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
			ПоказатьЗначение(Неопределено, ТекущиеДанные.Номенклатура);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Уведомление о ввозе маркированных товаров ЕАЭС не проведено. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Уведомление о ввозе маркированных товаров ЕАЭС было изменено. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		СтандартнаяОбработка = Ложь;
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанных"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусГИСМ()

	СтатусГИСМ         = Перечисления.СтатусыИнформированияГИСМ.Черновик;
	ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка();
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка)
		|		ИНАЧЕ Статусы.ДальнейшееДействие
		|	КОНЕЦ КАК ДальнейшееДействие
		|ИЗ
		|	РегистрСведений.СтатусыИнформированияГИСМ КАК Статусы
		|ГДЕ
		|	Статусы.ТекущееУведомление = &УведомлениеОбВвозе";
		
		Запрос.УстановитьПараметр("УведомлениеОбВвозе", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияГИСМ.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусГИСМ         = Выборка.Статус;
			ДальнейшееДействие = Выборка.ДальнейшееДействие;
			
		КонецЕсли;
		
	Иначе
		
		ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
		
	КонецЕсли;
	
	СтатусГИСМПредставление = ИнтеграцияГИСМ.ПредставлениеСтатусаГИСМ(
		СтатусГИСМ,
		ДальнейшееДействие,
		Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Форма.ФормаДокумента.ЗаписатьИЗакрыть");
	
	ОчиститьСообщения();
	
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗНоменклатураПредставление.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗ.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГИСМ);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<В основании отсутствует>'"));

КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ОбновитьСтатусГИСМ();
	ИнтеграцияГИСМПереопределяемый.ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Объект.Основание, Объект.НомераКиЗ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусГИСМ();
	ИнтеграцияГИСМПереопределяемый.ЗаполнитьПредставлениеТоваровУведомленияПоНомерамКиЗОснования(Объект.Основание, Объект.НомераКиЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
