﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("Магазин") Тогда
		Магазин = Параметры.Магазин;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация, Ответственный);
	
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТабДок;
	
	Элементы.ТабДок.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ТабДок.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.ТабДок.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПроверкиПриИзменении(Элемент)
	УстановитьНеАктуальностьРасчетов();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьНеАктуальностьРасчетов();
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Прав(ДанныеСобытия.Href, 22) = "ЗапуститьПеренумерацию" Тогда
		ЗапуститьПеренумерацию();
	ИначеЕсли ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда
		Позиция = Найти(ДанныеСобытия.Href, "e1cib");
		Ссылка = Сред(ДанныеСобытия.Href,Позиция);
		
		ПерейтиПоНавигационнойСсылке(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	СформироватьНаСервере();
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПолеHTML;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыКПеренумерации.Очистить();
	ДанныеПроверки = ДанныеПроверки();
	ЕстьОшибки = Ложь;
	
	ТекстHTML = "<html>
	|<head>
	|<meta http-equiv=""Content-Language"" content=""ru"">
	|<meta http-equiv=""Content-Type"" content=""text/html; charset=windows-1251"">
	|</head>
	|<body>";
	
	// Документы, которые необходимо внести в кассовую книгу.
	Если НЕ ДанныеПроверки[3].Пустой() Тогда
		ТекстHTML = ТекстHTML + "<h3><p style=""margin-bottom: 0""><b>Необходимо внести в кассовую книгу: </b></p></h3>";
		ВыборкаДокументов = ДанныеПроверки[3].Выбрать();
			Пока ВыборкаДокументов.Следующий() Цикл
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаДокументов.Ссылка);
				ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0""><a href="+НавигационнаяСсылка+">" 
				+ ВыборкаДокументов.Представление + "</a></p>";
			КонецЦикла;
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	// Непроведенные ПКО и РКО, которые уже внесены в кассовую книгу.
	Если НЕ ДанныеПроверки[4].Пустой() Тогда
		ТекстHTML = ТекстHTML + "<h3><p style=""margin-bottom: 0""><b>Не проведенные документы в кассовой книге: </b></p></h3>";
		ВыборкаКассовыхЛистов = ДанныеПроверки[4].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКассовыхЛистов.Следующий() Цикл
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаКассовыхЛистов.КассоваяКнига);
				ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0""><a href="+НавигационнаяСсылка+">" 
				+ ВыборкаКассовыхЛистов.КассоваяКнигаПредставление + "</a></p>";
				
				
				ВыборкаПоДокументам = ВыборкаКассовыхЛистов.Выбрать();
				Пока ВыборкаПоДокументам.Следующий() Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаПоДокументам.Документ);
					ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+НавигационнаяСсылка+">" 
					+ ВыборкаПоДокументам.ДокументПредставление + "</a></p>";
				КонецЦикла;
				
			КонецЦикла;
		ЕстьОшибки = Истина;
	КонецЕсли;

	// Не совпадают суммы в кассовой книге и ПКО или РКО.
	Если НЕ ДанныеПроверки[5].Пустой() Тогда
		ТекстHTML = ТекстHTML + "<h3><p style=""margin-bottom: 0""><b>Сумма документа отличается от суммы в листе кассовой книги: </b></p></h3>";
		ВыборкаКассовыхЛистов = ДанныеПроверки[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКассовыхЛистов.Следующий() Цикл
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаКассовыхЛистов.КассоваяКнига);
				ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0""><a href="+НавигационнаяСсылка+">" 
				+ ВыборкаКассовыхЛистов.КассоваяКнигаПредставление + "</a></p>";
				
				
				ВыборкаПоДокументам = ВыборкаКассовыхЛистов.Выбрать();
				Пока ВыборкаПоДокументам.Следующий() Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаПоДокументам.Документ);
					ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+НавигационнаяСсылка+">" 
					+ ВыборкаПоДокументам.ДокументПредставление + "</a></p>";
				КонецЦикла;
				
			КонецЦикла;
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	// Дата ПКО или РКО отличается от даты листа кассовой книги.
	Если НЕ ДанныеПроверки[6].Пустой() Тогда
		ТекстHTML = ТекстHTML + "<h3><p style=""margin-bottom: 0""><b>Дата документа отличается от даты листа кассовой книги:</b></p></h3>";
		ВыборкаКассовыхЛистов = ДанныеПроверки[6].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаКассовыхЛистов.Следующий() Цикл
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаКассовыхЛистов.КассоваяКнига);
				ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0""><a href="+НавигационнаяСсылка+">" 
				+ ВыборкаКассовыхЛистов.КассоваяКнигаПредставление + "</a></p>";
				
				
				ВыборкаПоДокументам = ВыборкаКассовыхЛистов.Выбрать();
				Пока ВыборкаПоДокументам.Следующий() Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаПоДокументам.Документ);
					ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+НавигационнаяСсылка+">" 
					+ ВыборкаПоДокументам.ДокументПредставление + "</a></p>";
				КонецЦикла;
				
			КонецЦикла;
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	// проверки нумерации
	Если НЕ ДанныеПроверки[7].Пустой() Тогда
		
		ВыборкаПоГодам = ДанныеПроверки[7].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ВыведенЗаголовок = Ложь;
		
		Пока ВыборкаПоГодам.Следующий() Цикл
			
			ВыборкаПоДокументам = ВыборкаПоГодам.Выбрать();
			НомерЛиста = Неопределено;
			
			СбитаНумерация = Ложь;
			
			Пока ВыборкаПоДокументам.Следующий() Цикл
				
				Если НЕ СбитаНумерация Тогда
					Если НомерЛиста = Неопределено Тогда
						НомерЛиста = ВыборкаПоДокументам.НомерЛиста;
					Иначе
						НомерЛиста = НомерЛиста + 1;
						СбитаНумерация = НЕ ВыборкаПоДокументам.НомерЛиста = НомерЛиста;
					КонецЕсли;
					
				КонецЕсли;
				
				Если СбитаНумерация Тогда
					
					Если НЕ ВыведенЗаголовок Тогда
						ТекстHTML = ТекстHTML + "<h3><p style=""margin-bottom: 0""><b>Документы со сбитой нумерацией:</b></p></h3><A href=""ЗапуститьПеренумерацию"">Перенумеровать</a><p style=""margin-top: 0; margin-bottom: 0"">&nbsp;</p>";
						ВыведенЗаголовок = Истина;
					КонецЕсли;
					
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ВыборкаПоДокументам.КассоваяКнига);
					ТекстHTML = ТекстHTML + "<p style=""margin-top: 0; margin-bottom: 0""><a href="+НавигационнаяСсылка+">" 
					+ ВыборкаПоДокументам.КассоваяКнигаПредставление + НСтр("ru = ', № листа:'") + " " + ВыборкаПоДокументам.НомерЛиста + "</a></p>";
					
					ДокументыКПеренумерации.Добавить(ВыборкаПоДокументам.КассоваяКнига);
					ЕстьОшибки = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ ЕстьОшибки Тогда
		
		ТекстHTML = ТекстHTML + "<h4><p style=""margin-bottom: 0""><b><font color=""green"">Ошибок не обнаружено</font></b></p></h4>";
		
	КонецЕсли;
	
	ТекстHTML = ТекстHTML + "</body>
	|</html>";
	
	ПолеHTML = ТекстHTML;
	

КонецПроцедуры

&НаСервере
Функция ДанныеПроверки()
	
	// [0] - Временная таблица КассовыеКниги
	// [1] - временная таблица ТаблицаДокументов не сгруппированная
	// [2] - временная таблица ТаблицаДокументов
	// [3] - документы, которые необходимо внести в кассовую книгу
	// [4] - непроведенные ПКО и РКО, которые уже внесены в кассовую книгу
	// [5] - не совпадают суммы в кассовой книге и ПКО или РКО
	// [6] - дата ПКО или РКО отличается от даты листа кассовой книги
	// [7] - таблица для проверки нумерации.
	
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "ВЫБРАТЬ
	|	КассоваяКнигаКассовыеОрдера.Ссылка,
	|	КассоваяКнигаКассовыеОрдера.КассовыйОрдер
	|ПОМЕСТИТЬ КассовыеКниги
	|ИЗ
	|	Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаКассовыеОрдера
	|ГДЕ
	|	КассоваяКнигаКассовыеОрдера.Ссылка.Проведен
	|	И КассоваяКнигаКассовыеОрдера.Ссылка.Организация = &Организация
	|	И КассоваяКнигаКассовыеОрдера.Ссылка.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	%УсловиеМагазин%
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка КАК Ссылка,
	|	РасходныйКассовыйОрдер.Дата КАК Дата
	|ПОМЕСТИТЬ ТаблицаДокументовПредварительная
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|		ЛЕВОЕ СОЕДИНЕНИЕ КассовыеКниги КАК КассоваяКнигаДокументы
	|		ПО РасходныйКассовыйОрдер.Ссылка = КассоваяКнигаДокументы.КассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Проведен
	|	И РасходныйКассовыйОрдер.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И РасходныйКассовыйОрдер.Организация = &Организация
	|	И РасходныйКассовыйОрдер.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	%УсловиеМагазин1%
	|	И КассоваяКнигаДокументы.Ссылка ЕСТЬ NULL 
	|	И ВЫБОР
	|			КОГДА &Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)
	|				ТОГДА НЕ РасходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
	|			ИНАЧЕ ВЫБОР
	|					КОГДА РасходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
	|						ТОГДА НЕ РасходныйКассовыйОрдер.Касса.Магазин = РасходныйКассовыйОрдер.КассаПолучатель.Магазин
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.Ссылка.Дата
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер.РасшифровкаПлатежа КАК РасходныйКассовыйОрдер
	|		ЛЕВОЕ СОЕДИНЕНИЕ КассовыеКниги КАК КассоваяКнигаДокументы
	|		ПО РасходныйКассовыйОрдер.Ссылка = КассоваяКнигаДокументы.КассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Ссылка.Проведен
	|	И РасходныйКассовыйОрдер.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И РасходныйКассовыйОрдер.Ссылка.Организация = &Организация
	|	И РасходныйКассовыйОрдер.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	%УсловиеМагазин2%
	|	И КассоваяКнигаДокументы.Ссылка ЕСТЬ NULL 
	|	И ВЫБОР
	|			КОГДА &Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)
	|				ТОГДА НЕ РасходныйКассовыйОрдер.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
	|			ИНАЧЕ ВЫБОР
	|					КОГДА РасходныйКассовыйОрдер.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
	|						ТОГДА НЕ РасходныйКассовыйОрдер.Ссылка.Касса.Магазин = РасходныйКассовыйОрдер.Ссылка.КассаПолучатель.Магазин
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриходныйКассовыйОрдер.Ссылка,
	|	ПриходныйКассовыйОрдер.Дата
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|		ЛЕВОЕ СОЕДИНЕНИЕ КассовыеКниги КАК КассоваяКнигаДокументы
	|		ПО ПриходныйКассовыйОрдер.Ссылка = КассоваяКнигаДокументы.КассовыйОрдер
	|ГДЕ
	|	ПриходныйКассовыйОрдер.Проведен
	|	И ПриходныйКассовыйОрдер.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ПриходныйКассовыйОрдер.Организация = &Организация
	|	И ПриходныйКассовыйОрдер.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	%УсловиеМагазин3%
	|	И КассоваяКнигаДокументы.Ссылка ЕСТЬ NULL 
	|	И ВЫБОР
	|			КОГДА &Магазин = ЗНАЧЕНИЕ(Справочник.Магазины.ПустаяСсылка)
	|				ТОГДА НЕ ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
	|			ИНАЧЕ ВЫБОР
	|					КОГДА ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
	|						ТОГДА НЕ ПриходныйКассовыйОрдер.ДокументОснование.Касса.Магазин = ПриходныйКассовыйОрдер.Касса.Магазин
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументовПредварительная.Ссылка КАК Ссылка,
	|	ТаблицаДокументовПредварительная.Дата КАК Дата
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	ТаблицаДокументовПредварительная КАК ТаблицаДокументовПредварительная
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокументовПредварительная.Ссылка,
	|	ТаблицаДокументовПредварительная.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаДокументов.Ссылка) КАК Представление
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокументов.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассоваяКнигаДокументы.Ссылка КАК КассоваяКнига,
	|	КассоваяКнигаДокументы.КассовыйОрдер КАК Документ,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.Ссылка) КАК КассоваяКнигаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.КассовыйОрдер) КАК ДокументПредставление
	|ИЗ
	|	Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|ГДЕ
	|	КассоваяКнигаДокументы.Ссылка.Проведен
	|	И КассоваяКнигаДокументы.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ КассоваяКнигаДокументы.КассовыйОрдер.Проведен
	|	И КассоваяКнигаДокументы.Ссылка.Организация = &Организация
	|	И КассоваяКнигаДокументы.Ссылка.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	И КассоваяКнигаДокументы.Ссылка.Магазин = &Магазин
	|ИТОГИ ПО
	|	КассоваяКнига
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассоваяКнигаДокументы.Ссылка КАК КассоваяКнига,
	|	КассоваяКнигаДокументы.КассовыйОрдер КАК Документ,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.Ссылка) КАК КассоваяКнигаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.КассовыйОрдер) КАК ДокументПредставление
	|ИЗ
	|	Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|ГДЕ
	|	КассоваяКнигаДокументы.Ссылка.Проведен
	|	И КассоваяКнигаДокументы.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ КассоваяКнигаДокументы.КассовыйОрдер.СуммаДокумента = КассоваяКнигаДокументы.Приход
	|	И НЕ КассоваяКнигаДокументы.КассовыйОрдер.СуммаДокумента = КассоваяКнигаДокументы.Расход
	|	И КассоваяКнигаДокументы.Ссылка.Организация = &Организация
	|	И КассоваяКнигаДокументы.Ссылка.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	И КассоваяКнигаДокументы.Ссылка.Магазин = &Магазин
	|ИТОГИ ПО
	|	КассоваяКнига
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассоваяКнигаДокументы.Ссылка КАК КассоваяКнига,
	|	КассоваяКнигаДокументы.КассовыйОрдер КАК Документ,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.Ссылка) КАК КассоваяКнигаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.КассовыйОрдер) КАК ДокументПредставление
	|ИЗ
	|	Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|ГДЕ
	|	КассоваяКнигаДокументы.Ссылка.Проведен
	|	И КассоваяКнигаДокументы.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ(КассоваяКнигаДокументы.КассовыйОрдер.Дата МЕЖДУ НАЧАЛОПЕРИОДА(КассоваяКнигаДокументы.Ссылка.Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(КассоваяКнигаДокументы.Ссылка.Дата, ДЕНЬ))
	|	И КассоваяКнигаДокументы.Ссылка.Организация = &Организация
	|	И КассоваяКнигаДокументы.Ссылка.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	И КассоваяКнигаДокументы.Ссылка.Магазин = &Магазин
	|ИТОГИ ПО
	|	КассоваяКнига
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГОД(КассоваяКнигаДокументы.Ссылка.Дата) КАК Год,
	|	КассоваяКнигаДокументы.Ссылка КАК КассоваяКнига,
	|	ПРЕДСТАВЛЕНИЕ(КассоваяКнигаДокументы.Ссылка) КАК КассоваяКнигаПредставление,
	|	КассоваяКнигаДокументы.НомерЛиста КАК НомерЛиста,
	|	КассоваяКнигаДокументы.Ссылка.Дата КАК Дата
	|ИЗ
	|	Документ.КассоваяКнига.КассовыеОрдера КАК КассоваяКнигаДокументы
	|ГДЕ
	|	КассоваяКнигаДокументы.Ссылка.Организация = &Организация
	|	И КассоваяКнигаДокументы.Ссылка.ДоговорПлатежногоАгента = &ДоговорПлатежногоАгента
	|	И КассоваяКнигаДокументы.Ссылка.Магазин = &Магазин
	|	И КассоваяКнигаДокументы.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И КассоваяКнигаДокументы.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	НомерЛиста
	|ИТОГИ ПО
	|	Год";
	
	Если ЗначениеЗаполнено(Магазин) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин%" , "И КассоваяКнигаКассовыеОрдера.Ссылка.Магазин = &Магазин");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин1%", "И РасходныйКассовыйОрдер.Касса.Магазин = &Магазин");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин2%", "И РасходныйКассовыйОрдер.Ссылка.Касса.Магазин = &Магазин");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин3%", "И ПриходныйКассовыйОрдер.Касса.Магазин = &Магазин");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин%" , "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин1%", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин2%", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеМагазин3%", "");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДоговорПлатежногоАгента", ДоговорПлатежногоАгента);
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("НачалоПериода", ПериодПроверки.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ПериодПроверки.ДатаОкончания);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьПеренумерацию()
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Перенумерация'"),
		,
		НСтр("ru='Начата перенумерация листов кассовой книги'"),
		БиблиотекаКартинок.Обновить);
	
	Если ЗапуститьПеренумерациюСервер() Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перенумерация'"),
			,
			НСтр("ru='Перенумерация успешно завершена'"),
			БиблиотекаКартинок.Обновить);
		
	Иначе
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перенумерация'"),
			,
			НСтр("ru='Перенумерация прервана с ошибкой'"),
			БиблиотекаКартинок.Обновить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьПеренумерациюСервер()
	
	НетОшибок = Истина;
	
	НачатьТранзакцию();
	Для Каждого КассоваяКнигаСсылка Из ДокументыКПеренумерации Цикл
		
		КассоваяКнигаОбъект = КассоваяКнигаСсылка.Значение.ПолучитьОбъект();
		КассоваяКнигаОбъект.ЗаполнитьНомераЛистов();
		Попытка
			КассоваяКнигаОбъект.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ТекстСообщения = ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			НетОшибок = Ложь;
			Прервать;
		КонецПопытки;
	КонецЦикла;
	
	Если НетОшибок Тогда
		
		Попытка
			ЗафиксироватьТранзакцию();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат НетОшибок;
	
КонецФункции

&НаКлиенте
Процедура УстановитьНеАктуальностьРасчетов()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТабДок;
	
	Элементы.ТабДок.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ТабДок.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.ТабДок.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти
