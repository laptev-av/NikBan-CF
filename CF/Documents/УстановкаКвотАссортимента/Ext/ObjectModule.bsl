﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ЭтоНовый() Тогда
		ИнициализироватьДокумент();
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный		 = Пользователи.ТекущийПользователь();
	ДатаНачалаДействия	 = НачалоМесяца(ТекущаяДатаСеанса());
	ПроверитьДоступностьОбъектаПланированияПриЗаполнении();
	Если ЗначениеЗаполнено(ОбъектПланирования) Тогда
		Если Документы.УстановкаКвотАссортимента.СуществуетПлан(ОбъектПланирования, ДатаНачалаДействия, Ссылка) Тогда
			ДатаНачалаДействия = Дата(1,1,1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЕстьПлан = Документы.УстановкаКвотАссортимента.СуществуетПлан(ОбъектПланирования, ДатаНачалаДействия, Ссылка);
		Если ЕстьПлан Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'На %1 для формата ""%2"" существует документ установки квот.'");
			ТекстСообщения = ТекстСообщения + НСтр("ru = 'Установка квот может производиться не чаще 1 раза в месяц.'");
			ТекстСообщения = ТекстСообщения + НСтр("ru = 'Выберите другую дату или формат магазинов.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ТекстСообщения,
								Формат(ДатаНачалаДействия, "ДЛФ=D"),
								ОбъектПланирования);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.УстановкаКвотАссортимента.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	АссортиментСервер.ОтразитьКвотыАссортимента(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент()
	
	Ответственный		 = Пользователи.ТекущийПользователь();
	ДатаНачалаДействия	 = НачалоМесяца(ТекущаяДатаСеанса());
	ОбъектПланирования	 = ЗначениеНастроекПовтИсп.ПолучитьФорматМагазинаПоУмолчанию(ОбъектПланирования);
	ПроверитьДоступностьОбъектаПланированияПриЗаполнении();
	Если ЗначениеЗаполнено(ОбъектПланирования) Тогда
		Если Документы.УстановкаКвотАссортимента.СуществуетПлан(ОбъектПланирования, ДатаНачалаДействия, Ссылка) Тогда
			ДатаНачалаДействия = Дата(1,1,1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДоступностьОбъектаПланированияПриЗаполнении()
	
	ДоступностьПравила = ОбщегоНазначенияРТВызовСервера.ПроверитьДоступКРеквизиту(
							ОбъектПланирования,
							"ПравилоЦенообразования",
							"Справочник.ПравилаЦенообразования");
	Если НЕ ДоступностьПравила Тогда
		ОбъектПланирования = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
