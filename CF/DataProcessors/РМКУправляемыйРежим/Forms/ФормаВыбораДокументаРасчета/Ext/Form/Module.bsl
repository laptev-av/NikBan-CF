﻿
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") Тогда
		Контрагент = Параметры.Контрагент;
		Если ЗначениеЗаполнено(Контрагент) Тогда
			Элементы.Контрагент.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Константы.КонтрагентРозничныйПокупатель.Получить();
	КонецЕсли;
	
	Если Параметры.Свойство("МассивОрганизаций") Тогда
		СписокОрганизаций.ЗагрузитьЗначения(Параметры.МассивОрганизаций);
	КонецЕсли;
	
	Если Параметры.Свойство("Магазин") Тогда
		Магазин = Параметры.Магазин;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаказПокупателя") Тогда
		ЗаказПокупателя = Параметры.ЗаказПокупателя;
	КонецЕсли;
	
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ЗафиксироватьВыборСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Передвинуть позицию в списке.
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх).
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьВыборСтроки()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("ДокументРасчета"   , ТекущиеДанные.ДокументРасчета);
		
		СтруктураСтроки.Вставить("ЭтоЗачетАванса"    , ТекущиеДанные.ЭтоЗачетАванса);
		СтруктураСтроки.Вставить("ЭтоОплатаРассрочки", ТекущиеДанные.ЭтоОплатаРассрочки);
		
		Если ТекущиеДанные.ЭтоЗачетАванса Тогда
			СтруктураСтроки.Вставить("Сумма"         , ТекущиеДанные.Аванс);
		ИначеЕсли ТекущиеДанные.ЭтоОплатаРассрочки Тогда
			СтруктураСтроки.Вставить("Сумма"         , ТекущиеДанные.Рассрочка);
		Иначе
			СтруктураСтроки.Вставить("Сумма"         , ТекущиеДанные.Сумма);
		КонецЕсли;
		СтруктураСтроки.Вставить("Контрагент"        , ТекущиеДанные.Контрагент);
		СтруктураСтроки.Вставить("ЗаказПокупателя"   , ТекущиеДанные.ЗаказПокупателя);
		Закрыть(СтруктураСтроки)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСКлиентамиОстатки.ДокументРасчета КАК ДокументРасчета,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентамиОстатки.СуммаОстаток < 0
	|			ТОГДА -РасчетыСКлиентамиОстатки.СуммаОстаток
	|		ИНАЧЕ РасчетыСКлиентамиОстатки.СуммаОстаток
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ЧекККМ
	|			ТОГДА РасчетыСКлиентамиОстатки.ДокументРасчета.ОперацияСДенежнымиСредствами
	|		КОГДА РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|			ТОГДА ИСТИНА
	|		КОГДА РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ОплатаОтПокупателяПлатежнойКартой
	|				И РасчетыСКлиентамиОстатки.ДокументРасчета.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоЗачетАванса,
	|	ВЫБОР
	|		КОГДА РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ЧекККМ
	|			ТОГДА НЕ РасчетыСКлиентамиОстатки.ДокументРасчета.ОперацияСДенежнымиСредствами
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоОплатаРассрочки,
	|	РасчетыСКлиентамиОстатки.Контрагент КАК Контрагент,
	|	РасчетыСКлиентамиОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|	РасчетыСКлиентамиОстатки.ДокументРасчета.Дата КАК Дата
	|ПОМЕСТИТЬ ТаблицаВЗапросе
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(
	|			,
	|			Магазин = &Магазин
	|				И Организация В (&Организации)
	|				И Контрагент = &Контрагент
	|				И (&ЭтоПустойЗаказ
	|					ИЛИ ЗаказПокупателя = &ЗаказПокупателя)) КАК РасчетыСКлиентамиОстатки
	|ГДЕ
	|	(РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|			ИЛИ РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ЧекККМ
	|			ИЛИ РасчетыСКлиентамиОстатки.ДокументРасчета ССЫЛКА Документ.ОплатаОтПокупателяПлатежнойКартой)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВЗапросе.ДокументРасчета КАК ДокументРасчета,
	|	ТаблицаВЗапросе.ДокументРасчета.СуммаДокумента КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТаблицаВЗапросе.ЭтоЗачетАванса
	|			ТОГДА ТаблицаВЗапросе.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Аванс,
	|	ВЫБОР
	|		КОГДА ТаблицаВЗапросе.ЭтоОплатаРассрочки
	|			ТОГДА ТаблицаВЗапросе.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Рассрочка,
	|	ТаблицаВЗапросе.ЭтоЗачетАванса КАК ЭтоЗачетАванса,
	|	ТаблицаВЗапросе.ЭтоОплатаРассрочки КАК ЭтоОплатаРассрочки,
	|	ТаблицаВЗапросе.Контрагент КАК Контрагент,
	|	ТаблицаВЗапросе.ЗаказПокупателя КАК ЗаказПокупателя
	|ИЗ
	|	ТаблицаВЗапросе КАК ТаблицаВЗапросе
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаВЗапросе.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Контрагент"     , Контрагент);
	Запрос.УстановитьПараметр("Организации"    , СписокОрганизаций.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("Магазин"        , Магазин);
	Запрос.УстановитьПараметр("ЗаказПокупателя", ЗаказПокупателя);
	Запрос.УстановитьПараметр("ЭтоПустойЗаказ", НЕ ЗначениеЗаполнено(ЗаказПокупателя));
	
	Результат = Запрос.Выполнить();
	
	Список.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти