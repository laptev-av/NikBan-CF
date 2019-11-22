﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ГрафикОплат = Новый ТаблицаЗначений;
	
	МассивТиповДокументов = Новый Массив;
	МассивТиповДокументов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	МассивТиповДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеТоваров"));
	
	ГрафикОплат.Колонки.Добавить("Документ", Новый ОписаниеТипов("ДокументСсылка.ЗаказПоставщику, ДокументСсылка.ПоступлениеТоваров"));
	ГрафикОплат.Колонки.Добавить("Поставщик", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ГрафикОплат.Колонки.Добавить("Магазин", Новый ОписаниеТипов("СправочникСсылка.Магазины"));
	ГрафикОплат.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ГрафикОплат.Колонки.Добавить("ДатаПлатежа", Новый ОписаниеТипов("Дата"));
	ГрафикОплат.Колонки.Добавить("ВидПлатежа", Новый ОписаниеТипов("ПеречислениеСсылка.ВидПлатежа"));
	ГрафикОплат.Колонки.Добавить("ОтсрочкаПлатежа", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,0)));
	ГрафикОплат.Колонки.Добавить("ФормаОплаты", Новый ОписаниеТипов("ПеречислениеСсылка.ФормыОплаты"));
	ГрафикОплат.Колонки.Добавить("КОплате", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ГрафикОплат.Колонки.Добавить("Закрыт",  Новый ОписаниеТипов("Булево"));
	ГрафикОплат.Колонки.Добавить("ДатаПоступления", Новый ОписаниеТипов("Дата"));
	ГрафикОплат.Колонки.Добавить("РасчетнаяДата", Новый ОписаниеТипов("Дата"));
	ГрафикОплат.Колонки.Добавить("ДеньНедели", Новый ОписаниеТипов("ПеречислениеСсылка.ДниНедели"));
	
	ПараметрОтчетаПериод = ОбщегоНазначенияРТКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Период");
	НачалоПериода = ПараметрОтчетаПериод.Значение.ДатаНачала;
	КонецПериода  = ПараметрОтчетаПериод.Значение.ДатаОкончания;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ЗакупкиСервер.ПолучитьТекстЗапросаГрафикаОплатыПоставок();
	
	Результат = Запрос.Выполнить();
	
	ВыборкаПоДокументам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		ВсеЭтапыОплачены = ?(ВыборкаПоДокументам.КОплате <= 0, Истина, Ложь);
		
		Если ВсеЭтапыОплачены Тогда
			Продолжить;
		КонецЕсли;
		
		КОплате = ВыборкаПоДокументам.КОплате;
		Выборка = ВыборкаПоДокументам.Выбрать();
		
		Пока Выборка.Следующий() И КОплате > 0 Цикл
			
			НоваяСтрока = ГрафикОплат.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			Если НЕ ПараметрОтчетаПериод.Использование ИЛИ (Выборка.ДатаПлатежа >= НачалоПериода И Выборка.ДатаПлатежа <=КонецПериода) Тогда
				НоваяСтрока.ДеньНедели = Перечисления.ДниНедели[Выборка.НомерДняНедели-1];
			Иначе
				НоваяСтрока.ДеньНедели = "";
			КонецЕсли;
			
			Сумма = Мин(КОплате, Выборка.Сумма);
			НоваяСтрока.Сумма = Сумма;
			КОплате = КОплате - Сумма;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикОплат.Документ,
	|	ГрафикОплат.Поставщик,
	|	ГрафикОплат.Магазин,
	|	ГрафикОплат.ФормаОплаты,
	|	ГрафикОплат.ВидПлатежа,
	|	ГрафикОплат.ДатаПлатежа,
	|	ГрафикОплат.ДеньНедели,
	|	ГрафикОплат.ОтсрочкаПлатежа,
	|	ГрафикОплат.Сумма,
	|	ГрафикОплат.РасчетнаяДата,
	|	ГрафикОплат.ДатаПоступления,
	|	ГрафикОплат.Закрыт
	|ПОМЕСТИТЬ ГрафикОплат
	|ИЗ
	|	&ГрафикОплат КАК ГрафикОплат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикОплат.Документ,
	|	ГрафикОплат.Поставщик,
	|	ГрафикОплат.Магазин,
	|	ГрафикОплат.ФормаОплаты,
	|	ГрафикОплат.ВидПлатежа,
	|	ГрафикОплат.ОтсрочкаПлатежа,
	|	СУММА(ГрафикОплат.Сумма) КАК Сумма,
	|	ГрафикОплат.РасчетнаяДата,
	|	ГрафикОплат.ДатаПоступления,
	|	ГрафикОплат.Закрыт,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ГрафикОплат.Закрыт
	|					И ГрафикОплат.ВидПлатежа = ЗНАЧЕНИЕ(Перечисление.ВидПлатежа.ОтсрочкаПлатежа)
	|					И ГрафикОплат.РасчетнаяДата <> ГрафикОплат.ДатаПлатежа
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НеАктуальнаяДатаПлатежа,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ГрафикОплат.ВидПлатежа = ЗНАЧЕНИЕ(Перечисление.ВидПлатежа.ОтсрочкаПлатежа)
	|					И НЕ ГрафикОплат.Закрыт
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК НеПлановыйПлатеж,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ГрафикОплат.ДатаПлатежа < &ТекущаяДатаСеанса
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПросроченныйПлатеж,
	|	ГрафикОплат.ДеньНедели КАК ДеньНедели,
	|	ВЫБОР
	|		КОГДА НЕ &УстановленПериод
	|				ИЛИ ГрафикОплат.ДатаПлатежа МЕЖДУ &НачалоПериода И &КонецПериода
	|			ТОГДА ГрафикОплат.ДатаПлатежа
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ГрафикОплат.ДатаПлатежа < &НачалоПериода
	|					ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|				ИНАЧЕ ДАТАВРЕМЯ(3999, 1, 1)
	|			КОНЕЦ
	|	КОНЕЦ КАК ДатаПлатежа
	|ИЗ
	|	ГрафикОплат КАК ГрафикОплат
	|
	|СГРУППИРОВАТЬ ПО
	|	ГрафикОплат.ФормаОплаты,
	|	ГрафикОплат.ДеньНедели,
	|	ГрафикОплат.ВидПлатежа,
	|	ГрафикОплат.Магазин,
	|	ГрафикОплат.Закрыт,
	|	ГрафикОплат.ДатаПоступления,
	|	ГрафикОплат.РасчетнаяДата,
	|	ГрафикОплат.Документ,
	|	ГрафикОплат.ОтсрочкаПлатежа,
	|	ГрафикОплат.Поставщик,
	|	ВЫБОР
	|		КОГДА НЕ &УстановленПериод
	|				ИЛИ ГрафикОплат.ДатаПлатежа МЕЖДУ &НачалоПериода И &КонецПериода
	|			ТОГДА ГрафикОплат.ДатаПлатежа
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ГрафикОплат.ДатаПлатежа < &НачалоПериода
	|					ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|				ИНАЧЕ ДАТАВРЕМЯ(3999, 1, 1)
	|			КОНЕЦ
	|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("ГрафикОплат", 		ГрафикОплат);
	Запрос.УстановитьПараметр("ТекущаяДатаСеанса",	НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("НачалоПериода", 		ПараметрОтчетаПериод.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", 		ПараметрОтчетаПериод.Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("УстановленПериод", 	ПараметрОтчетаПериод.Использование);
	
	Результат = Запрос.Выполнить();
	
	ГрафикОплат = Результат.Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура();
	ВнешниеНаборыДанных.Вставить("ГрафикОплат", ГрафикОплат);
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ОбщегоНазначенияРТ.ВывестиДатуФормированияОтчета(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
