﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкоду(Штрихкод, ДополнительныеПараметры) Экспорт
	
	Если НЕ ПустаяСтрока(Штрихкод) Тогда
		СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоМагнитномуКоду(ТекКод, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(ТекКод) Тогда
		СтруктураПараметровКлиента = ПолученМагнитныйКод(ТекКод);
		ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораДанныхПоиска(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработатьДанныеПоКодуСервер(Результат);
		ОбработатьДанныеПоКодуКлиент(Результат)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолученМагнитныйКод(МагнитныйКод) Экспорт 
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученМагнитныйКод(МагнитныйКод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Функция ПолученШтрихкодИзСШК(Штрихкод) Экспорт
	
	СтруктураРезультат = ПодключаемоеОборудованиеРТВызовСервера.ПолученШтрихкодИзСШК(Штрихкод, ЭтотОбъект);
	Возврат СтруктураРезультат;
	
КонецФункции

&НаСервере
Процедура ОбработатьДанныеПоКодуСервер(СтруктураРезультат) Экспорт
	
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		Если СтрокаРезультата.ЭтоРегистрационнаяКарта Тогда
			Если ЗначениеЗаполнено(СтрокаРезультата.ВладелецКарты)
				И ТипЗнч(СтрокаРезультата.ВладелецКарты) = Тип("СправочникСсылка.Пользователи") Тогда
				Список.Отбор.Элементы.Очистить();
				ГруппаЭлементов = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
									Список.Отбор.Элементы, "ОтборНоменклатура",
									ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
				
				ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
					ГруппаЭлементов,
					"Пользователь",
					СтрокаРезультата.ВладелецКарты);
					
				ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
					ГруппаЭлементов,
					"ЗамещаемыйПользователь",
					СтрокаРезультата.ВладелецКарты);
			КонецЕсли;
		Иначе
			Список.Отбор.Элементы.Очистить();
			ГруппаЭлементов = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
								Список.Отбор.Элементы, "ОтборНоменклатура",
								ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
			
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаЭлементов,
				"ВходящиеДанные",
				СтрокаРезультата.Карта);
				
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаЭлементов,
				"ИсходящиеДанные",
				СтрокаРезультата.Карта);
				
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаЭлементов,
				"ДополнительныеИсходящиеДанные",
				СтрокаРезультата.Карта);
				
			Если ТипЗнч(СтрокаРезультата.ВладелецКарты) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
					ГруппаЭлементов,
					"ВходящиеДанные",
					СтрокаРезультата.ВладелецКарты);
					
				ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
					ГруппаЭлементов,
					"ИсходящиеДанные",
					СтрокаРезультата.ВладелецКарты);
					
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		Список.Отбор.Элементы.Очистить();
		ГруппаЭлементов = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
							Список.Отбор.Элементы, "ОтборНоменклатура",
							ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
			ГруппаЭлементов,
			"ВходящаяНоменклатура",
			СтрокаРезультата.Номенклатура);
			
		ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
			ГруппаЭлементов,
			"ИсходящиеДанные",
			СтрокаРезультата.Номенклатура);
		
		ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
			ГруппаЭлементов,
			"ИсходящиеДанные",
			СтрокаРезультата.СерийныйНомер);
			
		ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
			ГруппаЭлементов,
			"ДополнительныеИсходящиеДанные",
			СтрокаРезультата.СерийныйНомер);
			
	Иначе // Номенклатура.
		
		Список.Отбор.Элементы.Очистить();
		ГруппаЭлементов = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
							Список.Отбор.Элементы, "ОтборНоменклатура",
							ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		Если ЗначениеЗаполнено(СтрокаРезультата.Характеристика) Тогда
								
			ГруппаВходящаяНоменклатура = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
								ГруппаЭлементов.Элементы, "ГруппаВходящаяНоменклатура",
								ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
								
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаВходящаяНоменклатура,
				"ВходящаяНоменклатура",
				СтрокаРезультата.Номенклатура);
				
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаВходящаяНоменклатура,
				"ВходящаяХарактеристика",
				СтрокаРезультата.Характеристика);
				
			ГруппаИсходящаяНоменклатура = ОбщегоНазначенияРТКлиентСервер.СоздатьГруппуЭлементовОтбора(
								ГруппаЭлементов.Элементы, "ГруппаИсходящаяНоменклатура",
								ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
								
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаИсходящаяНоменклатура,
				"ИсходящиеДанные",
				СтрокаРезультата.Номенклатура);
				
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаисходящаяНоменклатура,
				"ДополнительныеИсходящиеДанные",
				СтрокаРезультата.Характеристика);
				
		Иначе
			
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаЭлементов,
				"ВходящаяНоменклатура",
				СтрокаРезультата.Номенклатура);
				
			ОбщегоНазначенияРТКлиентСервер.ДобавитьЭлементОтбораВГруппу(
				ГруппаЭлементов,
				"ИсходящиеДанные",
				СтрокаРезультата.Номенклатура);
				
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКоду(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ЧекККМ")
		И ЗначениеЗаполнено(Параметры.Отбор.ЧекККМ) Тогда
		Элементы.ЧекККМ.Видимость = Ложь;
	КонецЕсли;
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "РегистрСведений.ЛогДействийКассираВРМК.Форма.ФормаСписка.Открытие");

	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудования(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ОбработчикиКомандПодключаемогоОборудования

&НаКлиенте
Процедура ПоискПоМагнитномуКоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиМагнитныйКод(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВвестиШтрихкод(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОчиститьОтбор(Команда)
	
	Список.Отбор.Элементы.Очистить();
	
КонецПроцедуры

#КонецОбласти
