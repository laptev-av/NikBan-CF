﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Обработка.ПечатьЭтикетокИЦенников.Форма.Форма.Открытие");
	
	ПараметрыФормы = ПодготовитьСтруктуруПечати(ПараметрКоманды);
	ОткрытьФорму("Обработка.ПечатьЭтикетокИЦенников.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьСтруктуруПечати(ПараметрКоманды)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Сертификат,
	|	1 КАК КоличествоЭтикеток,
	|	&Организация КАК Организация
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.ЭтоГруппа
	|	И Номенклатура.Ссылка В ИЕРАРХИИ(&МассивСсылок)
	|	И Номенклатура.ТипНоменклатуры = &ПодарочныйСертификат
	|	И Номенклатура.ИспользоватьСерийныеНомера
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Наименование,
	|	Сертификат
	|";
	
	Запрос.УстановитьПараметр("МассивСсылок", ПараметрКоманды);
	Запрос.УстановитьПараметр("ПодарочныйСертификат", Перечисления.ТипыНоменклатуры.ПодарочныйСертификат);
	
	ТекущийМагазин = ОбщегоНазначенияРТ.ОпределитьТекущийМагазин();
	Если ЗначениеЗаполнено(ТекущийМагазин) Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийМагазин, "СкладПродажи.Организация");
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Сертификаты = Запрос.Выполнить().Выгрузить();
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьМагазин", ТекущийМагазин);
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ПодарочныеСертификаты", Сертификаты);
	СтруктураРезультат.Вставить("СтруктураДействий", СтруктураДействий);
	СтруктураПараметры = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(СтруктураРезультат));
	
	Возврат СтруктураПараметры;
	
КонецФункции

#КонецОбласти