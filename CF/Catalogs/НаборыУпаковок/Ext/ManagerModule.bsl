﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//     Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы, связанного с
//              реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ЕдиницаИзмерения");
	
	Возврат Результат;

КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаборыУпаковок.Ссылка,
	|	НаборыУпаковок.ПометкаУдаления,
	|	ПРЕДСТАВЛЕНИЕ(НаборыУпаковок.Наименование) КАК Представление
	|ИЗ
	|	Справочник.НаборыУпаковок КАК НаборыУпаковок
	|ГДЕ
	|	НаборыУпаковок.Ссылка <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаборыУпаковок.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(Справочники.НаборыУпаковок.ИндивидуальныйДляНоменклатуры);
	
	Пока Выборка.Следующий() Цикл
		Значение = Новый Структура("Значение,ПометкаУдаления",Выборка.Ссылка,Выборка.ПометкаУдаления);
		ДанныеВыбора.Добавить(Значение,Выборка.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
