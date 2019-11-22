﻿#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийПодключаемогоОборудования

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ЗаголовокИнформации = НСтр("ru = 'При подключении оборудования произошла ошибка:'");
		ТекстИнформации     = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияРТКлиент.ВывестиИнформациюДляРМКУправляемой(ЗаголовокИнформации, ТекстИнформации);
	КонецЕсли;
	
КонецПроцедуры

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
	
	ИдентификаторСтроки = Неопределено;
	СтрокаРезультата = СтруктураРезультат.ЗначенияПоиска[0];
	
	Если СтрокаРезультата.Свойство("Карта") Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиКарт(СтруктураРезультат, СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("СерийныйНомер") Тогда
		
		ИдентификаторСтроки = ДобавитьНайденныеСерийныеНомера(СтрокаРезультата);
		
	ИначеЕсли СтрокаРезультата.Свойство("ШтрихкодУпаковкиЕГАИС")
		И ЗначениеЗаполнено(СтрокаРезультата.ШтрихкодУпаковкиЕГАИС) Тогда
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиАкцизныхМарок(СтруктураРезультат, СтрокаРезультата);
		
	Иначе
		
		ПодключаемоеОборудованиеРТВызовСервера.ВставитьПредупреждениеОНевозможностиОбработкиНоменклатуры(СтруктураРезультат, СтрокаРезультата);
		
	КонецЕсли;
	
	Если СтрокаРезультата.Свойство("ТекстПредупреждения") Тогда
		СтруктураРезультат.Вставить("ТекстПредупреждения", СтрокаРезультата.ТекстПредупреждения);
	КонецЕсли;
	
	Если ИдентификаторСтроки <> Неопределено Тогда
		СтруктураРезультат.Вставить("АктивизироватьСтроку", ИдентификаторСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента) Экспорт
	
	ОткрытаБлокирующаяФорма = Ложь;
	
	ПодключаемоеОборудованиеРТКлиент.ОбработатьДанныеПоКодуРМК(ЭтотОбъект, СтруктураПараметровКлиента, ОткрытаБлокирующаяФорма);
	
	Если НЕ ОткрытаБлокирующаяФорма Тогда
		ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьНайденныеСерийныеНомера(СтруктураНомера) Экспорт
	
	ИдентификаторСтроки = Неопределено;
	
	Если СтруктураНомера.Номенклатура =  Номенклатура Тогда
	
		СтрокиССерийнымНомером = Список.НайтиСтроки(Новый Структура("СерийныйНомер", СтруктураНомера.СерийныйНомер));
		
		Если СтрокиССерийнымНомером.Количество() = 0  Тогда
			
			СтрокаПогашения = Список.Добавить();
			СтрокаПогашения.СерийныйНомер = СтруктураНомера.СерийныйНомер;
			ИдентификаторСтроки = СтрокаПогашения.ПолучитьИдентификатор();
			
		Иначе
			
			СтрокаОшибки = НСтр("ru = 'Номер подарочного сертификата ""%1"" уже выбран в документе'");
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОшибки, СтруктураНомера.СерийныйНомер);
			СтруктураНомера.Вставить("ТекстПредупреждения", СтрокаОшибки);
			ИдентификаторСтроки = СтрокиССерийнымНомером[0].ПолучитьИдентификатор();
			
		КонецЕсли;
	Иначе
		СтрокаОшибки = НСтр("ru = 'Серийный номер ""%1"" не принадлежит выбранному подарочному сертификату'");
		СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаОшибки, СтруктураНомера.СерийныйНомер);
		СтруктураНомера.Вставить("ТекстПредупреждения", СтрокаОшибки);
	КонецЕсли;

	Возврат ИдентификаторСтроки;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Номенклатура = Параметры.Номенклатура;
	
	ЗаполнитьСписокВыбора(Параметры.МассивСерийныхНомеров);
	
	ИспользоватьПодключаемоеОборудование = ЗначениеНастроекВызовСервера.ИспользоватьПодключаемоеОборудование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	ПоддерживаемыеТипыВО = Новый Массив;
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);  
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, ЭтотОбъект, ПоддерживаемыеТипыВО);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
	ПоддерживаемыеТипыВО.Добавить("СчитывательМагнитныхКарт");
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоТипу(, ЭтотОбъект, ПоддерживаемыеТипыВО);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	// ПодключаемоеОборудование
	Если ВводДоступен() Тогда
		ПодключаемоеОборудованиеРТКлиент.ВнешнееСобытиеОборудованияРМК(ЭтотОбъект, Источник, Событие, Данные);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерийныйНомерПриИзменении(Элемент)
	
	Элементы.Список.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВниз(Команда)
	
	ПередвинутьПозицию(1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВверх(Команда)
	
	ПередвинутьПозицию(-1)
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	МассивСерийныхНомеров = Новый Массив;
	Для Каждого ТекСерийныйНомер Из Список Цикл
		Если ЗначениеЗаполнено(ТекСерийныйНомер.СерийныйНомер) Тогда
			МассивСерийныхНомеров.Добавить(ТекСерийныйНомер.СерийныйНомер);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСерийныхНомеров.Количество() > 0 Тогда
		Закрыть(МассивСерийныхНомеров);
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавить(Команда)
	
	ТекущаяСтрока = Список.Добавить();
	
	ТекущийЭлемент = Элементы.Список;
	Элементы.Список.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	Элементы.Список.ТекущийЭлемент = Элементы.СерийныйНомер;
	Элементы.Список.ИзменитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУдалить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если Не ТекущиеДанные = Неопределено Тогда
		
		Список.Удалить(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Передвинуть позицию в списке.
//
// Параметры:
// Движение = 1 (вниз) или -1 (вверх).
// 
&НаКлиенте
Процедура ПередвинутьПозицию(Движение)
	// Вставить содержимое обработчика.
	Если Список.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено  Тогда
		ИндексСтроки = 0;
	Иначе
		ИндексСтроки = Список.Индекс(ТекущиеДанные);
	КонецЕсли;
	
	ИндексСтроки = ИндексСтроки + Движение;
	
	Если ИндексСтроки > (Список.Количество() - 1) Тогда
		ИндексСтроки = 0;
	ИначеЕсли ИндексСтроки < 0 Тогда
		ИндексСтроки = Список.Количество() - 1;
	КонецЕсли;
	
	ТекущиеДанные = Список[ИндексСтроки];
	Элементы.Список.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора(МассивСерийныхНомеров)
	
	Для Каждого ТекСерийныйНомер Из МассивСерийныхНомеров Цикл
		Список.Добавить().СерийныйНомер = ТекСерийныйНомер;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбработкуДанныхПоКодуКлиент(СтруктураПараметровКлиента)
	
	ИдентификаторСтроки = ПодключаемоеОборудованиеРТКлиент.ЗавершитьОбработкуДанныхПоКодуКлиент(ЭтотОбъект, СтруктураПараметровКлиента, "Список");
	
КонецПроцедуры

#КонецОбласти