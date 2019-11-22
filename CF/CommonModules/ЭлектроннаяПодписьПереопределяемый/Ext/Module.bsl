﻿#Область ПрограммныйИнтерфейс

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов организации и при ее выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//
//    * Организация - СправочникСсылка.Организации - организация, которую нужно заполнить.
//                    Если организация уже заполнена, требуется перезаполнить ее свойства, например,
//                    при повтором вызове, когда пользователь выбрал другую организацию.
//                  - Неопределено, если ОпределяемыйТип.Организации не настроен.
//                    Пользователю недоступен выбор организации.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - (возвращаемое значение):
//                    Ложь   - начальное значение - указанная организация является юридическим лицом,
//                    Истина - указанная организация является индивидуальным предпринимателем.
//
//    * НаименованиеСокращенное  - Строка - (возвращаемое значение) краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * НаименованиеПолное       - Строка - (возвращаемое значение) краткое наименование организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ИНН                      - Строка - (возвращаемое значение) ИНН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП                      - Строка - (возвращаемое значение) КПП организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ОГРН                     - Строка - (возвращаемое значение) ОГРН организации.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * РасчетныйСчет            - Строка - (возвращаемое значение) основной расчетный счет организации для договора.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * БИК                      - Строка - (возвращаемое значение) БИК банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КорреспондентскийСчет    - Строка - (возвращаемое значение) корреспондентский счет банка расчетного счета.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Телефон                  - Строка - (возвращаемое значение) телефон организации в формате XML, как его
//                                 возвращает функция КонтактнаяИнформацияВXML общего модуля УправлениеКонтактнойИнформацией.
//
//    * ЮридическийАдрес - Строка - (возвращаемое значение) юридический адрес организации в формате XML, как его
//                         возвращает функция КонтактнаяИнформацияВXML общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ФактическийАдрес - Строка - (возвращаемое значение) фактический адрес организации в формате XML, как его
//                         возвращает функция КонтактнаяИнформацияВXML общего модуля УправлениеКонтактнойИнформацией.
//                       - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт
	
	Организация = Неопределено;
	Если Параметры.Свойство("Организация", Организация) Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			Если Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				Параметры.ЭтоИндивидуальныйПредприниматель = Истина;
			КонецЕсли;
			ДанныеОбОрганизации = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(Параметры.Организация, ТекущаяДатаСеанса());
			Параметры.НаименованиеСокращенное = ДанныеОбОрганизации.ПолноеНаименование;
			Параметры.НаименованиеПолное      = ДанныеОбОрганизации.НаименованиеПолноеПоУчредительнымДокументам;
			Параметры.ИНН                     = ДанныеОбОрганизации.ИНН;
			Параметры.КПП                     = ДанныеОбОрганизации.КПП;
			Параметры.ОГРН                    = Параметры.Организация.ОГРН;
			Параметры.РасчетныйСчет           = ДанныеОбОрганизации.НомерСчета;
			Параметры.БИК                     = ДанныеОбОрганизации.БИК;
			Параметры.КорреспондентскийСчет   = ДанныеОбОрганизации.КоррСчет;
			
			//Заполним контактную информацию
			ВидыКИ = Новый Массив;
			ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
			ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
			ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
			
			Объекты = Новый Массив();
			Объекты.Добавить(Параметры.Организация);
			КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, ТекущаяДатаСеанса());
			
			ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
			Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
			Если Строка <> Неопределено Тогда
				Параметры.ЮридическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.Значение, Строка.Представление, ВидКонтактнойИнформации);
			КонецЕсли;
			
			ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
			Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
			Если Строка <> Неопределено Тогда
				Параметры.ФактическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.Значение, Строка.Представление, ВидКонтактнойИнформации);
			КонецЕсли;
			
			ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
			Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
			Если Строка <> Неопределено Тогда
				Параметры.Телефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.Значение, Строка.Представление, ВидКонтактнойИнформации);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнении реквизитов владельца и при его выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация  - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                   - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипВладельца  - ОписаниеТипов - (возвращаемое значение) содержит ссылочные типы из которых можно сделать выбор.
//                    - Неопределено  - (возвращаемое значение) выбор владельца не поддерживается.
//
//    * Сотрудник    - ТипВладельца - (возвращаемое значение) - это владелец сертификата, которого нужно заполнить.
//                     Если уже заполнен (выбран пользователем), его не следует изменять.
//                   - Неопределено - если ТипВладельца не определен, тогда реквизит не доступен пользователю.
//
//    * Директор     - ТипВладельца - (возвращаемое значение) - это директор, который может быть выбран,
//                     как владелец сертификата.
//                   - Неопределено - начальное значение - скрыть директора из списка выбора.
//
//    * ГлавныйБухгалтер - ТипВладельца - (возвращаемое значение) это главный бухгалтер, который может быть выбран,
//                     как владелец сертификата.
//                   - Неопределено - начальное значение - скрыть главного бухгалтера из списка выбора.
//
//    * Пользователь - СправочникСсылка.Пользователи - (возвращаемое значение) пользователь-владелец сертификата.
//                     В общем случае, может быть не заполнено. Рекомендуется заполнить, если есть возможность.
//                     Записывается в сертификат в поле Пользователь, может быть изменено в дальнейшем.
//
//    * Фамилия            - Строка - (возвращаемое значение) фамилия сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Имя                - Строка - (возвращаемое значение) имя сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Отчество           - Строка - (возвращаемое значение) отчество сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * ДатаРождения       - Дата   - (возвращаемое значение) дата рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Пол                - Строка - (возвращаемое значение) пол сотрудника "Мужской" или "Женский".
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * МестоРождения      - Строка - (возвращаемое значение) описание места рождения сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Гражданство        - СправочникСсылка.СтраныМира - (возвращаемое значение) гражданство сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * СтраховойНомерПФР  - Строка - (возвращаемое значение) СНИЛС сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Должность          - Строка - (возвращаемое значение) должность сотрудника в организации.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Подразделение      - Строка - (возвращаемое значение) обособленное подразделение организации,
//                           в котором работает сотрудник.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументВид        - Строка - (возвращаемое значение) строки "21" или "91". 21 - паспорт гражданина РФ,
//                           91 - иной документ предусмотренный законодательством РФ (по СПДУЛ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументНомер      - Строка - (возвращаемое значение) номер документа сотрудника (серия и
//                           номер для паспорта гражданина РФ).
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументКемВыдан   - Строка - (возвращаемое значение) кем выдан документ сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументКодПодразделения - Строка - (возвращаемое значение) - код подразделения, если вид документа 21.
//                               - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ДокументДатаВыдачи - Дата   - (возвращаемое значение) дата выдачи документа сотрудника.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
//    * ЭлектроннаяПочта   - Строка - (возвращаемое значение) адрес электронной почты сотрудника в формате XML, как его
//                           возвращает функция КонтактнаяИнформацияВXML общего модуля УправлениеКонтактнойИнформацией.
//                         - Неопределено - значение не указано, не изменять имеющееся значение.
//
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
	Организация = Неопределено;
	ЭтоИндивидуальныйПредприниматель = Ложь;
	Если Параметры.Свойство("Организация", Организация) Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			Если Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ЭтоИндивидуальныйПредприниматель = Истина;
			КонецЕсли;
			
			ОтветственныеЛица = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(Организация, ТекущаяДатаСеанса(),, Истина);
			
			Если ЭтоИндивидуальныйПредприниматель Тогда
				Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
					Параметры.Сотрудник = ОтветственныеЛица.РуководительФизическоеЛицо;
					Параметры.ТипВладельца = "Сотрудник";
				КонецЕсли;
			Иначе
				Параметры.Директор         = ОтветственныеЛица.РуководительФизическоеЛицо;
				Параметры.ГлавныйБухгалтер = ОтветственныеЛица.ГлавныйБухгалтерФизическоеЛицо;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
				// Начальное значение для сотрудника.
				Если ЗначениеЗаполнено(Параметры.Директор) Тогда
					Параметры.Сотрудник = Параметры.Директор;
					Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
				ИначеЕсли ЗначениеЗаполнено(Параметры.ГлавныйБухгалтер) Тогда
					Параметры.Сотрудник = Параметры.ГлавныйБухгалтер;
					Параметры.Должность = "Главный бухгалтер";
				КонецЕсли;
			КонецЕсли;
			
			ТекущийВладелец = Параметры.Сотрудник;
			
			Если Не ЗначениеЗаполнено(ТекущийВладелец) Тогда
				Возврат; // Поля можно заполнить только, если сотрудник указан.
			КонецЕсли;
			
			Если ТекущийВладелец = Параметры.Директор Тогда
				Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
			ИначеЕсли ТекущийВладелец = Параметры.ГлавныйБухгалтер Тогда
				Параметры.Должность = ОтветственныеЛица.ГлавныйБухгалтерДолжность;
			Иначе
				Параметры.Должность = НСтр("ru = 'Менеджер'");
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(
				Параметры,
				ФормированиеПечатныхФормСервер.ФамилияИмяОтчество(ТекущийВладелец.Ссылка, ТекущаяДатаСеанса()));
			
			УдостоверениеЛичности = ДокументыФизическихЛиц.СтруктураДокументаУдостоверяющегоЛичность(ТекущийВладелец.Ссылка, ТекущаяДатаСеанса());
			
			Если ЗначениеЗаполнено(УдостоверениеЛичности) Тогда
				
				Параметры.ДокументВид        = УдостоверениеЛичности.ВидДокумента;
				Параметры.ДокументКемВыдан   = УдостоверениеЛичности.КемВыдан;
				Параметры.ДокументДатаВыдачи = УдостоверениеЛичности.ДатаВыдачи;
				Параметры.ДокументНомер      = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 %2'"),
					УдостоверениеЛичности.Серия,
					УдостоверениеЛичности.Номер);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов руководителя и при его выборе.
// Только для юридического лица. Для индивидуального предпринимателя не требуется.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация   - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                    - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипРуководителя - ОписаниеТипов - (возвращаемое значение) содержит ссылочные типы из которых можно сделать выбор.
//                      - Неопределено  - (возвращаемое значение) выбор партнера не поддерживается.
//
//    * Руководитель  - ТипРуководителя - это значение, выбранное пользователем по которому нужно заполнить должность.
//                    - Неопределено - ТипРуководителя не определен.
//                    - ЛюбаяСсылка - (возвращаемое значение) - руководитель, который будет подписывать документы.
//
//    * Представление - Строка - (возвращаемое значение) представление руководителя.
//                    - Неопределено - получить представление от значения Руководитель.
//
//    * Должность     - Строка - (возвращаемое значение) - должность руководителя, который будет подписывать документы.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * Основание     - Строка - (возвращаемое значение) - основание на котором действует
//                      должностное лицо (устав, доверенность, ...).
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
	Параметры.ТипРуководителя = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	
	ОтветственныеЛица = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(Параметры.Организация, ТекущаяДатаСеанса(),, Истина);
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Параметры.Руководитель = ОтветственныеЛица.РуководительФизическоеЛицо;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Возврат; // Поля можно заполнить только, если руководитель указан.
	КонецЕсли;
	
	Если Параметры.Руководитель = ОтветственныеЛица.Руководитель Тогда
		Параметры.Должность = ОтветственныеЛица.РуководительДолжность;
		Параметры.Основание = НСтр("ru = 'Устав'");
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в форме добавления заявления на новый сертификат для заполнения реквизитов партнера и при его выборе.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//    * Организация   - СправочникСсылка.Организации - выбранная организация, на которую оформляется сертификат.
//                    - Неопределено, если ОпределяемыйТип.Организации не настроен.
//
//    * ТипПартнера   - ОписаниеТипов - содержит ссылочные типы из которых можно сделать выбор.
//                    - Неопределено - выбор партнера не поддерживается.
//
//    * Партнер       - ТипПартнера - это контрагент (обслуживающая организация), выбранный пользователем,
//                      по которому нужно заполнить реквизиты, описанные ниже.
//                    - Неопределено - ТипПартнера не определен.
//                    - ЛюбаяСсылка - (возвращаемое значение) - значение сохраняемое в заявке для истории.
//
//    * Представление - Строка - (возвращаемое значение) представление партнера.
//                    - Неопределено - получить представление от значения Партнер.
//
//    * ЭтоИндивидуальныйПредприниматель - Булево - (возвращаемое значение):
//                      Ложь   - начальное значение - указанный партнер является юридическим лицом,
//                      Истина - указанный партнер является индивидуальным предпринимателем.
//
//    * ИНН           - Строка - (возвращаемое значение) ИНН партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
//    * КПП           - Строка - (возвращаемое значение) КПП партнера.
//                    - Неопределено - значение не указано, не изменять имеющееся значение.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
	Параметры.ТипПартнера = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	Если Не ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Возврат; // Поля можно заполнить только, если партнер указан.
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Партнер, "ИНН, КПП, ЮрФизЛицо");
	
	Если Реквизиты.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		Параметры.ЭтоИндивидуальныйПредприниматель = Истина;
	КонецЕсли;
	
	Параметры.ИНН = Реквизиты.ИНН;
	Параметры.КПП = Реквизиты.КПП;
	
КонецПроцедуры

// Вызывается в форме элемента справочника СертификатыКлючейЭлектроннойПодписиИШифрования и в других местах,
// где создаются или обновляются сертификаты, например в форме ВыборСертификатаДляПодписанияИлиРасшифровки.
// Допускается вызов исключения, если требуется остановить действие и что-то сообщить пользователю,
// например, при попытке создать элемент-копию сертификата, доступ к которому ограничен.
//
// Параметры:
//  Ссылка     - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - пустая для нового элемента.
//
//  Сертификат - СертификатКриптографии - сертификат для которого создается или обновляется элемент справочника.
//
//  ПараметрыРеквизитов - ТаблицаЗначений - с колонками:
//               * ИмяРеквизита       - Строка - имя реквизита для которого можно уточнить параметры.
//               * ТолькоПросмотр     - Булево - если установить Истина, редактирование будет запрещено.
//               * ПроверкаЗаполнения - Булево - если установить Истина, заполнение будет проверяться.
//               * Видимость          - Булево - если установить Истина, реквизит станет невидимым.
//               * ЗначениеЗаполнения - Произвольный - начальное значение реквизита нового объекта.
//                                    - Неопределено - заполнение не требуется.
//
Процедура ПередНачаломРедактированияСертификатаКлюча(Ссылка, Сертификат, ПараметрыРеквизитов) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании на сервере форм ПодписаниеДанных, РасшифровкаДанных.
// Используется для дополнительных действий, которые требуют серверного вызова, чтобы не
// вызывать сервер лишний раз.
//
// Параметры:
//  Операция          - Строка - строка Подписание или Расшифровка.
//
//  ВходныеПараметры  - Произвольный - значение свойства ПараметрыДополнительныхДействий
//                      параметра ОписаниеДанных методов Подписать, Расшифровать общего
//                      модуля ЭлектроннаяПодписьКлиент.
//                      
//  ВыходныеПараметры - Произвольный - произвольные возвращаемые данные, которые
//                      будут помещены в одноименную процедуру в общем модуле.
//                      ЭлектроннаяПодписьКлиентПереопределяемый после создания формы
//                      на сервере, но до ее открытия.
//
Процедура ПередНачаломОперации(Операция, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Вызывается для расширения состава выполняемых проверок.
//
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
// 
//  ДополнительныеПроверки - ТаблицаЗначений - с полями:
//    * Имя           - Строка - имя дополнительной проверки, например, АвторизацияВТакском.
//    * Представление - Строка - пользовательское имя проверки, например, "Авторизация на сервере Такском".
//    * Подсказка     - Строка - подсказка, которая будет показана пользователю при нажатии на знак вопроса.
//
//  ПараметрыДополнительныхПроверок - Произвольный - значение одноименного параметра, указанное
//    в процедуре ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент.
//
//  СтандартныеПроверки - Булево - если установить Ложь, тогда все стандартные проверки будут
//    пропущены и скрыты. Скрытые проверки не попадают в свойство Результат
//    процедуры ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент, кроме того
//    параметр МенеджерКриптографии не будет определен в процедурах ПриДополнительнойПроверкеСертификата
//    общих модулей ЭлектроннаяПодписьПереопределяемый и ЭлектроннаяПодписьКлиентПереопределяемый.
//  ВводитьПароль - Булево - если установить Ложь, тогда ввод пароля для закрытой части ключа сертификата будет скрыт.
//    Не учитывается, если параметр СтандартныеПроверки не установлен в Ложь.
//
Процедура ПриСозданииФормыПроверкаСертификата(Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль = Истина) Экспорт
	
	ЭлектронноеВзаимодействие.ПриСозданииФормыПроверкаСертификата(
		Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль);
	
КонецПроцедуры

// Вызывается из формы ПроверкаСертификата, если при создании формы были добавлены дополнительные проверки.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//  * Сертификат           - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
//  * Проверка             - Строка - имя проверки, добавленное в процедуре ПриСозданииФормыПроверкаСертификата
//                              общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * МенеджерКриптографии - МенеджерКриптографии - подготовленный менеджер криптографии для
//                              выполнения проверки.
//                         - Неопределено - если стандартные проверки отключены в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * ОписаниеОшибки       - Строка - (возвращаемое значение) - описание ошибки, полученной при выполнении проверки.
//                              Это описание сможет увидеть пользователь при нажатии на картинку результата.
//  * ЭтоПредупреждение    - Булево - (возвращаемое значение) - вид картинки Ошибка/Предупреждение 
//                            начальное значение Ложь.
//  * Пароль               - Строка - пароль, введенный пользователем.
//                         - Неопределено - если свойство ВводитьПароль установлено Ложь в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//  * РезультатыПроверок   - Структура - со свойствами:
//      * Ключ     - Строка - имя дополнительной проверки, которая уже выполнена.
//      * Значение - Неопределено - дополнительная проверка не выполнялась (ОписаниеОшибки осталось Неопределено).
//                 - Булево - результат выполнения дополнительной проверки.
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
