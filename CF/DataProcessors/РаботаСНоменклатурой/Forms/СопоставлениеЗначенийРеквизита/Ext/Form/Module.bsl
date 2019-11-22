﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТекущийРеквизит", ТекущийРеквизит);
	Параметры.Свойство("ВидНоменклатуры", ВидНоменклатуры);
	Параметры.Свойство("НаименованиеКатегории", НаименованиеКатегории);
	Параметры.Свойство("ИдентификаторКатегории", ИдентификаторКатегории);
	Параметры.Свойство("ИдентификаторРеквизитаКатегории", ИдентификаторРеквизитаКатегории);
	
	ЗаполнитьПодсказкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьЗначенияРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеКОперацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ИдентификаторКатегории", НавигационнаяСсылкаФорматированнойСтроки);
	
	ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.КарточкаКатегории", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияРеквизитаВидаНоменклатуры

&НаКлиенте
Процедура ЗначенияРеквизитаВидаНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияРеквизитаВидаНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПривязатьЗначениеВидаНоменклатуры(ВыбраннаяСтрока);
	
	ОбновитьКоличествоСопоставленныхЗначений();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияРеквизитаВидаНоменклатурыПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ЗначенияРеквизитаВидаНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееЗначениеРеквизита = ТекущиеДанные.ЗначениеРеквизита;
	
	УстановитьЗаголовокГиперссылкиОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияРеквизитаКатегории

&НаКлиенте
Процедура ЗначенияРеквизитаКатегорииПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияРеквизитаКатегорииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтвязатьЗначениеВидаНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкуСопоставлений();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначение(Команда)
	
	ПривязатьЗначениеВидаНоменклатуры(Элементы.ЗначенияРеквизитаВидаНоменклатуры.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьЗначение(Команда)
	
	ОтвязатьЗначениеВидаНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеЗначения(Команда)
	
	Если ЗначенияРеквизитаВидаНоменклатуры.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеЗначений = Новый Массив;	
	
	Для каждого ЭлементКоллекции Из ЗначенияРеквизитаВидаНоменклатуры Цикл
		ПредставлениеЗначений.Добавить(Строка(ЭлементКоллекции.ЗначениеРеквизита));
	КонецЦикла;
	
	ПараметрыЗапроса = Новый Структура;
	
	ПараметрыЗапроса.Вставить("ИдентификаторКатегории", ИдентификаторКатегории);
	ПараметрыЗапроса.Вставить("ИдентификаторДополнительногоРеквизита", ИдентификаторРеквизитаКатегории);
	ПараметрыЗапроса.Вставить("ПредставлениеЗначений", ПредставлениеЗначений);

	ПараметрыЗавершения = Новый Структура;
	
	ПолучитьНоменклатуруЗавершение = Новый ОписаниеОповещения("ПолучитьЗначенияСоответствующиеЗаданнымЗавершение", ЭтотОбъект, ПараметрыЗавершения);
		
	РаботаСНоменклатуройКлиент.ПолучитьЗначенияСоответствующиеЗаданным(
		ПолучитьНоменклатуруЗавершение, ПараметрыЗапроса, ЭтотОбъект, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗначенияСоответствующиеЗаданнымЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьЗначенияПоРезультатуПоиска(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПоРезультатуПоиска(Результат)
	
	Если Не ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияДляПодстановки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ТипЗнч(ЗначенияДляПодстановки) <> Тип("ТаблицаЗначений")
		ИЛИ ЗначенияДляПодстановки.Количество() = 0 Тогда
		
		Возврат;
	КонецЕсли;
	
	Если ЗначенияДляПодстановки.Количество() <> ЗначенияРеквизитаВидаНоменклатуры.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////
	
	СтрокиКУдалению = Новый Массив;
	
	Для Счетчик = 0 По ЗначенияРеквизитаВидаНоменклатуры.Количество() - 1 Цикл
		
		ТекущаяСтрока = ЗначенияДляПодстановки[Счетчик];
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.Идентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиПоИдентификаторам = ЗначенияРеквизитаКатегории.НайтиСтроки(
			Новый Структура("ИдентификаторЗначенияРеквизитаКатегории", ТекущаяСтрока.Идентификатор));
		
		Если СтрокиПоИдентификаторам.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокиПоИдентификаторам[0].ЗначениеРеквизитаВидаНоменклатуры) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиПоИдентификаторам[0].ЗначениеРеквизитаВидаНоменклатуры 
			= ЗначенияРеквизитаВидаНоменклатуры[Счетчик].ЗначениеРеквизита;
			
		СтрокиКУдалению.Добавить(ЗначенияРеквизитаВидаНоменклатуры[Счетчик]);	
			
	КонецЦикла;
	
	Для каждого ЭлементКоллекции Из СтрокиКУдалению Цикл
		ЗначенияРеквизитаВидаНоменклатуры.Удалить(ЭлементКоллекции);
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура УбратьВсеЗначения(Команда)
	
	Для каждого ЭлементКоллекции Из ЗначенияРеквизитаКатегории Цикл
		
		Если Не ЗначениеЗаполнено(ЭлементКоллекции.ЗначениеРеквизитаВидаНоменклатуры) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ЗначенияРеквизитаВидаНоменклатуры.Добавить();
		
		НоваяСтрока.ЗначениеРеквизита = ЭлементКоллекции.ЗначениеРеквизитаВидаНоменклатуры;
		
		ЭлементКоллекции.ЗначениеРеквизитаВидаНоменклатуры = Неопределено;
		
	КонецЦикла;
	
	ОбновитьКоличествоСопоставленныхЗначений();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗначение(Команда)
	
	РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуДополнительногоЗначения(ТекущийРеквизит, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПохожихЗначенийНажатие(Элемент, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	РежимОтбораПоЗначению = НЕ РежимОтбораПоЗначению;
	
	ИзменитьРежимОтбораПохожих(РежимОтбораПоЗначению);
		
	УстановитьЗаголовокГиперссылкиОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьЗначенияРеквизита()
	
	ПараметрыЗавершения = Новый Структура;
	
	ПолучитьНоменклатуруЗавершение = Новый ОписаниеОповещения("ПолучитьЗначенияРеквизитаЗавершение", ЭтотОбъект, ПараметрыЗавершения);
	
	ПараметрыПоиска = Новый Структура();
	ПараметрыПоиска.Вставить("ИдентификаторДополнительногоРеквизита", ИдентификаторРеквизитаКатегории);
	ПараметрыПоиска.Вставить("ИдентификаторКатегории",                ИдентификаторКатегории);
		
	РаботаСНоменклатуройКлиент.ПолучитьЗначенияДополнительногоРеквизитаКатегории(
		ПолучитьНоменклатуруЗавершение, ПараметрыПоиска, ЭтотОбъект, ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗначенияРеквизитаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьЗначенияРеквизитов(Результат.АдресРезультата);
	
	ОбновитьКоличествоСопоставленныхЗначений();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияРеквизитов(АдресРезультата)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Возврат;
	КонецЕсли; 
	
	ТаблицаРезультата = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если ТипЗнч(ТаблицаРезультата) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли; 
	
	////////////////////////////////////////////////////////////////////////////////
	
	ЗаполнитьРеквизитыКатегории(ТаблицаРезультата);
	
	ЗаполнитьРеквизитыВидаНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкуСопоставлений()
	
	РаботаСНоменклатурой.ЗаписатьСоответствиеЗначенийРеквизита(ВидНоменклатуры, ТекущийРеквизит, ЗначенияРеквизитаКатегории.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстНеЗаполненоЗначение());
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(200, 200, 200));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗначенияРеквизитаКатегории.ЗначениеРеквизитаВидаНоменклатуры");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗначенияРеквизитаКатегорииЗначениеРеквизитаВидаНоменклатуры.Имя);
	
	// Отображение только похожих значений
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Использование = Ложь;
	ЭлементУсловногоОформления.Представление = "ОтобратьПохожие";

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗначенияРеквизитаКатегории.ЗначениеРеквизитаКатегории");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеСодержит;
	ОтборЭлемента.ПравоеЗначение = "";
	
	// Для управления видимостью нужно указывать все колонки
	
	Для каждого ЭлементКоллекции Из Элементы.ЗначенияРеквизитаКатегории.ПодчиненныеЭлементы Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементКоллекции.Имя);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если ЭтоЗначениеДополнительногоРеквизита(НовыйОбъект) Тогда
		
		ТекущиеДанные = Элементы.ЗначенияРеквизитаКатегории.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущиеДанные.ЗначениеРеквизитаВидаНоменклатуры) Тогда
			НоваяСтрока = ЗначенияРеквизитаВидаНоменклатуры.Добавить();
			НоваяСтрока.ЗначениеРеквизита = НовыйОбъект;
		Иначе
			ТекущиеДанные.ЗначениеРеквизитаВидаНоменклатуры = НовыйОбъект;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЗначениеДополнительногоРеквизита(НовыйОбъект)
	
	ТипыДополнительныхЗначений = Метаданные.ОпределяемыеТипы.ЗначенияСвойствОбъектовРаботаСНоменклатурой.Тип.Типы();
	
	Если ТипыДополнительныхЗначений.Количество() = 0  Тогда
		ТипДополнительныхЗначений = Тип("Неопределено");
	Иначе
		ТипДополнительныхЗначений = ТипыДополнительныхЗначений[0];	
	КонецЕсли;

	Возврат ТипЗнч(НовыйОбъект) = ТипДополнительныхЗначений;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьКоличествоСопоставленныхЗначений()
	
	ОсталосьСопоставитьЗначений = ЗначенияРеквизитаВидаНоменклатуры.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРежимОтбораПохожих(ОтображатьТолькоПохожие)
		
	Для каждого ЭлементКоллекции Из УсловноеОформление.Элементы Цикл
		
		Если ЭлементКоллекции.Представление = "ОтобратьПохожие" Тогда
			ЭлементКоллекции.Использование = ОтображатьТолькоПохожие;
			ЭлементКоллекции.Отбор.Элементы[0].ПравоеЗначение = Строка(ТекущееЗначениеРеквизита);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодсказкиФормы()
	
	Элементы.ПояснениеКОперации.Заголовок = Новый ФорматированнаяСтрока(ТекстПоясненияОперации());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыВидаНоменклатуры()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	
	"ВЫБРАТЬ
	|	СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.Значение КАК Значение,
	|	СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.ИдентификаторЗначенияРеквизитаКатегории КАК ИдентификаторЗначенияРеквизитаКатегории
	|ПОМЕСТИТЬ ВТСопоставленныеРеквизиты
	|ИЗ
	|	РегистрСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой КАК СоответствиеЗначенийРеквизитовРаботаСНоменклатурой
	|ГДЕ
	|	СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.ОбъектСопоставления = &ОбъектСопоставления
	|	И СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.РеквизитОбъекта = &ТекущийРеквизит
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Ссылка КАК ЗначениеРеквизитаВидаНоменклатуры,
	|	ЕСТЬNULL(ВТСопоставленныеРеквизиты.ИдентификаторЗначенияРеквизитаКатегории, """") КАК ИдентификаторЗначенияРеквизитаКатегории
	|ИЗ
	|	&ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСопоставленныеРеквизиты КАК ВТСопоставленныеРеквизиты
	|		ПО ЗначенияСвойствОбъектов.Ссылка = ВТСопоставленныеРеквизиты.Значение
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Владелец = &ТекущийРеквизит";
	
	Запрос.УстановитьПараметр("ОбъектСопоставления", ВидНоменклатуры);
	Запрос.УстановитьПараметр("ТекущийРеквизит", ТекущийРеквизит);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ЗначенияСвойствОбъектов", 
		Метаданные.ОпределяемыеТипы.ЗначенияСвойствОбъектовРаботаСНоменклатурой.Тип.ПривестиЗначение().Метаданные().ПолноеИмя());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.ИдентификаторЗначенияРеквизитаКатегории) Тогда
			НоваяСтрока = ЗначенияРеквизитаВидаНоменклатуры.Добавить();
			НоваяСтрока.ЗначениеРеквизита = Выборка.ЗначениеРеквизитаВидаНоменклатуры;
		Иначе
			СтрокиЗначений = ЗначенияРеквизитаКатегории.НайтиСтроки(
				Новый Структура("ИдентификаторЗначенияРеквизитаКатегории", Выборка.ИдентификаторЗначенияРеквизитаКатегории));	
				
			Если СтрокиЗначений.Количество() <> 0 Тогда
				СтрокиЗначений[0].ЗначениеРеквизитаВидаНоменклатуры = Выборка.ЗначениеРеквизитаВидаНоменклатуры;
			КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКатегории(РеквизитыЗначенияКатегории)
	
	ЗначенияРеквизитаКатегории.Очистить();
	
	ТекущаяКатегория = РеквизитыЗначенияКатегории[0];
	
	Для каждого ЭлементКоллекции Из ТекущаяКатегория.Значения Цикл
		НоваяСтрока = ЗначенияРеквизитаКатегории.Добавить();
		
		НоваяСтрока.ЗначениеРеквизитаКатегории = ЭлементКоллекции.Наименование;
		НоваяСтрока.ИдентификаторЗначенияРеквизитаКатегории = ЭлементКоллекции.Идентификатор;
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПривязатьЗначениеВидаНоменклатуры(ВыбраннаяСтрока)
	
	СтрокаКатегории = Элементы.ЗначенияРеквизитаКатегории.ТекущиеДанные;
	
	Если СтрокаКатегории = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаВидаНоменклатуры = ЗначенияРеквизитаВидаНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);

	Если ЗначениеЗаполнено(СтрокаКатегории.ЗначениеРеквизитаВидаНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаКатегории.ЗначениеРеквизитаВидаНоменклатуры = СтрокаВидаНоменклатуры.ЗначениеРеквизита;
	
	ЗначенияРеквизитаВидаНоменклатуры.Удалить(СтрокаВидаНоменклатуры);
	
	СпозиционироватьНаНовойСтроке();
	
	ОбновитьКоличествоСопоставленныхЗначений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтвязатьЗначениеВидаНоменклатуры()
	
	ТекущиеДанные = Элементы.ЗначенияРеквизитаКатегории.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ЗначениеРеквизитаВидаНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	// Создаем строку в приемнике
	
	НоваяСтрока = ЗначенияРеквизитаВидаНоменклатуры.Добавить();
	
	НоваяСтрока.ЗначениеРеквизита = ТекущиеДанные.ЗначениеРеквизитаВидаНоменклатуры;
		
	// Очищаем в источнике
	
	ТекущиеДанные.ЗначениеРеквизитаВидаНоменклатуры = Неопределено;
	
	ОбновитьКоличествоСопоставленныхЗначений();
		
КонецПроцедуры

&НаКлиенте
Процедура СпозиционироватьНаНовойСтроке()
	
	Для каждого ЭлементКоллекции Из ЗначенияРеквизитаКатегории Цикл
		Если НЕ ЗначениеЗаполнено(ЭлементКоллекции.ЗначениеРеквизитаВидаНоменклатуры) Тогда
			Элементы.ЗначенияРеквизитаКатегории.ТекущаяСтрока = ЭлементКоллекции.ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область СтроковыеКонстанты

&НаКлиенте
Процедура УстановитьЗаголовокГиперссылкиОтбора()
	
	Если РежимОтбораПоЗначению Тогда
		ОтборПохожихЗначений = СтрШаблон(НСтр("ru = 'Убрать отбор по значению %1'"), ТекущееЗначениеРеквизита);
	Иначе
		ОтборПохожихЗначений = СтрШаблон(НСтр("ru = 'Отобрать похожие на %1'"), ТекущееЗначениеРеквизита);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ТекстПоясненияОперации()
	
	МассивПодстрок = Новый Массив;
	
	МассивПодстрок.Добавить(НСтр("ru = 'Сопоставление значений реквизита'") + " ");
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(Строка(ТекущийРеквизит),Новый Шрифт(,,Истина)));
	МассивПодстрок.Добавить(" " + НСтр("ru = 'вида номенклатуры'") + " ");
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(Строка(ВидНоменклатуры),Новый Шрифт(,,Истина)));
	МассивПодстрок.Добавить(" " + НСтр("ru = 'и категории 1С:Номенклатуры'") + " ");
	МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(НаименованиеКатегории,,,,ИдентификаторКатегории));

	Возврат МассивПодстрок;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстНеЗаполненоЗначение()
	
	Возврат НСтр("ru = '<Выберите значение или создайте новое>'");
	
КонецФункции

#КонецОбласти