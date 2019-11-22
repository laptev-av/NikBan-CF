﻿
#Область ОписаниеПеременных

// Контекст взаимодействия с сервисом ИПП
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Интернет-поддержки недоступно при работе в модели сервиса.'");
	КонецЕсли;
	
	Логин = Параметры.login;
	Если ЗначениеЗаполнено(Логин) Тогда
		Пароль = Новый УникальныйИдентификатор;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИПП_АктивизироватьФормуПодключенияИПП" Тогда
		Если Параметр.Активизирована <> Истина Тогда
			Если ВладелецФормы = Неопределено
				Или РежимОткрытияОкна <> РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьЭтуФорму", 0.1, Истина);
			ИначеЕсли ЭтотОбъект.ВладелецФормы <> Неопределено Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьВладельца", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
		
	Иначе
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Подключение Интернет-поддержки'"),
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не получается подключить Интернет-поддержку пользователей.
					|Для подключения указывается логин %1.'"),
				Элементы.Логин.ТекстРедактирования),
			,
			,
			Новый Структура("Логин, НастройкиСоединенияССерверами",
				Элементы.Логин.ТекстРедактирования,
				НастройкиСоединенияССерверами));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуВосстановленияПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуРегистрацииНовогоПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОКБизнесПроцесс(Команда)
	
	Если ЗаполнениеЛогинаИПароляКорректно() Тогда
		ПродолжитьБизнесПроцесс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Общего назначения.

&НаКлиенте
Функция ЗаполнениеЛогинаИПароляКорректно()
	
	Если ПустаяСтрока(Логин) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Логин"" не заполнено.'"),
			,
			"Логин");
		Возврат Ложь;
		
	ИначеЕсли ПустаяСтрока(Пароль) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Пароль"" не заполнено.'"),
			,
			"Пароль");
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура АктивизироватьЭтуФорму()
	
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьВладельца()
	
	ЭтотОбъект.ВладелецФормы.Активизировать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка бизнес-процессов.

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс()
	
	Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"login",
		Логин);
	Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"savePassword",
		"true");
	
	// Сохранение логина и пароля пользователя, при успешной авторизации
	// будут переданы в метод
	// ИнтернетПоддержкаПользователейПереопределяемый.ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки().
	
	КонтекстВзаимодействия.КСКонтекст.Логин = Логин;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "login", Логин));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "password", Пароль));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "savePassword", "true"));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти
