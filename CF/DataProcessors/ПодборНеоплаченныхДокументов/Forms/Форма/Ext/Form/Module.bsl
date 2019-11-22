﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Операция = Перечисления.ХозяйственныеОперации.ОплатаПоставщику Тогда
		ОтборФормаОплаты = Параметры.ФормаОплаты;
		
		Если НЕ Параметры.Свойство("ДатаПлатежа", ДатаПлатежа) Тогда
			ДатаПлатежа = ТекущаяДатаСеанса();
		КонецЕсли;
		
		ОплатаПоставщику = Истина;
	Иначе
		Элементы.ГруппаОтбор.Видимость = Ложь;
		ОплатаПоставщику = Ложь;
	КонецЕсли;
	
	Магазин = Параметры.Магазин;
	Контрагент = Параметры.Контрагент;
	АдресХранилищаРасшифровкаПлатежа = Параметры.АдресХранилищаРасшифровкаПлатежа;
	Ссылка = Параметры.Ссылка;
	Организация = Параметры.Организация;
	
	Параметры.Свойство("СуммаДокумента", СуммаПлатежа);
	
	ПодборИзЗаявки = ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств");
	
	Если ПодборИзЗаявки Тогда
		ЗаполнитьКорзинуДерево();
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКорзинаДерево;
	Иначе
		ЗаполнитьКорзину();
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКорзина;
	КонецЕсли;
	
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПлатежаПриИзменении(Элемент)
	
	Если ПодборИзЗаявки Тогда
		ЗаполнитьКорзинуДерево();
	Иначе
		ЗаполнитьКорзину();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборФормаОплатыПриИзменении(Элемент)
	
	Если ПодборИзЗаявки Тогда
		ЗаполнитьКорзинуДерево();
	Иначе
		ЗаполнитьКорзину();
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиКорзина

&НаКлиенте
Процедура КорзинаПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Корзина.ТекущиеДанные;
	УстановитьСнятьПометку(ТекущиеДанные.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаНеОплаченнаяСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Корзина.ТекущиеДанные;
	УстановитьСнятьПометку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоле = Поле.Имя;
	ИмяРеквизита = СтрЗаменить(Поле.Имя, "Корзина", "");
	
	Если ИмяРеквизита <> "ДокументРасчета" Тогда
		Возврат;
	КонецЕсли;
	
	Значение = Элемент.ТекущиеДанные[ИмяРеквизита];
	Если ЗначениеЗаполнено(Значение) Тогда
		ПоказатьЗначение(,Значение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КорзинаПриИзменении(Элемент)
	
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Корзина.ТекущиеДанные;
	ТекущиеДанные.Пометка = ?(ТекущиеДанные.Сумма > 0, Истина, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиКорзинаДерево

&НаКлиенте
Процедура КорзинаДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоле = Поле.Имя;
	ИмяРеквизита = СтрЗаменить(Поле.Имя, "КорзинаДерево", "");
	
	Если ИмяРеквизита <> "ДокументРасчета" Тогда
		Возврат;
	КонецЕсли;
	
	Значение = Элемент.ТекущиеДанные[ИмяРеквизита];
	Если ЗначениеЗаполнено(Значение) Тогда
		ПоказатьЗначение(,Значение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КорзинаДеревоПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.КорзинаДерево.ТекущиеДанные;
	УстановитьСнятьПометку(ТекущиеДанные.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаДеревоПриИзменении(Элемент)
	
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаДеревоСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.КорзинаДерево.ТекущиеДанные;
	ТекущиеДанные.Пометка = ?(ТекущиеДанные.Сумма > 0, Истина, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	СтруктураРезультат = ПоместитьКорзинуВХранилище();
	ОповеститьОВыборе(СтруктураРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьСнятьПометку(Истина);
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьСнятьПометку(Ложь);
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьСуммуПлатежа(Команда)
	
	Коллекция = ?(ПодборИзЗаявки, КорзинаДерево.ПолучитьЭлементы(), Объект.Корзина);
	
	СуммаРаспределения = СуммаПлатежа;
	
	Для каждого Строка Из Коллекция Цикл
		
		Если СуммаРаспределения > 0 Тогда
			
			Если ПодборИзЗаявки Тогда
				Сумма = Строка.КОплате - Строка.СуммаЗаявок;
				Строка.Сумма = Мин(Сумма, СуммаРаспределения);
				СуммаРаспределения = СуммаРаспределения - Строка.Сумма;
			Иначе
				Строка.Сумма = Мин(Строка.КОплате, СуммаРаспределения);
				СуммаРаспределения = СуммаРаспределения - Строка.Сумма;
			КонецЕсли;
			
			Строка.Пометка = Истина;
		Иначе
			Строка.Пометка = Ложь;
			Строка.Сумма   = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ПодборИзЗаявки Тогда
		ЗаполнитьКорзинуДерево();
	Иначе
		ЗаполнитьКорзину();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКорзину()
	
	Запрос = Новый Запрос;

	Если ОплатаПоставщику Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК Документ,
		|	РасшифровкаПлатежа.Сумма КАК СуммаИзДокумента
		|ПОМЕСТИТЬ РасшифровкаПлатежа
		|ИЗ
		|	&РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСПоставщиками.ДокументРасчета КАК ДокументРасчета,
		|	СУММА(РасчетыСПоставщиками.КОплатеОстаток) КАК КОплатеОстаток
		|ПОМЕСТИТЬ НеОплаченныеДокументы
		|ИЗ
		|	(ВЫБРАТЬ
		|		РасчетыСПоставщикамиОстатки.ДокументРасчета КАК ДокументРасчета,
		|		-РасчетыСПоставщикамиОстатки.КОплатеОстаток КАК КОплатеОстаток
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
		|				,
		|				Магазин = &Магазин
		|					И Поставщик = &Контрагент) КАК РасчетыСПоставщикамиОстатки
		|	ГДЕ
		|		РасчетыСПоставщикамиОстатки.КОплатеОстаток < 0
		|		И РасчетыСПоставщикамиОстатки.ДокументРасчета.Организация = &Организация
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		РасчетыСПоставщикамиОбороты.ДокументРасчета,
		|		РасчетыСПоставщикамиОбороты.КОплатеОборот
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщиками.Обороты(
		|				,
		|				,
		|				Регистратор,
		|				Магазин = &Магазин
		|					И Поставщик = &Контрагент) КАК РасчетыСПоставщикамиОбороты
		|	ГДЕ
		|		РасчетыСПоставщикамиОбороты.Регистратор = &Ссылка) КАК РасчетыСПоставщиками
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПоставщиками.ДокументРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказПоставщикуЭтапыОплат.Ссылка,
		|	СУММА(ЗаказПоставщикуЭтапыОплат.Сумма) КАК Сумма,
		|	ЗаказПоставщикуЭтапыОплат.Ссылка.СуммаДокумента,
		|	ЗаказПоставщикуЭтапыОплат.Ссылка.Дата
		|ПОМЕСТИТЬ ДолгПоЭтапамОплат
		|ИЗ
		|	Документ.ЗаказПоставщику.ЭтапыОплат КАК ЗаказПоставщикуЭтапыОплат
		|ГДЕ
		|	ЗаказПоставщикуЭтапыОплат.Ссылка В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				НеОплаченныеДокументы.ДокументРасчета
		|			ИЗ
		|				НеОплаченныеДокументы КАК НеОплаченныеДокументы)
		|	И ЗаказПоставщикуЭтапыОплат.ФормаОплаты <> ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Взаимозачет)
		|	И ЗаказПоставщикуЭтапыОплат.ФормаОплаты В(&ФормаОплаты)
		|	И ЗаказПоставщикуЭтапыОплат.ДатаПлатежа <= &ДатаПлатежа
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщикуЭтапыОплат.Ссылка,
		|	ЗаказПоставщикуЭтапыОплат.Ссылка.СуммаДокумента,
		|	ЗаказПоставщикуЭтапыОплат.Ссылка.Дата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПоступлениеТоваровЭтапыОплат.Ссылка,
		|	СУММА(ПоступлениеТоваровЭтапыОплат.Сумма),
		|	ПоступлениеТоваровЭтапыОплат.Ссылка.СуммаДокумента,
		|	ПоступлениеТоваровЭтапыОплат.Ссылка.Дата
		|ИЗ
		|	Документ.ПоступлениеТоваров.ЭтапыОплат КАК ПоступлениеТоваровЭтапыОплат
		|ГДЕ
		|	ПоступлениеТоваровЭтапыОплат.Ссылка В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				НеОплаченныеДокументы.ДокументРасчета
		|			ИЗ
		|				НеОплаченныеДокументы КАК НеОплаченныеДокументы)
		|	И ПоступлениеТоваровЭтапыОплат.ФормаОплаты <> ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Взаимозачет)
		|	И ПоступлениеТоваровЭтапыОплат.ФормаОплаты В(&ФормаОплаты)
		|	И ПоступлениеТоваровЭтапыОплат.ДатаПлатежа <= &ДатаПлатежа
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровЭтапыОплат.Ссылка,
		|	ПоступлениеТоваровЭтапыОплат.Ссылка.СуммаДокумента,
		|	ПоступлениеТоваровЭтапыОплат.Ссылка.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(РасчетыСПоставщиками.Сумма) КАК ОплаченнаяСумма,
		|	РасчетыСПоставщиками.ДокументРасчета
		|ПОМЕСТИТЬ ПроведенныеОплаты
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками
		|ГДЕ
		|	РасчетыСПоставщиками.ДокументРасчета В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				НеОплаченныеДокументы.ДокументРасчета
		|			ИЗ
		|				НеОплаченныеДокументы КАК НеОплаченныеДокументы)
		|	И РасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|	И РасчетыСПоставщиками.Магазин = &Магазин
		|	И РасчетыСПоставщиками.Поставщик = &Контрагент
		|	И РасчетыСПоставщиками.ФормаОплаты В(&ФормаОплаты)
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПоставщиками.ДокументРасчета
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НеОплаченныеДокументы.ДокументРасчета КАК ДокументРасчета,
		|	ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0) КАК КОплатеПоЭтапам,
		|	ВЫБОР
		|	КОГДА ЕСТЬNULL(ПроведенныеОплаты.ОплаченнаяСумма, 0) > ДолгПоЭтапамОплат.Сумма
		|	ТОГДА 0
		|ИНАЧЕ ВЫБОР
		|	КОГДА НеОплаченныеДокументы.КОплатеОстаток > ДолгПоЭтапамОплат.Сумма - ЕСТЬNULL(ПроведенныеОплаты.ОплаченнаяСумма, 0)
		|	ТОГДА ДолгПоЭтапамОплат.Сумма - ЕСТЬNULL(ПроведенныеОплаты.ОплаченнаяСумма, 0)
		|ИНАЧЕ НеОплаченныеДокументы.КОплатеОстаток
		|	КОНЕЦ
		|	КОНЕЦ КАК НеОплаченнаяСумма,
		|	ЕСТЬNULL(ДолгПоЭтапамОплат.СуммаДокумента, 0) КАК СуммаДокумента,
		|	ДолгПоЭтапамОплат.Дата
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	НеОплаченныеДокументы КАК НеОплаченныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ ДолгПоЭтапамОплат КАК ДолгПоЭтапамОплат
		|		ПО НеОплаченныеДокументы.ДокументРасчета = ДолгПоЭтапамОплат.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПроведенныеОплаты КАК ПроведенныеОплаты
		|		ПО НеОплаченныеДокументы.ДокументРасчета = ПроведенныеОплаты.ДокументРасчета
		|ГДЕ
		|	ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0) > 0
		|	И НеОплаченныеДокументы.КОплатеОстаток > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Результат.ДокументРасчета КАК ДокументРасчета,
		|	Результат.КОплатеПоЭтапам,
		|	Результат.НеОплаченнаяСумма КАК КОплате,
		|	Результат.СуммаДокумента,
		|	ВЫБОР
		|		КОГДА РасшифровкаПлатежа.СуммаИзДокумента ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Пометка,
		|	ЕСТЬNULL(РасшифровкаПлатежа.СуммаИзДокумента, 0) КАК Сумма
		|ИЗ
		|	Результат КАК Результат
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			РасшифровкаПлатежа.Документ КАК Документ,
		|			СУММА(РасшифровкаПлатежа.СуммаИзДокумента) КАК СуммаИзДокумента
		|		ИЗ
		|			РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|		
		|		СГРУППИРОВАТЬ ПО
		|			РасшифровкаПлатежа.Документ) КАК РасшифровкаПлатежа
		|		ПО Результат.ДокументРасчета = РасшифровкаПлатежа.Документ
		|ГДЕ Результат.НеОплаченнаяСумма > 0
		|УПОРЯДОЧИТЬ ПО
		|	Результат.Дата";
		
		ФормаОплаты = Новый СписокЗначений;
		
		Если ОтборФормаОплаты = Перечисления.ФормыОплаты.ПустаяСсылка() Тогда
			ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Наличная);
			ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Безналичная);
		ИначеЕсли ОтборФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
			ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Наличная);
		ИначеЕсли ОтборФормаОплаты = Перечисления.ФормыОплаты.Безналичная Тогда
			ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Безналичная);
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ДатаПлатежа", ДатаПлатежа);
		Запрос.УстановитьПараметр("ФормаОплаты", ФормаОплаты);
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчета,
		|	РасшифровкаПлатежа.Сумма КАК Сумма
		|ПОМЕСТИТЬ РасшифровкаПлатежа
		|ИЗ
		|	&РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСПоставщиками.ДокументРасчета КАК ДокументРасчета,
		|	СУММА(РасчетыСПоставщиками.КОплатеОстаток) КАК КОплате
		|ПОМЕСТИТЬ РасчетыСПоставщиками
		|ИЗ
		|	(ВЫБРАТЬ
		|		РасчетыСПоставщикамиОстатки.ДокументРасчета КАК ДокументРасчета,
		|		РасчетыСПоставщикамиОстатки.КОплатеОстаток КАК КОплатеОстаток
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
		|				,
		|				Магазин = &Магазин
		|					И Поставщик = &Контрагент
		|					И ДокументРасчета ССЫЛКА Документ.ВозвратТоваровПоставщику) КАК РасчетыСПоставщикамиОстатки
		|	ГДЕ
		|		РасчетыСПоставщикамиОстатки.КОплатеОстаток > 0
		|		И РасчетыСПоставщикамиОстатки.ДокументРасчета.Организация = &Организация
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		РасчетыСПоставщикамиОбороты.ДокументРасчета,
		|		-РасчетыСПоставщикамиОбороты.КОплатеОборот
		|	ИЗ
		|		РегистрНакопления.РасчетыСПоставщиками.Обороты(
		|				,
		|				,
		|				Регистратор,
		|				Магазин = &Магазин
		|					И Поставщик = &Контрагент) КАК РасчетыСПоставщикамиОбороты
		|	ГДЕ
		|		РасчетыСПоставщикамиОбороты.Регистратор = &Ссылка) КАК РасчетыСПоставщиками
		|
		|СГРУППИРОВАТЬ ПО
		|	РасчетыСПоставщиками.ДокументРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСПоставщиками.ДокументРасчета КАК ДокументРасчета,
		|	РасчетыСПоставщиками.КОплате,
		|	РасчетыСПоставщиками.ДокументРасчета.СуммаДокумента КАК СуммаДокумента,
		|	РасчетыСПоставщиками.ДокументРасчета.Дата КАК ДокументРасчетаДата
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	РасчетыСПоставщиками КАК РасчетыСПоставщиками
		|ГДЕ
		|	РасчетыСПоставщиками.КОплате > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Результат.ДокументРасчета,
		|	Результат.КОплате,
		|	Результат.СуммаДокумента,
		|	Результат.ДокументРасчетаДата КАК ДокументРасчетаДата,
		|	ЕСТЬNULL(РасшифровкаПлатежа.Сумма, 0) КАК Сумма,
		|	ВЫБОР
		|		КОГДА РасшифровкаПлатежа.Сумма ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Пометка
		|ИЗ
		|	Результат КАК Результат
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			РасшифровкаПлатежа.ДокументРасчета,
		|			СУММА(РасшифровкаПлатежа.Сумма) КАК Сумма
		|		ИЗ
		|			РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|		
		|		СГРУППИРОВАТЬ ПО
		|			РасшифровкаПлатежа.ДокументРасчета) КАК РасшифровкаПлатежа
		|		ПО Результат.ДокументРасчета = РасшифровкаПлатежа.ДокументРасчета
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументРасчетаДата";
		
	КонецЕсли;
	
	Если ПустаяСтрока(АдресХранилищаРасшифровкаПлатежа) Тогда
		РасшифровкаПлатежа = СоздатьПустуюТЗРасшифровкаПлатежа();
	Иначе
		РасшифровкаПлатежа = ПолучитьИзВременногоХранилища(АдресХранилищаРасшифровкаПлатежа);
	КонецЕсли;
	Запрос.УстановитьПараметр("РасшифровкаПлатежа", РасшифровкаПлатежа);
	
	Запрос.УстановитьПараметр("Магазин", 	Магазин);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Ссылка", 	Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	
	Объект.Корзина.Загрузить(Результат.Выгрузить());
	
	ОбновитьИтоговыеПоказателиСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКорзинуДерево()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом КАК ДокументРасчета,
	|	РасшифровкаПлатежа.Сумма КАК СуммаИзДокумента
	|ПОМЕСТИТЬ РасшифровкаПлатежа
	|ИЗ
	|	&РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыСПоставщиками.ДокументРасчета КАК ДокументРасчета,
	|	СУММА(РасчетыСПоставщиками.КОплатеОстаток) КАК КОплатеОстаток
	|ПОМЕСТИТЬ НеОплаченныеДокументы
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.ДокументРасчета КАК ДокументРасчета,
	|		-РасчетыСПоставщикамиОстатки.КОплатеОстаток КАК КОплатеОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Магазин = &Магазин
	|					И Поставщик = &Контрагент) КАК РасчетыСПоставщикамиОстатки
	|	ГДЕ
	|		РасчетыСПоставщикамиОстатки.КОплатеОстаток < 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РасчетыСПоставщикамиОбороты.ДокументРасчета,
	|		РасчетыСПоставщикамиОбороты.КОплатеОборот
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Обороты(
	|				,
	|				,
	|				Регистратор,
	|				Магазин = &Магазин
	|					И Поставщик = &Контрагент) КАК РасчетыСПоставщикамиОбороты
	|	ГДЕ
	|		РасчетыСПоставщикамиОбороты.Регистратор = &Ссылка) КАК РасчетыСПоставщиками
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщиками.ДокументРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказПоставщикуЭтапыОплат.Ссылка,
	|	СУММА(ЗаказПоставщикуЭтапыОплат.Сумма) КАК Сумма,
	|	ЗаказПоставщикуЭтапыОплат.Ссылка.СуммаДокумента,
	|	ЗаказПоставщикуЭтапыОплат.Ссылка.Дата
	|ПОМЕСТИТЬ ДолгПоЭтапамОплат
	|ИЗ
	|	Документ.ЗаказПоставщику.ЭтапыОплат КАК ЗаказПоставщикуЭтапыОплат
	|ГДЕ
	|	ЗаказПоставщикуЭтапыОплат.Ссылка В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				НеОплаченныеДокументы.ДокументРасчета
	|			ИЗ
	|				НеОплаченныеДокументы КАК НеОплаченныеДокументы)
	|	И ЗаказПоставщикуЭтапыОплат.ФормаОплаты <> ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Взаимозачет)
	|	И ЗаказПоставщикуЭтапыОплат.ФормаОплаты В(&ФормаОплаты)
	|	И ЗаказПоставщикуЭтапыОплат.ДатаПлатежа <= &ДатаПлатежа
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщикуЭтапыОплат.Ссылка,
	|	ЗаказПоставщикуЭтапыОплат.Ссылка.СуммаДокумента,
	|	ЗаказПоставщикуЭтапыОплат.Ссылка.Дата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровЭтапыОплат.Ссылка,
	|	СУММА(ПоступлениеТоваровЭтапыОплат.Сумма),
	|	ПоступлениеТоваровЭтапыОплат.Ссылка.СуммаДокумента,
	|	ПоступлениеТоваровЭтапыОплат.Ссылка.Дата
	|ИЗ
	|	Документ.ПоступлениеТоваров.ЭтапыОплат КАК ПоступлениеТоваровЭтапыОплат
	|ГДЕ
	|	ПоступлениеТоваровЭтапыОплат.Ссылка В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				НеОплаченныеДокументы.ДокументРасчета
	|			ИЗ
	|				НеОплаченныеДокументы КАК НеОплаченныеДокументы)
	|	И ПоступлениеТоваровЭтапыОплат.ФормаОплаты <> ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Взаимозачет)
	|	И ПоступлениеТоваровЭтапыОплат.ФормаОплаты В(&ФормаОплаты)
	|	И ПоступлениеТоваровЭтапыОплат.ДатаПлатежа <= &ДатаПлатежа
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеТоваровЭтапыОплат.Ссылка,
	|	ПоступлениеТоваровЭтапыОплат.Ссылка.СуммаДокумента,
	|	ПоступлениеТоваровЭтапыОплат.Ссылка.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НеОплаченныеДокументы.ДокументРасчета КАК ДокументРасчета,
	|	ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0) КАК КОплатеПоЭтапам,
	|	ВЫБОР
	|		КОГДА НеОплаченныеДокументы.КОплатеОстаток < ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0)
	|			ТОГДА НеОплаченныеДокументы.КОплатеОстаток
	|		ИНАЧЕ ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0)
	|	КОНЕЦ КАК НеОплаченнаяСумма,
	|	ЕСТЬNULL(ДолгПоЭтапамОплат.СуммаДокумента, 0) КАК СуммаДокумента,
	|	ДолгПоЭтапамОплат.Дата
	|ПОМЕСТИТЬ Результат
	|ИЗ
	|	НеОплаченныеДокументы КАК НеОплаченныеДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДолгПоЭтапамОплат КАК ДолгПоЭтапамОплат
	|		ПО НеОплаченныеДокументы.ДокументРасчета = ДолгПоЭтапамОплат.Ссылка
	|ГДЕ
	|	ЕСТЬNULL(ДолгПоЭтапамОплат.Сумма, 0) > 0
	|	И НеОплаченныеДокументы.КОплатеОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка КАК Заявка,
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.Дата,
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.Статус,
	|	ЕСТЬNULL(-ДенежныеСредстваКВыплатеОстаткиИОбороты.СуммаКонечныйОстаток, ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Сумма) КАК Сумма,
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом,
	|	ВЫБОР
	|		КОГДА ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ЖелательнаяДатаПлатежа
	|		ИНАЧЕ ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ДатаПлатежа
	|	КОНЕЦ КАК ДатаПлатежа,
	|	ДенежныеСредстваКВыплатеОстаткиИОбороты.СуммаКонечныйОстаток,
	|	ДенежныеСредстваКВыплатеОстаткиИОбороты.СуммаПриход,
	|	ДенежныеСредстваКВыплатеОстаткиИОбороты.СуммаРасход
	|ПОМЕСТИТЬ Заявки
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.ОстаткиИОбороты(, , , , ) КАК ДенежныеСредстваКВыплатеОстаткиИОбороты
	|		ПО ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка = ДенежныеСредстваКВыплатеОстаткиИОбороты.РаспоряжениеНаРасходованиеДенежныхСредств
	|			И ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств = ДенежныеСредстваКВыплатеОстаткиИОбороты.СтатьяДвиженияДенежныхСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.ДокументРасчетовСКонтрагентом В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Результат.ДокументРасчета
	|			ИЗ
	|				Результат КАК Результат)
	|	И ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.Проведен
	|	И ВЫБОР
	|			КОГДА ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ДатаПлатежа = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ЖелательнаяДатаПлатежа
	|			ИНАЧЕ ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ДатаПлатежа
	|		КОНЕЦ <= &ДатаПлатежа
	|	И НЕ ЕСТЬNULL(-ДенежныеСредстваКВыплатеОстаткиИОбороты.СуммаКонечныйОстаток, ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Сумма) = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Результат.ДокументРасчета КАК ДокументРасчета,
	|	Результат.КОплатеПоЭтапам КАК КОплатеПоЭтапам,
	|	Результат.НеОплаченнаяСумма КАК КОплате,
	|	Результат.СуммаДокумента КАК СуммаДокумента,
	|	Заявки.Заявка,
	|	Заявки.Дата,
	|	Заявки.Статус,
	|	Заявки.Сумма КАК СуммаЗаявок,
	|	ВЫБОР
	|		КОГДА Заявки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена)
	|			ТОГДА 0
	|		ИНАЧЕ Заявки.Сумма
	|	КОНЕЦ КАК СуммаЗаявокИтог,
	|	ЕСТЬNULL(РасшифровкаПлатежа.СуммаИзДокумента, 0) КАК Сумма,
	|	ВЫБОР
	|		КОГДА РасшифровкаПлатежа.СуммаИзДокумента ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	Результат КАК Результат
	|		ЛЕВОЕ СОЕДИНЕНИЕ Заявки КАК Заявки
	|		ПО Результат.ДокументРасчета = Заявки.ДокументРасчетовСКонтрагентом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|		ПО Результат.ДокументРасчета = РасшифровкаПлатежа.ДокументРасчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Результат.ДокументРасчета.Дата,
	|	Заявки.Дата
	|ИТОГИ
	|	МАКСИМУМ(КОплатеПоЭтапам),
	|	МАКСИМУМ(КОплате),
	|	МАКСИМУМ(СуммаДокумента),
	|	СУММА(СуммаЗаявок),
	|	СУММА(СуммаЗаявокИтог),
	|	МАКСИМУМ(Сумма),
	|	МАКСИМУМ(Пометка)
	|ПО
	|	ДокументРасчета";
	
	ФормаОплаты = Новый СписокЗначений;
	
	Если ОтборФормаОплаты = Перечисления.ФормыОплаты.ПустаяСсылка() Тогда
		ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Наличная);
		ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Безналичная);
	ИначеЕсли ОтборФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
		ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Наличная);
	ИначеЕсли ОтборФормаОплаты = Перечисления.ФормыОплаты.Безналичная Тогда
		ФормаОплаты.Добавить(Перечисления.ФормыОплаты.Безналичная);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДатаПлатежа", ДатаПлатежа);
	Запрос.УстановитьПараметр("ФормаОплаты", ФормаОплаты);
	
	Если ПустаяСтрока(АдресХранилищаРасшифровкаПлатежа) Тогда
		РасшифровкаПлатежа = СоздатьПустуюТЗРасшифровкаПлатежа();
	Иначе
		РасшифровкаПлатежа = ПолучитьИзВременногоХранилища(АдресХранилищаРасшифровкаПлатежа);
	КонецЕсли;
	Запрос.УстановитьПараметр("РасшифровкаПлатежа", РасшифровкаПлатежа);
	
	Запрос.УстановитьПараметр("Магазин", 	Магазин);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Дерево = РеквизитФормыВЗначение("КорзинаДерево");
	Дерево.Строки.Очистить();
	
	Если НЕ Результат.Пустой() Тогда
		
		ВыборкаПоДокументам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоДокументам.Следующий() Цикл
			
			СтрокаДокумент = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДокумент, ВыборкаПоДокументам);
			СтрокаДокумент.СуммаЗаявок = ВыборкаПоДокументам.СуммаЗаявокИтог;
			
			Выборка = ВыборкаПоДокументам.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если ЗначениеЗаполнено(Выборка.Заявка) Тогда
					СтрокаЗаявка = СтрокаДокумент.Строки.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаЗаявка, Выборка, "СуммаЗаявок, Статус");
					СтрокаЗаявка.ДокументРасчета = Выборка.Заявка;
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, "КорзинаДерево");
	ОбновитьИтоговыеПоказателиСервер();
	
КонецПроцедуры

&НаСервере
Функция ПоместитьКорзинуВХранилище()
	
	ТЧКорзина = Объект.Корзина.Выгрузить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом,
	|	РасшифровкаПлатежа.Сумма,
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ РасшифровкаПлатежа
	|ИЗ
	|	&РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧКорзина.ДокументРасчета КАК Ссылка,
	|	ТЧКорзина.Пометка,
	|	ТЧКорзина.Сумма
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ТЧКорзина КАК ТЧКорзина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом, ТаблицаДокументов.Ссылка) КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Ссылка ЕСТЬ NULL 
	|			ТОГДА РасшифровкаПлатежа.Сумма
	|		ИНАЧЕ ТаблицаДокументов.Сумма
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА ТаблицаДокументов.Ссылка ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ТаблицаДокументов.Пометка
	|	КОНЕЦ КАК Пометка,
	|	РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ПОМЕСТИТЬ Результат
	|ИЗ
	|	РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|		ПО РасшифровкаПлатежа.ДокументРасчетовСКонтрагентом = ТаблицаДокументов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Результат.Ссылка КАК ДокументРасчетовСКонтрагентом,
	|	Результат.Сумма КАК Сумма,
	|	Результат.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Результат КАК Результат
	|ГДЕ
	|	Результат.Сумма > 0
	|	И Результат.Пометка";
	
	Если ПодборИзЗаявки Тогда
		Дерево = РеквизитФормыВЗначение("КорзинаДерево");
		
		Для Каждого СтрокаДерева Из Дерево.Строки Цикл
			НовСтрока = ТЧКорзина.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, СтрокаДерева);
		КонецЦикла;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТЧКорзина", ТЧКорзина);
	
	Если ПустаяСтрока(АдресХранилищаРасшифровкаПлатежа) Тогда
		РасшифровкаПлатежа = СоздатьПустуюТЗРасшифровкаПлатежа();
	Иначе
		РасшифровкаПлатежа = ПолучитьИзВременногоХранилища(АдресХранилищаРасшифровкаПлатежа);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("РасшифровкаПлатежа", РасшифровкаПлатежа);
	Результат = Запрос.Выполнить();
	
	Корзина = Результат.Выгрузить();
	
	АдресКорзиныВХранилище = ПоместитьВоВременноеХранилище(Корзина, УникальныйИдентификатор);
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("АдресКорзиныВХранилище", АдресКорзиныВХранилище);
	СтруктураРезультат.Вставить("ФормаОплаты", ОтборФормаОплаты);
	СтруктураРезультат.Вставить("ДатаПлатежа", ДатаПлатежа);
	
	Возврат СтруктураРезультат;
	
КонецФункции

&НаКлиенте
Процедура УстановитьСнятьПометку(Пометка)
	
	ВыделенныеСтроки = ?(ПодборИзЗаявки, Элементы.КорзинаДерево.ВыделенныеСтроки, Элементы.Корзина.ВыделенныеСтроки);
	
	Корзина = ?(ПодборИзЗаявки, КорзинаДерево, Объект.Корзина);
	
	Для Каждого Идентификатор Из ВыделенныеСтроки Цикл
		Строка = Корзина.НайтиПоИдентификатору(Идентификатор);
		Строка.Пометка = Пометка;
		
		Если Строка.Сумма = 0 И Пометка Тогда
			Строка.Сумма = ?(ПодборИзЗаявки, Строка.КОплате - Строка.СуммаЗаявок, Строка.КОплате);
		ИначеЕсли Не Пометка Тогда
			Строка.Сумма = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоговыеПоказатели()
	
	СуммаИтог = 0;
	
	Коллекция = ?(ПодборИзЗаявки, КорзинаДерево.ПолучитьЭлементы(), Объект.Корзина);
	
	Для Каждого Строка Из Коллекция Цикл
		
		Если Строка.Пометка Тогда
			СуммаИтог = СуммаИтог + Строка.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
	ИтогоСумма = СуммаИтог;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоговыеПоказателиСервер()
	
	СуммаИтог = 0;
	КОплатеИтог = 0;
	
	Коллекция = ?(ПодборИзЗаявки, КорзинаДерево.ПолучитьЭлементы(), Объект.Корзина);
	
	Для Каждого Строка Из Коллекция Цикл
		
		Если Строка.Пометка Тогда
			СуммаИтог = СуммаИтог + Строка.Сумма;
		КонецЕсли;
		КОплатеИтог = КОплатеИтог + Строка.КОплате;
		
	КонецЦикла;
	
	ИтогоКОплате = КОплатеИтог;
	ИтогоСумма = СуммаИтог;
	
КонецПроцедуры

&НаСервере
Функция СоздатьПустуюТЗРасшифровкаПлатежа()
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваров"));
	ДопустимыеТипы = Новый ОписаниеТипов(МассивТипов);
	
	РасшифровкаПлатежа = Новый ТаблицаЗначений;
	РасшифровкаПлатежа.Колонки.Добавить("ДокументРасчетовСКонтрагентом", ДопустимыеТипы);
	РасшифровкаПлатежа.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
	РасшифровкаПлатежа.Колонки.Добавить("СтатьяДвиженияДенежныхСредств", Новый ОписаниеТипов("СправочникСсылка.СтатьиДвиженияДенежныхСредств"));
	
	Возврат РасшифровкаПлатежа;
	
КонецФункции

#КонецОбласти
