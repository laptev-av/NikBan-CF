﻿
#Область ОбработчикСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОплатыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СуммаПроцентов = Объект.ЭтапыОплаты.Итог("ПроцентПлатежа");
	
	Если СуммаПроцентов >= 100 Тогда
		
		ТекстОшибки = НСтр("ru = 'Добавление этапа не требуется'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.ЭтапыОплат",
			,
			Отказ);
		
	Иначе
		
		СтрокаЭтапаОплаты = Объект.ЭтапыОплаты.Добавить();
		СтрокаЭтапаОплаты.ПроцентПлатежа = 100 - СуммаПроцентов;
		СтрокаЭтапаОплаты.ВидПлатежа = ПредопределенноеЗначение("Перечисление.ВидПлатежа.Предоплата");
		СтрокаЭтапаОплаты.Срок = 1;
		СтрокаЭтапаОплаты.ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличная");
		
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьЭтапыОплат(Команда)
	СортироватьЭтапыСервер();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СортироватьЭтапыСервер()
	
		Запрос = Новый Запрос ("ВЫБРАТЬ
		                       |	ЭтапыОплат.НомерСтроки КАК НомерСтроки,
		                       |	ЭтапыОплат.Срок КАК Срок,
		                       |	ЭтапыОплат.ФормаОплаты КАК ФормаОплаты,
		                       |	ЭтапыОплат.ВидПлатежа КАК ВидПлатежа,
		                       |	ЭтапыОплат.ПроцентПлатежа КАК ПроцентОплаты
		                       |ПОМЕСТИТЬ ЭтапыОплат
		                       |ИЗ
		                       |	&ТЧЭтапыОплат КАК ЭтапыОплат
		                       |;
		                       |
		                       |////////////////////////////////////////////////////////////////////////////////
		                       |ВЫБРАТЬ
		                       |	ЭтапыОплат.НомерСтроки,
		                       |	ЭтапыОплат.Срок КАК Срок,
		                       |	ЭтапыОплат.ФормаОплаты,
		                       |	ЭтапыОплат.ВидПлатежа,
		                       |	ЭтапыОплат.ПроцентОплаты КАК ПроцентПлатежа
		                       |ИЗ
		                       |	ЭтапыОплат КАК ЭтапыОплат
		                       |ГДЕ
		                       |	ЭтапыОплат.ВидПлатежа = &ВидПлатежаПредоплата
		                       |
		                       |УПОРЯДОЧИТЬ ПО
		                       |	Срок УБЫВ
		                       |;
		                       |
		                       |////////////////////////////////////////////////////////////////////////////////
		                       |ВЫБРАТЬ
		                       |	ЭтапыОплат.НомерСтроки,
		                       |	ЭтапыОплат.Срок КАК Срок,
		                       |	ЭтапыОплат.ФормаОплаты,
		                       |	ЭтапыОплат.ВидПлатежа,
		                       |	ЭтапыОплат.ПроцентОплаты КАК ПроцентПлатежа
		                       |ИЗ
		                       |	ЭтапыОплат КАК ЭтапыОплат
		                       |ГДЕ
		                       |	ЭтапыОплат.ВидПлатежа = &ВидПлатежаОтсрочка
		                       |
		                       |УПОРЯДОЧИТЬ ПО
		                       |	Срок
		                       |");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ТЧЭтапыОплат", Объект.ЭтапыОплаты.Выгрузить());
	Запрос.УстановитьПараметр("ВидПлатежаПредоплата", Перечисления.ВидПлатежа.Предоплата);
	Запрос.УстановитьПараметр("ВидПлатежаОтсрочка", Перечисления.ВидПлатежа.ОтсрочкаПлатежа);
	
	МассивРезультатовЗапроса             = Запрос.ВыполнитьПакет();
	ТаблицаЭтапыПредоплата = МассивРезультатовЗапроса[1].Выгрузить();
	ТаблицаЭтапыОтсрочка   = МассивРезультатовЗапроса[2].Выгрузить();
	
	Объект.ЭтапыОплаты.Очистить();
	
	Для Каждого Строка ИЗ ТаблицаЭтапыПредоплата Цикл
	
		СтрокаЭтапыОплат = Объект.ЭтапыОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтапыОплат, Строка);
	
	КонецЦикла;
	
	Для Каждого Строка ИЗ ТаблицаЭтапыОтсрочка Цикл
	
		СтрокаЭтапыОплат = Объект.ЭтапыОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтапыОплат, Строка);
	
	КонецЦикла;
	
КонецПроцедуры