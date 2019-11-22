﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Параметры.Отбор.Свойство("Магазин") Тогда
		
		Магазин = Параметры.Отбор.Магазин;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапретитьИзменениеМагазина") Тогда
		
		Элементы.ОтборМагазин.Видимость = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ИнтервалыРаботыМагазинов.Форма.ФормаЭлемента.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля "Магазин".
&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	МагазинОтборПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - обработчик события "ПриИзменении" поля "магазин".
//
&НаСервере
Процедура МагазинОтборПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
		
КонецПроцедуры

// Функция возвращает массив динамических списков, для которых требуется установка отбора.
//
&НаСервере
Функция ПолучитьМассивДинамическихСписковНаСервере()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(Список);
	
	Возврат МассивСписков;

КонецФункции

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Для Каждого ДинамическийСписок Из ПолучитьМассивДинамическихСписковНаСервере() Цикл
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДинамическийСписок, "Магазин", Магазин , ЗначениеЗаполнено(Магазин), ВидСравненияКомпоновкиДанных.Равно);
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти