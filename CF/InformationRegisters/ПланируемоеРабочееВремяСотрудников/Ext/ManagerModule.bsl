﻿
#Область ПрограммныйИнтерфейс

// Функция читает данные из регистра за неделю.
//
// Параметры:
//	Магазин			- СправочникСсылка.Магазины
//	НачалоНедели	- Дата
//
// Возвращаемое значение
//	ТаблицаЗначений
//
Функция ПрочитатьДанныеИзРегистра(Магазин, НачалоНедели) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("НачалоНедели", НачалоДня(НачалоНедели));
	Запрос.УстановитьПараметр("КонецНедели", КонецДня(НачалоНедели + 86400 * 7));
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПланируемоеРабочееВремяСотрудников.Период                        КАК Период,
	|	ПланируемоеРабочееВремяСотрудников.ИнтервалРаботыМагазинов       КАК ИнтервалРаботыМагазинов,
	|	ПланируемоеРабочееВремяСотрудников.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
	|	ПланируемоеРабочееВремяСотрудников.Сотрудник                     КАК Сотрудник,
	|	ПланируемоеРабочееВремяСотрудников.ДатаОкончания                 КАК ДатаОкончания,
	|	ПланируемоеРабочееВремяСотрудников.ДлинаРабочегоВремени          КАК ДлинаРабочегоВремени
	|ИЗ
	|	РегистрСведений.ПланируемоеРабочееВремяСотрудников КАК ПланируемоеРабочееВремяСотрудников
	|ГДЕ
	|	ПланируемоеРабочееВремяСотрудников.ИнтервалРаботыМагазинов.Магазин = &Магазин
	|	И ПланируемоеРабочееВремяСотрудников.Период МЕЖДУ &НачалоНедели И &КонецНедели
	|";
		
	Возврат Запрос.Выполнить().Выгрузить();
		
КонецФункции

// Записывает график работы в регистр.
//
// Параметры:
//	ТаблицаРегистра	- Таблица значений, структура = структура регистра.
//
//
Процедура ЗаписатьПланируемоеРабочееВремяСотрудников(ТаблицаРегистра) Экспорт
	
	Если ТаблицаРегистра.Количество() > 0 Тогда
		
		ЗапросПоЗаписям = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаРегистра.ИнтервалРаботыМагазинов КАК ИнтервалРаботыМагазинов,
		|	ТаблицаРегистра.Сотрудник КАК Сотрудник,
		|	ТаблицаРегистра.Период КАК Период
		|ПОМЕСТИТЬ ТаблицаРегистра
		|ИЗ
		|	&ТаблицаРегистра КАК ТаблицаРегистра
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПланируемоеРабочееВремяСотрудников.ИнтервалРаботыМагазинов КАК ИнтервалРаботыМагазинов,
		|	ПланируемоеРабочееВремяСотрудников.РаботаВыполняемаяСотрудниками КАК РаботаВыполняемаяСотрудниками,
		|	ПланируемоеРабочееВремяСотрудников.Период КАК Период,
		|	ПланируемоеРабочееВремяСотрудников.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.ПланируемоеРабочееВремяСотрудников КАК ПланируемоеРабочееВремяСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаРегистра КАК ТаблицаРегистра
		|		ПО (ТаблицаРегистра.ИнтервалРаботыМагазинов = ПланируемоеРабочееВремяСотрудников.ИнтервалРаботыМагазинов)
		|			И (НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(ПланируемоеРабочееВремяСотрудников.Период, ДЕНЬ))
		|			И ПланируемоеРабочееВремяСотрудников.Сотрудник = ТаблицаРегистра.Сотрудник");
		
		ЗапросПоЗаписям.УстановитьПараметр("ТаблицаРегистра",ТаблицаРегистра);
		ВыборкаПоЗаписям = ЗапросПоЗаписям.Выполнить().Выбрать();
		
		Пока ВыборкаПоЗаписям.Следующий() Цикл
			
			МенеджерЗаписи = РегистрыСведений.ПланируемоеРабочееВремяСотрудников.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ВыборкаПоЗаписям);
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.Удалить();
			
		КонецЦикла;
		
		Для Каждого СтрокаТаблицыРегистра Из ТаблицаРегистра Цикл
			
			Если НЕ СтрокаТаблицыРегистра.Очистить Тогда
				
				НаборЗаписей = РегистрыСведений.ПланируемоеРабочееВремяСотрудников.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Период.Установить(СтрокаТаблицыРегистра.Период);
				НаборЗаписей.Отбор.ИнтервалРаботыМагазинов.Установить(СтрокаТаблицыРегистра.ИнтервалРаботыМагазинов);
				НаборЗаписей.Отбор.РаботаВыполняемаяСотрудниками.Установить(СтрокаТаблицыРегистра.РаботаВыполняемаяСотрудниками);
				НаборЗаписей.Отбор.Сотрудник.Установить(СтрокаТаблицыРегистра.Сотрудник);
				
				НаборЗаписей.Прочитать();
				
				НаборЗаписей.Очистить();
				
				Строка = НаборЗаписей.Добавить();
				
				ЗаполнитьЗначенияСвойств(Строка, СтрокаТаблицыРегистра);
				
				НаборЗаписей.Записать(Истина);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти