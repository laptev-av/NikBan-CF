﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КомпоновщикНастроек = Параметры.КомпоновщикНастроек;
	НастройкиОтчета = Параметры.НастройкиОтчета;
	
	ТолькоБыстрые = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ТолькоБыстрые", Ложь);
	
	Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы);
	КомпоновщикНастроек.Инициализировать(Источник);
	
	ОтчетОбъектИлиПолноеИмя = НастройкиОтчета.ПолноеИмя; // Копирование, чтобы объект отчета не приехал в клиентскую структуру.
	
	УсловияВывода = Новый Структура;
	УсловияВывода.Вставить("ТолькоПользовательские", Истина);
	УсловияВывода.Вставить("ТолькоБыстрые",          ТолькоБыстрые);
	УсловияВывода.Вставить("ИдентификаторТекущегоУзлаКД", Неопределено);
	Информация = ОтчетыСервер.РасширеннаяИнформацияОНастройках(КомпоновщикНастроек, НастройкиОтчета, ОтчетОбъектИлиПолноеИмя, УсловияВывода);
	
	ВыводимыеНастройки = Информация.ПользовательскиеНастройки.Скопировать(Новый Структура("ВыводРазрешен", Истина));
	ВыводимыеНастройки.Сортировать("ИндексВКоллекции Возр");
	
	ОтчетыСервер.ОчиститьРасширеннуюИнформациюОНастройках(Информация);
	
	НаборСтрок = Отборы.ПолучитьЭлементы();
	ВыводимыеТипыНастроек = Новый Массив;
	ВыводимыеТипыНастроек.Добавить("ЭлементОтбора");
	Для Каждого СвойстваНастройки Из ВыводимыеНастройки Цикл
		Если ВыводимыеТипыНастроек.Найти(СвойстваНастройки.Тип) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы = НаборСтрок.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СвойстваНастройки, "ПредставлениеПоУмолчанию, ВидСравнения, ИдентификаторКД");
		СтрокаТаблицы.ТипЗначения = СвойстваНастройки.ОписаниеТипов;
		СтрокаТаблицы.ИсходныйВидСравнения = СтрокаТаблицы.ВидСравнения;
	КонецЦикла;
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтборыТаблица

&НаКлиенте
Процедура ОтборыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.Отборы.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонки = Поле.Имя;
	Если ИмяКолонки = "ОтборыУсловие" Тогда
		Контекст = Новый Структура;
		Контекст.Вставить("СтрокаТаблицы", СтрокаТаблицы);
		Обработчик = Новый ОписаниеОповещения("ПослеВыбораВидаСравнения", ЭтотОбъект, Контекст);
		
		Список = ОтчетыКлиентСервер.СписокВыбораВидовСравнения(СтрокаТаблицы.ТипЗначения);
		
		ЭлементСписка = Список.НайтиПоЗначению(СтрокаТаблицы.ВидСравнения);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Картинка = БиблиотекаКартинок.Пометка;
		КонецЕсли;
		
		ПоказатьВыборИзМеню(Обработчик, Список);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВидаСравнения(ЭлементСписка, Контекст) Экспорт
	Если ЭлементСписка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Контекст.СтрокаТаблицы.ВидСравнения = ЭлементСписка.Значение;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ВыбратьИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть()
	Результат = Новый Соответствие;
	Для Каждого СтрокаТаблицы Из Отборы.ПолучитьЭлементы() Цикл
		Если СтрокаТаблицы.ИсходныйВидСравнения <> СтрокаТаблицы.ВидСравнения Тогда
			Результат.Вставить(СтрокаТаблицы.ИдентификаторКД, СтрокаТаблицы.ВидСравнения);
		КонецЕсли;
	КонецЦикла;
	ОповеститьОВыборе(Результат);
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти
