﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЗаказПоставщику.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьДвиженияНоменклатураПоставщиков(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗакупкиСервер.ОтразитьЗаказыТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
		ЭтотОбъект,
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС),
		"СуммаДокумента");
		
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			Если ЭтотОбъект.ЭтапыОплат.Количество() = 0 Тогда
				
				ПараметрыЭтаповОплат = Новый Структура();
				ПараметрыЭтаповОплат.Вставить("ЭтапыОплат",      ЭтотОбъект.ЭтапыОплат);
				ПараметрыЭтаповОплат.Вставить("Результат",       ЭтотОбъект.Контрагент);
				ПараметрыЭтаповОплат.Вставить("ДатаПоступления", ЭтотОбъект.Дата);
				ПараметрыЭтаповОплат.Вставить("СуммаДокумента",  ЭтотОбъект.СуммаДокумента);
				
				ЗакупкиСервер.ДобавитьЭтапОплаты(ПараметрыЭтаповОплат);
			КонецЕсли;
		КонецЕсли;
	
	// ИнтеграцияГИСМ
	ЕстьКиЗГИСМ = ИнтеграцияГИСМ_РТ.ЕстьКиЗГИСМ(Товары);
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ЗакупкиСервер.ОбновитьСостояниеОплатыПоступления(Ссылка, Истина);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Запрос = Новый Запрос();
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказПоставщикуТовары.Номенклатура   КАК Номенклатура,
		|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика,
		|	ЗаказПоставщикуТовары.Количество     КАК КоличествоЗаказ,
		|	0.00                                 КАК КоличествоПоступление,
		|	ЗаказПоставщикуТовары.Сумма          КАК Сумма,
		|	ЗаказПоставщикуТовары.СтавкаНДС      КАК СтавкаНДС
		|ПОМЕСТИТЬ ТоварыПоступленияЗаказа
		|ИЗ
		|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|ПО
		|	ПоступлениеТоваров.ЗаказПоставщику = &ЗаказПоставщику
		|	И ПоступлениеТоваров.Проведен = ИСТИНА
		|ГДЕ
		|	ЗаказПоставщикуТовары.Ссылка = &ЗаказПоставщику
		|ОБЪЕДИНИТЬ ВСЕ
		|ВЫБРАТЬ
		|	ПоступлениеТоваровТовары.Номенклатура         КАК Номенклатура,
		|	ПоступлениеТоваровТовары.Характеристика       КАК Характеристика,
		|	0.00                                          КАК КоличествоЗаказ,
		|	ПоступлениеТоваровТовары.Количество           КАК КоличествоПоступление,
		|	0.00                                          КАК Сумма,
		|	NULL                                          КАК СтавкаНДС
		|ИЗ
		|	Документ.ПоступлениеТоваров.Товары КАК ПоступлениеТоваровТовары
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		|ПО
		|	ПоступлениеТоваров.Ссылка = ПоступлениеТоваровТовары.Ссылка
		|ГДЕ
		|	ПоступлениеТоваров.ЗаказПоставщику = &ЗаказПоставщику
		|	И ПоступлениеТоваров.Проведен
		|;
		|ВЫБРАТЬ
		|	ТоварыПоступленияЗаказа.Номенклатура                   КАК Номенклатура,
		|	ТоварыПоступленияЗаказа.Характеристика                 КАК Характеристика,
		|	СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ)
		|	- СУММА(ТоварыПоступленияЗаказа.КоличествоПоступление)   КАК КоличествоУпаковок,
		|	СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ)
		|	- СУММА(ТоварыПоступленияЗаказа.КоличествоПоступление)   КАК Количество,
		|	ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК Упаковка,
		|	ВЫБОР	КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТоварыПоступленияЗаказа.СтавкаНДС) > 1.00
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)
		|			ИНАЧЕ МАКСИМУМ(ТоварыПоступленияЗаказа.СтавкаНДС)
		|	КОНЕЦ                                                  КАК СтавкаНДС,
		|	ВЫБОР	КОГДА СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ) = 0.00
		|			ТОГДА 0.00
		|			ИНАЧЕ СУММА(ТоварыПоступленияЗаказа.Сумма) / СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ)
		|	КОНЕЦ                                                  КАК Цена,
		|	ВЫБОР	КОГДА СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ) = 0.00
		|			ТОГДА 0.00
		|			ИНАЧЕ СУММА(ТоварыПоступленияЗаказа.Сумма) / СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ)
		|	КОНЕЦ
		|	* (СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ)
		|	- СУММА(ТоварыПоступленияЗаказа.КоличествоПоступление))  КАК Сумма
		|ИЗ
		|	ТоварыПоступленияЗаказа КАК ТоварыПоступленияЗаказа
		|СГРУППИРОВАТЬ ПО
		|	ТоварыПоступленияЗаказа.Номенклатура,
		|	ТоварыПоступленияЗаказа.Характеристика
		|ИМЕЮЩИЕ
		|	СУММА(ТоварыПоступленияЗаказа.КоличествоЗаказ) > СУММА(ТоварыПоступленияЗаказа.КоличествоПоступление)
		|";
		Запрос.УстановитьПараметр("ЗаказПоставщику", ДанныеЗаполнения);
		РезультатЗапросаКЗаказу = Запрос.ВыполнитьПакет()[1];
		
		Если РезультатЗапросаКЗаказу.Пустой() Тогда
			ТекстОшибки = НСтр("ru='По документу %1 не требуется допоставка товаров. Ввод на основании документа невозможен'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДанныеЗаполнения);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(
		ЭтотОбъект, 
		ДанныеЗаполнения,
		"Склад, Магазин, Контрагент, УчитыватьНДС, ЦенаВключаетНДС, Организация");
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапросаКЗаказу.Выгрузить(), Товары);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить(
			"ПересчитатьСуммуНДС",
			ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(ЭтотОбъект));
		
		СтруктураТЧ = Новый Структура;
		СтруктураТЧ.Вставить("СтрокиТЧ", Товары);
		ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий, Неопределено);
		СуммаДокумента = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОбработкаФормированиеЗаказов") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		ДанныеШапкиДокумента = ДанныеЗаполнения.Реквизиты;
		ДанныеТабличнойЧасти = ДанныеЗаполнения.Товары;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеШапкиДокумента);
		КэшированныеЗначения = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
		ЗаполнитьТабличнуюЧастьИзОбработкиФормированиеЗаказов(ДанныеТабличнойЧасти, КэшированныеЗначения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Статус = Перечисления.СтатусыЗаказовПокупателей.НеСогласован Тогда
			ТекстОшибки = НСтр("ru='Заказ не согласован.
			|Заполнение документа не выполнено.'");
			
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли ДанныеЗаполнения.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт Тогда
			ТекстОшибки = НСтр("ru='Заказ закрыт.
			|Заполнение документа не выполнено.'");
			
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(
		ЭтотОбъект, 
		ДанныеЗаполнения,
		"Склад, Магазин, Организация");
		
		УчитыватьНДС    = Истина;
		ЦенаВключаетНДС = Истина;
		ЗаказПокупателя = ДанныеЗаполнения.Ссылка;
		ДатаПоступления = ДанныеЗаполнения.ЖелаемаяДатаПродажи;
		
		РозничныеПродажиСервер.ЗаполнитьТабличнуюЧастьПоОстаткамЗаказаБезРезерва(ЭтотОбъект, "Товары", ЗаказПокупателя);
		
		Для каждого ЭлементТовары Из Товары Цикл
			
			ЭлементТовары.Цена     = 0;
			ЭлементТовары.Сумма    = 0;
			ЭлементТовары.СуммаНДС = 0;
			
		КонецЦикла;
		
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураПараметровСтавкиНДСУчитыватьНДС(ЭтотОбъект));
		СтруктураТЧ = Новый Структура;
		СтруктураТЧ.Вставить("СтрокиТЧ", Товары);
		ОбработкаТабличнойЧастиТоварыСервер.ПриИзмененииРеквизитовВТЧСервер(СтруктураТЧ, СтруктураДействий, Неопределено);
		
	КонецЕсли;
	
	УчетНДС.СкорректироватьНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Закрыт          = Ложь;
	ДатаПоступления = Дата('00010101');
	// ИнтеграцияГИСМ
	ЕстьКиЗГИСМ             = Ложь;
	// Конец ИнтеграцияГИСМ
	
	ЭтапыОплат.Очистить();
	
	УчетНДС.СкорректироватьНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ИнициализироватьДокумент();
	
	АссортиментСервер.ПроверитьАссортиментТаблицыТоваровДокументаЗакупки(Магазин, Товары, Дата);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДатаПоступления) И НачалоДня(ДатаПоступления) < НачалоДня(Дата) Тогда

		ТекстСообщения = НСтр("ru = 'Дата планируемого поступления
		|не может быть меньше даты документа'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"ДатаПоступления",
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	Если Не ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	// ИнтеграцияГИСМ
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ") Тогда
		ИнтеграцияГИСМПереопределяемый.ПроверитьКорректностьПерсонифицованностиЗаказываемыхКиЗ(ЭтотОбъект, "Товары", Отказ);
	КонецЕсли;
	// Конец ИнтеграцияГИСМ
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ВидПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДатаПлатежа");
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыОплат.ДокументВзаимозачета");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

	ПроверитьСуществованиеПоступленийПоЗаказу(Отказ);
	ЗакупкиСервер.СортироватьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	ЗакупкиСервер.ПроверитьТабличнуюЧастьЭтапыОплат(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
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
	
	Ответственный = Пользователи.ТекущийПользователь();
	Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоступленияПоУмолчанию(Магазин,,Склад, Ответственный);
	Контрагент    = ЗначениеНастроекПовтИсп.ПолучитьПоставщикаПоУмолчанию(Ответственный, Контрагент);
	
	Если ЗначениеЗаполнено(Магазин) И НЕ ЗначениеЗаполнено(Склад) Тогда
		Склад = Магазин.СкладПоступления;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) И НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = Склад.Организация;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеТоваров;
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет возможность снятия флага Закрыт.
// Если существуют поступления по заказу, в этом случае заказ считается закрыт.
// Параметры:
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьСуществованиеПоступленийПоЗаказу(Отказ)
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	ПРЕДСТАВЛЕНИЕ(ПоступлениеТоваров.Ссылка) КАК ПоступлениеТоваров
		                      |ИЗ
		                      |	Документ.ПоступлениеТоваров КАК ПоступлениеТоваров
		                      |ГДЕ
		                      |	ПоступлениеТоваров.ЗаказПоставщику = &ЗаказПоставщику
		                      |	И (НЕ ПоступлениеТоваров.ЗаказПоставщику = ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка))
		                      |	И ПоступлениеТоваров.Проведен");
		
		Запрос.УстановитьПараметр("ЗаказПоставщику", Ссылка);
		
		РезультатЗапросаПроверкаЗаказа = Запрос.Выполнить();
		
		Если НЕ РезультатЗапросаПроверкаЗаказа.Пустой() 
			И НЕ Закрыт Тогда
			
			ТекстСообщения = НСтр("ru = 'Существуют документы поступления, оформленные по документу %ЗаказПоставщику% :'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%ЗаказПоставщику%",Ссылка);
			
			ВыборкаРезультатаПроверкаЗаказа = РезультатЗапросаПроверкаЗаказа.Выбрать();
			
			Пока ВыборкаРезультатаПроверкаЗаказа.Следующий() Цикл
				
				ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = '%ПоступлениеТоваров%'");
				
				ТекстСообщения = СтрЗаменить(
					ТекстСообщения,
					"%ПоступлениеТоваров%",
					ВыборкаРезультатаПроверкаЗаказа.ПоступлениеТоваров);
				
			КонецЦикла;
			
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru = 'Не установлен флаг ""Закрыт""'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Объект.Закрыт",
			,
			Отказ);
			
		КонецЕсли;
		
КонецПроцедуры

// Процедура заполняет табличную часть товары из данных обработки АнализПродажФормированиеЗаказов.
//
Процедура ЗаполнитьТабличнуюЧастьИзОбработкиФормированиеЗаказов(ДанныеТабличнойЧасти, КэшированныеЗначения)
	
	Для каждого СтрокаДанных Из ДанныеТабличнойЧасти Цикл
		СтрокаТоваров = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТоваров, СтрокаДанных, "Номенклатура, Характеристика, Упаковка, Цена");
		СтрокаТоваров.КоличествоУпаковок = СтрокаДанных.Количество;
		
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиТоварыКлиентСервер.СтруктураПараметровСтавкиНДСУчитыватьНДС(ЭтотОбъект));
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС",
			ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(ЭтотОбъект));
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
		ОбработкаТабличнойЧастиТоварыСервер.ОбработатьСтрокуТЧСервер(СтрокаТоваров, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
	СуммаДокумента = ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, Ложь);
	ОбработкаТабличнойЧастиТоварыКлиентСервер.ОбновитьСуммыПодвала(Товары, Ложь, СуммаДокумента);
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.РасчетыСПоставщиками);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
