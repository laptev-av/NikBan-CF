﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка            КАК Ссылка,
	|	ВидыЦен.Наименование      КАК Наименование,
	|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
	|	ВЫБОР
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗадаватьВручную)
	|		ТОГДА
	|			0
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
	|		ТОГДА
	|			1
	|		КОГДА
	|			ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоДругимВидамЦен)
	|		ТОГДА
	|			2
	|	КОНЕЦ КАК ИндексКартинки
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка В(&МассивВидовЦен)
	|УПОРЯДОЧИТЬ ПО
	|	ВидыЦен.РеквизитДопУпорядочивания
	|";
	
	Запрос.УстановитьПараметр("МассивВидовЦен", ВидыЦенДокументов(Параметры.МассивДокументов));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаВидЦены = ДеревоНастроек.ПолучитьЭлементы().Добавить();
		НоваяСтрокаВидЦены.Наименование  = Выборка.Наименование;
		НоваяСтрокаВидЦены.Параметр = Выборка.Ссылка;
		НоваяСтрокаВидЦены.ИндексКартинки = Выборка.ИндексКартинки;
		НоваяСтрокаВидЦены.ВыводитьНаПечать = 1;		
				
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоНастроек

&НаКлиенте
Процедура ДеревоНастроекВыводитьНаПечатьПриИзменении(Элемент)
	
	ТекущаяСтрока = ДеревоНастроек.НайтиПоИдентификатору(Элементы.ДеревоНастроек.ТекущаяСтрока);
	Если ТипЗнч(ТекущаяСтрока.Параметр) = Тип("СправочникСсылка.ВидыЦен") Тогда
		
		Если ТекущаяСтрока.ВыводитьНаПечать = 2 Тогда
			ТекущаяСтрока.ВыводитьНаПечать = 0;
		КонецЕсли;
		
	Иначе
		
		Если ТекущаяСтрока.ВыводитьНаПечать = 2 Тогда
			ТекущаяСтрока.ВыводитьНаПечать = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		ВидЦены.ВыводитьНаПечать = 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		ВидЦены.ВыводитьНаПечать = 0;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ПараметрыПечати = Новый Структура;
	ПоместитьВоВременноеХранилищеНаСервере(ПараметрыПечати);
	ПараметрыПечати.Вставить("ПечататьТолькоИзмененныеЦены", ТолькоИзмененныеЦены);
	ПараметрыПечати.Вставить("ВыводитьШапку", Истина);
	
	Закрыть(ПараметрыПечати);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВидыЦенДокументов(МассивДокументов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	УстановкаЦенНоменклатурыВидыЦен.ВидЦены КАК ВидЦены
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры.ВидыЦен КАК УстановкаЦенНоменклатурыВидыЦен
	|ГДЕ
	|	УстановкаЦенНоменклатурыВидыЦен.Ссылка В(&МассивДокументов)";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦены");
	
КонецФункции

&НаСервере
Процедура ПоместитьВоВременноеХранилищеНаСервере(ПараметрыПечати)
	
	ПараметрыПечати.Вставить("ДеревоНастроек", ПоместитьДеревоВоВременноеХранилищеНаСервере());
	ПараметрыПечати.Вставить("ДеревоНастроекДляКлиента", ПоместитьДеревоВоВременноеХранилищеНаСервереДляКлиента());
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДеревоВоВременноеХранилищеНаСервере()
	
	Дерево = РеквизитФормыВЗначение("ДеревоНастроек");
	Возврат ПоместитьВоВременноеХранилище(Дерево);
	
КонецФункции

&НаСервере
Функция ПоместитьДеревоВоВременноеХранилищеНаСервереДляКлиента()
	
	Массив = Новый Массив;
	
	Дерево = РеквизитФормыВЗначение("ДеревоНастроек");
	Для Каждого Строка Из Дерево.Строки Цикл
		
		НоваяСтрока = Новый Структура("Наименование, ВыводитьНаПечать, Параметр, Строки");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , "Строки");
		Массив.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(Новый Структура("Строки", Массив));
	
КонецФункции

#КонецОбласти
