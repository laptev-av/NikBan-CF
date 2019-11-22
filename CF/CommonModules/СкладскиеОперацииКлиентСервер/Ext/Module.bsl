﻿
// Функция получения параметров для анализа пересортицы.
//
Функция ПолучитьМассивПараметровАнализаПересортицы(ПараметрыАнализаПересортицы) Экспорт
	
	МассивПараметровПоУмолчанию = СкладскиеОперацииКлиентСерверПовтИсп.ПолучитьМассивПараметровАнализаПересортицыПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(ПараметрыАнализаПересортицы) Тогда
		Возврат МассивПараметровПоУмолчанию;
	КонецЕсли;
	
	МассивПараметров = Новый Массив;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ПараметрыАнализаПересортицы);
	
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		СтрокаПараметра = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		Если НЕ МассивПараметровПоУмолчанию.Найти(СтрокаПараметра) = Неопределено Тогда
			
			МассивПараметров.Добавить(СтрокаПараметра);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивПараметров.Количество() = 0  Тогда
		Возврат МассивПараметровПоУмолчанию;
	КонецЕсли;
	
	Возврат МассивПараметров;
	
КонецФункции
