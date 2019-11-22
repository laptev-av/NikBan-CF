﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ПересчетТоваров.Форма.ФормаСпискаОсновная.Открытие");

    УстановитьДоступностьСклада();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин       = Настройки.Получить("Магазин");
	Склад         = Настройки.Получить("Склад");
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
                 Истина, "Документ.ПересчетТоваров.Форма.ФормаДокумента.Открытие");
        
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	УстановитьВсеОтборыДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьВсеОтборыДинамическогоСписка();
	УстановитьДоступностьСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриказНаПроведениеИнвентаризацииТоваровПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("ДокументОснование");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриказНаПроведениеИнвентаризацииТоваровНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначениеОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Магазин) Тогда
		ЗначениеОтбора.Вставить("Магазин", Магазин);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ЗначениеОтбора.Вставить("Склад", Склад);
	КонецЕсли;
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.ПриказНаПроведениеИнвентаризацииТоваров.Форма.ФормаВыбора.Открытие");
                 
	ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
	
	ОткрытьФорму("Документ.ПриказНаПроведениеИнвентаризацииТоваров.ФормаВыбора", ПараметрыВыбора, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВсеОтборыДинамическогоСписка()
	
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	УстановитьОтборДинамическогоСписка("ДокументОснование");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка(ИмяРеквизита)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		Список, 
		ИмяРеквизита, 
		ЭтаФорма[ИмяРеквизита], 
		ЗначениеЗаполнено(ЭтаФорма[ИмяРеквизита]));
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСклада()

	Элементы.ОтборСклад.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Магазин);

КонецПроцедуры

#КонецОбласти
