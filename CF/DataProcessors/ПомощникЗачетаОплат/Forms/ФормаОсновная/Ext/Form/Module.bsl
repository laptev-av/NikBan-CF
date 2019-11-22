﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    
    // &ЗамерПроизводительности
	ОценкаПроизводительностиРТКлиент.НачатьЗамер(
		     Истина, "Обработка.ПомощникЗачетаОплат.Форма.ФормаОсновная.Открытие");
             
    УстановитьНеАктуальностьРасчетов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоставщикПриИзменении(Элемент)
	
	УстановитьНеАктуальностьРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	
	УстановитьНеАктуальностьРасчетов();
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТабличнойЧастиОплаты

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоле = Поле.Имя;
	ИмяРеквизита = СтрЗаменить(Поле.Имя, "ТаблицаДокументов", "");
	
	Если НЕ (ИмяРеквизита = "ДокументОплаты" ИЛИ ИмяРеквизита = "ДокументРасчетов") Тогда
		Возврат;
	КонецЕсли;
	
	Значение = Элемент.ТекущиеДанные[ИмяРеквизита];
	Если ЗначениеЗаполнено(Значение) Тогда
		ПоказатьЗначение(,Значение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовСуммаКОплатеПриИзменении(Элемент)
	
	ЭлементДерева = Элементы.ТаблицаДокументов.ТекущиеДанные;
	СуммаПревышения = 0;
	КонтролироватьПревышение = ЭлементДерева.СуммаКОплате > ЭлементДерева.СуммаОплатыДоРедактирования;
	
	Если КонтролироватьПревышение
		И ПроверитьПревышениеЗадолженности(ЭлементДерева.ДокументРасчетов, ЭлементДерева.ДолгПоДокументуРасчетов, СуммаПревышения) Тогда
		
		ТекстСообщения = НСтр("ru = 'Превышена на %1 руб. сумма оплаты задолженности по документу %2.
									|Сумма оплаты скорректирована.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СуммаПревышения, ЭлементДерева.ДокументРасчетов);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		ЭлементДерева.СуммаКОплате = ЭлементДерева.СуммаКОплате - СуммаПревышения;
	КонецЕсли;
	
	Отказ = Ложь;
	ДокументОплаты = Неопределено;
	
	ПересчитатьСуммуИтога(ЭлементДерева, КонтролироватьПревышение, СуммаПревышения, Отказ, ДокументОплаты);
	
	Если Отказ Тогда
		
		ТекстСообщения = НСтр("ru = 'Превышена на %1 руб. сумма аванса по документу %2.
									|Сумма оплаты скорректирована.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СуммаПревышения, ДокументОплаты);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		ЭлементДерева.СуммаКОплате = ЭлементДерева.СуммаКОплате - СуммаПревышения;
		
		ПересчитатьСуммуИтога(ЭлементДерева, Ложь);
		
	КонецЕсли;
	
	Родитель = ЭлементДерева.ПолучитьРодителя();
	ПересчитатьСуммуИтога(Родитель, Ложь);
	
	ЭлементДерева.СуммаОплатыДоРедактирования = ЭлементДерева.СуммаКОплате;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьТаблицуДокументов();
	
	Если ТаблицаДокументов.ПолучитьЭлементы().Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Нет данных для зачета'");
		Пояснение = НСтр("ru='Выполнять зачет оплаты не требуется'");
		ПоказатьОповещениеПользователя(ТекстСообщения, , Пояснение, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	УстановитьКнопкуПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗачетОплаты(Команда)
	
	Перем МассивОбработанныхДокументов;
	
	Отказ = Ложь;
	
	СохранитьРезультатЗачетаОплаты(МассивОбработанныхДокументов, Отказ);
	ОповеститьОРезультатеЗачетаОплаты(МассивОбработанныхДокументов);
	
	ЗаполнитьТаблицуДокументов();
	УстановитьКнопкуПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуДокументов()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаДокументов.Видимость = Истина;
	Элементы.ТабДок.Видимость = Ложь;
	
	УсловиеПоставщик = ?(ЗначениеЗаполнено(Поставщик), "И Поставщик = &Поставщик", "");

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(РасчетыСПоставщиками.Регистратор КАК Документ.РасходныйКассовыйОрдер).Дата КАК Дата,
	|	РасчетыСПоставщиками.Регистратор КАК ДокументОплаты,
	|	РасчетыСПоставщиками.Поставщик КАК Поставщик,
	|	РасчетыСПоставщиками.Магазин КАК Магазин,
	|	РасчетыСПоставщиками.СуммаПриход КАК СуммаАванса,
	|	0 КАК СуммаЗачетаОплаты
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.ОстаткиИОбороты(
	|			,
	|			,
	|			Регистратор,
	|			,
	|			(ДокументРасчета = НЕОПРЕДЕЛЕНО
	|				ИЛИ ДокументРасчета = ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|				ИЛИ ДокументРасчета = ЗНАЧЕНИЕ(Документ.ПоступлениеТоваров.ПустаяСсылка))
	|				И Магазин = &Магазин "+ УсловиеПоставщик +") КАК РасчетыСПоставщиками
	|ГДЕ
	|	РасчетыСПоставщиками.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
	|	И ВЫРАЗИТЬ(РасчетыСПоставщиками.Регистратор КАК Документ.РасходныйКассовыйОрдер).ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаПоставщику)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(РасчетыСПоставщиками.Регистратор КАК Документ.РегистрацияБезналичнойОплаты).Дата,
	|	РасчетыСПоставщиками.Регистратор,
	|	РасчетыСПоставщиками.Поставщик,
	|	РасчетыСПоставщиками.Магазин,
	|	РасчетыСПоставщиками.СуммаПриход,
	|	0
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.ОстаткиИОбороты(
	|			,
	|			,
	|			Регистратор,
	|			,
	|			(ДокументРасчета = НЕОПРЕДЕЛЕНО
	|				ИЛИ ДокументРасчета = ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|				ИЛИ ДокументРасчета = ЗНАЧЕНИЕ(Документ.ПоступлениеТоваров.ПустаяСсылка))
	|				И Магазин = &Магазин "+ УсловиеПоставщик +") КАК РасчетыСПоставщиками
	|ГДЕ
	|	РасчетыСПоставщиками.Регистратор ССЫЛКА Документ.РегистрацияБезналичнойОплаты
	|	И ВЫРАЗИТЬ(РасчетыСПоставщиками.Регистратор КАК Документ.РегистрацияБезналичнойОплаты).ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаПоставщику)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата
	|ИТОГИ ПО
	|	Поставщик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыСПоставщиками.Магазин КАК Магазин,
	|	РасчетыСПоставщиками.Поставщик КАК Поставщик,
	|	РасчетыСПоставщиками.ДокументРасчета КАК ДокументРасчета,
	|	-РасчетыСПоставщиками.КОплатеОстаток КАК КОплате
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками.Остатки(, Магазин = &Магазин "+ УсловиеПоставщик +") КАК РасчетыСПоставщиками
	|ГДЕ
	|	РасчетыСПоставщиками.КОплатеОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасчетыСПоставщиками.ДокументРасчета.Дата
	|ИТОГИ ПО
	|	Поставщик";
	
	Запрос.УстановитьПараметр("Магазин", 	Магазин);
	Запрос.УстановитьПараметр("Поставщик", 	Поставщик);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаПоПоставщикамОплаты = РезультатЗапроса[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоПоставщикамРасчеты = РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	МассивПодстрок = Новый Массив;
	
	ДеревоДокументов = РеквизитФормыВЗначение("ТаблицаДокументов");
	ДеревоДокументов.Строки.Очистить();
	
	Пока ВыборкаПоПоставщикамОплаты.Следующий() Цикл
		
		ВыборкаДокументыОплаты = ВыборкаПоПоставщикамОплаты.Выбрать();
		
		ЕстьНепогашенныйОстаток = Ложь;
		Сумма = 0;
		
		СтруктураПоиска = Новый Структура("Поставщик", ВыборкаПоПоставщикамОплаты.Поставщик);
		ВыборкаПоПоставщикамРасчеты.Сбросить();
		Если НЕ ВыборкаПоПоставщикамРасчеты.НайтиСледующий(СтруктураПоиска) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПоставщик = Неопределено;
		СуммаАвансаИтогПоПоставщику = 0;
		СуммаКОплатеИтогПоПоставщику = 0;
		ДолгПоДокументуРасчетов = 0;
		
		ВыборкаДокументыРасчетов = ВыборкаПоПоставщикамРасчеты.Выбрать();
		
		Пока ВыборкаДокументыОплаты.Следующий() Цикл
			МассивПодстрок.Очистить();
			СуммаАванса = ВыборкаДокументыОплаты.СуммаАванса;
			СуммаАвансаИтог = СуммаАванса;
			СуммаКОплатеИтог = 0;
			
			Если ЕстьНепогашенныйОстаток Тогда
				
				КОплате = КОплате - Сумма;
				Сумма = МИН(СуммаАванса, КОплате);
				СтруктураПодстроки = Новый Структура;
				СтруктураПодстроки.Вставить("ДокументОплаты", ВыборкаДокументыОплаты.ДокументОплаты);
				СтруктураПодстроки.Вставить("ДокументРасчетов", ВыборкаДокументыРасчетов.ДокументРасчета);
				СтруктураПодстроки.Вставить("СуммаКОплате", Сумма);
				СтруктураПодстроки.Вставить("ДолгПоДокументуРасчетов", ДолгПоДокументуРасчетов);
				СуммаАванса = СуммаАванса - Сумма;
				СуммаКОплатеИтог = СуммаКОплатеИтог + Сумма;
				ЕстьНепогашенныйОстаток = ?(КОплате > Сумма, Истина, Ложь);
				МассивПодстрок.Добавить(СтруктураПодстроки);
			КонецЕсли;
			
			Пока НЕ ЕстьНепогашенныйОстаток И СуммаАванса > 0 И ВыборкаДокументыРасчетов.Следующий() Цикл
				КОплате = ВыборкаДокументыРасчетов.КОплате;
				ДолгПоДокументуРасчетов = КОплате;
				Сумма = МИН(СуммаАванса, КОплате);
				СтруктураПодстроки = Новый Структура;
				СтруктураПодстроки.Вставить("ДокументОплаты", ВыборкаДокументыОплаты.ДокументОплаты);
				СтруктураПодстроки.Вставить("ДокументРасчетов", ВыборкаДокументыРасчетов.ДокументРасчета);
				СтруктураПодстроки.Вставить("СуммаКОплате", Сумма);
				СтруктураПодстроки.Вставить("ДолгПоДокументуРасчетов", ДолгПоДокументуРасчетов);
				СуммаАванса = СуммаАванса - Сумма;
				СуммаКОплатеИтог = СуммаКОплатеИтог + Сумма;
				ЕстьНепогашенныйОстаток = ?(КОплате > Сумма, Истина, Ложь);
				МассивПодстрок.Добавить(СтруктураПодстроки);
			КонецЦикла;
			
			Если МассивПодстрок.Количество() <> 0 Тогда
				
				Если СтрокаПоставщик = Неопределено Тогда
					Если НЕ ЗначениеЗаполнено(Поставщик) Тогда
						СтрокаПоставщик = ДеревоДокументов.Строки.Добавить();
						СтрокаПоставщик.Поставщик = ВыборкаПоПоставщикамОплаты.Поставщик;
					Иначе 
						СтрокаПоставщик = ДеревоДокументов;
					КонецЕсли;
				КонецЕсли;
				
				СтрокаРодитель = ДобавитьСтрокуВерхнегоУровня(СтрокаПоставщик, ВыборкаДокументыОплаты.ДокументОплаты, СуммаАвансаИтог, СуммаКОплатеИтог);
				ДобавитьСтрокиНижнегоУровня(СтрокаРодитель, МассивПодстрок);
				
			КонецЕсли;
			СуммаАвансаИтогПоПоставщику = СуммаАвансаИтогПоПоставщику + СуммаАвансаИтог;
			СуммаКОплатеИтогПоПоставщику = СуммаКОплатеИтогПоПоставщику + СуммаКОплатеИтог;
		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(Поставщик) Тогда
			СтрокаПоставщик.СуммаАванса 	= СуммаАвансаИтогПоПоставщику;
			СтрокаПоставщик.СуммаКОплате 	= СуммаКОплатеИтогПоПоставщику;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДеревоДокументов.Строки.Количество() > 0 Тогда
		Элементы.ФормаВыполнитьЗачетОплаты.Доступность = Истина;
	Иначе
		Элементы.ФормаВыполнитьЗачетОплаты.Доступность = Ложь;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоДокументов, "ТаблицаДокументов");
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуВерхнегоУровня(СтрокаПоставщик, Документ, СуммаАванса, СуммаКОплате)
	
	Строка = СтрокаПоставщик.Строки.Добавить();
	Строка.ДокументОплаты 	= Документ;
	Строка.СуммаАванса 		= СуммаАванса;
	Строка.СуммаКОплате 	= СуммаКОплате;
	Строка.ВерсияДанных 	= ВерсияДанныхДокумента(Документ);
	
	Возврат Строка;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокиНижнегоУровня(СтрокаРодитель, МассивПодстрок)

	Для Каждого Подстрока Из МассивПодстрок Цикл
		Строка = СтрокаРодитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, Подстрока);
		Строка.СуммаОплатыДоРедактирования = Строка.СуммаКОплате;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРезультатЗачетаОплаты(МассивОбработанныхДокументов, Отказ = Ложь)
	
	МассивОбработанныхДокументов = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	ДеревоДокументов = РеквизитФормыВЗначение("ТаблицаДокументов");
	
	ЗаблокироватьДокументыДляРедактирования(ДеревоДокументов, Отказ);
	
	Если ЗначениеЗаполнено(Поставщик) Тогда
		СохранитьРезультатПоВеткеДерева(ДеревоДокументов.Строки, Отказ, МассивОбработанныхДокументов);
	Иначе
		Для каждого Строки Из ДеревоДокументов.Строки Цикл
		
			СохранитьРезультатПоВеткеДерева(Строки.Строки, Отказ, МассивОбработанныхДокументов);
			
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	РазблокироватьДокументыДляРедактирования(МассивОбработанныхДокументов);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРезультатПоВеткеДерева(Строки, Отказ, МассивОбработанныхДокументов)

	Для Каждого СтрокаТаблицы Из Строки Цикл
		
		НачатьТранзакцию();
		
		ДокументСсылка = СтрокаТаблицы.ДокументОплаты;
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		
		ИмяТабличнойЧасти = "РасшифровкаПлатежа";
		
		ТаблицаРасшифровкаПлатежа = ДокументОбъект[ИмяТабличнойЧасти].Выгрузить(,);
		
		ТаблицаРасшифровкаПлатежа.Свернуть("СтатьяДвиженияДенежныхСредств, ДокументРасчетовСКонтрагентом ", "Сумма");
		ТаблицаРасшифровкаПлатежа.Сортировать("ДокументРасчетовСКонтрагентом Убыв");
		
		ДанныеИзменены = Ложь;
		
		Для Каждого Подстрока Из СтрокаТаблицы.Строки Цикл
			
			ОтразитьЗачетОплатыВДокументе(
				ТаблицаРасшифровкаПлатежа,
				Подстрока.ДокументРасчетов,
				Подстрока.СуммаКОплате,
				Отказ,
				ДанныеИзменены);
			
		КонецЦикла;
		
		Если ДанныеИзменены Тогда
			
			ДокументОбъект[ИмяТабличнойЧасти].Загрузить(ТаблицаРасшифровкаПлатежа);
			ДокументОбъект.ДополнительныеСвойства.Вставить("ПроверкаДатыЗапретаИзменения", Ложь);
			Если ДокументОбъект.ПроверитьЗаполнение() Тогда
				Попытка
					ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Не удалось записать документ %1. %2'"),
						ДокументСсылка,
						КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,);
					Отказ = Истина;
				КонецПопытки;
			Иначе
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не удалось записать документ %1'"),
					ДокументСсылка);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,);
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ Отказ Тогда
			
			Попытка
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
				ОтменитьТранзакцию();
			КонецПопытки;
			
			МассивОбработанныхДокументов.Добавить(СтрокаТаблицы.ДокументОплаты);
		КонецЕсли;
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОтразитьЗачетОплатыВДокументе(ТаблицаРасшифровкаПлатежа, ДокументРасчета , Знач СуммаКОплате, Отказ, ДанныеИзменены)
	
	Для Каждого СтрокаДокумента Из ТаблицаРасшифровкаПлатежа Цикл
		
		Если СуммаКОплате > 0 И НЕ ЗначениеЗаполнено(СтрокаДокумента.ДокументРасчетовСКонтрагентом) Тогда
			
			УменьшениеСуммы = 0;
			Сумма = МИН(СуммаКОплате, СтрокаДокумента.Сумма);
			УменьшениеСуммы = СтрокаДокумента.Сумма - Сумма;
			СтрокаДокумента.Сумма = Сумма;
			СуммаКОплате = СуммаКОплате - Сумма;
			
			Если УменьшениеСуммы <> 0 Тогда
				НоваяСтрока = ТаблицаРасшифровкаПлатежа.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаДокумента);
				НоваяСтрока.Сумма = УменьшениеСуммы;
				НоваяСтрока.ДокументРасчетовСКонтрагентом = Неопределено;
			КонецЕсли;
			
			СтрокаДокумента.ДокументРасчетовСКонтрагентом = ДокументРасчета;
			ДанныеИзменены = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьДокументыДляРедактирования(ДеревоДокументов, Отказ = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(Поставщик) Тогда
		ЗаблокироватьДокументы(ДеревоДокументов.Строки, Отказ);
	Иначе
		Для каждого Строки Из ДеревоДокументов.Строки Цикл
		
			ЗаблокироватьДокументы(Строки.Строки, Отказ);
			
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьДокументы(Строки, Отказ)
	
	Для Каждого СтрокаТаблицы Из Строки Цикл
		
		Если СтрокаТаблицы.ВерсияДанных <> ВерсияДанныхДокумента(СтрокаТаблицы.ДокументОплаты) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось заблокировать %1. Данные были изменены или удалены другим пользователем.'"),
				СтрокаТаблицы.ДокументОплаты);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				, // КлючДанных
				"ТаблицаДокументов");
				
			Отказ = Истина;
			
		Иначе
			
			Попытка
				ЗаблокироватьДанныеДляРедактирования(
					СтрокаТаблицы.ДокументОплаты,
					,// ВерсияДанных
					УникальныйИдентификатор);
				
			Исключение
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Не удалось заблокировать %1. %2'"),
					СтрокаТаблицы.ДокументОплаты,
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					, // КлючДанных
					"ТаблицаДокументов");
				
				Отказ = Истина;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьДокументыДляРедактирования(МассивОбработанныхДокументов)
	
	РазблокироватьДанныеДляРедактирования(
		, // Ключ
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОРезультатеЗачетаОплаты(МассивОбработанныхДокументов)
	
	Если МассивОбработанныхДокументов.Количество() = 0 Тогда
		Текст = НСтр("ru='Изменений в зачете оплаты не было'");
		Пояснение = НСтр("ru='Изменений в документах при зачете оплаты не было'");
		ПоказатьОповещениеПользователя(
			Текст,
			, // НавигационнаяСсылка
			Пояснение,
			БиблиотекаКартинок.Информация32);
		
	Иначе
		Для Каждого ДокументСсылка Из МассивОбработанныхДокументов Цикл
			Текст = НСтр("ru='Изменен зачет оплаты'");
			Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Изменен зачет оплаты по документу: %1'"),
				ДокументСсылка);
			
			ПоказатьОповещениеПользователя(
				Текст,
				ПолучитьНавигационнуюСсылку(ДокументСсылка),
				Пояснение,
				БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВерсияДанныхДокумента(ДокументСсылка)
	
	ИмяДокумента = Метаданные.НайтиПоТипу(ТипЗнч(ДокументСсылка)).Имя;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.ВерсияДанных КАК ВерсияДанных
	|ИЗ
	|	Документ.%ИмяДокумента% КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|";
	Запрос = Новый Запрос;
	Запрос.Текст = СтрЗаменить(ТекстЗапроса, "%ИмяДокумента%", ИмяДокумента);
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВерсияДанных = Выборка.ВерсияДанных;
	Иначе
		ВерсияДанных = "            ";
	КонецЕсли;
	
	Возврат ВерсияДанных;
	
КонецФункции

&НаКлиенте
Процедура УстановитьНеАктуальностьРасчетов()
	
	Элементы.ФормаВыполнитьЗачетОплаты.Доступность = Ложь;
	ТаблицаДокументов.ПолучитьЭлементы().Очистить();
	
	Элементы.ТаблицаДокументов.Видимость = Ложь;
	Элементы.ТабДок.Видимость = Истина;
	
	Элементы.ТабДок.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ТабДок.ОтображениеСостояния.Текст = НСтр("ru = 'Документы не подобраны. Нажмите ""Подобрать документы"" для заполнения таблицы.'");
	Элементы.ТабДок.ОтображениеСостояния.Видимость = Истина;
	
	УстановитьКнопкуПоУмолчанию();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКнопкуПоУмолчанию()
	
	Если ТаблицаДокументов.ПолучитьЭлементы().Количество() = 0 Тогда
		Элементы.ФормаОбновить.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ФормаВыполнитьЗачетОплаты.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуИтога(ЭлементДерева, КонтролироватьПревышениеАванса, СуммаПревышения = 0, Отказ = Ложь, ДокументОплаты = Неопределено)

	Родитель = ЭлементДерева.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодчиненныеПоРодителю = Родитель.ПолучитьЭлементы();
	
	Сумма = 0;
	Для Каждого Строка Из ПодчиненныеПоРодителю Цикл
		Сумма = Сумма + Строка.СуммаКОплате;
	КонецЦикла;
	
	Родитель.СуммаКОплате = Сумма;
	
	Если КонтролироватьПревышениеАванса Тогда
		Если Сумма > Родитель.СуммаАванса Тогда
			Отказ = Истина;
			СуммаПревышения = Сумма - Родитель.СуммаАванса;
			ДокументОплаты = Родитель.ДокументОплаты;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПревышениеЗадолженности(ДокументРасчетов, ДолгПоДокументуРасчетов, СуммаПревышения)
	
	Отказ = Ложь;
	
	ДеревоДокументов = РеквизитФормыВЗначение("ТаблицаДокументов");
	
	ПараметрыОтбора = Новый Структура("ДокументРасчетов", ДокументРасчетов);
	
	НайденныеСтроки = ДеревоДокументов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	
	ВведеннаяСуммаОплаты = 0;
	Для Каждого Строка Из НайденныеСтроки Цикл
		ВведеннаяСуммаОплаты = ВведеннаяСуммаОплаты + Строка.СуммаКОплате;
	КонецЦикла;
	
	Если ВведеннаяСуммаОплаты > ДолгПоДокументуРасчетов Тогда
		СуммаПревышения = ВведеннаяСуммаОплаты - ДолгПоДокументуРасчетов;
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

#КонецОбласти
