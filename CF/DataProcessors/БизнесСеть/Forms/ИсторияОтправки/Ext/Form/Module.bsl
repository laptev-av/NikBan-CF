﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропуск инициализации, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СтруктураЭД) Тогда
		Для каждого СтруктураОбмена Из Параметры.СтруктураЭД Цикл
			НоваяСтрока = Список.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОбмена);
			Если ЗначениеЗаполнено(НоваяСтрока.ЭлектронныйДокумент) Тогда
				НоваяСтрока.ПредставлениеЭД = ОбменСКонтрагентамиСлужебный.ПолучитьПредставлениеЭД(НоваяСтрока.ЭлектронныйДокумент);
			Иначе
				НоваяСтрока.ПредставлениеЭД = НоваяСтрока.НаименованиеФайла;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ЗначениеЗаполнено(Параметры.МассивСсылокЭД) Тогда
		Соответствие = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Параметры.МассивСсылокЭД, "ВладелецФайла, НаправлениеЭД");
		Для каждого ЭлементСоответствия Из Соответствие Цикл
			НоваяСтрока = Список.Добавить();
			НоваяСтрока.ЭлектронныйДокумент = ЭлементСоответствия.Ключ;
			НоваяСтрока.ВладелецЭД = ЭлементСоответствия.Значение.ВладелецФайла;
			НоваяСтрока.НаправлениеЭД = ЭлементСоответствия.Значение.НаправлениеЭД;
			НоваяСтрока.ПредставлениеЭД = ОбменСКонтрагентамиСлужебный.ПолучитьПредставлениеЭД(НоваяСтрока.ЭлектронныйДокумент);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормТаблицаДанных

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВывестиЭДНаПросмотр(Список[ВыбраннаяСтрока]);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ПолноеИмяФайла");
	ПараметрыОткрытия.Вставить("НаименованиеФайла");
	ПараметрыОткрытия.Вставить("НаправлениеЭД");
	ПараметрыОткрытия.Вставить("Контрагент");
	ПараметрыОткрытия.Вставить("Идентификатор");
	ПараметрыОткрытия.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОткрытия.Вставить("ВладелецЭД");
	ПараметрыОткрытия.Вставить("ЭлектронныйДокумент");
	ПараметрыОткрытия.Вставить("АдресХранилища");
	ПараметрыОткрытия.Вставить("ФайлАрхива");
	ПараметрыОткрытия.Вставить("Информация");
	ПараметрыОткрытия.Вставить("Статус");
	ПараметрыОткрытия.Вставить("Отправитель");
	ПараметрыОткрытия.Вставить("Получатель");
	ПараметрыОткрытия.Вставить("КонтрагентИНН");
	ПараметрыОткрытия.Вставить("КонтрагентКПП");
	ПараметрыОткрытия.Вставить("Дата");
	ПараметрыОткрытия.Вставить("Источник");

	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, СтрокаДанных,, "УникальныйИдентификатор");
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(ПараметрыОткрытия.ЭлектронныйДокумент) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", СтрокаДанных.ЭлектронныйДокумент);
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(СтрокаДанных.ЭлектронныйДокумент,ПараметрыФормы,ЭтотОбъект);
	Иначе
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента",
			Новый Структура("СтруктураЭД", ПараметрыОткрытия), ЭтотОбъект, "" + СтрокаДанных.УникальныйИдентификатор + СтрокаДанных.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
