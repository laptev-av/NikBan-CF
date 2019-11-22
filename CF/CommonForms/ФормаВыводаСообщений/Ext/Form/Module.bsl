﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем АдресВоВременномХранилище;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресВоВременномХранилище", АдресВоВременномХранилище) Тогда
		
		ПримененныеСкидки = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
		
		СписокСообщений.ЗагрузитьЗначения(ПримененныеСкидки.ТаблицаСообщений.ВыгрузитьКолонку("ТекстСообщения"));
		
		Если СписокСообщений.Количество() = 0  Тогда
			Отказ = Истина;
		Иначе
			НомерТекущегоСообщения = 0;
			ТекстСообщения = СписокСообщений[НомерТекущегоСообщения];
			Элементы.Назад.Доступность = Ложь;
			
			Если СписокСообщений.Количество() = 1 Тогда
				Элементы.Далее.Заголовок = "Закрыть"
			Иначе
				Элементы.Далее.Заголовок = "Далее >>"
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		Истина, "ОбщаяФорма.ФормаВыводаСообщений.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	НомерТекущегоСообщения = НомерТекущегоСообщения - 1;
	ОбновлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.Далее.Заголовок = "Закрыть" Тогда
		Закрыть();
	Иначе
		НомерТекущегоСообщения = НомерТекущегоСообщения + 1;
		ОбновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновлениеФормы()

	Элементы.Назад.Доступность = НомерТекущегоСообщения >= 1;
	
	Если (СписокСообщений.Количество() - 1) <= НомерТекущегоСообщения Тогда
		Элементы.Далее.Заголовок = "Закрыть";
		ТекстСообщения = СписокСообщений[СписокСообщений.Количество() - 1];
	Иначе
		Элементы.Далее.Заголовок = "Далее >>";
		ТекстСообщения = СписокСообщений[НомерТекущегоСообщения];
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти



