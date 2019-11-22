﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьИнформациюОСопоставлении();
	КонецЕсли;
	
	ПустойКонтрагент = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	
	Если ПустойКонтрагент = "" Или ПустойКонтрагент = Неопределено Тогда
		Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Истина;
		Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Ложь;
	Иначе
		Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПустойКонтрагент))
			И Не ПравоДоступа("Чтение", Метаданные.Справочники.КлассификаторОрганизацийЕГАИС)
			Или Не ПравоДоступа("Чтение", ПустойКонтрагент.Метаданные()) Тогда
			Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Истина;
			Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Ложь;
		Иначе
			Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Ложь;
			Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	СопоставитьИмпортераИПроизводителя();
	
	Элементы.ГруппаДанныеЕГАИС.ТолькоПросмотр = Не ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ИзменениеСопоставленияАлкогольнойПродукцииЕГАИС" Тогда
		
		ОбновитьИнформациюОСопоставлении();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбновитьИнформациюОСопоставлении();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОЗаписи(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИмпортерПриИзменении(Элемент)
	
	СопоставитьИмпортераИПроизводителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	
	СопоставитьИмпортераИПроизводителя();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьИнформациюОСопоставлении()
	
	Запрос = Новый Запрос();
	Запрос.Текст = Справочники.КлассификаторАлкогольнойПродукцииЕГАИС.ТекстЗапросаИнформацияОСопоставлении();
	Запрос.УстановитьПараметр("АлкогольнаяПродукция", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество = 1 Тогда
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				ИнтеграцияЕГАИСПереопределяемый.ПредставлениеНоменклатуры(
					Выборка.Номенклатура,
					Выборка.Характеристика, Неопределено),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГИСМ,,
				"ОткрытьСоответствиеНоменклатурыЕГАИС");
			
		ИначеЕсли Выборка.Количество > 1 Тогда
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				СтрШаблон(НСтр("ru = '%1 ( + еще %2...)'"), Выборка.НоменклатураНаименование, Выборка.Количество - 1),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЦветГиперссылкиГИСМ,,
				"ОткрытьСоответствиеНоменклатурыЕГАИС");
			
		Иначе
			
			Сопоставлено = Новый ФорматированнаяСтрока(
				НСтр("ru = '<Не сопоставлено>'"),
				Новый Шрифт(,,,,Истина),
				ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи,,
				"ОткрытьСоответствиеНоменклатурыЕГАИС");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлассификаторАлкогольнойПродукцииЕГАИС", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура СопоставитьИмпортераИПроизводителя()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(Объект.Импортер) Тогда
		КонтрагентИмпортер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Импортер, "Контрагент");
	Иначе
		КонтрагентИмпортер = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда
		КонтрагентПроизводитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Производитель, "Контрагент");
	Иначе
		КонтрагентПроизводитель = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	КонецЕсли;
	
	// Получение текстового представления
	КонтрагентИмпортерТекстовоеПредставление      = Строка(КонтрагентИмпортер);
	КонтрагентПроизводительТекстовоеПредставление = Строка(КонтрагентПроизводитель);
	ИмпортерТекстовоеПредставление                = Строка(Объект.Импортер);
	ПроизводительТекстовоеПредставление           = Строка(Объект.Производитель);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставленоОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСоответствиеНоменклатурыЕГАИС" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияЕГАИСКлиент.ОткрытьФормуСопоставленияАлкогольнойПродукции(
			Объект.Ссылка,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
