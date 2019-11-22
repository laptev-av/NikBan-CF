﻿#Область ПрограммныйИнтерфейс

// Открывает отчет по версиям объекта в режиме сравнения версий.
//
// Параметры:
//  Ссылка                       - ЛюбаяСсылка - ссылка на версионируемый объект;
//  АдресСериализованногоОбъекта - Строка - адрес двоичных данных сравниваемой версии
//                                          объекта во временном хранилище.
//
Процедура ОткрытьОтчетПоИзменениям(Ссылка, АдресСериализованногоОбъекта) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ссылка", Ссылка);
	Параметры.Вставить("АдресСериализованногоОбъекта", АдресСериализованногоОбъекта);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", Параметры);
	
КонецПроцедуры

// Функция открывает отчет по версии объекта переданной в параметре АдресСериализованногоОбъекта.
//
// Параметры:
//  Ссылка                       - ЛюбаяСсылка - ссылка на версионируемый объект;
//  АдресСериализованногоОбъекта - Строка - адрес двоичных данных версии объекта во временном хранилище.
//
Процедура ОткрытьОтчетПоВерсииОбъекта(Ссылка, АдресСериализованногоОбъекта) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Ссылка", Ссылка);
	Параметры.Вставить("АдресСериализованногоОбъекта", АдресСериализованногоОбъекта);
	Параметры.Вставить("ПоВерсии", Истина);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает отчет о версии или о сравнении версий.
//
// Параметры:
//	Ссылка - Ссылка на объект
//	СравниваемыеВерсии - Массив - Содержит массив сравниваемых версий,
//	если версия одна, то открывается отчет о версии.
//
Процедура ОткрытьОтчетСравненияВерсий(Ссылка, СравниваемыеВерсии) Экспорт
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка", Ссылка);
	ПараметрыОтчета.Вставить("СравниваемыеВерсии", СравниваемыеВерсии);
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

#КонецОбласти
