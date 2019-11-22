﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки – Коллекция – Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета – СтрокаДереваЗначений – Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); 
// Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Продажи");
	НастройкиВарианта.Описание = НСтр("ru='Анализ продаж в произвольных разрезах'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиБезПодарочныхСертификатов");
	НастройкиВарианта.Описание = НСтр("ru='Анализ продаж в произвольных разрезах с исключением продаж подарочных сертификатов'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПродажиПоТоварнымКатегориям");
	НастройкиВарианта.Описание = НСтр("ru='Анализ продаж в разрезе товарных категорий'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Продажи, "ПродажиПоТоварнымКатегориям");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Продажи);
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Продажи, "Продажи");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Маркетинг.Подсистемы.Ассортимент.Подсистемы.ДополнительныеОтчетыПоАнализуАссортимента);
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.Продажи, "ПродажиБезПодарочныхСертификатов");
	Вариант.Размещение.Удалить(Метаданные.Подсистемы.Маркетинг.Подсистемы.Ассортимент.Подсистемы.ДополнительныеОтчетыПоАнализуАссортимента);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
