﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ПараметрыПредставленияСервер());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Отбор.Свойство("ДокументОснование", ДокументОснование);
	Параметры.Отбор.Свойство("Организация", 	  Организация);
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "ДатаИсправления");
	ОбщегоНазначенияРТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "ДатаВыставления");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.СчетФактураВыданный.Форма.ФормаДокумента.Открытие");

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

#Область Прочее

&НаСервере
Функция ПараметрыПредставленияСервер()
	
	ПараметрыПредставления = ПродажиСервер.ПараметрыПредставленияСчетаФактуры(ДокументОснование, Организация);
	ПараметрыПредставления.Вставить("Организация", Организация);
	
	Возврат ПараметрыПредставления;
	
КонецФункции

#КонецОбласти

#КонецОбласти
