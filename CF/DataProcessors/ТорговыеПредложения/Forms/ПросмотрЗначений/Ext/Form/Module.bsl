﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторКатегории", ИдентификаторКатегории);
	Параметры.Свойство("ИдентификаторРеквизитаКатегории", ИдентификаторРеквизита);
	Параметры.Свойство("Категория", Категория);
	Параметры.Свойство("ПредставлениеРеквизитаКатегории", Свойство);
	Параметры.Свойство("ТипРеквизитаРубрикатора", ТипРеквизитаРубрикатора);
	
	Если ТипРеквизитаРубрикатора = "Список" Тогда
		КлючСохраненияПоложенияОкна = "Список";
		ЗагрузитьЗначенияРеквизитаРубрикатора(Отказ);
	Иначе
		КлючСохраненияПоложенияОкна = "Значение";
		Элементы.Список.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьЗначенияРеквизитаРубрикатора(Отказ)
	
	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("ИдентификаторКатегории", ИдентификаторКатегории);
	ПараметрыМетода.Вставить("ИдентификаторХарактеристики", ИдентификаторРеквизита);
	ПараметрыКоманды = ТорговыеПредложения.ПараметрыКомандыПолучитьЗначенияХарактеристики(ПараметрыМетода, Отказ);
	Результат = БизнесСеть.ВыполнитьКомандуСервиса(ПараметрыКоманды, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЗначенияРубрикатора Из Результат Цикл
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Значение = ЗначенияРубрикатора.Значение;
	КонецЦикла;
	
	Список.Сортировать("Значение");
	
КонецПроцедуры

#КонецОбласти
