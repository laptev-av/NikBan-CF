﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	ЗаполнитьСписокОплат(Ссылка);
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиСписокОплат

&НаКлиенте
Процедура СписокОплатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоле = Поле.Имя;
	ИмяРеквизита = СтрЗаменить(Поле.Имя, "СписокОплат", "");
	
	Если ИмяРеквизита <> "ДокументОплаты" Тогда
		Возврат;
	КонецЕсли;
	
	Значение = Элемент.ТекущиеДанные[ИмяРеквизита];
	Если ЗначениеЗаполнено(Значение) Тогда
		ПоказатьЗначение(,Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокОплат(ДокументРасчета)
	
	Запрос = Новый Запрос;
	
	Если ТипЗнч(ДокументРасчета) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда
		
		Запрос.Текст =  "ВЫБРАТЬ
		|	РасчетыСПоставщикамиОбороты.Регистратор КАК ДокументОплаты,
		|	ВЫБОР
		|		КОГДА РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|	КОНЕЦ КАК ФормаОплаты,
		|	РасчетыСПоставщикамиОбороты.КОплатеРасход КАК Сумма
		|ПОМЕСТИТЬ Оплата
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками.Обороты(, , Регистратор, ДокументРасчета = &ДокументРасчета) КАК РасчетыСПоставщикамиОбороты
		|ГДЕ
		|	РасчетыСПоставщикамиОбороты.Регистратор <> РасчетыСПоставщикамиОбороты.ДокументРасчета
		|	И (РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|			ИЛИ РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.РегистрацияБезналичнойОплаты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Оплата.ДокументОплаты КАК ДокументОплаты,
		|	Оплата.ФормаОплаты,
		|	Оплата.Сумма
		|ИЗ
		|	Оплата КАК Оплата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументОплаты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|				ТОГДА Оплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Наличные,
		|	СУММА(ВЫБОР
		|			КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|				ТОГДА Оплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Безналичные,
		|	СУММА(Оплата.Сумма) КАК Итого
		|ИЗ
		|	Оплата КАК Оплата";
		
	ИначеЕсли ТипЗнч(ДокументРасчета) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		
		Запрос.Текст ="ВЫБРАТЬ
		|	ДенежныеСредстваКВыплатеОбороты.Регистратор КАК ДокументОплаты,
		|	ВЫБОР
		|		КОГДА ДенежныеСредстваКВыплатеОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|	КОНЕЦ КАК ФормаОплаты,
		|	ДенежныеСредстваКВыплатеОбороты.СуммаПриход КАК Сумма
		|	ПОМЕСТИТЬ Оплата
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКВыплате.Обороты(, , Регистратор, РаспоряжениеНаРасходованиеДенежныхСредств = &ДокументРасчета) КАК ДенежныеСредстваКВыплатеОбороты
		|ГДЕ
		|	ДенежныеСредстваКВыплатеОбороты.СуммаПриход > 0;
		|	
		|	
		|	////////////////////////////////////////////////////////////////////////////////
		|		ВЫБРАТЬ
		|			Оплата.ДокументОплаты КАК ДокументОплаты,
		|			Оплата.ФормаОплаты,
		|			Оплата.Сумма
		|		ИЗ
		|			Оплата КАК Оплата
		|		
		|		УПОРЯДОЧИТЬ ПО
		|			ДокументОплаты
		|		;
		|		
		|		////////////////////////////////////////////////////////////////////////////////
		|		ВЫБРАТЬ
		|			СУММА(ВЫБОР
		|					КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|						ТОГДА Оплата.Сумма
		|					ИНАЧЕ 0
		|				КОНЕЦ) КАК Наличные,
		|			СУММА(ВЫБОР
		|					КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|						ТОГДА Оплата.Сумма
		|					ИНАЧЕ 0
		|				КОНЕЦ) КАК Безналичные,
		|			СУММА(Оплата.Сумма) КАК Итого
		|		ИЗ
		|			Оплата КАК Оплата";
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыСПоставщикамиОбороты.Регистратор КАК ДокументОплаты,
		|	ВЫБОР
		|		КОГДА РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|	КОНЕЦ КАК ФормаОплаты,
		|	РасчетыСПоставщикамиОбороты.КОплатеПриход КАК Сумма
		|ПОМЕСТИТЬ Оплата
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками.Обороты(, , Регистратор, ДокументРасчета = &ДокументРасчета) КАК РасчетыСПоставщикамиОбороты
		|ГДЕ
		|	РасчетыСПоставщикамиОбороты.Регистратор <> РасчетыСПоставщикамиОбороты.ДокументРасчета
		|	И (РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
		|			ИЛИ РасчетыСПоставщикамиОбороты.Регистратор ССЫЛКА Документ.РегистрацияБезналичнойОплаты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Оплата.ДокументОплаты КАК ДокументОплаты,
		|	Оплата.ФормаОплаты,
		|	Оплата.Сумма
		|ИЗ
		|	Оплата КАК Оплата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументОплаты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
		|				ТОГДА Оплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Наличные,
		|	СУММА(ВЫБОР
		|			КОГДА Оплата.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Безналичная)
		|				ТОГДА Оплата.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Безналичные,
		|	СУММА(Оплата.Сумма) КАК Итого
		|ИЗ
		|	Оплата КАК Оплата";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДокументРасчета", ДокументРасчета);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СписокОплат.Загрузить(Результат[1].Выгрузить());
	
	Если НЕ Результат[2].Пустой() Тогда
		Выборка = Результат[2].Выбрать();
		Выборка.Следующий();
		Итого = Выборка.Итого;
		ИтогоНаличными = Выборка.Наличные;
		ИтогоБезналичными = Выборка.Безналичные;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
