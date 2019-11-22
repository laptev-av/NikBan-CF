﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Для предопределенного узла этой информационной базы закладку "НастройкаФильтровРегистрации" не отображаем.
	ИмяУзла = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Объект.Ссылка);
	Если ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяУзла) = Объект.Ссылка Тогда
		
		Элементы.НастройкаФильтровРегистрации.Видимость = Ложь;
		Элементы.СтраницыФормы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Если Элементы.Найти("РазрешитьРедактированиеРеквизитовОбъекта") <> Неопределено Тогда
			Элементы.РазрешитьРедактированиеРеквизитовОбъекта.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ИмяУзла = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Объект.Ссылка);

	Если НЕ ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяУзла) = Объект.Ссылка Тогда
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПередаватьРозничныеЦеныПриИзменении(Элемент)
	
	Если НЕ Объект.ПередаватьРозничныеЦены Тогда
		Объект.ПередаватьЦеныХарактеристик = Ложь;
	Иначе
		РазблокируемыеРеквизиты = Новый Массив;
		РазблокируемыеРеквизиты.Добавить("ПередаватьЦеныХарактеристик");
		Элементы.ПередаватьЦеныХарактеристик.Доступность = Истина;
		Элементы.ПередаватьЦеныХарактеристик.ТолькоПросмотр = Ложь;
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьРазрешенностьРедактированияРеквизитов(ЭтотОбъект,РазблокируемыеРеквизиты);
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ Объект.Ссылка.Пустая() 
		И НЕ ЭтоПредопределенныйУзелПланаОбмена() Тогда
		ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтоПредопределенныйУзелПланаОбмена()

	ИмяУзла = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Объект.Ссылка);

	Возврат ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяУзла) = Объект.Ссылка;

КонецФункции 

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Элементы.ОтборПоОрганизациям.Видимость	= Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.ПередаватьЦеныХарактеристик.Видимость = Объект.ПередаватьРозничныеЦены И ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
   
КонецПроцедуры

#КонецОбласти