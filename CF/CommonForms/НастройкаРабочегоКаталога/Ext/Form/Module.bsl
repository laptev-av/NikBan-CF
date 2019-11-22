﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Элементы.СейчасВЛокальномКэшеФайлов.Видимость = Ложь;
		Элементы.ОчиститьРабочийКаталог.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПараметрыНаСервере();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами", 0.1, Истина);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РабочийКаталогПользователя = РаботаСФайламиСлужебныйКлиент.РабочийКаталогПользователя();
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РабочийКаталогПользователяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	
	// Выбираем другой путь к рабочему каталогу.
	ИмяКаталога = РабочийКаталогПользователя;
	Заголовок = НСтр("ru = 'Выберите рабочий каталог'");
	Если Не РаботаСФайламиСлужебныйКлиент.ВыбратьПутьКРабочемуКаталогу(ИмяКаталога, Заголовок, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьНовыйРабочийКаталог(ИмяКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерЛокальногоКэшаФайловПриИзменении(Элемент)
	
	СохранитьПараметры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждатьПриУдаленииИзЛокальногоКэшаФайловПриИзменении(Элемент)
	
	СохранитьПараметры();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактированияПриИзменении(Элемент)
	
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования Тогда
		Элементы.ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов.Доступность = Истина;
	Иначе
		Элементы.ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов.Доступность = Ложь;
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов                      = Ложь;
	КонецЕсли;
	
	СохранитьПараметры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	РаботаСФайламиСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыполнить()
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ФайлыВОсновномРабочемКаталоге", , ЭтотОбъект, , , ,
		Новый ОписаниеОповещения("СписокФайловЗакрытие", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайлов(Команда)
	
	ТекстВопроса =
		НСтр("ru = 'Из рабочего каталога будут удалены все файлы,
		           |кроме занятых для редактирования.
		           |
		           |Продолжить?'");
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловПослеОтветаНаВопросПродолжить", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКРабочемуКаталогуПоУмолчанию(Команда)
	
	УстановитьНовыйРабочийКаталог(РаботаСФайламиСлужебныйКлиент.ВыбратьПутьККаталогуДанныхПользователя());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьПараметры()
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект",    "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение",  РабочийКаталогПользователя);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", МаксимальныйРазмерЛокальногоКэшаФайлов * 1048576);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Элемент.Вставить("Значение", УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловПослеОтветаНаВопросПродолжить(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловЗавершение", ЭтотОбъект);
	// ОчищатьВсе = Истина.
	РаботаСФайламиСлужебныйКлиент.ОчиститьРабочийКаталог(Обработчик, РазмерФайловВРабочемКаталоге, 0, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Рабочий каталог'"),, НСтр("ru = 'Очистка рабочего каталога успешно завершена.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьТекущееСостояниеРабочегоКаталога();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыНаСервере()
	
	УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Неопределено Тогда
		УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Ложь;
	КонецЕсли;
	
	ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	
	Если ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Неопределено Тогда
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Ложь;
	КонецЕсли;
	
	МаксРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	
	Если МаксРазмер = Неопределено Тогда
		МаксРазмер = 100*1024*1024; // 100 мб
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов", МаксРазмер);
	КонецЕсли;
	МаксимальныйРазмерЛокальногоКэшаФайлов = МаксРазмер / 1048576;
	
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования Тогда
		Элементы.ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов.Доступность = Истина;
	Иначе
		Элементы.ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов.Доступность = Ложь;
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов                      = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущееСостояниеРабочегоКаталога()
	
#Если НЕ ВебКлиент Тогда
	МассивФайлов = НайтиФайлы(РабочийКаталогПользователя, "*.*");
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	
	РаботаСФайламиСлужебныйКлиент.ОбходФайловРазмер(
		РабочийКаталогПользователя,
		МассивФайлов,
		РазмерФайловВРабочемКаталоге,
		КоличествоСуммарное); 
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНовыйРабочийКаталог(НовыйКаталог)
	
	Если НовыйКаталог = РабочийКаталогПользователя Тогда
		Возврат;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	Обработчик = Новый ОписаниеОповещения(
		"УстановитьНовыйРабочийКаталогЗавершение", ЭтотОбъект, НовыйКаталог);
	
	РаботаСФайламиСлужебныйКлиент.ПеренестиСодержимоеРабочегоКаталога(
		Обработчик, РабочийКаталогПользователя, НовыйКаталог);
#Иначе
	УстановитьНовыйРабочийКаталогЗавершение(-1, НовыйКаталог);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНовыйРабочийКаталогЗавершение(Результат, НовыйКаталог) Экспорт
	
	Если Результат <> -1 Тогда
		Если Результат <> Истина Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	РабочийКаталогПользователя = НовыйКаталог;
	
	СохранитьПараметры();
	
КонецПроцедуры

#КонецОбласти
