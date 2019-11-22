﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
		
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("КодКарты");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	ИначеЕсли ЗначениеЗаполнено(КодКарты) Тогда
		
		МаркетинговыеАкцииСервер.ПроверитьИспользованиеКодаКарты(ЭтотОбъект, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриКопировании"
// для объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ОбъектКопирования.ЭтоГруппа Тогда
		КодКарты = "";
	КонецЕсли;
	ГруппаВладельцаКартыПоШаблону = Справочники.ФизическиеЛица.ПустаяСсылка();
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидКарты = Перечисления.ВидыИнформационныхКарт.Штриховая Тогда
		КодКарты = "";
	КонецЕсли;
	
	Если ТипЗнч(ВладелецКарты) = Тип("СправочникСсылка.Контрагенты")
		ИЛИ ТипКарты = Перечисления.ТипыИнформационныхКарт.Регистрационная Тогда
		ДатаСледующегоОпроса = Дата("00010101");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
