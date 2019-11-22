﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию.
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт
	
	НастройкиПланаОбмена.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	НастройкиПланаОбмена.ИмяКонфигурацииИсточника = СокрЛП(Метаданные.Имя);
	НастройкиПланаОбмена.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииВариантовНастроекОбмена   = Истина;
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными = Истина;
	
	ИспользуемыеТранспортыСообщенийОбмена = Новый Массив;
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	ИспользуемыеТранспортыСообщенийОбмена.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);


	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ИспользуемыеТранспортыСообщенийОбмена;
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену =
	НСтр("ru = 'Позволяет синхронизировать данные между приложениями ""1С:Розница, ред. 2.2"" и ""1С:Отчетность предпринимателя, ред. 2.0"". 
	|Синхронизация односторонняя. Из приложения ""Розница"" в приложение ""Отчетность предпринимателя"" переносятся все необходимые данные 
	|для подготовки и сдачи отчетности. Для получения более подробной информации нажмите на ссылку Подробное описание.'");
	
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Отчетность предпринимателя, ред. 2.0'");
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "ОтчетностьПредпринимателя";

	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена РТ-ОП'");
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Отчетность предпринимателя, ред. 2.0'");
	
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ОбменРозницаОтчетностьПредпринимателя.Форма.ПодробнаяИнформация";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли