﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
	
	// Заполнение полей формы
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	СтрокаБесплатныхПакетов = СтрЗаменить(
		СокрЛП(Параметры.freePackagesED),
			   Символ(160),
			   "");
	СтрокаНераспределено =  СтрЗаменить(
		СокрЛП(Параметры.unallocatedPackagesED),
			   Символ(160),
			   "");
	
	СтрокаДатыНачала    = Параметры.begindatetarifED;
	СтрокаДатыОкончания = Параметры.enddatetarifED;
	СтрокаДатыЗаявки    = Параметры.dateRequestED;
	НомерЗаявки         = Параметры.numberRequestED;
	СтатусЗаявкиED      = Параметры.applicationStatusED;
	КодОтказа           = Параметры.codeErrorED;
	ТекстОтказа         = Параметры.textErrorED;
	
	ДатаЗаявки    = ПолучитьДатуИзСтрокиДатыССервера(СтрокаДатыЗаявки);
	ДатаНачала    = ПолучитьДатуИзСтрокиДатыССервера(СтрокаДатыНачала);
	ДатаОкончания = ПолучитьДатуИзСтрокиДатыССервера(СтрокаДатыОкончания);
	
	Попытка
		БесплатныхПакетов = Число(СтрокаБесплатныхПакетов);
	Исключение
		БесплатныхПакетов = 0;
	КонецПопытки;
	
	Попытка
		Нераспределено = Число(СтрокаНераспределено);
	Исключение
		Нераспределено = 0;
	КонецПопытки;
	
	МаксимальныйТариф = БесплатныхПакетов + Нераспределено;
	
	СтрокаМаксТарифа = СтрЗаменить(Строка(МаксимальныйТариф), Символ(160), "");
	ТекстПриглашения = Элементы.НадписьОформленияЗаявки.Заголовок;
	Элементы.НадписьОформленияЗаявки.Заголовок = СтрЗаменить(ТекстПриглашения, "1000", СтрокаМаксТарифа);
	
	Элементы.БесплатныхПакетов.МаксимальноеЗначение = МаксимальныйТариф;
	
	ТекстЗаголовка = НСтр("ru = 'Период: с %1 по %2'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", Формат(ДатаНачала, "ДЛФ=D"));
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%2", Формат(ДатаОкончания, "ДЛФ=D"));
	
	Элементы.ПериодТарификации.Заголовок = ТекстЗаголовка;
	
	ЗаголовокЗаявки = НСтр("ru = 'Заявка №%1 от %2'");
	ЗаголовокЗаявки = СтрЗаменить(ЗаголовокЗаявки, "%1", НомерЗаявки);
	ЗаголовокЗаявки = СтрЗаменить(ЗаголовокЗаявки, "%2", Формат(ДатаЗаявки, "ДЛФ=DDT"));
	
	Элементы.НадписьЗаявка.Заголовок  = ЗаголовокЗаявки;
	Элементы.НадписьЗаявка1.Заголовок = ЗаголовокЗаявки;
	Элементы.НадписьЗаявка2.Заголовок = ЗаголовокЗаявки;
	
	ОбработатьСтатусФормы();
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаСтатусаЗаявки.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
	Если СтатусЗаявкиED = "notconsidered" Тогда
		
		ВремяОжиданияСек = 60;
		УстановитьНадписьНаГиперссылкеОбновленияСтатуса();
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО", 1, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ПрограммноеЗакрытие Тогда
		
		Если Модифицированность Тогда
			
			Отказ = Истина;
			Если ЗавершениеРаботы Тогда
				ТекстПредупреждения =
					НСтр("ru = 'Заявка на изменение тарифа обмена электронными документами не отправлена.'");
			Иначе
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПриОтветеНаВопросОЗакрытииМодифицированнойФормы",
					ЭтотОбъект);
				ТекстВопроса = НСтр("ru = 'Данные изменены. Закрыть форму без сохранения данных?'");
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
			Возврат;
			
		КонецЕсли;
		
		Если Не НажатаКнопкаИзменить Тогда
			// Обработать закрытие формы в бизнес-процессе.
			
			ПараметрыЗапроса = Новый Массив;
			ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm", "close"));
			Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
				КонтекстВзаимодействия,
				ЭтотОбъект,
				ПараметрыЗапроса);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиСообщениеВТехПоддержку(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения =
			НСтр("ru = 'Не получается изменить тариф работы с оператором обмена ЭД.
				|
				|%1'");
		
		ЛогинПользователя = Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Подключение1СТакскомКлиент.ТекстТехническихПараметровЭДО(КонтекстВзаимодействия));
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Изменение тарифа в 1С-Такском.'"),
			ТекстСообщения,
			"taxcom",
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БесплатныхПакетовПриИзменении(Элемент)
	
	Нераспределено = МаксимальныйТариф - БесплатныхПакетов;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПричинаНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ПоказатьПричинуОтклоненияЗаявкиЭДО(КонтекстВзаимодействия);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОбновитьНажатие(Элемент)
	
	// Обновить статус заявки
	Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		"getApplicationStatus");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаИзменить(Команда)
	
	// Передача данных на сервер
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm"              , "send"));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "freePackagesED"       , БесплатныхПакетов));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "unallocatedPackagesED", Нераспределено));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
		"enddatetarifED",
		Формат(ДатаОкончания, "ДФ=""гггг-ММ-дд ЧЧ:мм:сс""")));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение",
		"begindatetarifED",
		Формат(ДатаНачала, "ДФ=""гггг-ММ-дд ЧЧ:мм:сс""")));
	
	НажатаКнопкаИзменить = Истина;
	Модифицированность   = Ложь;
	
	// Отправить параметры на сервер
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получения даты из форматной строки с датой,
// переданной с сервера.
//
// Параметры
// СтрокаДаты - строка с датой переданная с сервера.
//
// Возвращаемое значение - Дата.
//
&НаСервере
Функция ПолучитьДатуИзСтрокиДатыССервера(СтрокаДаты)
	
	Если ПустаяСтрока(СтрокаДаты) Тогда
		перемДата = Дата(1,1,1);
	Иначе
		Попытка
			перемДата = Дата(СтрЗаменить
								(СтрЗаменить
									(СтрЗаменить
										(СтрЗаменить
											(СтрокаДаты,
											".",
											""),
										"-",
										""),
									" ",
									""),
								":",
								""));
		Исключение
			перемДата = Дата(1,1,1);
		КонецПопытки;
	КонецЕсли;
	
	Возврат перемДата;
	
КонецФункции

// Процедура изменений внешнего вида формы в зависимости от статуса
//
&НаСервере
Процедура ОбработатьСтатусФормы()
	
	Если НЕ ЗначениеЗаполнено(СтатусЗаявкиED) ИЛИ СтатусЗаявкиED = "none" Тогда
		// Новая заявка
		Элементы.СтраницаНоваяЗаявка.Видимость   = Истина;
		Элементы.СтраницаНеРассмотрено.Видимость = Ложь;
		Элементы.СтраницаОбработано.Видимость    = Ложь;
		Элементы.СтраницаОтклонена.Видимость     = Ложь;
		
		Элементы.ПанельСтатуса.ТекущаяСтраница = Элементы.СтраницаНоваяЗаявка;
		Элементы.КомандаИзменить.Видимость     = Истина;
		ТолькоПросмотр                         = Ложь;
		
	ИначеЕсли СтатусЗаявкиED = "notconsidered" Тогда
		// Не обработана
		Элементы.СтраницаНоваяЗаявка.Видимость   = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость = Истина;
		Элементы.СтраницаОбработано.Видимость    = Ложь;
		Элементы.СтраницаОтклонена.Видимость     = Ложь;
		
		Элементы.ПанельСтатуса.ТекущаяСтраница   = Элементы.СтраницаНеРассмотрено;
		Элементы.КомандаИзменить.Видимость       = Ложь;
		Элементы.ЗакрытьФорму.КнопкаПоУмолчанию  = Истина;
		ТолькоПросмотр                           = Истина;
		
	ИначеЕсли СтатусЗаявкиED = "rejected" Тогда
		// Отклонена
		Элементы.СтраницаНоваяЗаявка.Видимость   = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость = Ложь;
		Элементы.СтраницаОбработано.Видимость    = Ложь;
		Элементы.СтраницаОтклонена.Видимость     = Истина;
		
		Элементы.ПанельСтатуса.ТекущаяСтраница = Элементы.СтраницаОтклонена;
		Элементы.КомандаИзменить.Видимость     = Ложь;
		ТолькоПросмотр                         = Истина;
		
	ИначеЕсли СтатусЗаявкиED = "obtained" Тогда
		// Успешно обработана
		Элементы.СтраницаНоваяЗаявка.Видимость   = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость = Ложь;
		Элементы.СтраницаОбработано.Видимость    = Истина;
		Элементы.СтраницаОтклонена.Видимость     = Ложь;
		
		Элементы.ПанельСтатуса.ТекущаяСтраница = Элементы.СтраницаОбработано;
		Элементы.КомандаИзменить.Видимость     = Ложь;
		ТолькоПросмотр                         = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура для установки текста гиперссылки для обновления
//
&НаКлиенте
Процедура УстановитьНадписьНаГиперссылкеОбновленияСтатуса()
	
	ТекстЗаголовка = НСтр("ru = 'Проверить выполнение заявки (осталось %1 сек.)'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", Строка(ВремяОжиданияСек));
	Элементы.НадписьОбновить.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

// Обработчик ожидания обновления статуса заявки.
// Срабатывает через 1 сек.
//
&НаКлиенте
Процедура ОбработчикОжиданияОбновленияСтатусаЭДО()
	
	Если ВремяОжиданияСек < 1 Тогда
		
		ОтключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО");
		// Обновить статус заявки
		Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
			КонтекстВзаимодействия,
			ЭтотОбъект,
			"getApplicationStatus");
		
	Иначе
		
		ВремяОжиданияСек = ВремяОжиданияСек - 1;
		УстановитьНадписьНаГиперссылкеОбновленияСтатуса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОЗакрытииМодифицированнойФормы(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
