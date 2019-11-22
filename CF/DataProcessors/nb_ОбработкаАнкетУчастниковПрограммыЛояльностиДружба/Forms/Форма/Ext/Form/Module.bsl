﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПервоначальноеСостояниеКартинок();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИнициализацияРеквизитов();
КонецПроцедуры


&НаКлиенте
Процедура УстановитьПервоначальноеСостояниеКартинок()
	Отказ = Истина;
	УстановитьКартинкуВыполнитьПроверкуНовогоПользователя(Отказ);
	УстановитьКартинкуВыполнитьРегистрацию(Отказ);
	УстановитьКартинкуНачислитьБонус(Отказ)
КонецПроцедуры

&НаСервере
Процедура ИнициализацияРеквизитов()
	Объект.nb_ДатаРегистрации = ТекущаяДата();
	Объект.Ответственный = Пользователи.ТекущийПользователь();
	Объект.ДатаНачалаОбработкиАнкеты = ТекущаяДата();
КонецПроцедуры	

Процедура ОчиститьРеквизиты(ИсключитьИзОчистки)
	МетаданныеОбъекта = Метаданные.Обработки.nb_ОбработкаАнкетУчастниковПрограммыЛояльностиДружба;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Если СтрНайти(ИсключитьИзОчистки, Реквизит.Имя) > 0 Тогда
			Продолжить;
		КонецЕсли;	
		Объект[Реквизит.Имя] = Неопределено;
	КонецЦикла;	
	Объект.Клиент = Неопределено;
КонецПроцедуры	


&НаСервере
Процедура ВыполнитьРегистрациюНаСервере(Отказ)
	ФизЛицоССылка = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФизЛицоПоБК(Объект.nb_БК);
	Если НЕ ФизЛицоССылка.Пустая() Тогда
		Попытка
			НачатьТранзакцию();
			ФизЛицоОбъект = ФизЛицоССылка.ПолучитьОбъект();
			
			ЗаполнитьЗначенияСвойств(ФизЛицоОбъект, Объект);
			ФизЛицоОбъект.Наименование = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьНаименованиеПоФИО(Объект.Фамилия, Объект.ИМя, Объект.Отчество);
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ФизЛицоОбъект, Объект.EMail, Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица);
			УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ФизЛицоОбъект, Объект.Телефон, Справочники.ВидыКонтактнойИнформации.ТелефонФизическогоЛица);
			
			ФизЛицоОбъект.nb_МесяцевПолученияБонусныхБаллов = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьКоличествоМесяцевПериодаИспользованияБонусныхБаллов(ФизЛицоОбъект);
			
			ФизЛицоОбъект.Записать();
			
			МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ФизЛицо = ФизЛицоССылка;
			МенеджерЗаписи.Период = ФизЛицоОбъект.ДатаРождения;
			МенеджерЗаписи.Фамилия = Объект.Фамилия;
			МенеджерЗаписи.Имя = Объект.Имя;
			МенеджерЗаписи.Отчество = Объект.Отчество;
			МенеджерЗаписи.Записать(Истина);

			
			ДисконтнаяКартаСсылка = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьДисконтнуюКартуПоБК(ФизЛицоССылка, Объект.nb_БК);
			Если НЕ ДисконтнаяКартаСсылка.Пустая() Тогда
				ДисконтнаяКартаОбъект = ДисконтнаяКартаСсылка.ПолучитьОбъект();
				ДисконтнаяКартаОбъект.Наименование = ДисконтнаяКартаОбъект.КодКарты + " " + ФизЛицоОбъект.Наименование; 
				ДисконтнаяКартаОбъект.Записать();
			КонецЕсли;	
			
			ДокументОбъект = Документы.nb_АнкетаУчастникаПрограммыЛояльностиДружба.СоздатьДокумент();
			ЗаполнитьЗначенияСвойств(ДокументОбъект, Объект);
			ДокументОбъект.Дата = ТекущаяДата();
			ДокументОбъект.ДисконтнаяКарта = ДисконтнаяКартаОбъект.Ссылка;
			ДокументОбъект.nb_МесяцевПолученияБонусныхБаллов = ФизЛицоОбъект.nb_МесяцевПолученияБонусныхБаллов;
			ДокументОбъект.ДатаЗавершенияОбработкиАнкеты = ТекущаяДата();
			ДокументОбъект.ДатаНачалаОбработкиАнкеты = Объект.ДатаНачалаОбработкиАнкеты;
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
			Если ЗначениеЗаполнено(Объект.Рекомендатель) Тогда
				nb_ПрограммаЛояльностиДружбаСервер.ДобавитьВКругПриглашенныхДрузей(Объект.Рекомендатель, ФизЛицоОбъект.ССылка, Объект.nb_ДатаРегистрации);
			КонецЕсли;	
			
			ЗафиксироватьТранзакцию();
			Объект.Клиент = ФизЛицоОбъект.ССылка;
		Исключение
			Отказ = Истина;
			ОтменитьТранзакцию();
			ТекстСообщения = "Ошибка регистрации нового пользователя:
			| "+ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					,
					,
					,
					Отказ);
			

		КонецПопытки;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегистрацию(Команда)
	Отказ = Ложь;
	ВыполнитьПроверкуНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		ВыполнитьРегистрациюНаСервере(Отказ);
	КонецЕсли;
	УстановитьКартинкуВыполнитьРегистрацию(Отказ);
	
	Если НЕ Отказ Тогда
		//ЭтаФорма.ОбновитьОтображениеДанных();
	    ОповеститьОбИзменении(Объект.Клиент);
		//Сообщить("Анкета зарегистрирована: "+Объект.Клиент);
	КонецЕсли;	
	
	Если НЕ Отказ Тогда
		КомандаНачислитьБонусНаСервере(Отказ);
		УстановитьКартинкуНачислитьБонус(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура nb_БКПриИзмененииНаСервере()
	ОчиститьРеквизиты("nb_БК, nb_ДатаРегистрации, Ответственный, ДатаНачалаОбработкиАнкеты");
	Объект.Клиент = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФизЛицоПоБК(Объект.nb_БК);
	Если ЗначениеЗаполнено(Объект.Клиент) Тогда
		Объект.Рекомендатель = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьРекомендующего(Объект.Клиент);
		Объект.Рекомендатель_БК = Объект.Рекомендатель.nb_БК;
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.Клиент.nb_ДатаРегистрации) Тогда
		ЗаполнитьЗначенияСвойств(Объект, Объект.Клиент);
		ФИО = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФИОФизЛица(Объект.Клиент);
		ЗаполнитьЗначенияСвойств(Объект, ФИО);
		
		Объект.EMail 	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Объект.Клиент, Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица);
		Объект.Телефон 	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Объект.Клиент, Справочники.ВидыКонтактнойИнформации.ТелефонФизическогоЛица);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура nb_БКПриИзменении(Элемент)
	nb_БКПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаНоваяАнкетаНаСервере()
	// Очистить все поля
	ОчиститьРеквизиты("nb_ДатаРегистрации, Ответственный");
	ИнициализацияРеквизитов();

КонецПроцедуры

&НаКлиенте
Процедура КомандаНоваяАнкета(Команда)
	КомандаНоваяАнкетаНаСервере();
	УстановитьПервоначальноеСостояниеКартинок();
КонецПроцедуры

&НаСервере
Процедура РекомендательПриИзмененииНаСервере()
	Объект.Рекомендатель_БК = Объект.Рекомендатель.nb_БК;	
КонецПроцедуры

&НаКлиенте
Процедура РекомендательПриИзменении(Элемент)
	РекомендательПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура БКРекомендателяПриИзмененииНаСервере()
	Объект.Рекомендатель = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФизЛицоПоБК(Объект.Рекомендатель_БК);
КонецПроцедуры

&НаКлиенте
Процедура БКРекомендателяПриИзменении(Элемент)
	БКРекомендателяПриИзмененииНаСервере();
	УстановитьКартинкуНачислитьБонус(Истина);
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеОбязательныхПолей(СтруктураОбязательныхПолей, Отказ)
	
	Для Каждого ЭлПроверки Из СтруктураОбязательныхПолей Цикл
		Если Не ЗначениеЗаполнено(Объект[ЭлПроверки.Ключ]) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Поле ""%1"" не заполнен!", ЭлПроверки.Значение);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					,
					ЭлПроверки.Ключ,
					"Объект",
					Отказ);
			
		КонецЕсли;
	КонецЦикла	
	

КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуНовогоПользователяНаСервере(Отказ)
	
	/// ПРОВЕРКА НА ФИО И ДР
	ФИО = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьНаименованиеПоФИО(Объект.Фамилия, Объект.ИМя, Объект.Отчество); 
	ФизЛицоССылка = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФизЛицоПоФИОиДР(ФИО, Объект.ДатаРождения);
	Если НЕ ФизЛицоССылка.Пустая() Тогда
		ТекстСообщения = "Пользователь с такими ФИО и датой рождения уже введен! БК № "+ФизЛицоССылка.nb_БК;

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"Объект.Фамилия",
				,
				Отказ);
				
	КонецЕсли;
			
	/// НОМЕР ТЕЛЕФОНА
	ФизЛицоССылка = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьФизЛицоПоТелефону(Объект.Телефон);
	Если НЕ ФизЛицоССылка.Пустая() Тогда
		ТекстСообщения = "Пользователь с такими Телефоном уже введен! БК:"+ФизЛицоССылка.nb_БК;

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				,
				"Объект.Телефон",
				,
				Отказ);
				
	КонецЕсли;
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ВыполнитьПроверкуНаСервере(Отказ)

	СтруктураОбязательныхПолей = Новый Структура("nb_БК, Фамилия, Имя", "БК", "Фамилия", "Имя");
	ПроверитьЗаполнениеОбязательныхПолей(СтруктураОбязательныхПолей, Отказ);
	ВыполнитьПроверкуНовогоПользователяНаСервере(Отказ);
	

КонецПроцедуры // ВыполнитьПроверкуНаСервере()


&НаКлиенте
Процедура КомандаВыполнитьПроверкуНовогоПользователя(Команда)
	Отказ = Ложь;
	
	ВыполнитьПроверкуНаСервере(Отказ);
	УстановитьКартинкуВыполнитьПроверкуНовогоПользователя(Отказ);
	
КонецПроцедуры


&НаСервере
Процедура КомандаНачислитьБонусНаСервере(Отказ)
	Если ЗначениеЗаполнено(Объект.Рекомендатель) 
		И Объект.ПервоеПосещение Тогда
		
		ДисконтнаяКарта = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьДисконтнуюКартуПоБК(Объект.Клиент, Объект.nb_БК);
		
		КоличествоБонусныхБаллов = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьКоличествоБалловПолученныхПриРегистрации(ДисконтнаяКарта);
		Если КоличествоБонусныхБаллов = 0 Тогда
			ДокументОбъект = Документы.НачислениеИСписаниеБонусныхБаллов.СоздатьДокумент();
			ДокументОбъект.Дата = Объект.nb_ДатаРегистрации;
			ДокументОбъект.БонуснаяПрограммаЛояльности = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьБонуснуюПрограммуДружба();
			
			СтрокаТЧ = ДокументОбъект.Начисление.Добавить();
			СтрокаТЧ.Баллы = nb_ПрограммаЛояльностиДружбаСервер.ПолучитьКоличествоБонусныхБалловЗаРегистрациюПоРекомендации();
			СтрокаТЧ.ДисконтнаяКарта = ДисконтнаяКарта;
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Сообщить("Бонусные баллы за регистрацию по приглашению начислены!");
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							"Ошибка начисления бонусных баллов, начислены ранее!"
							,
							,
							,
							Отказ);
			
		КонецЕсли;	
		
		
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура КомандаНачислитьБонус(Команда)
	Отказ = Ложь;
	КомандаНачислитьБонусНаСервере(Отказ);
	УстановитьКартинкуНачислитьБонус(Отказ);
КонецПроцедуры


&НаКлиенте
Процедура ПервоеПосещениеПриИзменении(Элемент)
	УстановитьКартинкуНачислитьБонус(Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКартинкуНачислитьБонус(Отказ)
	Если ЗначениеЗаполнено(Объект.Рекомендатель) 
		И Объект.ПервоеПосещение Тогда
		Элементы.ФормаКомандаНачислитьБонус.Доступность = Истина;
		Элементы.ФормаКомандаНачислитьБонус.Картинка = БиблиотекаКартинок["Важно"];
	Иначе
		Элементы.ФормаКомандаНачислитьБонус.Доступность = Ложь;
		Элементы.ФормаКомандаНачислитьБонус.Картинка = Новый Картинка;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		Элементы.ФормаКомандаНачислитьБонус.Картинка = БиблиотекаКартинок["ВыполненоУспешно"];
	Иначе
		Элементы.ФормаКомандаНачислитьБонус.Картинка = БиблиотекаКартинок["Важно"];
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьКартинкуВыполнитьПроверкуНовогоПользователя(Отказ)
	Если НЕ Отказ Тогда
		Элементы.ФормаКомандаВыполнитьПроверкуНовогоПользователя.Картинка = БиблиотекаКартинок["ВыполненоУспешно"];
	Иначе
		Элементы.ФормаКомандаВыполнитьПроверкуНовогоПользователя.Картинка = БиблиотекаКартинок["Важно"];
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКартинкуВыполнитьРегистрацию(Отказ)
	Если НЕ Отказ Тогда
		Элементы.ФормаВыполнитьРегистрацию.Картинка = БиблиотекаКартинок["ВыполненоУспешно"];
	Иначе
		Элементы.ФормаВыполнитьРегистрацию.Картинка = БиблиотекаКартинок["Важно"];
	КонецЕсли;	
КонецПроцедуры

