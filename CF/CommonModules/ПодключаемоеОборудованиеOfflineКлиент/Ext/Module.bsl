﻿
#Область ПрограммныйИнтерфейсВесыСПечатью

// Процедура завершения выгрузки товаров в весы с печатью этикеток.
//
Процедура НачатьВыгрузкуТоваровВВесыЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Устройство:'") + Символы.НПП + РезультатВыполнения.ИдентификаторУстройства + Символы.ПС;
	Если РезультатВыполнения.Результат Тогда
		ПодключаемоеОборудованиеOfflineВызовСервера.ПриВыгрузкеТоваровВУстройство(РезультатВыполнения.ИдентификаторУстройства, Параметры.СтруктураДанные, 
			Параметры.ЧастичнаяВыгрузка, РезультатВыполнения.Результат);
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Товары успешно выгружены!'");
	Иначе
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Выгрузить товары не удалось:'") + Символы.НПП + РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	Если Параметры.ОповещениеПриВыгрузке <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеПриВыгрузке, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выгружает товары в весы с печатью этикеток.
//
Процедура НачатьВыгрузкуТоваровВВесы(ОповещениеПриВыгрузке, МассивУстройств, ЧастичнаяВыгрузка) Экспорт
	
	Если МассивУстройств.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать устройство, для которого требуется выгрузить товары.'"), 10);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется выгрузка товаров в весы с печатью этикеток...'"));
	
	Для Каждого ИдентификаторУстройства Из МассивУстройств Цикл
	
		СтруктураДанные = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьДанныеДляВесов(ИдентификаторУстройства, ЧастичнаяВыгрузка);
		Контекст = Новый Структура("ОповещениеПриВыгрузке, СтруктураДанные, ЧастичнаяВыгрузка", ОповещениеПриВыгрузке, СтруктураДанные, ЧастичнаяВыгрузка);
		
		Если Не ЗначениеЗаполнено(СтруктураДанные) Или СтруктураДанные.Данные.Количество() = 0 Тогда
			
			Если Не ЗначениеЗаполнено(СтруктураДанные) Тогда
				ОписаниеОшибки = НСтр("ru = 'План обмена не установлен!'");
			ИначеЕсли СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками = 0 Тогда
				ОписаниеОшибки = НСтр("ru = 'Нет данных для выгрузки!'");
			Иначе
				ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Данные не выгружены. Обнаружено ошибок:%1'"), СтруктураДанные.КоличествоНеВыгруженныхСтрокСОшибками);
			КонецЕсли;
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ОписаниеОшибки, ИдентификаторУстройства);
			НачатьВыгрузкуТоваровВВесыЗавершение(РезультатВыполнения, Контекст);
			
		Иначе
			ИдентификаторКлиента = Новый УникальныйИдентификатор;
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровВВесыЗавершение", ЭтотОбъект, Контекст);
			МенеджерОборудованияКлиент.НачатьВыгрузкуДанныеВВесыСПечатьюЭтикеток(ОписаниеОповещения, 
				ИдентификаторКлиента, СтруктураДанные.Данные, ИдентификаторУстройства, СтруктураДанные.ЧастичнаяВыгрузка)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура завершения выгрузки товаров в весы с печатью этикеток.
//
Процедура НачатьОчисткуТоваровВВесахЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ПриОчисткеТоваровВУстройстве(РезультатВыполнения.ИдентификаторУстройства, РезультатВыполнения.Результат);
	
	ТекстСообщения = НСтр("ru = 'Устройство:'") + Символы.НПП + РезультатВыполнения.ИдентификаторУстройства + Символы.ПС;
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Товары успешно очищены!'");
	Иначе
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Очистить товары не удалось:'") + Символы.НПП + РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	Если Параметры.ОповещениеПриОчисткеДанные <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеПриОчисткеДанные, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура очищает список товаров в весах с печатью этикеток.
//
Процедура НачатьОчисткуТоваровВВесах(ОповещениеПриОчисткеДанные, МассивУстройств) Экспорт
	
	Если МассивУстройств.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать устройство, для которого требуется очистить товары.'"), 10);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется очистка товаров в весы с печатью этикеток...'"));
	
	Для Каждого ИдентификаторУстройства Из МассивУстройств Цикл
		
		ИдентификаторКлиента = Новый УникальныйИдентификатор;
		Контекст = Новый Структура("ОповещениеПриОчисткеДанные", ОповещениеПриОчисткеДанные);
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровВВесахЗавершение", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.НачатьОчисткуТоваровВВесахСПечатьюЭтикеток(ОписаниеОповещения, ИдентификаторКлиента, ИдентификаторУстройства)
		
	КонецЦикла;
	                       
КонецПроцедуры

#КонецОбласти
