﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ТТНИсходящаяЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияЕГАИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Отправка данных на самого себя портит данные регистра Акцизные марки ЕГАИС
	Если Грузоотправитель = Грузополучатель Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Грузополучатель должен отличаться от грузоотправителя.'"),
			ЭтотОбъект,
			"Грузополучатель",,
			Отказ);
		
	КонецЕсли;
	
	Если Дата >= '20180701' Тогда
		АкцизныеМаркиЕГАИС.ПроверитьЗаполнениеАкцизныхМарокТТНИсходящейЕГАИС(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = ИнтеграцияЕГАИС.НовыйИдентификаторДокумента();
	КонецЕсли;
	
	Если СтатусПроверкиИПодбора <> Перечисления.СтатусыПроверкиИПодбораЕГАИС.Выполняется Тогда
		ДанныеПроверкиИПодбора = Неопределено;
	КонецЕсли;
	
	СуммаДокумента = Товары.Итог("Сумма");
	
	ИнтеграцияЕГАИСПереопределяемый.ЗаписатьСоответствиеНоменклатуры(ЭтотОбъект, Истина, Истина);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.РассчитатьСтатусОформленияВозвратИзРегистра2ЕГАИС(ЭтотОбъект, Отказ);
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	Идентификатор           = "";
	ИдентификаторЕГАИС      = "";
	ДатаРегистрацииДвижений = '00010101';
	ЕстьРасхождения         = Ложь;
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "Справка2");
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "КоличествоФакт");
	КонецЕсли;
	
	СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораЕГАИС.НеВыполнялось;
	ДанныеПроверкиИПодбора = Неопределено;
	АкцизныеМарки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
