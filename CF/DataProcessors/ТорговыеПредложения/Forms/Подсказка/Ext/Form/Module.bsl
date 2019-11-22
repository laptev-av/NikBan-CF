﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Подсказка", Подсказка) = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Идея));
	МассивСтрок.Добавить("  ");
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(Подсказка.Заголовок, Новый Шрифт(,, Истина,,,, 130)));
	МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
	МассивСтрок.Добавить(Подсказка.Содержание);
	
	КлючСохраненияПоложенияОкна = Подсказка.Код;
	
	// Регистрация в сервисе.
	Если Подсказка.Действия.Найти("Регистрация")<> Неопределено Тогда
		МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
		МассивСтрок.Добавить("     ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
		НСтр("ru = 'Зарегистрироваться в сервисе 1С:Бизнес-сеть'"),,,, "ДействиеРегистрация"));
	КонецЕсли;
	
	// Публикация торговых предложений.
	Если Подсказка.Действия.Найти("ПубликацияТорговыхПредложений") <> Неопределено Тогда
		МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
		МассивСтрок.Добавить("     ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Настроить публикацию торговых предложений'"),,,, "ДействиеПубликация"));
	КонецЕсли;
		
	// Приглашение контрагентов.
	Если Подсказка.Действия.Найти("ОтправкаПриглашений") <> Неопределено Тогда
		МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
		МассивСтрок.Добавить("     ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Пригласить в сервис клиентов'"),,,, "ДействиеПриглашение"));
	КонецЕсли;
	
	// Поиск торговых предложений по отборам.
	Если Подсказка.Действия.Найти("ПоискПоОтборам") <> Неопределено Тогда
		МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
		МассивСтрок.Добавить("     ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Найти торговые предложения'"),,,, "ДействиеПоискПоОтборам"));
	КонецЕсли;
	
	// Поиск торговых предложений по списку.
	Если Подсказка.Действия.Найти("ПоискПоТоварам") <> Неопределено Тогда
		МассивСтрок.Добавить(Символы.ПС + " " + Символы.ПС);
		МассивСтрок.Добавить("     ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			НСтр("ru = 'Найти торговые предложения'"),,,, "ДействиеПоискПоТоварам"));
	КонецЕсли;
	
	// Элементы выгрузки штрихкодов.
	Элементы.ПоказыватьПодсказкиПоставщиков.Видимость = Ложь;
	Элементы.ПоказыватьПодсказкиПокупателей.Видимость = Ложь;
	ТекстПредупреждения = "";
	Если Подсказка.Действия.Найти("ВыгрузкаШтрихкодов") <> Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'В сервис 1С:Бизнес-сеть еще не выгружены штрихкоды по регламентному заданию.'");
		УстановитьПривилегированныйРежим(Истина);
		Константа_ПоказыватьПодсказкиПоставщиков = Константы.ПоказыватьПодсказкиПоставщиковБизнесСеть.Получить();
		Константа_ПоказыватьПодсказкиПокупателей = Константы.ПоказыватьПодсказкиПокупателейБизнесСеть.Получить();
		УстановитьПривилегированныйРежим(Ложь);
		Если Подсказка.РежимПоставщика Тогда
			Элементы.ПоказыватьПодсказкиПоставщиков.Видимость = Истина;
			Элементы.ПоказыватьПодсказкиПоставщиков.Доступность = Не Константа_ПоказыватьПодсказкиПоставщиков;;
			Если Константа_ПоказыватьПодсказкиПоставщиков Тогда
				ТекстПредупреждения = ТекстОшибки;
			КонецЕсли;
		ИначеЕсли Подсказка.РежимПокупателя Тогда
			Элементы.ПоказыватьПодсказкиПокупателей.Видимость = Истина;
			Элементы.ПоказыватьПодсказкиПокупателей.Доступность = Не Константа_ПоказыватьПодсказкиПокупателей;;
			Если Константа_ПоказыватьПодсказкиПокупателей Тогда
				ТекстПредупреждения = ТекстОшибки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстПредупреждения) Тогда
		Элементы.ПредупреждениеОбОшибке.Заголовок = ТекстПредупреждения;
	КонецЕсли;
	
	Элементы.Содержание.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СодержаниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ДействиеРегистрация" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		ОткрытьФорму("Обработка.БизнесСеть.Форма.РегистрацияОрганизаций");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПубликация" Тогда
		
		ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПомощникПубликации");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПриглашение" Тогда
		
		Если Подсказка.РежимПоставщика Тогда
			РежимПриглашения = "Поставщики";
		ИначеЕсли Подсказка.РежимПокупателя Тогда
			РежимПриглашения = "Покупатели";
		Иначе
			РежимПриглашения = "Общий";
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимПриглашения", РежимПриглашения);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашенийКонтрагентам", ПараметрыОткрытия);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПоискПоТоварам" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыКоманды", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект.ВладелецФормы.Объект.Ссылка));
		ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПоискПоТоварам", ПараметрыОткрытия);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПоискПоОтборам" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыКоманды", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект.ВладелецФормы.Объект.Ссылка));
		ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПоискПоОтборам", ПараметрыОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПодсказкиПоставщиковПриИзменении(Элемент)
	
	ИзменитьНастройкуПодсказок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПодсказкиПокупателейПриИзменении(Элемент)
	
	ИзменитьНастройкуПодсказок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИзменитьНастройкуПодсказок()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Установка констант подсказок.
	Константы.ПоказыватьПодсказкиПокупателейБизнесСеть.Установить(Константа_ПоказыватьПодсказкиПокупателей);
	Константы.ПоказыватьПодсказкиПоставщиковБизнесСеть.Установить(Константа_ПоказыватьПодсказкиПоставщиков);
	
	// Изменение регламентного задания.
	БизнесСеть.ИзменитьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ОбновлениеПодсказокТорговыеПредложения.Имя,
		"Использование", Макс(Константа_ПоказыватьПодсказкиПоставщиков, Константа_ПоказыватьПодсказкиПокупателей));
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти