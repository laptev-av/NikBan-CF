﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	
	ДанныеВыбора = Новый Структура("ВидВремени, БуквенноеОбозначение"); 
	ДанныеВыбора.ВидВремени = ВыбраннаяСтрока;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		ДанныеВыбора.БуквенноеОбозначение = ВРег(Лев(ДанныеТекущейСтроки.Ссылка,1));
	КонецЕсли;
	
 	ОповеститьОВыборе(ДанныеВыбора);	
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры
