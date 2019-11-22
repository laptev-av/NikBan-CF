﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ТТНИсходящаяЕГАИС) Тогда 
		Элементы.ФормаСоздатьНаОснованииТТНИсходящаяЕГАИС.Видимость = Ложь;	
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ВозвратТоваровПоставщику.Форма.ФормаСписка.Открытие");

    УстановитьДоступностьСклада();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин       = Настройки.Получить("Магазин");
	Склад         = Настройки.Получить("Склад");
	Контрагент    = Настройки.Получить("Контрагент");
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	УстановитьОтборДинамическогоСписка("Контрагент");
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Склад");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Магазин");
	
	УстановитьОтборДинамическогоСписка("Склад");
	
	УстановитьДоступностьСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Контрагент");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента.СозданиеНового");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьНаОснованииТТНИсходящаяЕГАИС(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта!'");
	КонецЕсли;
	
	ПроверитьВозможностьВводаНаОсновании(ТекущиеДанные.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Документ.ТТНИсходящаяЕГАИС.Форма.ФормаДокумента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает отбор динамических списка формы.
//
&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтотОбъект[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтотОбъект[ИмяРеквизита]));
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСклада()

	Элементы.ОтборСклад.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Магазин);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВозможностьВводаНаОсновании(ДокументОснование)
	
	ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование);
	
КонецФункции

#КонецОбласти
