﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка.Магазин,
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Поставщик,
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.ДокументРасчета,
	|	ВЫБОР
	|		КОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма > 0
	|			ТОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате > 0
	|			ТОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КОплате,
	|	ВЫБОР
	|		КОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению > 0
	|			ТОГДА ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КПоступлению
	|ИЗ
	|	Документ.ВводОстатковРасчетовСПоставщиками.РасчетыСПоставщиками КАК ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками
	|ГДЕ
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка = &Ссылка
	|	И (ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма > 0
	|			ИЛИ ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате > 0
	|			ИЛИ ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению > 0)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка.Магазин,
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Поставщик,
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.ДокументРасчета,
	|	ВЫБОР
	|		КОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма > 0
	|			ТОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате > 0
	|			ТОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению > 0
	|			ТОГДА -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|ИЗ
	|	Документ.ВводОстатковРасчетовСПоставщиками.РасчетыСПоставщиками КАК ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками
	|ГДЕ
	|	ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Ссылка = &Ссылка
	|	И (-ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.Сумма > 0
	|			ИЛИ -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КОплате > 0
	|			ИЛИ -ВводОстатковРасчетовСПоставщикамиРасчетыСПоставщиками.КПоступлению > 0)");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПоставщиками", Результат[0].Выгрузить());
	
КонецПроцедуры

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
