﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = МассивНеиспользуемыхРеквизитов();
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	МассивОчищаемыхРеквизитов = МассивНеиспользуемыхРеквизитов();
	
	Для Каждого ИмяРеквизита Из МассивОчищаемыхРеквизитов Цикл
		ЭтотОбъект[ИмяРеквизита] = Неопределено;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Период) И ВидДокумента <> Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации Тогда
		Период = НачалоМесяца(Период);
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДвиженияМеждуРегистрами.Очистить();
	ДвиженияПоСправке2.Очистить();
	ИнформацияОбОрганизацииЕГАИС.Очистить();
	НеобработанныеТТН.Очистить();
	ОбработанныеЧеки.Очистить();
	ОстаткиАлкогольнойПродукции.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = ТекущаяДатаСеанса();
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если (ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки) И НЕ ЗначениеЗаполнено(Период) Тогда
		Период = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если КодФСРАР = Неопределено Тогда
		КодФСРАР = Справочники.КлассификаторОрганизацийЕГАИС.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Функция МассивНеиспользуемыхРеквизитов()
	
	Результат = Новый Массив;
	Результат.Добавить("Период");
	Результат.Добавить("АлкогольнаяПродукция");
	Результат.Добавить("Справка2");
	Результат.Добавить("КодФСРАР");
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияМеждуРегистрами Тогда
		
		Результат.Удалить(Результат.Найти("Период"));
		Результат.Удалить(Результат.Найти("АлкогольнаяПродукция"));
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаДвиженияПоСправке2 Тогда
		
		Результат.Удалить(Результат.Найти("Справка2"));
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИнформацияОбОрганизации Тогда
		
		Результат.Удалить(Результат.Найти("Период"));
		Результат.Удалить(Результат.Найти("КодФСРАР"));
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаНеобработанныеТТН Тогда
		
		// Нет параметров запроса
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОбработанныеЧеки Тогда
		
		Результат.Удалить(Результат.Найти("Период"));
		Результат.Удалить(Результат.Найти("АлкогольнаяПродукция"));
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре1
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре2 Тогда
		
		// Нет параметров запроса
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаОстаткиВРегистре3 Тогда
		
		Если ЗначениеЗаполнено(АлкогольнаяПродукция) Тогда
			Результат.Удалить(Результат.Найти("АлкогольнаяПродукция"));
		КонецЕсли;
		Если ЗначениеЗаполнено(Справка2) Тогда
			Результат.Удалить(Результат.Найти("Справка2"));
		КонецЕсли;
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОтчетаИсторияСправок2 Тогда
		
		Результат.Удалить(Результат.Найти("Справка2"));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли