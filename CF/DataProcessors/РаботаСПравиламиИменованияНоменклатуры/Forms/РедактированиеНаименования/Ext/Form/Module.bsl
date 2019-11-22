﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ПравилоИменования = Параметры.Правило;	
	Номенклатура = Параметры.Номенклатура;
	
	МассивПараметровПравила = Новый Массив;
	Для Каждого СтрокаПараметр из Параметры.ПараметрыПравилаИменования Цикл				
		ЗаполнитьЗначенияСвойств(ПараметрыПравилаИменования.Добавить(),СтрокаПараметр);	
		МассивПараметровПравила.Добавить(Новый РеквизитФормы(СтрокаПараметр.ПутьКДанным,СтрокаПараметр.ТипРеквизита,,СтрокаПараметр.ИмяПараметра));	
	КонецЦикла;	
	ЭтаФорма.ИзменитьРеквизиты(МассивПараметровПравила);
	
	Если Параметры.Свойство("ЗначенияПараметровИменования") Тогда
		Для Каждого СтрокаПараметр из ПараметрыПравилаИменования Цикл
			СтрокиЗначенияПараметров = Параметры.ЗначенияПараметровИменования.НайтиСтроки(Новый Структура("ПутьКДанным",СтрокаПараметр.ПутьКДанным));
			Если СтрокиЗначенияПараметров.Количество() > 0 Тогда 
				ЭтаФорма[СтрокаПараметр.ПутьКДанным] = СтрокиЗначенияПараметров[0].Значение;
				СтрокаПараметр.ДанныеПараметраСтрокой = Формат(СтрокиЗначенияПараметров[0].Значение,"ДЛФ=Д; БЛ='Ложь'; БИ='" + СтрокаПараметр.ИмяПараметра + "'");
			КонецЕсли;
		КонецЦикла;
	Иначе
		РезультатЗапроса = РаботаСПравиламиИменования.ПолучитьЗначенияПараметровНоменклатуры(Номенклатура.ВидНоменклатуры,ПараметрыПравилаИменования,Номенклатура);
		ВыборкаДанных 	 = РезультатЗапроса.Выбрать();
		Если ВыборкаДанных.Количество() > 0 Тогда 
			ВыборкаДанных.Следующий(); 
			Для Каждого СтрокаПараметр из ПараметрыПравилаИменования Цикл
				ЭтаФорма[СтрокаПараметр.ПутьКДанным] = ВыборкаДанных[СтрокаПараметр.ИмяЭлемента];
				СтрокаПараметр.ДанныеПараметраСтрокой = Формат(ЭтаФорма[СтрокаПараметр.ПутьКДанным],"ДЛФ=Д; БЛ='Ложь'; БИ='" + СтрокаПараметр.ИмяПараметра + "'");
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
	РаботаСПравиламиИменования.ДобавитьЭлементыПравилаИменования(ЭтаФорма,Элементы.ГруппаПараметрыИменования);
	
	РеквизитыНоменклатуры = Метаданные.Справочники.Номенклатура.Реквизиты;
	
	Для Каждого СтрокаПараметр из ПараметрыПравилаИменования Цикл
		Если СтрокаПараметр.ЭтоДопРеквизит Тогда
			Если СтрокаПараметр.Свойство.ЗаполнятьОбязательно Тогда
				СтрокаПараметр.ПроверятьЗаполнение = Истина;
			Иначе
				Элементы[СтрокаПараметр.ИмяЭлемента].АвтоОтметкаНезаполненного = Ложь;
			КонецЕсли;
		ИначеЕсли СтрокаПараметр.ЭтоДопСведение Тогда
			Элементы[СтрокаПараметр.ИмяЭлемента].АвтоОтметкаНезаполненного = Ложь;
		Иначе
			Если СтрокаПараметр.ПутьКДанным = "ВидНоменклатуры" Тогда
				Элементы[СтрокаПараметр.ИмяЭлемента].ТолькоПросмотр = Истина;
			ИначеЕсли СтрокаПараметр.ПутьКДанным = "СтавкаНДС" Тогда
				Элементы[СтрокаПараметр.ИмяЭлемента].РежимВыбораИзСписка = Истина;
				Элементы[СтрокаПараметр.ИмяЭлемента].СписокВыбора.Добавить(УчетНДС.СтавкаНДСПоУмолчанию(ТекущаяДатаСеанса()));
				Элементы[СтрокаПараметр.ИмяЭлемента].СписокВыбора.Добавить(Перечисления.СтавкиНДС.НДС10);
				Элементы[СтрокаПараметр.ИмяЭлемента].СписокВыбора.Добавить(Перечисления.СтавкиНДС.БезНДС);
			КонецЕсли;
			РеквизитНоменклатуры = РеквизитыНоменклатуры[СтрокаПараметр.ПутьКДанным];
			Если РеквизитНоменклатуры.ПроверкаЗаполнения = ПроверкаЗаполнения.НеПроверять Тогда
				Элементы[СтрокаПараметр.ИмяЭлемента].АвтоОтметкаНезаполненного = Ложь;
			Иначе
				СтрокаПараметр.ПроверятьЗаполнение = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
			
	СформироватьНаименование();
	ПоискДублей();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	МассивНеЗаполненныхПараметров = ПараметрыПравилаИменования.НайтиСтроки(Новый Структура("ДанныеПараметраСтрокой",""));
	Если МассивНеЗаполненныхПараметров.Количество() = 0 Тогда
		ЗакрытьФорму();
	Иначе
		МассивНеЗаполненныхОбязательныхПараметров = ПараметрыПравилаИменования.НайтиСтроки(Новый Структура("ДанныеПараметраСтрокой,ПроверятьЗаполнение","",Истина));
		Если МассивНеЗаполненныхОбязательныхПараметров.Количество() > 0 Тогда
			Для Каждого СтрокаПараметр из МассивНеЗаполненныхОбязательныхПараметров Цикл
				ТекстСообщения =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"),СтрокаПараметр.ИмяПараметра);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,СтрокаПараметр.ПутьКДанным);
			КонецЦикла;
		Иначе
			ТекстВопроса = НСтр("ru = 'Некоторые параметры именования не заполнены. Продолжить?'");
			Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросЗавершение", ЭтаФорма);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ПараметрИменованияПриИзменении(Элемент)
	
	Строки = ПараметрыПравилаИменования.НайтиСтроки(Новый Структура("ИмяЭлемента",Элемент.Имя));	
	Для Каждого Строка из Строки Цикл
		Строка.ДанныеПараметраСтрокой = Формат(ЭтаФорма[Строка.ПутьКДанным],"ДЛФ=Д; БЛ='Ложь'; БИ='" + Строка.ИмяПараметра + "'");
	КонецЦикла;
	
	СформироватьНаименование();	
	ПоискДублей();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИнформацияДублирующиеПозицииНажатие(Элемент)
	
	МассивДублирующихПозиций = Новый Массив;
	
	Для Каждого Строка Из ДублиНоменклатуры Цикл
		МассивДублирующихПозиций.Добавить(Строка.Номенклатура);
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивДублирующихПозиций",МассивДублирующихПозиций);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаСпискаДублирующиеПозиции",ПараметрыОткрытия,ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьНаименование()
	
	Элементы.ДекорацияПримерНаименования.Заголовок = РаботаСПравиламиИменованияКлиентСервер.ПреобразоватьСтрокуПоПравилу(ПравилоИменования,ПараметрыПравилаИменования,"ИмяПараметра","ДанныеПараметраСтрокой");
		
КонецПроцедуры

&НаСервере
Процедура ПоискДублей()

	ДублиНоменклатуры.Очистить();

	СтруктураПоискаДублей = РаботаСПравиламиИменования.ПолучитьСтруктуруПоискаНоменклатуры(ЭтаФорма);
	
	Если СтруктураПоискаДублей.РеквизитыЗаполнены Тогда		
		СтруктураПоискаДублей.Вставить("ВидНоменклатуры",Номенклатура.ВидНоменклатуры);
		Результат = РаботаСПравиламиИменования.ПоискНоменклатуры(СтруктураПоискаДублей,Номенклатура);
		Выборка   = Результат.Выбрать();
		
		КоличествоДублирующихПозиций = Выборка.Количество(); 
		Элементы.НадписьИнформацияДублирующиеПозиции.Заголовок = "Обнаружены карточки с одинаковым наименованием (" + КоличествоДублирующихПозиций + ")";
		Элементы.НадписьИнформацияДублирующиеПозиции.Видимость = КоличествоДублирующихПозиций > 0;	
		
		Пока Выборка.Следующий() Цикл
			НСтр = ДублиНоменклатуры.Добавить();
			НСтр.Номенклатура = Выборка.Номенклатура;
		КонецЦикла;

	Иначе 
		Элементы.НадписьИнформацияДублирующиеПозиции.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросЗавершение(Результат, ПараметрКоманды) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	ПараметрыЗакрытия			= Новый Структура;
	МассивЗаполненныхПараметров	= Новый Массив;
	
	Для Каждого СтрокаПараметр из ПараметрыПравилаИменования Цикл
		
		СтруктураПараметра = Новый Структура;
		
		Если СтрокаПараметр.ЭтоДопРеквизит Тогда
			СтруктураПараметра.Вставить("ДанныеОбъекта",Ложь);
		ИначеЕсли СтрокаПараметр.ЭтоДопСведение Тогда
			ЗаписатьДопСведение(СтрокаПараметр.Свойство,ЭтаФорма[СтрокаПараметр.ПутьКДанным]); 
			СтруктураПараметра.Вставить("ЭтоДопСведение");	
		Иначе
			СтруктураПараметра.Вставить("ДанныеОбъекта",Истина);
		КонецЕсли;
		
		СтруктураПараметра.Вставить("ПутьКДанным",	СтрокаПараметр.ПутьКДанным);
		СтруктураПараметра.Вставить("Значение",		ЭтаФорма[СтрокаПараметр.ПутьКДанным]);
		
		МассивЗаполненныхПараметров.Добавить(СтруктураПараметра);
		
	КонецЦикла;
	
	ПараметрыЗакрытия.Вставить("Наименование",Элементы.ДекорацияПримерНаименования.Заголовок);
	ПараметрыЗакрытия.Вставить("МассивЗаполненныхПараметров",МассивЗаполненныхПараметров);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДопСведение(Свойство,Значение)
	
	МенеджерЗаписи = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = Номенклатура;
	МенеджерЗаписи.Свойство = Свойство;
	МенеджерЗаписи.Значение = Значение;
	МенеджерЗаписи.Записать();
			
КонецПроцедуры

#КонецОбласти