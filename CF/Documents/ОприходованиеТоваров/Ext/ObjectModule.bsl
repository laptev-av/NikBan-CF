﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет ТЧ Товары по остаткам регистра ТоварыКОформлениюИзлишковНедостач документа основания.
//
Процедура ЗаполнитьТабличнуюЧастьТовары() Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика КАК Характеристика,
	|	СУММА(ТоварыКОформлению.КОформлениюАктовОстаток) КАК Количество
	|ПОМЕСТИТЬ ТаблицаЗапроса
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|		ТоварыКОформлению.Характеристика КАК Характеристика,
	|		ТоварыКОформлению.КОформлениюАктовОстаток КАК КОформлениюАктовОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(
	|				,
	|				ДокументОснование = &ДокументОснование
	|					И Склад = &Склад) КАК ТоварыКОформлению
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыКОформлению.Номенклатура,
	|		ТоварыКОформлению.Характеристика,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ТоварыКОформлению.КОформлениюАктов
	|			ИНАЧЕ ТоварыКОформлению.КОформлениюАктов
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыКОформлению
	|	ГДЕ
	|		ТоварыКОформлению.Регистратор = &Ссылка
	|		И ТоварыКОформлению.ДокументОснование = &ДокументОснование
	|		И ТоварыКОформлению.Активность = ИСТИНА) КАК ТоварыКОформлению
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.Номенклатура,
	|	ТоварыКОформлению.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыКОформлению.КОформлениюАктовОстаток) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапроса.Номенклатура,
	|	ТаблицаЗапроса.Характеристика,
	|	ТаблицаЗапроса.Количество,
	|	ТаблицаЗапроса.Количество КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаЗапроса КАК ТаблицаЗапроса";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Нет данных для заполнения по основанию ""%ДокументОснование%"" .'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДокументОснование");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ОприходованиеТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.СерийныеНомера.ОчиститьВДокументеНеиспользуемыеСерийныеНомера(Товары, СерийныеНомера);
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(
		ЭтотОбъект,
		Документы.ОприходованиеТоваров.ПараметрыУказанияСерий(ЭтотОбъект));
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, Истина),
		"СуммаДокумента");

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
			ДанныеЗаполнения = ДанныеЗаполнения.ДокументОснование;
		КонецЕсли;
	КонецЕсли;
	
	ДокументОснование = ЗапасыСерверВызовСервера.ПолучитьОснованиеОформленияИзлишковНедостачТоваров(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриказНаПроведениеИнвентаризацииТоваров") 
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров") 
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОрдерНаОтражениеРезультатовПересчетовТоваров") 
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров")
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктОРасхожденияхПриПриемкеТоваров") Тогда
			Реквизиты = Новый Структура("Склад, Магазин, Организация", "СкладОтправитель", "МагазинОтправитель", "Организация");
		
			ЗначенияРеквизитов = ОбщегоНазначенияРТ.ПолучитьЗначенияРеквизитовОбъекта(ДанныеЗаполнения, Реквизиты);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
			Реквизиты = Новый Структура("Магазин, Организация", "ТорговыйОбъект", "Организация");
		
			ЗначенияРеквизитов = ОбщегоНазначенияРТ.ПолучитьЗначенияРеквизитовОбъекта(ДанныеЗаполнения, Реквизиты);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		Иначе
			ЗаполнитьЗначенияСвойств(
				ЭтотОбъект, 
				ДанныеЗаполнения,
				"Склад, Магазин, Организация");
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Магазин)
			И Магазин.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач
			И Не ЗначениеЗаполнено(ДокументОснование) Тогда
			
			ТекстСообщения = НСтр("ru='В магазине ""%1%"" используется ордерная схема для отражения излишков и недостач,
									  |поэтому ""Оприходование товаров"" нужно вводить по основанию.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1%",Склад);
			
			ВызватьИсключение ТекстСообщения;
			
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
			ЗаполнитьТабличнуюЧастьПоАктуПостановки();
		Иначе
			ЗаполнитьТабличнуюЧастьТовары();
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОстаткиЕГАИС") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		ДокументОснование = ДанныеЗаполнения;
		
		Ответственный = Пользователи.ТекущийПользователь();
		Магазин = ДанныеЗаполнения.ТорговыйОбъект;
		Организация = ДанныеЗаполнения.Организация;
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
		|	СУММА(ОстаткиПоДаннымЕГАИС.Количество) КАК количество
		|ПОМЕСТИТЬ втОстаткиПоДаннымЕГАИС
		|ИЗ
		|	Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиПоДаннымЕГАИС
		|ГДЕ
		|	ОстаткиПоДаннымЕГАИС.Ссылка = &ДокументОснование
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СоответствиеНоменклатуры.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
		|	МАКСИМУМ(СоответствиеНоменклатуры.Номенклатура) КАК номенклатура,
		|	МАКСИМУМ(СоответствиеНоменклатуры.Характеристика) КАК Характеристика
		|ПОМЕСТИТЬ втСоответствиеНоменклатуры
		|ИЗ
		|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатуры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втОстаткиПоДаннымЕГАИС КАК ОстаткиПоДаннымЕГАИС
		|		ПО СоответствиеНоменклатуры.АлкогольнаяПродукция = ОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция
		|			И (СоответствиеНоменклатуры.Порядок = 1)
		|
		|СГРУППИРОВАТЬ ПО
		|	СоответствиеНоменклатуры.АлкогольнаяПродукция
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СоответствиеНоменклатуры.номенклатура КАК Номенклатура,
		|	ОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
		|	СоответствиеНоменклатуры.Характеристика КАК Характеристика,
		|	ОстаткиПоДаннымЕГАИС.Количество / ВЫБОР
		|		КОГДА СоответствиеНоменклатуры.номенклатура ЕСТЬ NULL
		|			ТОГДА 1
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ЕСТЬNULL(СоответствиеНоменклатуры.Номенклатура.ВидНоменклатуры.ПродаетсяВРозлив, ЛОЖЬ)
		|						И СоответствиеНоменклатуры.Номенклатура.ОбъемДАЛ <> 0
		|					ТОГДА СоответствиеНоменклатуры.Номенклатура.ОбъемДАЛ
		|				ИНАЧЕ 1
		|			КОНЕЦ
		|	КОНЕЦ КАК КоличествоУпаковок
		|ИЗ
		|	втОстаткиПоДаннымЕГАИС КАК ОстаткиПоДаннымЕГАИС
		|		ЛЕВОЕ СОЕДИНЕНИЕ втСоответствиеНоменклатуры КАК СоответствиеНоменклатуры
		|		ПО ОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция = СоответствиеНоменклатуры.АлкогольнаяПродукция
		|ГДЕ
		|	ОстаткиПоДаннымЕГАИС.Количество > 0";
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		
		Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Если Товары.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Нет данных для заполнения оприходования товаров'");
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		СтруктураТЧ = Новый Структура;
		СтруктураТЧ.Вставить("СтрокиТЧ", Товары);
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		СтруктураДействий.Вставить("НеобходимоОбработатьВсюТЧ");
		ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий, Неопределено);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда
		
		ИнтеграцияВЕТИСРТ.ЗаполнитьОприходованиеТоваровНаОснованииИнвентаризацииПродукцииВЕТИС(ЭтотОбъект, ДанныеЗаполнения,, СтандартнаяОбработка);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если Магазин.СкладУправляющейСистемы Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
	КонецЕсли;
	
	ХозяйственнаяОперация = АналитикаХозяйственнойОперации.ХозяйственнаяОперация;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеКомиссионныхТоваров Тогда
		ЗапасыСервер.ПроверитьНаличиеКомиссионнойАлкогольнойПродукцииИлиКиЗ(ЭтотОбъект, Отказ);
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	ЗапасыСервер.ПроверитьУказаниеГТДДляКиЗ(ЭтотОбъект, Отказ);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		Документы.ОприходованиеТоваров.ПараметрыУказанияСерий(ЭтотОбъект),
		Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеТЧПриНаличииОбменаСУправлениемТорговлей(
		ЭтотОбъект, 
		Отказ); 
	
	МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
	МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеров(
		ЭтотОбъект,
		"Товары",
		"СерийныеНомера",
		Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	
	Если ЗначениеЗаполнено(ДокументОснование) 
		И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриказНаПроведениеИнвентаризацииТоваров") Тогда
		АналитикаХозяйственнойОперации = ЗначениеНастроекПовтИсп.ПолучитьАналитикуХозяйственнойОперацииПоУмолчанию(
			АналитикаХозяйственнойОперации,
			Перечисления.ХозяйственныеОперации.ОприходованиеПоИнвентаризации);
	Иначе
		АналитикаХозяйственнойОперации = ЗначениеНастроекПовтИсп.ПолучитьАналитикуХозяйственнойОперацииПоУмолчанию(
			АналитикаХозяйственнойОперации,
			Перечисления.ХозяйственныеОперации.Оприходование);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Склад")
			И НЕ ЗначениеЗаполнено(Склад) Тогда
			Если ЗначениеЗаполнено(Магазин) Тогда
				Если НЕ Справочники.Склады.ПроверитьПринадлежностьСкладаМагазину(Магазин, ДанныеЗаполнения.Склад) Тогда
					ДанныеЗаполнения.Склад = Справочники.Склады.ПустаяСсылка();
				КонецЕсли;
			Иначе
				Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.Склад, "Магазин");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьПоАктуПостановки()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаЗапроса.Номенклатура,
	|	ТаблицаЗапроса.Характеристика,
	|	ТаблицаЗапроса.Количество,
	|	ТаблицаЗапроса.КоличествоУпаковок
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК ТаблицаЗапроса
	|ГДЕ
	|	ТаблицаЗапроса.Ссылка = &ДокументОснование";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Нет данных для заполнения по основанию ""%ДокументОснование%"" .'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДокументОснование");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
