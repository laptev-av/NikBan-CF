﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		Номер = Штрихкод;
		НомерПриИзменении(Элементы.Номер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
														 "ВидНоменклатуры",
														 ВидНоменклатуры,
														 ВидСравненияКомпоновкиДанных.Равно,
														 ,
														 Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.СерииНоменклатуры.Форма.ФормаСписка.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
														 "ВидНоменклатуры",
														 ВидНоменклатуры,
														 ВидСравненияКомпоновкиДанных.Равно,
														 ,
														 Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
														 "Номер",
														 Номер,
														 ВидСравненияКомпоновкиДанных.Содержит,
														 ,
														 ЗначениеЗаполнено(Номер));
														 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Справочник.СерииНоменклатуры.Форма.ФормаЭлемента.СозданиеНового");

    Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать вид номенклатуры.'");
			
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидНоменклатуры",ВидНоменклатуры);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти