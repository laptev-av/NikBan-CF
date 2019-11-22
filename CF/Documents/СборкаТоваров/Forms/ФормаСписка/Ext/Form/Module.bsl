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

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Магазин       = Настройки.Получить("Магазин");
	Склад         = Настройки.Получить("Склад");
	ВидОперации   = Настройки.Получить("ВидОперации");
	
	УстановитьОтборДинамическогоСписка("Магазин");
	УстановитьОтборДинамическогоСписка("Склад");
	УстановитьОтборДинамическогоСписка("ВидОперации");

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.СборкаТоваров.Форма.ФормаСписка.Открытие");
	
	УстановитьДоступностьСклада();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.СборкаТоваров.Форма.ФормаДокумента.Открытие");
       
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка("Склад");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМагазинПриИзменении(Элемент)
	
	УстановитьВсеОтборыДинамическогоСписка();
	УстановитьДоступностьСклада();
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииПриИзменении(Элемент)
	УстановитьОтборДинамическогоСписка("ВидОперации");
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
		         Истина, "Документ.СборкаТоваров.Форма.ФормаДокумента.СозданиеНового");

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
	УстановитьОтборДинамическогоСписка("ВидОперации");
	
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
