﻿// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьЗаполнениеПоИНН;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоИННЗавершение(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДопПараметры);
		АдресныйКлассификаторКлиент.АвторизоватьНаСайтеПоддержкиПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДопПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)
		И ЗначениеЗаполнено(Результат.Пароль) Тогда
		//Аутентификация = Результат;
		//Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = Ложь;
		//Элементы.ИнформацияОбОбновление.Видимость = Истина;
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "СтраницаКонтактнаяИнформация",ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	УправлениеДоступностьюНаСервере();
	
	Если НЕ ОбщегоНазначенияРТ.УпрощенныйВводДоступен() Тогда
		Элементы.ИНН.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереКонтрагент(ЭтотОбъект, Параметры);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	ИспользованиеСПАРКРазрешено = СПАРКРиски.ИспользованиеРазрешено();
	
	Если ИспользованиеСПАРКРазрешено 
		И ПоказатьИнформациюСпарк(ЭтотОбъект) Тогда 
		ПараметрыПроцедуры = Новый Структура("ВариантОтображения", "Многострочный");
		Если Параметры.Ключ.Пустая() Тогда
			// Если это копирование, то использовать ИНН, а не ссылку для получения индексов.
			СПАРКРиски.ПриСозданииНаСервере(
				ЭтотОбъект,
				Объект,
				Объект.ИНН,
				ПараметрыПроцедуры);
		Иначе
			СПАРКРиски.ПриСозданииНаСервере(
				ЭтотОбъект,
				Объект,
				Объект.Ссылка,
				ПараметрыПроцедуры);
		КонецЕсли;
		ИспользованиеСПАРКРазрешено = Истина;
	Иначе
		Элементы.ГруппаИндексыСПАРКРиски.Видимость = Ложь;
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	// Команды1СПАРКРиски
	Если ИспользованиеСПАРКРазрешено Тогда
		СПАРКРиски.ДобавитьПодключаемыеКомандыКонтрагента(ЭтотОбъект, Объект, Элементы.Подменю1СПАРКРиски);
	КонецЕсли;
	// Конец Команды1СПАРКРиски
	
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ОтключитьОтметкуНезаполненного();
	
// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииКонтрагент(ЭтотОбъект);
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	Если ИспользованиеСПАРКРазрешено Тогда
		СПАРКРискиКлиент.ПриОткрытии(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	Если ИспользованиеСПАРКРазрешено Тогда
		СПАРКРискиКлиент.ОбработкаОповещения(ЭтотОбъект, Объект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
	Если ИмяСобытия = "ЗагруженАдресныйКлассификатор" Тогда
		
		Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Видимость = АдресныйКлассификаторПуст();
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.ИНН) И (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"))Тогда
		Объект.ИНН = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.КПП) И НЕ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") ИЛИ НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		Объект.КПП = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.КодПоОКПО) И (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо")) Тогда
		Объект.КодПоОКПО = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.ИНН) Тогда
		
		Контрагент = ОбщегоНазначенияРТ.ИННКППУжеИспользуетсяВИнформационнойБазе(Объект.ИНН,Объект.КПП,Объект.Ссылка);
		
		Если Контрагент <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Данные ИНН и КПП уже указаны для контрагента с кодом %1'"),Контрагент.Код),
			,
			"Объект.ИНН",
			,
			Отказ);
		КонецЕсли;		
		
	КонецЕсли;
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереКонтрагент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	Если ИспользованиеСПАРКРазрешено Тогда
		
		СПАРКРиски.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОплатыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Справочник.ГрафикиОплаты.Форма.ФормаВыбора.Открытие");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	РеквизитыПроверкиКонтрагентов.ЭтоИностранныйКонтрагент = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	РеквизитыПроверкиКонтрагентов.ЭтоЮридическоеЛицо  	   = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ПустаяСсылка");
		
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	Если ИспользованиеСПАРКРазрешено Тогда
		ЭтотОбъект.ИндексыСПАРКРиски = Неопределено;
		ОбновитьОтображениеИндексыСПАРК();
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	Если Объект.ЮрФизЛицо =  ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
			ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент") Тогда
		
		УправлениеДоступностью();
		
		// СтандартныеПодсистемы.РаботаСКонтрагентами
		Если ЗначениеЗаполнено(Объект.ИНН)
			И НЕ (ЗначениеЗаполнено(Объект.Наименование) 
			ИЛИ ЗначениеЗаполнено(Объект.НаименованиеПолное) 
			ИЛИ ЗначениеЗаполнено(Объект.КПП)) Тогда
			ВыполнитьЗаполнениеРеквизитовПоИНН();
		КонецЕсли;
		ОтключитьЗаполнениеПоИНН = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ВключитьЗаполнениеПоИНН", 0.1, Истина);
		
		// ИнтернетПоддержкаПользователей.СПАРКРиски
		Если ИспользованиеСПАРКРазрешено Тогда
			ЭтотОбъект.ИндексыСПАРКРиски = Неопределено;
			ОбновитьОтображениеИндексыСПАРК();
		КонецЕсли;
		// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
		
	КонецЕсли;
	
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИндексыСПАРКРискиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СПАРКРискиКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьКартинкуДляКомментария", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияАдресныйКлассификаторНеЗагруженОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗагрузитьАдресныйКлассификатор" Тогда
		СтандартнаяОбработка = Ложь;
		АдресныйКлассификаторКлиент.ЗагрузитьАдресныйКлассификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКПООкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Перем ТекстСообщения;
	ОчиститьСообщения();
	
	ЭтоЮрЛицо = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо")
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	
	Если НЕ ПустаяСтрока(Текст) 
		И НЕ РегламентированныеДанныеКлиентСервер.КодПоОКПОСоответствуетТребованиям(Текст,
			ЭтоЮрЛицо, 
			ТекстСообщения) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,"Объект.КодПоОКПО",,);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаполнитьПоИНН(Команда)
	
	Если ОтключитьЗаполнениеПоИНН <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Наименование) 
		ИЛИ ЗначениеЗаполнено(Объект.НаименованиеПолное) 
		ИЛИ ЗначениеЗаполнено(Объект.КПП) Тогда
		ТекстВопроса = НСтр("ru='Перезаполнить текущие реквизиты?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоИННЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьЗаполнениеРеквизитовПоИНН();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагента(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентаПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Видимость = АдресныйКлассификаторПуст();
	
	Текст = СтрШаблон(
		НСтр("ru = 'Для автоподбора и выбора адресных сведений необходимо <a href = %1 >загрузить классификатор</a>.'"),
		"ЗагрузитьАдресныйКлассификатор");
		ФорматированнаяСтрока = СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Текст);
		Элементы.ДекорацияАдресныйКлассификаторНеЗагружен.Заголовок = ФорматированнаяСтрока;
	
КонецПроцедуры

// Отвечает за доступность элементов форм.
//
&НаКлиенте
Процедура УправлениеДоступностью()

	ЭтоЮридическоеЛицо = Объект.ЮрФизЛицо =  ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
		
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", "Видимость", ЭтоЮридическоеЛицо);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументУдостоверяющийЛичность", "Видимость", Не ЭтоЮридическоеЛицо);
	
	Если ЭтоЮридическоеЛицо Тогда
		Элементы.ИНН.Маска = "9999999999";    //10
	Иначе
		Элементы.ИНН.Маска = "999999999999";  //12
	КонецЕсли;
	
	Элементы.ИНН.Доступность = НЕ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
	Элементы.КПП.Доступность = Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") И ЗначениеЗаполнено(Объект.ИНН);
	Элементы.КодПоОКПО.Доступность = НЕ (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо") 
		ИЛИ Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"));
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

// Отвечает за доступность элементов форм.
//
&НаСервере
Процедура УправлениеДоступностьюНаСервере()

	ЭтоЮридическоеЛицо = Объект.ЮрФизЛицо =  Перечисления.ЮрФизЛицо.ЮрЛицо;
		
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КПП", "Видимость", ЭтоЮридическоеЛицо);
	ОбщегоНазначенияРТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументУдостоверяющийЛичность", "Видимость", Не ЭтоЮридическоеЛицо);
	
	Элементы.КПП.Доступность = Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо И ЗначениеЗаполнено(Объект.ИНН);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	МодульУправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	МодульУправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВСправочнике(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура ВыполнитьЗаполнениеРеквизитовПоИНН()
	
	ОписаниеОшибки = "";
	ЗаполнитьРеквизитыПоИНННаСервере(ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		// Обработка ошибок
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов контрагентов
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") Тогда
		// Проверка юридического лица по данным сервиса ИФНС после заполнения реквизитов (мог измениться КПП).
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоИНННаСервере(ОписаниеОшибки = "")
	
	ЭтоЮридическоеЛицо = Объект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	Если ЭтоЮридическоеЛицо Тогда
		РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыЮридическогоЛицаПоИНН(Объект.ИНН);
	Иначе
		РеквизитыКонтрагента = РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН(Объект.ИНН);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыКонтрагента.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыКонтрагента);
	
	Если ЭтоЮридическоеЛицо Тогда
		ЗаполнитьЭлементКонтактнойИнформации(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, 
			РеквизитыКонтрагента.ЮридическийАдрес);
	КонецЕсли;
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементКонтактнойИнформации(ВидКонтактнойИнформации, СтруктураДанных)
	
	Если СтруктураДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Вид", ВидКонтактнойИнформации);
	Строки = ЭтотОбъект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДанныеСтроки.Представление = СтруктураДанных.Представление;
	ДанныеСтроки.Значение = СтруктураДанных.КонтактнаяИнформация;
	ЭтотОбъект[ДанныеСтроки.ИмяРеквизита] = СтруктураДанных.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьЗаполнениеПоИНН()
	ОтключитьЗаполнениеПоИНН = Неопределено;
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_УстановитьКартинкуДляКомментария()
	ОбщегоНазначенияРТКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаКомментарий, Объект.Комментарий);
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресныйКлассификаторПуст()
	Возврат НЕ АдресныйКлассификатор.АдресныйКлассификаторЗагружен();
КонецФункции

// ИнтернетПоддержкаПользователей.СПАРКРиски
&НаКлиенте
Процедура Подключаемый_ОбновитьОтображениеИндексыСПАРК()
	ОбновитьОтображениеИндексыСПАРК();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеИндексыСПАРК()
	ПараметрыОтображения = Новый Структура("ВариантОтображения", "Многострочный");
	СПАРКРискиКлиент.ОтобразитьИндексыСПАРК(
		ЭтотОбъект.ИндексыСПАРКРиски,
		Объект,
		Объект.ИНН, // Искать по ИНН
		ЭтотОбъект,
		ПараметрыОтображения,
		Истина);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПоказатьИнформациюСпарк(Форма)
	
	Объект = Форма.Объект;
	ПоказатьИнформацию = (Объект.ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"));
	Возврат ПоказатьИнформацию;
	
КонецФункции

// Конец ИнтернетПоддержкаПользователей.СПАРКРиски

// Команды1СПАРКРиски
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду1СПАРКРиски(Команда)
	СПАРКРискиКлиент.ВыполнитьПодключаемуюКоманду(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец Команды1СПАРКРиски

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти