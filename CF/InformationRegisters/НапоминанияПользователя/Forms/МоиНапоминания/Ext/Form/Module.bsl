﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		Элементы.Переместить(Элементы.КнопкаСоздать, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.КнопкаИзменить, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.КнопкаУдалить, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.СтандартныеКоманды, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ФормаСправка, Элементы.ФормаКоманднаяПанель);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	СтрокаВыбрана = Не Элемент.ТекущаяСтрока = Неопределено;
	Элементы.КнопкаУдалить.Доступность = СтрокаВыбрана;
	Элементы.КнопкаИзменить.Доступность = СтрокаВыбрана;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "Источник" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Источник) Тогда
			ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Источник);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Источник напоминания не задан.'"));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", Элементы.Список.ТекущаяСтрока));
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	УдалитьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтключитьНапоминание(ПараметрыНапоминания)
	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ПараметрыНапоминания, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНапоминание()
	
	КнопкиДиалога = Новый СписокЗначений;
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не удалять'"));
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьНапоминаниеЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить напоминание?'"), КнопкиДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНапоминаниеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	КлючЗаписи = Элементы.Список.ТекущаяСтрока;
	ПараметрыНапоминания = Новый Структура("Пользователь,ВремяСобытия,Источник");
	ЗаполнитьЗначенияСвойств(ПараметрыНапоминания, Элементы.Список.ТекущиеДанные);
	
	ОтключитьНапоминание(ПараметрыНапоминания);
	НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ПараметрыНапоминания);
	Оповестить("Запись_НапоминанияПользователя", Новый Структура, КлючЗаписи);
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
	
КонецПроцедуры

#КонецОбласти
