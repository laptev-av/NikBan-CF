﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РежимОтображенияНоменклатуры = "Все";
	
	ТребуетсяОбновитьИнформациюПоНоменклатуре = Истина;
	
	ВедетсяУчетВидовНоменклатуры 
		= РаботаСНоменклатурой.ВедетсяУчетВидовНоменклатуры();
	
	ИнтернетПоддержкаПодключена 
		= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();	
		
	НастроитьВнешнийВидФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИнтернетПоддержкаПодключена Тогда
		ПолучитьОбновления();
	Иначе
		ПолучитьОбновленияПослеОткрытия = Новый ОписаниеОповещения("ПолучитьОбновленияПослеОткрытия",
			ЭтотОбъект);
			ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ПолучитьОбновленияПослеОткрытия,
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьТолькоИзмененныеНажатие(Элемент)
	
	РежимОтображенияНоменклатуры = "Измененные";
	
	ОтобразитьДанные();	
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьТолькоНовыеНажатие(Элемент)
	
	РежимОтображенияНоменклатуры = "Новые";
	
	ОтобразитьДанные();	
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоказатьВсеНажатие(Элемент)
	
	РежимОтображенияНоменклатуры = "Все";
	
	ОтобразитьДанные();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОбновляемыеАвтоматическиПриИзменении(Элемент)
		
	ИзменитьВидимостьОбновляемыхАвтоматически();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Если Элементы.СписокНоменклатуры.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНоменклатуру(Элементы.СписокНоменклатуры.ТекущаяСтрока);
	
	ПолучитьОбновленияНоменклатуры(Элементы.СписокНоменклатуры.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	
	ОбновитьНоменклатуру();
	
	ПолучитьОбновленияНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаНоменклатура Тогда
		Закрыть();
	Иначе
		Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаНоменклатура;
        ПолучитьОбновленияНоменклатуры();
	КонецЕсли;
	
	ИзменитьСвойстваЭлементов();
		
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаВидыНоменклатуры;
	
	ИзменитьСвойстваЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьОбновления()
	
	Если ВедетсяУчетВидовНоменклатуры Тогда
		ПолучитьОбновленияВидовНоменклатуры();
	Иначе
		ПолучитьОбновленияНоменклатуры();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОбновленияПослеОткрытия(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("Логин") Тогда
		
		ИнтернетПоддержкаПодключена = Истина;
		Элементы.ГруппаКнопкиНавигации.Доступность = Истина;
		ПолучитьОбновления()
		
	Иначе
		ТекстСообщения = НСтр("ru = 'Отсутствует подключение к Интернет-поддержке пользователей.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Элементы.ГруппаКнопкиНавигации.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВнешнийВидФормы()
	
	ИзменитьВидПанелиОтборов();
	
	Элементы.Назад.Видимость = Ложь;
	
	Если Не ВедетсяУчетВидовНоменклатуры Тогда
		Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаНоменклатура;
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'")
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСвойстваЭлементов()
	
	Если Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаНоменклатура Тогда
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'")
	ИначеЕсли Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаВидыНоменклатуры Тогда	
		Элементы.Далее.Заголовок = НСтр("ru = 'Далее'")	
	КонецЕсли;
	
	Элементы.Назад.Видимость = Элементы.ГруппаСтраницыТаблиц.ТекущаяСтраница = Элементы.СтраницаНоменклатура;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьОбновляемыхАвтоматически()
	
	Для каждого ЭлементКоллекции Из УсловноеОформление.Элементы Цикл
		
		Если ЭлементКоллекции.Представление = "ВидыНоменклатурыАвтообновление" 
			ИЛИ ЭлементКоллекции.Представление = "НоменклатураАвтообновление" Тогда
			
			ЭлементКоллекции.Использование = НЕ ПоказатьОбновляемыеАвтоматически;
		КонецЕсли;
				
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	#Область ВидНоменклатуры
	
	// Тест автоматически обновляемых
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Автоматическое обновление'"));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокВидовНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВидовНоменклатурыОписаниеИзменений.Имя);
	
	// Цвет автоматически обновляемых
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(200, 200, 200));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокВидовНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВидовНоменклатуры.Имя);
	
	// Тест обновлено
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Обновлено'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(100, 176, 16));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокВидовНоменклатуры.Обновлено");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВидовНоменклатурыОписаниеИзменений.Имя);
	
	#КонецОбласти
	
	#Область Номенклатура
	
	// Тест автоматически обновляемых
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Автоматическое обновление'"));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокНоменклатурыОписаниеИзменений.Имя);
	
	// Цвет автоматически обновляемых
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(200, 200, 200));
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокНоменклатуры.Имя);		
	
	#КонецОбласти
	
	#Область ОтборНоменклатуры

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Использование = Ложь;
	ЭлементУсловногоОформления.Представление = "ТолькоИзмененные";

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокНоменклатуры.КоличествоНовыхЗначений");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	// Для управления видимостью нужно указывать все колонки
	
	Для каждого ЭлементКоллекции Из Элементы.СписокНоменклатуры.ПодчиненныеЭлементы Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементКоллекции.Имя);
	КонецЦикла;
	
	////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Использование = Ложь;
	ЭлементУсловногоОформления.Представление = "ТолькоНовые";
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокНоменклатуры.КоличествоИзмененныхЗначений");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	// Для управления видимостью нужно указывать все колонки
	
	Для каждого ЭлементКоллекции Из Элементы.СписокНоменклатуры.ПодчиненныеЭлементы Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементКоллекции.Имя);
	КонецЦикла;

	#КонецОбласти	
	
	#Область АвтоматическиОбновляемые

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Представление = "ВидыНоменклатурыАвтообновление";
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокВидовНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	// Для управления видимостью нужно указывать все колонки
	
	Для каждого ЭлементКоллекции Из Элементы.СписокВидовНоменклатуры.ПодчиненныеЭлементы Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементКоллекции.Имя);
	КонецЦикла;

	////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Представление = "НоменклатураАвтообновление";
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));	
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СписокНоменклатуры.ОбновляетсяАвтоматически");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	// Для управления видимостью нужно указывать все колонки
	
	Для каждого ЭлементКоллекции Из Элементы.СписокНоменклатуры.ПодчиненныеЭлементы Цикл
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементКоллекции.Имя);
	КонецЦикла;

	#КонецОбласти	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНоменклатуру(ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		НоменклатураДляОбновления = СписокНоменклатуры;
	Иначе
		НоменклатураДляОбновления = Новый Массив;
		НоменклатураДляОбновления.Добавить(СписокНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока));
	КонецЕсли;
	
	Для каждого ТекущаяНоменклатура Из НоменклатураДляОбновления Цикл
		
		СтрокиРеквизитов = РеквизитыНоменклатурыДляОбновления.Выгрузить(Новый Структура("Номенклатура", ТекущаяНоменклатура.Номенклатура));
		
		Если СтрокиРеквизитов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			РаботаСНоменклатуройПереопределяемый.ЗаполнитьНоменклатуру(
				ТекущаяНоменклатура.Номенклатура, СтрокиРеквизитов.Скопировать(Новый Структура("ЯвляетсяДополнительнымРеквизитом", Ложь)));
			
			РаботаСНоменклатуройПереопределяемый.ЗаполнитьДополнительныеРеквизитыНоменклатуры(
				ТекущаяНоменклатура.Номенклатура, СтрокиРеквизитов.Скопировать(Новый Структура("ЯвляетсяДополнительнымРеквизитом", Истина)));
				
			Если ТекущаяНоменклатура.КоличествоВыбранныхРеквизитов = ТекущаяНоменклатура.КоличествоНовыхЗначений + ТекущаяНоменклатура.КоличествоИзмененныхЗначений Тогда
				РаботаСНоменклатурой.ИзменитьДатуОбновленияНоменклатуры(
					ТекущаяНоменклатура.Номенклатура, ТекущаяНоменклатура.ИдентификаторНоменклатуры);	
			КонецЕсли;	
				
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
		КонецПопытки;		
				
	КонецЦикла;

	ТребуетсяОбновитьИнформациюПоНоменклатуре = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзмененияНоменклатуры(АдресРезультата, ДополнительныеПараметры)
			
	Если Не ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Возврат;
	КонецЕсли; 
	
	ДанныеПоОбновляемойНоменклатуре = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если ДанныеПоОбновляемойНоменклатуре = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущаяСтрока = Неопределено;
	
	Если ДополнительныеПараметры.Свойство("ТекущаяСтрока", ТекущаяСтрока) Тогда
		
		СтрокаНоменклатуры = СписокНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока);
		
		ТаблицаРеквизитов = РеквизитыНоменклатурыДляОбновления.НайтиСтроки(
		Новый Структура("Номенклатура", СтрокаНоменклатуры.Номенклатура));
		
		Для каждого ЭлементКоллекции Из ТаблицаРеквизитов Цикл
			РеквизитыНоменклатурыДляОбновления.Удалить(ЭлементКоллекции);
		КонецЦикла;	
		
		РезультатАнализаНоменклатуры = ДанныеПоОбновляемойНоменклатуре.РезультатАнализаНоменклатуры;
		
		Если РезультатАнализаНоменклатуры.НайтиСтроки(
			Новый Структура("Номенклатура", СтрокаНоменклатуры.Номенклатура)).Количество() > 0 Тогда
			
			СтрокаДанных = РезультатАнализаНоменклатуры[0];
			
			Если СтрокаДанных.КоличествоИзмененныхЗначений = 0 И СтрокаДанных.КоличествоНовыхЗначений = 0 Тогда
				СписокНоменклатуры.Удалить(СтрокаНоменклатуры);
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокаНоменклатуры, СтрокаДанных);
				
				СтрокаНоменклатуры.КоличествоВыбранныхРеквизитов 
					= СтрокаДанных.КоличествоИзмененныхЗначений + СтрокаДанных.КоличествоНовыхЗначений;
				
				СтрокаНоменклатуры.ОписаниеИзменений = ТекстОперацииОбновленияНоменклатуры(
					СтрокаДанных.КоличествоИзмененныхЗначений + СтрокаДанных.КоличествоНовыхЗначений,
					СтрокаДанных.КоличествоИзмененныхЗначений, 
					СтрокаДанных.КоличествоНовыхЗначений);
			КонецЕсли;
						
		Иначе
			СписокНоменклатуры.Удалить(СтрокаНоменклатуры);		
		КонецЕсли;	
		
	Иначе 
		СписокНоменклатуры.Очистить();
		РеквизитыНоменклатурыДляОбновления.Очистить();
		
		Для каждого ЭлементКоллекции Из ДанныеПоОбновляемойНоменклатуре.РезультатАнализаНоменклатуры Цикл
			
			Если ЭлементКоллекции.КоличествоНовыхЗначений = 0
				И ЭлементКоллекции.КоличествоИзмененныхЗначений = 0 Тогда
				
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = СписокНоменклатуры.Добавить();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
			
			НоваяСтрока.КоличествоВыбранныхРеквизитов = НоваяСтрока.КоличествоИзмененныхЗначений + НоваяСтрока.КоличествоНовыхЗначений;
			
			НоваяСтрока.ОписаниеИзменений = ТекстОперацииОбновленияНоменклатуры(
				НоваяСтрока.КоличествоИзмененныхЗначений + НоваяСтрока.КоличествоНовыхЗначений,
				НоваяСтрока.КоличествоИзмененныхЗначений, 
				НоваяСтрока.КоличествоНовыхЗначений);
			
		КонецЦикла;	
		
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из ДанныеПоОбновляемойНоменклатуре.РеквизитыНоменклатурыДляОбновления Цикл
		ЗаполнитьЗначенияСвойств(РеквизитыНоменклатурыДляОбновления.Добавить(), ЭлементКоллекции);
	КонецЦикла;
	
	ТребуетсяОбновитьИнформациюПоНоменклатуре = Ложь;
	
	ОсталосьОбновитьНоменклатуры = СписокНоменклатуры.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзмененияВидовНоменклатуры(АдресРезультата, ДополнительныеПараметры)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Возврат;
	КонецЕсли; 
	
	ДанныеПоОбновляемымВидамНоменклатуры = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если ДанныеПоОбновляемымВидамНоменклатуры = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущаяСтрока = Неопределено;
	
	Если ДополнительныеПараметры.Свойство("ТекущаяСтрока", ТекущаяСтрока) Тогда
		
		СтрокаДанных = СписокВидовНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока);
		
		Если СтрокаДанных = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		
		Категория = ДанныеПоОбновляемымВидамНоменклатуры[0];
		
		СтрокаДанных.ВидНоменклатуры = Категория.ВидНоменклатуры;
		СтрокаДанных.ИдентификаторКатегории = Категория.ИдентификаторКатегории;
		
		Если ВидНоменклатурыОбновлен(Категория) Тогда
			СтрокаДанных.Обновлено = Истина;
		Иначе
			СтрокаДанных.ОписаниеИзменений = ТекстОперацииОбновленияВида(
			Категория.НеСопоставленоРеквизитов, 
			Категория.НеСопоставленоЗначений,
			Категория.ИзмененоРеквизитов);
		КонецЕсли;	
		
	Иначе 
		
		Для каждого Категория Из ДанныеПоОбновляемымВидамНоменклатуры Цикл
			
			Если ВидНоменклатурыОбновлен(Категория) Тогда
				Продолжить;
			КонецЕсли;
			
			////////////////////////////////////////////////////////////////////////////////
			
			НоваяСтрока = СписокВидовНоменклатуры.Добавить();
			
			НоваяСтрока.ВидНоменклатуры = Категория.ВидНоменклатуры;
			НоваяСтрока.ИдентификаторКатегории = Категория.ИдентификаторКатегории;
			НоваяСтрока.ПредставлениеКатегории = Категория.ПредставлениеКатегории;
			НоваяСтрока.ОбновляетсяАвтоматически = Категория.ОбновляетсяАвтоматически;
			
			Если НЕ Категория.ОбновляетсяАвтоматически Тогда
				НоваяСтрока.ОписаниеИзменений 
				= ТекстОперацииОбновленияВида(Категория.НеСопоставленоРеквизитов, Категория.НеСопоставленоЗначений, Категория.ИзмененоРеквизитов);				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли; 
		
	ОсталосьОбновитьВидовНоменклатуры = СписокВидовНоменклатуры.НайтиСтроки(Новый Структура("Обновлено", Ложь)).Количество();
	
	ТребуетсяОбновитьИнформациюПоНоменклатуре = Истина;
	
КонецПроцедуры

&НаСервере
Функция ВидНоменклатурыОбновлен(ДанныеПоИзменениям)
	
	Возврат ДанныеПоИзменениям.НеСопоставленоРеквизитов = 0
		И ДанныеПоИзменениям.НеСопоставленоЗначений = 0
		И ДанныеПоИзменениям.ИзмененоРеквизитов = 0;	
		
КонецФункции

&НаСервере
Функция ТекстОперацииОбновленияВида(НовыхРеквизитов = 0, НовыхЗначений = 0, Изменено = 0)
	
	ИтоговаяСтрока = Новый Массив;
	
	Если Изменено <> 0 Тогда
		ИтоговаяСтрока.Добавить(СтрШаблон(НСтр("ru = 'Изменено реквизитов (%1)'"), Изменено));
	КонецЕсли;
		
	Если НовыхРеквизитов <> 0 Тогда
		ИтоговаяСтрока.Добавить(СтрШаблон(НСтр("ru = 'Новых реквизитов (%1)'"), НовыхРеквизитов));
	КонецЕсли;
	
	Если НовыхЗначений <> 0 Тогда
		ИтоговаяСтрока.Добавить(СтрШаблон(НСтр("ru = 'Новых значений (%1)'"), НовыхЗначений));
	КонецЕсли;
		
	Возврат СтрСоединить(ИтоговаяСтрока, "; ");
	
КонецФункции

&НаСервере
Функция ТекстОперацииОбновленияНоменклатуры(ВыбраноРеквизитов = 0, ИзмененоЗначений = 0, ДобавленоЗначений = 0)
	
	ИтоговаяСтрока = Новый Массив;
	
	Если ИзмененоЗначений Тогда
		ИтоговаяСтрока.Добавить(СтрШаблон(НСтр("ru = 'изменено: (%1)'"), ИзмененоЗначений));
	КонецЕсли;
	
	Если ДобавленоЗначений Тогда
		ИтоговаяСтрока.Добавить(СтрШаблон(НСтр("ru = 'новых: (%1)'"), ДобавленоЗначений));
	КонецЕсли;
	
	Возврат СтрШаблон(НСтр("ru = 'Выбрано %1 из %2 %3'"), ВыбраноРеквизитов, ИзмененоЗначений + ДобавленоЗначений, СтрСоединить(ИтоговаяСтрока, "; "));
	
КонецФункции

&НаКлиенте
Процедура СписокВидовНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СписокВидовНоменклатурыОписаниеИзменений Тогда
		
		Если Элементы.СписокВидовНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ТекущиеДанные = Элементы.СписокВидовНоменклатуры.ТекущиеДанные;
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеОкнаЗаполненияВидаНоменклатуры", ЭтотОбъект);
		
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("ИдентификаторКатегории", ТекущиеДанные.ИдентификаторКатегории);
		ПараметрыФормы.Вставить("НаименованиеКатегории", ТекущиеДанные.ПредставлениеКатегории);
		ПараметрыФормы.Вставить("ВидНоменклатуры", ТекущиеДанные.ВидНоменклатуры);
		
		ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ЗаполнениеВидаНоменклатуры", ПараметрыФормы, ЭтаФорма,,,,Оповещение);
		
	ИначеЕсли Поле = Элементы.СписокВидовНоменклатурыВидНоменклатуры Тогда	
		
		Если Элементы.СписокВидовНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные = Элементы.СписокВидовНоменклатуры.ТекущиеДанные;
		
		РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуВидаНоменклатуры(ТекущиеДанные.ВидНоменклатуры, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СписокНоменклатурыОписаниеИзменений Тогда
		
		Если Элементы.СписокНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытиеОкнаЗаполненияНоменклатуры", 
			ЭтотОбъект, Новый Структура("Номенклатура, ВыбраннаяСтрока", ТекущиеДанные.Номенклатура, ВыбраннаяСтрока));
		
		ПараметрыФормы = Новый Структура;
		
		ПараметрыФормы.Вставить("ИдентификаторНоменклатуры", ТекущиеДанные.ИдентификаторНоменклатуры);
		ПараметрыФормы.Вставить("НоменклатураБазы", ТекущиеДанные.Номенклатура);
		ПараметрыФормы.Вставить("ВидНоменклатуры", ТекущиеДанные.ВидНоменклатуры);
		ПараметрыФормы.Вставить("ВызовИзПомощникаОбновления", Истина);
		ПараметрыФормы.Вставить("РеквизитыНоменклатурыДляОбновления", ИзмененныеРеквизиты(ТекущиеДанные.Номенклатура));
		
		ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ЗаполнениеНоменклатуры", ПараметрыФормы, ЭтаФорма,,,,Оповещение);
		
	ИначеЕсли Поле = Элементы.СписокНоменклатурыНоменклатура Тогда	
		
		Если Элементы.СписокНоменклатуры.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные = Элементы.СписокНоменклатуры.ТекущиеДанные;
		
		РаботаСНоменклатуройКлиентПереопределяемый.ОткрытьФормуНоменклатуры(ТекущиеДанные.Номенклатура, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Функция ИзмененныеРеквизиты(Номенклатура)
	
	Возврат РеквизитыНоменклатурыДляОбновления.Выгрузить(Новый Структура("Номенклатура", Номенклатура)).ВыгрузитьКолонку("РеквизитОбъекта");
		
КонецФункции

&НаКлиенте
Процедура ЗакрытиеОкнаЗаполненияНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьОбновляемыеРеквизиты(Результат, ДополнительныеПараметры.Номенклатура, ДополнительныеПараметры.ВыбраннаяСтрока);
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьОбновляемыеРеквизиты(Результат, Номенклатура, ВыбраннаяСтрока)
	
	Если НЕ ЭтоАдресВременногоХранилища(Результат.ТаблицаОтличий) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиПоНоменклатуре = РеквизитыНоменклатурыДляОбновления.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура));
	
	Для каждого ЭлементКоллекции Из СтрокиПоНоменклатуре Цикл
		РеквизитыНоменклатурыДляОбновления.Удалить(ЭлементКоллекции);
	КонецЦикла;
	
	ОбновляемыеРеквизиты = ПолучитьИзВременногоХранилища(Результат.ТаблицаОтличий);
	
	ВыбраноРеквизитов = 0;
	НовыхРеквизитов = 0;
	ИзмененныхРеквизитов = 0;
	
	Для каждого ЭлементКоллекции Из ОбновляемыеРеквизиты Цикл
		
		Если ЭлементКоллекции.НеСопоставлен Тогда
			НовыхРеквизитов = НовыхРеквизитов + 1;
		Иначе
			ИзмененныхРеквизитов = ИзмененныхРеквизитов + 1;	
		КонецЕсли;
		
		Если НЕ ЭлементКоллекции.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = РеквизитыНоменклатурыДляОбновления.Добавить();
		
		НоваяСтрока.Номенклатура = Номенклатура;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
		
		ВыбраноРеквизитов = ВыбраноРеквизитов + 1;
				
	КонецЦикла;
	
	Если ВыбраннаяСтрока <> Неопределено Тогда
		СтрокаНоменклатуры = СписокНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);
		СтрокаНоменклатуры.ОписаниеИзменений = ТекстОперацииОбновленияНоменклатуры(ВыбраноРеквизитов, ИзмененныхРеквизитов, НовыхРеквизитов);
		СтрокаНоменклатуры.КоличествоВыбранныхРеквизитов = ВыбраноРеквизитов;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидПанелиОтборов()
	
	ЦветСерый = Новый Цвет(242, 242, 242);
	ЦветБелый = Новый Цвет(255, 255, 255);
	
	Элементы.НадписьПоказатьВсе.Гиперссылка      = РежимОтображенияНоменклатуры <> "Все";
	Элементы.НадписьТолькоИзмененные.Гиперссылка = РежимОтображенияНоменклатуры <> "Измененные";
	Элементы.НадписьТолькоНовые.Гиперссылка      = РежимОтображенияНоменклатуры <> "Новые";
	
	Элементы.ГруппаПоказатьВсе.ЦветФона      = ?(НЕ Элементы.НадписьПоказатьВсе.Гиперссылка,      ЦветСерый, ЦветБелый);
	Элементы.ГруппаТолькоИзмененные.ЦветФона = ?(НЕ Элементы.НадписьТолькоИзмененные.Гиперссылка, ЦветСерый, ЦветБелый);
	Элементы.ГруппаТолькоНовые.ЦветФона      = ?(НЕ Элементы.НадписьТолькоНовые.Гиперссылка,      ЦветСерый, ЦветБелый);
		
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДанные()
	
	ИзменитьВидПанелиОтборов();
	
	Для каждого ЭлементКоллекции Из УсловноеОформление.Элементы Цикл
		
		Если ЭлементКоллекции.Представление = "ТолькоНовые" Тогда
			ЭлементКоллекции.Использование = РежимОтображенияНоменклатуры = "Новые";
		КонецЕсли;
		
		Если ЭлементКоллекции.Представление = "ТолькоИзмененные" Тогда
			ЭлементКоллекции.Использование = РежимОтображенияНоменклатуры = "Измененные";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОбновленияВидовНоменклатуры(ТекущаяСтрока = Неопределено)
	
	ПараметрыЗавершения = Новый Структура;
	
	ВидНоменклатуры = Неопределено;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		СтрокаДанных = СписокВидовНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока);
		
		Если СтрокаДанных = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		
		ВидНоменклатуры = СтрокаДанных.ВидНоменклатуры;
		
		ПараметрыЗавершения.Вставить("ТекущаяСтрока", ТекущаяСтрока);
	КонецЕсли; 
	
	ОчиститьСообщения();
	
	ПолучитьНоменклатуруЗавершение = Новый ОписаниеОповещения("ПолучитьОбновленияВидовНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.ПолучитьОбновленияВидовНоменклатуры(
		ПолучитьНоменклатуруЗавершение, ВидНоменклатуры, ЭтотОбъект, ИдентификаторЗадания);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОбновленияНоменклатуры(ТекущаяСтрока = Неопределено)
	
	Если НЕ ТребуетсяОбновитьИнформациюПоНоменклатуре И ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗавершения = Новый Структура;
	
	Номенклатура = Неопределено;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		СтрокаДанных = СписокНоменклатуры.НайтиПоИдентификатору(ТекущаяСтрока);
		
		Если СтрокаДанных = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		
		Номенклатура = СтрокаДанных.Номенклатура;
		
		ПараметрыЗавершения.Вставить("ТекущаяСтрока", ТекущаяСтрока);
	КонецЕсли; 
	
	ОчиститьСообщения();
	
	ПолучитьНоменклатуруЗавершение = Новый ОписаниеОповещения("ПолучитьОбновленияНоменклатурыЗавершение", ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.ПолучитьОбновленияНоменклатуры(
		ПолучитьНоменклатуруЗавершение, Номенклатура, ЭтотОбъект, ИдентификаторЗадания);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещения

&НаКлиенте
Процедура ЗакрытиеОкнаЗаполненияВидаНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяОбновитьИнформациюПоНоменклатуре = Истина;
	
	Если Элементы.СписокВидовНоменклатуры.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьОбновленияВидовНоменклатуры(Элементы.СписокВидовНоменклатуры.ТекущаяСтрока);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОбновленияВидовНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьИзмененияВидовНоменклатуры(Результат.АдресРезультата, ДополнительныеПараметры)
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОбновленияНоменклатурыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ИдентификаторЗадания <> ДополнительныеПараметры.ИдентификаторЗадания Тогда 
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	
	ЗаполнитьИзмененияНоменклатуры(Результат.АдресРезультата, ДополнительныеПараметры)
	
КонецПроцедуры

#КонецОбласти
