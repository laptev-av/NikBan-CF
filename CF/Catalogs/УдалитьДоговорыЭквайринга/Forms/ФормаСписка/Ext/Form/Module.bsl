﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = Настройки.Получить("Организация");
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.УдалитьДоговорыЭквайринга.Форма.ФормаЭлемента.Открытие");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.УдалитьДоговорыЭквайринга.Форма.ФормаСписка.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Отказ = Истина;
		СтруктураПараметры = Новый Структура();
		СтруктураПараметры.Вставить("Основание", Новый Структура("Организация", Организация));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
